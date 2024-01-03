create or replace package Ui_Vhr478 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr478;
/
create or replace package body Ui_Vhr478 is
  ----------------------------------------------------------------------------------------------------
  Function Round_Model(i_Round_Model varchar2 := null) return Hashmap is
    v_Round_Model varchar2(30) := Nvl(i_Round_Model, Mkr_Util.Default_Round_Model);
    v_Matrix      Matrix_Varchar2 := Mkr_Util.Round_Model_Types;
    v_Data        varchar2(50) := Substr(v_Round_Model, Length(v_Round_Model), 1);
    v_Value       varchar2(50);
    result        Hashmap := Hashmap;
  begin
    for i in 1 .. v_Matrix.Count
    loop
      if v_Matrix(i) (1) = v_Data then
        v_Value := v_Matrix(i) (2);
        Result.Put('round_type', v_Value);
        exit;
      end if;
    end loop;
  
    v_Matrix := Mkr_Util.Round_Model_Values;
    v_Data   := Substr(v_Round_Model, 1, Length(v_Round_Model) - 1);
  
    for i in 1 .. v_Matrix.Count
    loop
      if v_Matrix(i) (1) = v_Data then
        v_Value := v_Matrix(i) (2);
        Result.Put('round_value', v_Value);
        exit;
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Ranks(i_Register_Id number) return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Rank_Id,
                          (select w.Name
                             from Mhr_Ranks w
                            where w.Company_Id = q.Company_Id
                              and w.Filial_Id = q.Filial_Id
                              and w.Rank_Id = q.Rank_Id))
      bulk collect
      into v_Matrix
      from Hrm_Register_Ranks q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Register_Id = i_Register_Id
     order by q.Order_No;
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Indicators(i_Register_Id number) return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Rank_Id,
                          (select w.Name
                             from Href_Indicators w
                            where w.Company_Id = q.Company_Id
                              and w.Indicator_Id = q.Indicator_Id),
                          q.Indicator_Value,
                          q.Coefficient)
      bulk collect
      into v_Matrix
      from Hrm_Register_Rank_Indicators q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Register_Id = i_Register_Id;
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Data Hrm_Wage_Scale_Registers%rowtype;
    result Hashmap;
  begin
    r_Data := z_Hrm_Wage_Scale_Registers.Load(i_Company_Id  => Ui.Company_Id,
                                              i_Filial_Id   => Ui.Filial_Id,
                                              i_Register_Id => p.r_Number('register_id'));
  
    result := z_Hrm_Wage_Scale_Registers.To_Map(r_Data,
                                                z.Register_Id,
                                                z.Register_Date,
                                                z.Register_Number,
                                                z.Wage_Scale_Id,
                                                z.Base_Wage,
                                                z.Valid_From,
                                                z.Posted,
                                                z.Note);
  
    Result.Put_All(Round_Model(r_Data.Round_Model));
    Result.Put('ranks', Fazo.Zip_Matrix(Get_Ranks(r_Data.Register_Id)));
    Result.Put('indicators', Fazo.Zip_Matrix(Get_Indicators(r_Data.Register_Id)));
  
    if r_Data.Base_Wage is null then
      Result.Put('with_base_wage', Ui.t_No);
    else
      Result.Put('with_base_wage', Ui.t_Yes);
    end if;
  
    Result.Put('wage_scale_name',
               z_Hrm_Wage_Scales.Load(i_Company_Id => r_Data.Company_Id, i_Filial_Id => r_Data.Filial_Id, i_Wage_Scale_Id => r_Data.Wage_Scale_Id).Name);
  
    return result;
  end;

end Ui_Vhr478;
/
