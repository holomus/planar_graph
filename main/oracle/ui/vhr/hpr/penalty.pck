create or replace package Ui_Vhr307 is
  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Copy_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Edit(p Hashmap);
end Ui_Vhr307;
/
create or replace package body Ui_Vhr307 is
  ----------------------------------------------------------------------------------------------------  
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put_All(References);
    Result.Put('data', Fazo.Zip_Map('state', 'A'));
    Result.Put('penalty_kinds', Fazo.Zip_Matrix(Hpr_Util.Penalty_Kinds));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    v_Matrix  Matrix_Varchar2;
    r_Penalty Hpr_Penalties%rowtype;
    v_Data    Hashmap;
    result    Hashmap := Hashmap();
  begin
    r_Penalty := z_Hpr_Penalties.Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Penalty_Id => p.r_Number('penalty_id'));
  
    v_Data := z_Hpr_Penalties.To_Map(r_Penalty, z.Penalty_Id, z.Name, z.Division_Id, z.State);
  
    v_Data.Put('month', to_char(r_Penalty.Month, Href_Pref.c_Date_Format_Month));
  
    v_Data.Put('division_name',
               z_Mhr_Divisions.Take(i_Company_Id => r_Penalty.Company_Id, i_Filial_Id => r_Penalty.Filial_Id, i_Division_Id => r_Penalty.Division_Id).Name);
  
    -- penalties
    select Array_Varchar2(q.Penalty_Kind,
                          Nullif(q.From_Day, 0),
                          q.To_Day,
                          Nullif(q.From_Time, 0),
                          q.To_Time,
                          q.Penalty_Coef,
                          q.Penalty_Per_Time,
                          q.Penalty_Amount,
                          q.Penalty_Time,
                          q.Calc_After_From_Time)
      bulk collect
      into v_Matrix
      from Hpr_Penalty_Policies q
     where q.Company_Id = r_Penalty.Company_Id
       and q.Penalty_Id = r_Penalty.Penalty_Id
     order by q.From_Time, q.From_Day;
  
    v_Data.Put('penalties', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('data', v_Data);
    Result.Put('penalty_kinds', Fazo.Zip_Matrix(Hpr_Util.Penalty_Kinds));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Copy_Model(p Hashmap) return Hashmap is
    v_Matrix  Matrix_Varchar2;
    r_Penalty Hpr_Penalties%rowtype;
    v_Data    Hashmap := Hashmap();
    result    Hashmap := Hashmap();
  begin
    r_Penalty := z_Hpr_Penalties.Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Penalty_Id => p.r_Number('penalty_id'));
  
    v_Data.Put('state', r_Penalty.State);
    v_Data.Put('month', to_char(r_Penalty.Month, Href_Pref.c_Date_Format_Month));
  
    -- penalties
    select Array_Varchar2(q.Penalty_Kind,
                          Nullif(q.From_Day, 0),
                          q.To_Day,
                          Nullif(q.From_Time, 0),
                          q.To_Time,
                          q.Penalty_Coef,
                          q.Penalty_Per_Time,
                          q.Penalty_Amount,
                          q.Penalty_Time)
      bulk collect
      into v_Matrix
      from Hpr_Penalty_Policies q
     where q.Company_Id = r_Penalty.Company_Id
       and q.Penalty_Id = r_Penalty.Penalty_Id
     order by q.From_Time, q.From_Day;
  
    v_Data.Put('penalties', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('data', v_Data);
    Result.Put('penalty_kinds', Fazo.Zip_Matrix(Hpr_Util.Penalty_Kinds));
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p_Penalty in out nocopy Hpr_Pref.Penalty_Rt,
    p         Hashmap
  ) is
    v_Item  Hashmap;
    v_Items Arraylist;
  begin
    v_Items := Nvl(p.o_Arraylist('penalties'), Arraylist());
  
    for i in 1 .. v_Items.Count
    loop
      v_Item := Treat(v_Items.r_Hashmap(i) as Hashmap);
    
      Hpr_Util.Penalty_Add_Policy(p_Penalty              => p_Penalty,
                                  i_Penalty_Kind         => v_Item.r_Varchar2('penalty_kind'),
                                  i_Penalty_Type         => v_Item.r_Varchar2('penalty_type'),
                                  i_From_Day             => Nvl(v_Item.o_Number('from_day'), 0),
                                  i_To_Day               => v_Item.o_Number('to_day'),
                                  i_From_Time            => Nvl(v_Item.o_Number('from_time'), 0),
                                  i_To_Time              => v_Item.o_Number('to_time'),
                                  i_Penalty_Coef         => v_Item.o_Number('penalty_coef'),
                                  i_Penalty_Per_Time     => v_Item.o_Number('penalty_per_time'),
                                  i_Penalty_Amount       => v_Item.o_Number('penalty_amount'),
                                  i_Penalty_Time         => v_Item.o_Number('penalty_time'),
                                  i_Calc_After_From_Time => v_Item.o_Varchar2('calc_after_from_time'));
    end loop;
  
    Hpr_Api.Penalty_Save(p_Penalty);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
    v_Division_Ids Array_Number := p.o_Array_Number('division_id');
    v_Penalty      Hpr_Pref.Penalty_Rt;
  begin
    Hpr_Util.Penalty_New(o_Penalty    => v_Penalty,
                         i_Company_Id => Ui.Company_Id,
                         i_Filial_Id  => Ui.Filial_Id,
                         i_Penalty_Id => null,
                         i_Month      => p.r_Date('month', Href_Pref.c_Date_Format_Month),
                         i_Name       => p.o_Varchar2('name'),
                         i_State      => p.r_Varchar2('state'));
  
    if v_Division_Ids is null then
      v_Penalty.Penalty_Id := Hpr_Next.Penalty_Id;
    
      save(v_Penalty, p);
    else
      for i in 1 .. v_Division_Ids.Count
      loop
        v_Penalty.Penalty_Id  := Hpr_Next.Penalty_Id;
        v_Penalty.Division_Id := v_Division_Ids(i);
        v_Penalty.Policies    := Hpr_Pref.Penalty_Policy_Nt();
      
        save(v_Penalty, p);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    v_Penalty Hpr_Pref.Penalty_Rt;
  begin
    Hpr_Util.Penalty_New(o_Penalty     => v_Penalty,
                         i_Company_Id  => Ui.Company_Id,
                         i_Filial_Id   => Ui.Filial_Id,
                         i_Penalty_Id  => p.r_Number('penalty_id'),
                         i_Month       => p.r_Date('month', Href_Pref.c_Date_Format_Month),
                         i_Name        => p.o_Varchar2('name'),
                         i_Division_Id => p.r_Number('division_id'),
                         i_State       => p.r_Varchar2('state'));
  
    save(v_Penalty, p);
  end;

end Ui_Vhr307;
/
