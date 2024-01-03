create or replace package Hper_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Group_Save(i_Plan_Group Hper_Plan_Groups%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Group_Delete
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Plan_Group_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Save(i_Plan_Type Hper_Pref.Plan_Type_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Add_Division
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Division_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Remove_Division
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Division_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Add_Task_Type
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Task_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Remove_Task_Type
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Task_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Plan_Save(i_Plan Hper_Pref.Plan_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Plan_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Plan_Id    number
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
  Procedure Staff_Plan_Update
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Values        Matrix_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Part_Save(i_Plan_Part Hper_Staff_Plan_Parts%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Part_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Part_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Save_Tasks
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Task_Ids      Array_Number,
    i_Fact_Note     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Set_Draft
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Set_New
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Set_Waiting
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Set_Completed
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Plan_Id      number,
    i_Main_Fact_Percent  number := null,
    i_Extra_Fact_Percent number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Delete
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  );
end Hper_Api;
/
create or replace package body Hper_Api is
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
  Procedure Plan_Group_Save(i_Plan_Group Hper_Plan_Groups%rowtype) is
  begin
    z_Hper_Plan_Groups.Save_Row(i_Plan_Group);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Group_Delete
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Plan_Group_Id number
  ) is
  begin
    z_Hper_Plan_Groups.Delete_One(i_Company_Id    => i_Company_Id,
                                  i_Filial_Id     => i_Filial_Id,
                                  i_Plan_Group_Id => i_Plan_Group_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Save(i_Plan_Type Hper_Pref.Plan_Type_Rt) is
    r_Plan_Type  Hper_Plan_Types%rowtype;
    v_Rule       Hper_Pref.Rule_Rt;
    v_Rule_2     Hper_Pref.Rule_Rt;
    v_Rule_Codes Array_Number := Array_Number();
    v_Max_Value  number := 1000000000;
    v_Exists     boolean := true;
  begin
    if not z_Hper_Plan_Types.Exist_Lock(i_Company_Id   => i_Plan_Type.Company_Id,
                                        i_Filial_Id    => i_Plan_Type.Filial_Id,
                                        i_Plan_Type_Id => i_Plan_Type.Plan_Type_Id,
                                        o_Row          => r_Plan_Type) then
      r_Plan_Type.Company_Id   := i_Plan_Type.Company_Id;
      r_Plan_Type.Filial_Id    := i_Plan_Type.Filial_Id;
      r_Plan_Type.Plan_Type_Id := i_Plan_Type.Plan_Type_Id;
    
      v_Exists := false;
    end if;
  
    r_Plan_Type.Name                 := i_Plan_Type.Name;
    r_Plan_Type.Plan_Group_Id        := i_Plan_Type.Plan_Group_Id;
    r_Plan_Type.Calc_Kind            := i_Plan_Type.Calc_Kind;
    r_Plan_Type.With_Part            := i_Plan_Type.With_Part;
    r_Plan_Type.Extra_Amount_Enabled := case
                                          when i_Plan_Type.Calc_Kind in
                                               (Hper_Pref.c_Calc_Kind_Manual,
                                                Hper_Pref.c_Calc_Kind_External) then
                                           i_Plan_Type.Extra_Amount_Enabled
                                          else
                                           'N'
                                        end;
    r_Plan_Type.Sale_Kind            := i_Plan_Type.Sale_Kind;
    r_Plan_Type.State                := i_Plan_Type.State;
    r_Plan_Type.Code                 := i_Plan_Type.Code;
    r_Plan_Type.Order_No             := i_Plan_Type.Order_No;
    r_Plan_Type.c_Divisions_Exist := case
                                       when i_Plan_Type.Division_Ids.Count > 0 then
                                        'Y'
                                       else
                                        'N'
                                     end;
  
    -- check rules
    if r_Plan_Type.Extra_Amount_Enabled = 'Y' then
      for i in 1 .. i_Plan_Type.Rules.Count
      loop
        v_Rule              := i_Plan_Type.Rules(i);
        v_Rule.From_Percent := Nvl(v_Rule.From_Percent, 0);
        v_Rule.To_Percent   := Nvl(v_Rule.To_Percent, v_Max_Value);
      
        for j in i + 1 .. i_Plan_Type.Rules.Count
        loop
          v_Rule_2              := i_Plan_Type.Rules(j);
          v_Rule_2.From_Percent := Nvl(v_Rule_2.From_Percent, 0);
          v_Rule_2.To_Percent   := Nvl(v_Rule_2.To_Percent, v_Max_Value);
        
          if v_Rule.To_Percent > v_Rule_2.From_Percent and
             v_Rule.From_Percent < v_Rule_2.To_Percent then
            Hper_Error.Raise_003(i_Plan_Type_Name => i_Plan_Type.Name,
                                 i_First_Rule     => Href_Util.t_From_To_Rule(i_From      => v_Rule.From_Percent,
                                                                              i_To        => v_Rule.To_Percent,
                                                                              i_Rule_Unit => '%'),
                                 i_Second_Rule    => Href_Util.t_From_To_Rule(i_From      => v_Rule_2.From_Percent,
                                                                              i_To        => v_Rule_2.To_Percent,
                                                                              i_Rule_Unit => '%'));
          end if;
        end loop;
      end loop;
    end if;
  
    if v_Exists then
      z_Hper_Plan_Types.Update_Row(r_Plan_Type);
    
      delete from Hper_Plan_Type_Divisions q
       where q.Company_Id = i_Plan_Type.Company_Id
         and q.Filial_Id = i_Plan_Type.Filial_Id
         and q.Plan_Type_Id = i_Plan_Type.Plan_Type_Id
         and q.Division_Id not member of i_Plan_Type.Division_Ids;
    
      delete from Hper_Plan_Type_Task_Types q
       where q.Company_Id = i_Plan_Type.Company_Id
         and q.Filial_Id = i_Plan_Type.Filial_Id
         and q.Plan_Type_Id = i_Plan_Type.Plan_Type_Id
         and (r_Plan_Type.Calc_Kind <> Hper_Pref.c_Calc_Kind_Task or q.Task_Type_Id not member of
              i_Plan_Type.Task_Type_Ids);
    else
      z_Hper_Plan_Types.Insert_Row(r_Plan_Type);
    end if;
  
    -- save divisions
    for i in 1 .. i_Plan_Type.Division_Ids.Count
    loop
      z_Hper_Plan_Type_Divisions.Insert_Try(i_Company_Id   => i_Plan_Type.Company_Id,
                                            i_Filial_Id    => i_Plan_Type.Filial_Id,
                                            i_Plan_Type_Id => i_Plan_Type.Plan_Type_Id,
                                            i_Division_Id  => i_Plan_Type.Division_Ids(i));
    end loop;
  
    -- save tasks
    if r_Plan_Type.Calc_Kind = Hper_Pref.c_Calc_Kind_Task then
      for i in 1 .. i_Plan_Type.Task_Type_Ids.Count
      loop
        z_Hper_Plan_Type_Task_Types.Insert_Try(i_Company_Id   => i_Plan_Type.Company_Id,
                                               i_Filial_Id    => i_Plan_Type.Filial_Id,
                                               i_Plan_Type_Id => i_Plan_Type.Plan_Type_Id,
                                               i_Task_Type_Id => i_Plan_Type.Task_Type_Ids(i));
      end loop;
    end if;
  
    -- save rules
    if r_Plan_Type.Extra_Amount_Enabled = 'Y' then
      v_Rule_Codes.Extend(i_Plan_Type.Rules.Count);
    
      for j in 1 .. i_Plan_Type.Rules.Count
      loop
        v_Rule := i_Plan_Type.Rules(j);
      
        z_Hper_Plan_Type_Rules.Save_One(i_Company_Id   => i_Plan_Type.Company_Id,
                                        i_Filial_Id    => i_Plan_Type.Filial_Id,
                                        i_Plan_Type_Id => i_Plan_Type.Plan_Type_Id,
                                        i_From_Percent => v_Rule.From_Percent,
                                        i_To_Percent   => v_Rule.To_Percent,
                                        i_Plan_Percent => v_Rule.Amount);
      
        v_Rule_Codes(j) := v_Rule.From_Percent;
      end loop;
    end if;
  
    if v_Exists then
      delete Hper_Plan_Type_Rules q
       where q.Company_Id = i_Plan_Type.Company_Id
         and q.Filial_Id = i_Plan_Type.Filial_Id
         and q.Plan_Type_Id = i_Plan_Type.Plan_Type_Id
         and q.From_Percent not member of v_Rule_Codes;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number
  ) is
  begin
    z_Hper_Plan_Types.Delete_One(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Plan_Type_Id => i_Plan_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Add_Division
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Division_Id  number
  ) is
  begin
    z_Hper_Plan_Type_Divisions.Insert_Try(i_Company_Id   => i_Company_Id,
                                          i_Filial_Id    => i_Filial_Id,
                                          i_Plan_Type_Id => i_Plan_Type_Id,
                                          i_Division_Id  => i_Division_Id);
  
    Hper_Core.Make_Dirty_Plan_Type(i_Company_Id   => i_Company_Id,
                                   i_Filial_Id    => i_Filial_Id,
                                   i_Plan_Type_Id => i_Plan_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Remove_Division
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Division_Id  number
  ) is
  begin
    z_Hper_Plan_Type_Divisions.Delete_One(i_Company_Id   => i_Company_Id,
                                          i_Filial_Id    => i_Filial_Id,
                                          i_Plan_Type_Id => i_Plan_Type_Id,
                                          i_Division_Id  => i_Division_Id);
  
    Hper_Core.Make_Dirty_Plan_Type(i_Company_Id   => i_Company_Id,
                                   i_Filial_Id    => i_Filial_Id,
                                   i_Plan_Type_Id => i_Plan_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Add_Task_Type
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Task_Type_Id number
  ) is
    r_Plan_Type Hper_Plan_Types%rowtype;
  begin
    r_Plan_Type := z_Hper_Plan_Types.Lock_Load(i_Company_Id   => i_Company_Id,
                                               i_Filial_Id    => i_Filial_Id,
                                               i_Plan_Type_Id => i_Plan_Type_Id);
  
    if r_Plan_Type.Calc_Kind <> Hper_Pref.c_Calc_Kind_Task then
      Hper_Error.Raise_001(i_Plan_Type_Id   => r_Plan_Type.Plan_Type_Id,
                           i_Plan_Type_Name => r_Plan_Type.Name,
                           i_Calc_Kind      => r_Plan_Type.Calc_Kind);
    end if;
  
    z_Hper_Plan_Type_Task_Types.Insert_Try(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Plan_Type_Id => i_Plan_Type_Id,
                                           i_Task_Type_Id => i_Task_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Remove_Task_Type
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Plan_Type_Id number,
    i_Task_Type_Id number
  ) is
  begin
    z_Hper_Plan_Type_Task_Types.Delete_One(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Plan_Type_Id => i_Plan_Type_Id,
                                           i_Task_Type_Id => i_Task_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Save(i_Plan Hper_Pref.Plan_Rt) is
    r_Plan          Hper_Plans%rowtype;
    v_Item          Hper_Pref.Plan_Item_Rt;
    v_Rule          Hper_Pref.Rule_Rt;
    v_Rule_2        Hper_Pref.Rule_Rt;
    v_Plan_Type_Ids Array_Number;
    v_Rule_Codes    Array_Number;
    v_Value         number;
    v_Calc          Calc := Calc();
    v_Max_Value     number := 1000000000;
    v_Exists        boolean;
  begin
    if z_Hper_Plans.Exist_Lock(i_Company_Id => i_Plan.Company_Id,
                               i_Filial_Id  => i_Plan.Filial_Id,
                               i_Plan_Id    => i_Plan.Plan_Id,
                               o_Row        => r_Plan) then
      v_Exists := true;
    else
      r_Plan.Company_Id      := i_Plan.Company_Id;
      r_Plan.Filial_Id       := i_Plan.Filial_Id;
      r_Plan.Plan_Id         := i_Plan.Plan_Id;
      r_Plan.Plan_Date       := i_Plan.Plan_Date;
      r_Plan.Journal_Page_Id := i_Plan.Journal_Page_Id;
    
      if r_Plan.Journal_Page_Id is not null then
        r_Plan.Plan_Kind := Hper_Pref.c_Plan_Kind_Contract;
      else
        if i_Plan.Division_Id is null or i_Plan.Job_Id is null or i_Plan.Employment_Type is null then
          Hper_Error.Raise_002(i_Plan.Plan_Id);
        end if;
      
        r_Plan.Plan_Kind       := Hper_Pref.c_Plan_Kind_Standard;
        r_Plan.Division_Id     := i_Plan.Division_Id;
        r_Plan.Job_Id          := i_Plan.Job_Id;
        r_Plan.Rank_Id         := i_Plan.Rank_Id;
        r_Plan.Employment_Type := i_Plan.Employment_Type;
      end if;
    end if;
  
    -- check
    v_Value := 0;
  
    for k in 1 .. i_Plan.Items.Count
    loop
      v_Item := i_Plan.Items(k);
    
      for i in 1 .. v_Item.Rules.Count
      loop
        v_Rule              := v_Item.Rules(i);
        v_Rule.From_Percent := Nvl(v_Rule.From_Percent, 0);
        v_Rule.To_Percent   := Nvl(v_Rule.To_Percent, v_Max_Value);
      
        for j in i + 1 .. v_Item.Rules.Count
        loop
          v_Rule_2              := v_Item.Rules(j);
          v_Rule_2.From_Percent := Nvl(v_Rule_2.From_Percent, 0);
          v_Rule_2.To_Percent   := Nvl(v_Rule_2.To_Percent, v_Max_Value);
        
          if v_Rule.To_Percent > v_Rule_2.From_Percent and
             v_Rule.From_Percent < v_Rule_2.To_Percent then
            Hper_Error.Raise_003(i_Plan_Type_Name => z_Hper_Plan_Types.Load(i_Company_Id => i_Plan.Company_Id, --
                                                     i_Filial_Id => i_Plan.Filial_Id, --
                                                     i_Plan_Type_Id => v_Item.Plan_Type_Id).Name,
                                 i_First_Rule     => Href_Util.t_From_To_Rule(i_From      => v_Rule.From_Percent,
                                                                              i_To        => v_Rule.To_Percent,
                                                                              i_Rule_Unit => '%'),
                                 i_Second_Rule    => Href_Util.t_From_To_Rule(i_From      => v_Rule_2.From_Percent,
                                                                              i_To        => v_Rule_2.To_Percent,
                                                                              i_Rule_Unit => '%'));
          end if;
        end loop;
      end loop;
    
      if v_Item.Plan_Type = Hper_Pref.c_Plan_Type_Main then
        if i_Plan.Main_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
          v_Calc.Plus(Hper_Pref.c_Plan_Type_Main, v_Item.Plan_Amount);
        end if;
      
        v_Value := v_Value + 1;
      elsif v_Item.Plan_Type = Hper_Pref.c_Plan_Type_Extra then
        if i_Plan.Extra_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
          v_Calc.Plus(Hper_Pref.c_Plan_Type_Extra, v_Item.Plan_Amount);
        end if;
      else
        Hper_Error.Raise_018(i_Plan_Type => v_Item.Plan_Type);
      end if;
    end loop;
  
    if v_Value < 1 then
      Hper_Error.Raise_004(i_Main_Plan_Count => v_Value);
    end if;
  
    if i_Plan.Main_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
      v_Value := v_Calc.Get_Value(Hper_Pref.c_Plan_Type_Main);
    
      if v_Value <> 100 then
        Hper_Error.Raise_005(i_Plan_Id => i_Plan.Plan_Id, i_Current_Total_Weight => v_Value);
      end if;
    end if;
  
    if i_Plan.Extra_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight and --
       Lower(Hper_Pref.c_Plan_Type_Extra) member of v_Calc.Keyset then
      v_Value := v_Calc.Get_Value(Hper_Pref.c_Plan_Type_Extra);
    
      if v_Value <> 100 then
        Hper_Error.Raise_006(i_Plan_Id => i_Plan.Plan_Id, i_Current_Total_Weight => v_Value);
      end if;
    end if;
  
    -- save
    r_Plan.Main_Calc_Type  := i_Plan.Main_Calc_Type;
    r_Plan.Extra_Calc_Type := i_Plan.Extra_Calc_Type;
    r_Plan.Note            := i_Plan.Note;
  
    if v_Exists then
      z_Hper_Plans.Update_Row(r_Plan);
    else
      z_Hper_Plans.Insert_Row(r_Plan);
    end if;
  
    v_Plan_Type_Ids := Array_Number();
    v_Plan_Type_Ids.Extend(i_Plan.Items.Count);
  
    for i in 1 .. i_Plan.Items.Count
    loop
      v_Item := i_Plan.Items(i);
    
      z_Hper_Plan_Items.Save_One(i_Company_Id   => r_Plan.Company_Id,
                                 i_Filial_Id    => r_Plan.Filial_Id,
                                 i_Plan_Id      => r_Plan.Plan_Id,
                                 i_Plan_Type_Id => v_Item.Plan_Type_Id,
                                 i_Plan_Type    => v_Item.Plan_Type,
                                 i_Plan_Value   => v_Item.Plan_Value,
                                 i_Plan_Amount  => v_Item.Plan_Amount,
                                 i_Note         => v_Item.Note,
                                 i_Order_No     => i);
    
      v_Plan_Type_Ids(i) := v_Item.Plan_Type_Id;
    
      v_Rule_Codes := Array_Number();
      v_Rule_Codes.Extend(v_Item.Rules.Count);
    
      for j in 1 .. v_Item.Rules.Count
      loop
        v_Rule := v_Item.Rules(j);
      
        z_Hper_Plan_Rules.Save_One(i_Company_Id   => r_Plan.Company_Id,
                                   i_Filial_Id    => r_Plan.Filial_Id,
                                   i_Plan_Id      => r_Plan.Plan_Id,
                                   i_Plan_Type_Id => v_Item.Plan_Type_Id,
                                   i_From_Percent => v_Rule.From_Percent,
                                   i_To_Percent   => v_Rule.To_Percent,
                                   i_Fact_Amount  => v_Rule.Amount);
      
        v_Rule_Codes(j) := v_Rule.From_Percent;
      end loop;
    
      if v_Exists then
        delete Hper_Plan_Rules q
         where q.Company_Id = r_Plan.Company_Id
           and q.Filial_Id = r_Plan.Filial_Id
           and q.Plan_Id = r_Plan.Plan_Id
           and q.Plan_Type_Id = v_Item.Plan_Type_Id
           and q.From_Percent not member of v_Rule_Codes;
      end if;
    end loop;
  
    if v_Exists then
      delete Hper_Plan_Items q
       where q.Company_Id = r_Plan.Company_Id
         and q.Filial_Id = r_Plan.Filial_Id
         and q.Plan_Id = r_Plan.Plan_Id
         and q.Plan_Type_Id not member of v_Plan_Type_Ids;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Plan_Id    number
  ) is
  begin
    z_Hper_Plans.Delete_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Plan_Id    => i_Plan_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Plans
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Plan_Id    number := null,
    i_Date       date
  ) is
  begin
    if i_Plan_Id is not null then
      Hper_Core.Gen_Plans(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Plan_Id    => i_Plan_Id,
                          i_Date       => i_Date);
    else
      Hper_Core.Gen_Plans(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Date       => i_Date);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Staff_Plan_Fix_Total
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  ) is
    r_Data               Hper_Staff_Plans%rowtype;
    v_Round_Model        Round_Model;
    v_Value              number;
    v_Plan_Percent       number;
    v_Main_Extra_Amount  number := 0;
    v_Extra_Extra_Amount number := 0;
    v_Max_Value          number := 1000000000;
    v_Currency_Id        number;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    v_Round_Model := Round_Model(Md_Pref.Round_Model(i_Company_Id));
  
    v_Currency_Id := Hpd_Util.Get_Closest_Currency_Id(i_Company_Id => r_Data.Company_Id,
                                                      i_Filial_Id  => r_Data.Filial_Id,
                                                      i_Staff_Id   => r_Data.Staff_Id,
                                                      i_Period     => r_Data.Month_End_Date);
  
    if r_Data.Main_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
      r_Data.c_Main_Fact_Percent := 0;
    else
      r_Data.Main_Fact_Amount := 0;
    end if;
  
    if r_Data.Extra_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
      r_Data.c_Extra_Fact_Percent := 0;
    else
      r_Data.Extra_Fact_Amount := 0;
    end if;
  
    for r in (select *
                from Hper_Staff_Plan_Items q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Plan_Id = i_Staff_Plan_Id)
    loop
      select sum(w.Amount)
        into r.Fact_Value
        from Hper_Staff_Plan_Parts w
       where w.Company_Id = r.Company_Id
         and w.Filial_Id = r.Filial_Id
         and w.Staff_Plan_Id = r.Staff_Plan_Id
         and w.Plan_Type_Id = r.Plan_Type_Id;
    
      r.Fact_Value   := Nvl(r.Fact_Value, 0);
      r.Fact_Percent := v_Round_Model.Eval(r.Fact_Value / r.Plan_Value * 100);
      v_Value        := r.Fact_Value * 100;
    
      begin
        select w.Fact_Amount
          into r.Fact_Amount
          from Hper_Staff_Plan_Rules w
         where w.Company_Id = i_Company_Id
           and w.Filial_Id = i_Filial_Id
           and w.Staff_Plan_Id = i_Staff_Plan_Id
           and w.Plan_Type_Id = r.Plan_Type_Id
           and v_Value > w.From_Percent * r.Plan_Value
           and v_Value <= Nvl(w.To_Percent, v_Max_Value) * r.Plan_Value;
      exception
        when others then
          r.Fact_Amount := null;
      end;
    
      if r.Plan_Type = Hper_Pref.c_Plan_Type_Main and
         r_Data.Main_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight or
         r.Plan_Type = Hper_Pref.c_Plan_Type_Extra and
         r_Data.Extra_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
        r.Fact_Amount := Nvl(r.Fact_Amount, r.Fact_Percent);
      else
        r.Fact_Amount := Nvl(r.Fact_Amount, r.Plan_Amount);
      end if;
    
      if r.Extra_Amount_Enabled = 'Y' then
        begin
          select w.Plan_Percent
            into v_Plan_Percent
            from Hper_Staff_Plan_Type_Rules w
           where w.Company_Id = i_Company_Id
             and w.Filial_Id = i_Filial_Id
             and w.Staff_Plan_Id = i_Staff_Plan_Id
             and w.Plan_Type_Id = r.Plan_Type_Id
             and r.Fact_Percent > w.From_Percent
             and r.Fact_Percent <= Nvl(w.To_Percent, v_Max_Value);
        exception
          when others then
            v_Plan_Percent := 0;
        end;
      
        r.Extra_Amount := v_Round_Model.Eval(r.Plan_Value * v_Plan_Percent / 100);
      
        if v_Currency_Id is not null then
          r.Extra_Amount := Mk_Util.Calc_Amount(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Currency_Id => v_Currency_Id,
                                                i_Rate_Date   => r_Data.Month_End_Date,
                                                i_Amount_Base => r.Extra_Amount);
        end if;
      else
        r.Extra_Amount := 0;
      end if;
    
      z_Hper_Staff_Plan_Items.Update_One(i_Company_Id    => i_Company_Id,
                                         i_Filial_Id     => i_Filial_Id,
                                         i_Staff_Plan_Id => i_Staff_Plan_Id,
                                         i_Plan_Type_Id  => r.Plan_Type_Id,
                                         i_Fact_Value    => Option_Number(r.Fact_Value),
                                         i_Fact_Percent  => Option_Number(r.Fact_Percent),
                                         i_Fact_Amount   => Option_Number(r.Fact_Amount),
                                         i_Extra_Amount  => Option_Number(r.Extra_Amount));
    
      if r.Plan_Type = Hper_Pref.c_Plan_Type_Main then
        if r_Data.Main_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
          r_Data.c_Main_Fact_Percent := r_Data.c_Main_Fact_Percent +
                                        v_Round_Model.Eval(r.Fact_Amount / 100 * r.Plan_Amount);
        else
          r_Data.Main_Fact_Amount := r_Data.Main_Fact_Amount +
                                     v_Round_Model.Eval(r.Fact_Amount * r.Fact_Value);
        end if;
      
        v_Main_Extra_Amount := v_Main_Extra_Amount + r.Extra_Amount;
      else
        if r_Data.Extra_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
          r_Data.c_Extra_Fact_Percent := r_Data.c_Extra_Fact_Percent +
                                         v_Round_Model.Eval(r.Fact_Amount / 100 * r.Plan_Amount);
        else
          r_Data.Extra_Fact_Amount := r_Data.Extra_Fact_Amount +
                                      v_Round_Model.Eval(r.Fact_Amount * r.Fact_Value);
        end if;
      
        v_Extra_Extra_Amount := v_Extra_Extra_Amount + r.Extra_Amount;
      end if;
    end loop;
  
    if r_Data.Main_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
      r_Data.Main_Fact_Amount := v_Round_Model.Eval(r_Data.c_Main_Fact_Percent / 100 *
                                                    r_Data.Main_Plan_Amount);
    else
      r_Data.c_Main_Fact_Percent := Nvl(v_Round_Model.Eval(r_Data.Main_Fact_Amount /
                                                           Nullif(r_Data.Main_Plan_Amount, 0) * 100),
                                        0);
    end if;
  
    if r_Data.Extra_Calc_Type = Hper_Pref.c_Plan_Calc_Type_Weight then
      r_Data.Extra_Fact_Amount := v_Round_Model.Eval(r_Data.c_Extra_Fact_Percent / 100 *
                                                     r_Data.Extra_Plan_Amount);
    else
      r_Data.c_Extra_Fact_Percent := Nvl(v_Round_Model.Eval(r_Data.Extra_Fact_Amount /
                                                            Nullif(r_Data.Extra_Plan_Amount, 0) * 100),
                                         0);
    end if;
  
    r_Data.Main_Fact_Percent  := r_Data.c_Main_Fact_Percent;
    r_Data.Extra_Fact_Percent := r_Data.c_Extra_Fact_Percent;
  
    z_Hper_Staff_Plans.Update_One(i_Company_Id           => i_Company_Id,
                                  i_Filial_Id            => i_Filial_Id,
                                  i_Staff_Plan_Id        => i_Staff_Plan_Id,
                                  i_Main_Fact_Percent    => Option_Number(r_Data.Main_Fact_Percent),
                                  i_Extra_Fact_Percent   => Option_Number(r_Data.Extra_Fact_Percent),
                                  i_Main_Fact_Amount     => Option_Number(r_Data.Main_Fact_Amount +
                                                                          v_Main_Extra_Amount),
                                  i_Extra_Fact_Amount    => Option_Number(r_Data.Extra_Fact_Amount +
                                                                          v_Extra_Extra_Amount),
                                  i_c_Main_Fact_Percent  => Option_Number(r_Data.c_Main_Fact_Percent),
                                  i_c_Extra_Fact_Percent => Option_Number(r_Data.c_Extra_Fact_Percent));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Calc_External
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  ) is
    r_Staff_Plan    Hper_Staff_Plans%rowtype;
    v_Division_Code Mhr_Divisions.Code%type;
    v_Code          Mr_Natural_Persons.Code%type;
    v_Part_Ids      Array_Number;
  begin
    r_Staff_Plan := z_Hper_Staff_Plans.Load(i_Company_Id    => i_Company_Id,
                                            i_Filial_Id     => i_Filial_Id,
                                            i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    v_Division_Code := z_Mhr_Divisions.Load(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Division_Id => r_Staff_Plan.Division_Id).Code;
    v_Code          := Href_Util.Staff_Code(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Staff_Id   => r_Staff_Plan.Staff_Id);
  
    for r in (select q.Plan_Type_Id, q.Sale_Kind
                from Hper_Staff_Plan_Items q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Staff_Plan_Id = i_Staff_Plan_Id
                 and q.Calc_Kind = Hper_Pref.c_Calc_Kind_External)
    loop
      v_Part_Ids := Array_Number();
    
      for Part in (select Part.Part_Id, Sale.Sale_Date as Part_Date, Sale.Amount, Part.Note
                     from (select q.Sale_Date, sum(q.Sale_Amount) Amount
                             from Hes_Billz_Consolidated_Sales q
                            where q.Company_Id = i_Company_Id
                              and q.Filial_Id = i_Filial_Id
                              and (r.Sale_Kind = Hper_Pref.c_Sale_Kind_Personal and
                                  q.Billz_Seller_Id = v_Code or
                                  r.Sale_Kind = Hper_Pref.c_Sale_Kind_Department and
                                  q.Billz_Office_Id = v_Division_Code)
                              and q.Sale_Date between r_Staff_Plan.Begin_Date and
                                  r_Staff_Plan.End_Date
                            group by q.Sale_Date
                           having sum(q.Sale_Amount) > 0) Sale
                     left join (select p.Part_Id, p.Part_Date, p.Note
                                 from Hper_Staff_Plan_Parts p
                                where p.Company_Id = i_Company_Id
                                  and p.Filial_Id = i_Filial_Id
                                  and p.Staff_Plan_Id = i_Staff_Plan_Id
                                  and p.Plan_Type_Id = r.Plan_Type_Id) Part
                       on Sale.Sale_Date = Part.Part_Date)
      loop
        if Part.Part_Id is null then
          Part.Part_Id := Hper_Next.Part_Id;
        end if;
      
        z_Hper_Staff_Plan_Parts.Save_One(i_Company_Id    => i_Company_Id,
                                         i_Filial_Id     => i_Filial_Id,
                                         i_Part_Id       => Part.Part_Id,
                                         i_Staff_Plan_Id => i_Staff_Plan_Id,
                                         i_Plan_Type_Id  => r.Plan_Type_Id,
                                         i_Part_Date     => Part.Part_Date,
                                         i_Amount        => Part.Amount,
                                         i_Note          => Part.Note);
      
        Fazo.Push(v_Part_Ids, Part.Part_Id);
      end loop;
    
      delete from Hper_Staff_Plan_Parts q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Plan_Id = i_Staff_Plan_Id
         and q.Plan_Type_Id = r.Plan_Type_Id
         and q.Part_Id not member of v_Part_Ids;
    end loop;
  
    Staff_Plan_Fix_Total(i_Company_Id    => i_Company_Id,
                         i_Filial_Id     => i_Filial_Id,
                         i_Staff_Plan_Id => i_Staff_Plan_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Update
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Values        Matrix_Varchar2
  ) is
    r_Data      Hper_Staff_Plans%rowtype;
    r_Plan_Item Hper_Staff_Plan_Items%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    if r_Data.Status not in
       (Hper_Pref.c_Staff_Plan_Status_New, Hper_Pref.c_Staff_Plan_Status_Draft) then
      Hper_Error.Raise_007(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                                                   i_Filial_Id  => r_Data.Filial_Id,
                                                                   i_Staff_Id   => r_Data.Staff_Id),
                           i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                           i_Status        => r_Data.Status,
                           i_Plan_Date     => r_Data.Plan_Date);
    end if;
  
    for i in 1 .. i_Values.Count
    loop
      r_Plan_Item := z_Hper_Staff_Plan_Items.Lock_Load(i_Company_Id    => i_Company_Id,
                                                       i_Filial_Id     => i_Filial_Id,
                                                       i_Staff_Plan_Id => i_Staff_Plan_Id,
                                                       i_Plan_Type_Id  => i_Values(i) (1));
    
      continue when r_Plan_Item.Calc_Kind in(Hper_Pref.c_Calc_Kind_Task,
                                             Hper_Pref.c_Calc_Kind_External);
    
      Hper_Core.Staff_Plan_Eval_Fact(i_Company_Id    => i_Company_Id,
                                     i_Filial_Id     => i_Filial_Id,
                                     i_Staff_Plan_Id => i_Staff_Plan_Id,
                                     i_Plan_Type_Id  => r_Plan_Item.Plan_Type_Id,
                                     i_Fact_Value    => Nvl(i_Values(i) (2), 0),
                                     i_Fact_Note     => i_Values(i) (3));
    end loop;
  
    Staff_Plan_Fix_Total(i_Company_Id    => i_Company_Id,
                         i_Filial_Id     => i_Filial_Id,
                         i_Staff_Plan_Id => i_Staff_Plan_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Part_Save(i_Plan_Part Hper_Staff_Plan_Parts%rowtype) is
    r_Staff_Plan      Hper_Staff_Plans%rowtype;
    r_Staff_Plan_Item Hper_Staff_Plan_Items%rowtype;
    r_Staff_Plan_Part Hper_Staff_Plan_Parts%rowtype;
  begin
    r_Staff_Plan := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Plan_Part.Company_Id,
                                                 i_Filial_Id     => i_Plan_Part.Filial_Id,
                                                 i_Staff_Plan_Id => i_Plan_Part.Staff_Plan_Id);
  
    if r_Staff_Plan.Status not in
       (Hper_Pref.c_Staff_Plan_Status_New, Hper_Pref.c_Staff_Plan_Status_Draft) then
      Hper_Error.Raise_008(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Staff_Plan.Company_Id,
                                                                   i_Filial_Id  => r_Staff_Plan.Filial_Id,
                                                                   i_Staff_Id   => r_Staff_Plan.Staff_Id),
                           i_Staff_Plan_Id => r_Staff_Plan.Staff_Plan_Id,
                           i_Status        => r_Staff_Plan.Status,
                           i_Plan_Date     => r_Staff_Plan.Plan_Date);
    end if;
  
    r_Staff_Plan_Item := z_Hper_Staff_Plan_Items.Load(i_Company_Id    => i_Plan_Part.Company_Id,
                                                      i_Filial_Id     => i_Plan_Part.Filial_Id,
                                                      i_Staff_Plan_Id => i_Plan_Part.Staff_Plan_Id,
                                                      i_Plan_Type_Id  => i_Plan_Part.Plan_Type_Id);
  
    if r_Staff_Plan_Item.Calc_Kind = Hper_Pref.c_Calc_Kind_External then
      Hper_Error.Raise_019(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Staff_Plan.Company_Id,
                                                                   i_Filial_Id  => r_Staff_Plan.Filial_Id,
                                                                   i_Staff_Id   => r_Staff_Plan.Staff_Id),
                           i_Staff_Plan_Id => r_Staff_Plan.Staff_Plan_Id,
                           i_Plan_Date     => r_Staff_Plan.Plan_Date);
    end if;
  
    if z_Hper_Staff_Plan_Parts.Exist(i_Company_Id => i_Plan_Part.Company_Id,
                                     i_Filial_Id  => i_Plan_Part.Filial_Id,
                                     i_Part_Id    => i_Plan_Part.Part_Id,
                                     o_Row        => r_Staff_Plan_Part) then
      z_Hper_Staff_Plan_Parts.Save_One(i_Company_Id    => r_Staff_Plan_Part.Company_Id,
                                       i_Filial_Id     => r_Staff_Plan_Part.Filial_Id,
                                       i_Part_Id       => r_Staff_Plan_Part.Part_Id,
                                       i_Staff_Plan_Id => r_Staff_Plan_Part.Staff_Plan_Id,
                                       i_Plan_Type_Id  => r_Staff_Plan_Part.Plan_Type_Id,
                                       i_Part_Date     => r_Staff_Plan_Part.Part_Date,
                                       i_Amount        => i_Plan_Part.Amount,
                                       i_Note          => i_Plan_Part.Note);
    else
      z_Hper_Staff_Plan_Parts.Save_One(i_Company_Id    => i_Plan_Part.Company_Id,
                                       i_Filial_Id     => i_Plan_Part.Filial_Id,
                                       i_Part_Id       => i_Plan_Part.Part_Id,
                                       i_Staff_Plan_Id => i_Plan_Part.Staff_Plan_Id,
                                       i_Plan_Type_Id  => i_Plan_Part.Plan_Type_Id,
                                       i_Part_Date     => Nvl(i_Plan_Part.Part_Date,
                                                              Htt_Util.Timestamp_To_Date(i_Timestamp => Current_Timestamp,
                                                                                         i_Timezone  => null)),
                                       i_Amount        => i_Plan_Part.Amount,
                                       i_Note          => i_Plan_Part.Note);
    end if;
  
    Staff_Plan_Fix_Total(i_Company_Id    => r_Staff_Plan.Company_Id,
                         i_Filial_Id     => r_Staff_Plan.Filial_Id,
                         i_Staff_Plan_Id => r_Staff_Plan.Staff_Plan_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Part_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Part_Id    number
  ) is
    r_Staff_Plan      Hper_Staff_Plans%rowtype;
    r_Staff_Plan_Item Hper_Staff_Plan_Items%rowtype;
    r_Part            Hper_Staff_Plan_Parts%rowtype;
  begin
    r_Part := z_Hper_Staff_Plan_Parts.Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Part_Id    => i_Part_Id);
  
    r_Staff_Plan := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => r_Part.Company_Id,
                                                 i_Filial_Id     => r_Part.Filial_Id,
                                                 i_Staff_Plan_Id => r_Part.Staff_Plan_Id);
  
    if r_Staff_Plan.Status not in
       (Hper_Pref.c_Staff_Plan_Status_New, Hper_Pref.c_Staff_Plan_Status_Draft) then
      Hper_Error.Raise_009(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Staff_Plan.Company_Id,
                                                                   i_Filial_Id  => r_Staff_Plan.Filial_Id,
                                                                   i_Staff_Id   => r_Staff_Plan.Staff_Id),
                           i_Staff_Plan_Id => r_Staff_Plan.Staff_Plan_Id,
                           i_Status        => r_Staff_Plan.Status,
                           i_Plan_Date     => r_Staff_Plan.Plan_Date);
    end if;
  
    r_Staff_Plan_Item := z_Hper_Staff_Plan_Items.Load(i_Company_Id    => r_Part.Company_Id,
                                                      i_Filial_Id     => r_Part.Filial_Id,
                                                      i_Staff_Plan_Id => r_Part.Staff_Plan_Id,
                                                      i_Plan_Type_Id  => r_Part.Plan_Type_Id);
  
    if r_Staff_Plan_Item.Calc_Kind = Hper_Pref.c_Calc_Kind_External then
      Hper_Error.Raise_020(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Staff_Plan.Company_Id,
                                                                   i_Filial_Id  => r_Staff_Plan.Filial_Id,
                                                                   i_Staff_Id   => r_Staff_Plan.Staff_Id),
                           i_Staff_Plan_Id => r_Staff_Plan.Staff_Plan_Id,
                           i_Plan_Date     => r_Staff_Plan.Plan_Date);
    end if;
  
    z_Hper_Staff_Plan_Parts.Delete_One(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Part_Id    => i_Part_Id);
  
    Staff_Plan_Fix_Total(i_Company_Id    => r_Staff_Plan.Company_Id,
                         i_Filial_Id     => r_Staff_Plan.Filial_Id,
                         i_Staff_Plan_Id => r_Staff_Plan.Staff_Plan_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Save_Tasks
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Task_Ids      Array_Number,
    i_Fact_Note     varchar2
  ) is
    r_Data       Hper_Staff_Plans%rowtype;
    v_Fact_Value number := 0;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    if r_Data.Status not in
       (Hper_Pref.c_Staff_Plan_Status_New, Hper_Pref.c_Staff_Plan_Status_Draft) then
      Hper_Error.Raise_010(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                                                   i_Filial_Id  => r_Data.Filial_Id,
                                                                   i_Staff_Id   => r_Data.Staff_Id),
                           i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                           i_Status        => r_Data.Status,
                           i_Plan_Date     => r_Data.Plan_Date);
    end if;
  
    delete Hper_Staff_Plan_Tasks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Plan_Id = i_Staff_Plan_Id
       and q.Plan_Type_Id = i_Plan_Type_Id;
  
    Hper_Core.Staff_Plan_Clear_Fact(i_Company_Id    => i_Company_Id,
                                    i_Filial_Id     => i_Filial_Id,
                                    i_Staff_Plan_Id => i_Staff_Plan_Id,
                                    i_Plan_Type_Id  => i_Plan_Type_Id);
    for r in (select *
                from Ms_Tasks q
               where q.Company_Id = i_Company_Id
                 and q.Task_Id in (select Column_Value
                                     from table(i_Task_Ids)))
    loop
      z_Hper_Staff_Plan_Tasks.Insert_One(i_Company_Id    => i_Company_Id,
                                         i_Filial_Id     => i_Filial_Id,
                                         i_Staff_Plan_Id => i_Staff_Plan_Id,
                                         i_Plan_Type_Id  => i_Plan_Type_Id,
                                         i_Task_Id       => r.Task_Id);
    
      v_Fact_Value := v_Fact_Value + r.Grade;
    end loop;
  
    Hper_Core.Staff_Plan_Eval_Fact(i_Company_Id    => i_Company_Id,
                                   i_Filial_Id     => i_Filial_Id,
                                   i_Staff_Plan_Id => i_Staff_Plan_Id,
                                   i_Plan_Type_Id  => i_Plan_Type_Id,
                                   i_Fact_Value    => v_Fact_Value,
                                   i_Fact_Note     => i_Fact_Note);
  
    Staff_Plan_Fix_Total(i_Company_Id    => i_Company_Id,
                         i_Filial_Id     => i_Filial_Id,
                         i_Staff_Plan_Id => i_Staff_Plan_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Update_Total
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Plan_Id      number,
    i_Main_Fact_Percent  number,
    i_Extra_Fact_Percent number
  ) is
    r_Data               Hper_Staff_Plans%rowtype;
    v_Main_Extra_Amount  number;
    v_Extra_Extra_Amount number;
    v_Round_Model        Round_Model;
  begin
    r_Data := z_Hper_Staff_Plans.Load(i_Company_Id    => i_Company_Id,
                                      i_Filial_Id     => i_Filial_Id,
                                      i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    select Nvl(sum(Decode(q.Plan_Type, Hper_Pref.c_Plan_Type_Main, q.Extra_Amount, 0)), 0),
           Nvl(sum(Decode(q.Plan_Type, Hper_Pref.c_Plan_Type_Extra, q.Extra_Amount, 0)), 0)
      into v_Main_Extra_Amount, v_Extra_Extra_Amount
      from Hper_Staff_Plan_Items q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Plan_Id = i_Staff_Plan_Id;
  
    v_Round_Model := Round_Model(Md_Pref.Round_Model(i_Company_Id));
  
    r_Data.Main_Fact_Percent  := i_Main_Fact_Percent;
    r_Data.Extra_Fact_Percent := i_Extra_Fact_Percent;
  
    r_Data.Main_Fact_Amount  := v_Round_Model.Eval(r_Data.Main_Fact_Percent / 100 *
                                                   r_Data.Main_Plan_Amount);
    r_Data.Extra_Fact_Amount := v_Round_Model.Eval(r_Data.Extra_Fact_Percent / 100 *
                                                   r_Data.Extra_Plan_Amount);
  
    z_Hper_Staff_Plans.Update_One(i_Company_Id         => i_Company_Id,
                                  i_Filial_Id          => i_Filial_Id,
                                  i_Staff_Plan_Id      => i_Staff_Plan_Id,
                                  i_Main_Fact_Percent  => Option_Number(r_Data.Main_Fact_Percent),
                                  i_Extra_Fact_Percent => Option_Number(r_Data.Extra_Fact_Percent),
                                  i_Main_Fact_Amount   => Option_Number(r_Data.Main_Fact_Amount +
                                                                        v_Main_Extra_Amount),
                                  i_Extra_Fact_Amount  => Option_Number(r_Data.Extra_Fact_Amount +
                                                                        v_Extra_Extra_Amount));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Set_Draft
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  ) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    if r_Data.Status != Hper_Pref.c_Staff_Plan_Status_New then
      Hper_Error.Raise_011(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                                                   i_Filial_Id  => r_Data.Filial_Id,
                                                                   i_Staff_Id   => r_Data.Staff_Id),
                           i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                           i_Status        => r_Data.Status,
                           i_Plan_Date     => r_Data.Plan_Date);
    end if;
  
    z_Hper_Staff_Plans.Update_One(i_Company_Id    => i_Company_Id,
                                  i_Filial_Id     => i_Filial_Id,
                                  i_Staff_Plan_Id => i_Staff_Plan_Id,
                                  i_Status        => Option_Varchar2(Hper_Pref.c_Staff_Plan_Status_Draft));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Set_New
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  ) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    if r_Data.Status not in
       (Hper_Pref.c_Staff_Plan_Status_Draft, Hper_Pref.c_Staff_Plan_Status_Waiting) then
      Hper_Error.Raise_012(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                                                   i_Filial_Id  => r_Data.Filial_Id,
                                                                   i_Staff_Id   => r_Data.Staff_Id),
                           i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                           i_Status        => r_Data.Status,
                           i_Plan_Date     => r_Data.Plan_Date);
    end if;
  
    z_Hper_Staff_Plans.Update_One(i_Company_Id    => i_Company_Id,
                                  i_Filial_Id     => i_Filial_Id,
                                  i_Staff_Plan_Id => i_Staff_Plan_Id,
                                  i_Status        => Option_Varchar2(Hper_Pref.c_Staff_Plan_Status_New));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Set_Waiting
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  ) is
    r_Data            Hper_Staff_Plans%rowtype;
    r_Plan_Interval   Hper_Staff_Plan_Intervals%rowtype;
    v_External_Exists varchar2(1);
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    select Nvl((select 'Y'
                 from Hper_Staff_Plan_Items q
                where q.Company_Id = i_Company_Id
                  and q.Filial_Id = i_Filial_Id
                  and q.Staff_Plan_Id = i_Staff_Plan_Id
                  and q.Calc_Kind = Hper_Pref.c_Calc_Kind_External
                  and Rownum = 1),
               'N')
      into v_External_Exists
      from Dual;
  
    if r_Data.Status = Hper_Pref.c_Staff_Plan_Status_Waiting then
      Hper_Error.Raise_013(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                                                   i_Filial_Id  => r_Data.Filial_Id,
                                                                   i_Staff_Id   => r_Data.Staff_Id),
                           i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                           i_Status        => r_Data.Status,
                           i_Plan_Date     => r_Data.Plan_Date);
    end if;
  
    if r_Data.Status = Hper_Pref.c_Staff_Plan_Status_Completed then
      if v_External_Exists = 'N' then
        Staff_Plan_Update_Total(i_Company_Id         => i_Company_Id,
                                i_Filial_Id          => i_Filial_Id,
                                i_Staff_Plan_Id      => i_Staff_Plan_Id,
                                i_Main_Fact_Percent  => r_Data.c_Main_Fact_Percent,
                                i_Extra_Fact_Percent => r_Data.c_Extra_Fact_Percent);
      end if;
    
      r_Plan_Interval := z_Hper_Staff_Plan_Intervals.Lock_Load(i_Company_Id    => i_Company_Id,
                                                               i_Filial_Id     => i_Filial_Id,
                                                               i_Staff_Plan_Id => i_Staff_Plan_Id);
    
      z_Hper_Staff_Plan_Intervals.Delete_One(i_Company_Id    => i_Company_Id,
                                             i_Filial_Id     => i_Filial_Id,
                                             i_Staff_Plan_Id => i_Staff_Plan_Id);
    
      Hpd_Api.Lock_Interval_Delete(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Interval_Id => r_Plan_Interval.Interval_Id);
    end if;
  
    if v_External_Exists = 'Y' then
      Staff_Plan_Calc_External(i_Company_Id    => i_Company_Id,
                               i_Filial_Id     => i_Filial_Id,
                               i_Staff_Plan_Id => i_Staff_Plan_Id);
    end if;
  
    z_Hper_Staff_Plans.Update_One(i_Company_Id    => i_Company_Id,
                                  i_Filial_Id     => i_Filial_Id,
                                  i_Staff_Plan_Id => i_Staff_Plan_Id,
                                  i_Status        => Option_Varchar2(Hper_Pref.c_Staff_Plan_Status_Waiting));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Set_Completed
  (
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Staff_Plan_Id      number,
    i_Main_Fact_Percent  number := null,
    i_Extra_Fact_Percent number := null
  ) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    if r_Data.Status <> Hper_Pref.c_Staff_Plan_Status_Waiting then
      Hper_Error.Raise_014(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                                                   i_Filial_Id  => r_Data.Filial_Id,
                                                                   i_Staff_Id   => r_Data.Staff_Id),
                           i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                           i_Status        => r_Data.Status,
                           i_Plan_Date     => r_Data.Plan_Date);
    end if;
  
    if i_Main_Fact_Percent is not null then
      Staff_Plan_Update_Total(i_Company_Id         => i_Company_Id,
                              i_Filial_Id          => i_Filial_Id,
                              i_Staff_Plan_Id      => i_Staff_Plan_Id,
                              i_Main_Fact_Percent  => i_Main_Fact_Percent,
                              i_Extra_Fact_Percent => i_Extra_Fact_Percent);
    end if;
  
    z_Hper_Staff_Plans.Update_One(i_Company_Id    => i_Company_Id,
                                  i_Filial_Id     => i_Filial_Id,
                                  i_Staff_Plan_Id => i_Staff_Plan_Id,
                                  i_Status        => Option_Varchar2(Hper_Pref.c_Staff_Plan_Status_Completed));
  
    Hpd_Api.Perf_Lock_Interval_Insert(i_Company_Id    => i_Company_Id,
                                      i_Filial_Id     => i_Filial_Id,
                                      i_Staff_Plan_Id => i_Staff_Plan_Id,
                                      i_Staff_Id      => r_Data.Staff_Id,
                                      i_Begin_Date    => r_Data.Month_Begin_Date,
                                      i_End_Date      => r_Data.Month_End_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Delete
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Plan_Id number
  ) is
    r_Data Hper_Staff_Plans%rowtype;
  begin
    r_Data := z_Hper_Staff_Plans.Lock_Load(i_Company_Id    => i_Company_Id,
                                           i_Filial_Id     => i_Filial_Id,
                                           i_Staff_Plan_Id => i_Staff_Plan_Id);
  
    if r_Data.Status <> Hper_Pref.c_Staff_Plan_Status_Draft then
      Hper_Error.Raise_015(i_Staff_Name    => Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                                                   i_Filial_Id  => r_Data.Filial_Id,
                                                                   i_Staff_Id   => r_Data.Staff_Id),
                           i_Staff_Plan_Id => r_Data.Staff_Plan_Id,
                           i_Status        => r_Data.Status,
                           i_Plan_Date     => r_Data.Plan_Date);
    end if;
  
    z_Hper_Staff_Plans.Delete_One(i_Company_Id    => i_Company_Id,
                                  i_Filial_Id     => i_Filial_Id,
                                  i_Staff_Plan_Id => i_Staff_Plan_Id);
  end;

end Hper_Api;
/
