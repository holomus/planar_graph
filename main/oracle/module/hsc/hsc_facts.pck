create or replace package Hsc_Facts is
  ----------------------------------------------------------------------------------------------------
  Function Import_File
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Data       Hashmap
  ) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Predict_Facts_Response
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Data       Array_Varchar2
  ) return Hashmap;
end Hsc_Facts;
/
create or replace package body Hsc_Facts is
  ----------------------------------------------------------------------------------------------------
  -- template global variables
  ----------------------------------------------------------------------------------------------------
  g_Starting_Row   number;
  g_Date_Column    number;
  g_Object_Column  number;
  g_Max_Fact_Date  date;
  g_Fact           Hsc_Driver_Facts%rowtype;
  g_Error_Messages Arraylist;
  g_Errors         Arraylist;

  ----------------------------------------------------------------------------------------------------
  g_Colums_Used Fazo.Boolean_Code_Aat;

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
    return b.Translate('HSC:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Empty_Columns Fazo.Boolean_Code_Aat;
  begin
    Hsc_Util.Load_Import_Settings(o_Starting_Row  => g_Starting_Row,
                                  o_Date_Column   => g_Date_Column,
                                  o_Object_Column => g_Object_Column,
                                  i_Company_Id    => i_Company_Id,
                                  i_Filial_Id     => i_Filial_Id);
  
    g_Max_Fact_Date := null;
    g_Fact          := null;
  
    g_Errors         := Arraylist();
    g_Error_Messages := Arraylist();
  
    g_Colums_Used := v_Empty_Columns;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Object(i_Object_Code varchar2) is
  begin
    g_Fact.Object_Id := Mhr_Util.Division_Id_By_Code(i_Company_Id => g_Fact.Company_Id,
                                                     i_Filial_Id  => g_Fact.Filial_Id,
                                                     i_Code       => i_Object_Code);
  
  exception
    when others then
      b.Raise_Error(t('$1{error message} with object code $2{object_code}',
                      b.Trim_Ora_Error(sqlerrm),
                      i_Object_Code));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fact_Date(i_Fact_Date varchar2) is
  begin
    g_Fact.Fact_Date := Mr_Util.Convert_To_Date(i_Fact_Date);
  
  exception
    when others then
      b.Raise_Error(t('$1{error message} with fact date $2{fact_date}',
                      b.Trim_Ora_Error(sqlerrm),
                      i_Fact_Date));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fact_Value
  (
    i_Fact_Value    varchar2,
    i_Column_Number number
  ) is
  begin
    g_Fact.Fact_Value := i_Fact_Value;
  
  exception
    when others then
      b.Raise_Error(t('$1{error message} with fact value $2{fact_value} in the column $3{column number}',
                      b.Trim_Ora_Error(sqlerrm),
                      i_Fact_Value,
                      i_Column_Number));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Fact_Save is
    r_Fact Hsc_Driver_Facts%rowtype;
  
    -------------------------------------------------- 
    Function Used_Column
    (
      i_Object_Id number,
      i_Area_Id   number,
      i_Driver_Id number,
      i_Fact_Date date
    ) return boolean is
    begin
      return g_Colums_Used(i_Object_Id || ':' || i_Area_Id || ':' || i_Driver_Id || ':' ||
                           to_char(i_Fact_Date, 'yyyymmdd'));
    exception
      when No_Data_Found then
        return false;
    end;
  
  begin
    g_Fact.Fact_Id := Hsc_Util.Next_Fact_Id(i_Company_Id => g_Fact.Company_Id,
                                            i_Filial_Id  => g_Fact.Filial_Id,
                                            i_Object_Id  => g_Fact.Object_Id,
                                            i_Area_Id    => g_Fact.Area_Id,
                                            i_Driver_Id  => g_Fact.Driver_Id,
                                            i_Fact_Type  => g_Fact.Fact_Type,
                                            i_Fact_Date  => g_Fact.Fact_Date);
  
    if z_Hsc_Driver_Facts.Exist(i_Company_Id => g_Fact.Company_Id,
                                i_Filial_Id  => g_Fact.Filial_Id,
                                i_Fact_Id    => g_Fact.Fact_Id,
                                o_Row        => r_Fact) then
      if Used_Column(g_Fact.Object_Id, g_Fact.Area_Id, g_Fact.Driver_Id, g_Fact.Fact_Date) then
        g_Fact.Fact_Value := g_Fact.Fact_Value + r_Fact.Fact_Value;
      else
        z_Hsc_Driver_Facts.Delete_One(i_Company_Id => r_Fact.Company_Id,
                                      i_Filial_Id  => r_Fact.Filial_Id,
                                      i_Fact_Id    => r_Fact.Fact_Id);
      end if;
    end if;
  
    g_Max_Fact_Date := Greatest(Nvl(g_Fact.Fact_Date, g_Max_Fact_Date),
                                Nvl(g_Max_Fact_Date, g_Fact.Fact_Date));
  
    Hsc_Api.Driver_Fact_Save(g_Fact);
  
    g_Colums_Used(g_Fact.Object_Id || ':' || g_Fact.Area_Id || ':' || g_Fact.Driver_Id || ':' || to_char(g_Fact.Fact_Date, 'yyyymmdd')) := true;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Parse_Row
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
  begin
    Set_Fact_Date(i_Sheet.o_Varchar2(i_Row_Index, g_Date_Column));
    Set_Object(i_Sheet.o_Varchar2(i_Row_Index, g_Object_Column));
  
    for r in (select *
                from Hsc_Driver_Fact_Import_Settings t
               where t.Company_Id = g_Fact.Company_Id
                 and t.Filial_Id = g_Fact.Filial_Id
                 and t.Object_Id = g_Fact.Object_Id)
    loop
      g_Fact.Area_Id   := r.Area_Id;
      g_Fact.Driver_Id := r.Driver_Id;
    
      Set_Fact_Value(i_Fact_Value    => i_Sheet.o_Varchar2(i_Row_Index, r.Column_Index),
                     i_Column_Number => r.Column_Index);
    
      if g_Fact.Fact_Value is not null then
        Fact_Save;
      end if;
    end loop;
  exception
    -- rows, where errors in base values (object name and fact date) occured, will be ignored
    when others then
      g_Error_Messages.Push(b.Trim_Ora_Error(sqlerrm));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Error(i_Row_Index number) is
    v_Error Hashmap;
  begin
    if g_Error_Messages.Count > 0 then
      v_Error := Hashmap();
    
      v_Error.Put('row_id', i_Row_Index);
      v_Error.Put('items', g_Error_Messages);
    
      g_Errors.Push(v_Error);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Import_File
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Data       Hashmap
  ) return Hashmap is
    v_Sheets Arraylist;
    v_Sheet  Excel_Sheet;
    result   Hashmap := Hashmap();
  begin
    v_Sheets := i_Data.r_Arraylist('import_file');
    v_Sheet  := Excel_Sheet(v_Sheets.r_Hashmap(1));
    Set_Global_Variables(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    g_Fact.Company_Id := i_Company_Id;
    g_Fact.Filial_Id  := i_Filial_Id;
    g_Fact.Fact_Type  := Hsc_Pref.c_Fact_Type_Actual;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      g_Error_Messages := Arraylist();
    
      Parse_Row(v_Sheet, i);
      Push_Error(i);
    end loop;
  
    Result.Put('errors', g_Errors);
    Result.Put('max_fact_date', g_Max_Fact_Date);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Predict_Facts_Response
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Data       Array_Varchar2
  ) return Hashmap is
    v_Data Gmap := Gmap(Json_Object_t.Parse(Fazo.Make_Clob(i_Data)));
  
    v_Fact       Gmap := Gmap();
    v_Facts      Glist;
    v_Category   Gmap := Gmap();
    v_Categories Glist := v_Data.r_Glist('categories');
  
    v_Predict_Type varchar2(1) := v_Data.r_Varchar2('predict_type');
    v_Area_Id      number;
    v_Driver_Id    number;
  
    v_Error_Messages Arraylist := Arraylist();
  
    r_Fact Hsc_Driver_Facts%rowtype;
  
    v_Average     number;
    v_Value_Cache Fazo.Number_Code_Aat;
  
    result Hashmap := Hashmap();
  
    --------------------------------------------------
    Function Make_Key
    (
      i_Area_Id   number,
      i_Driver_Id number,
      i_Period    date,
      i_Week_Day  number
    ) return varchar2 is
    begin
      return i_Area_Id || '$' || i_Driver_Id || '$' || to_char(i_Period, 'yyyymmdd') || '$' || i_Week_Day;
    end;
  
    --------------------------------------------------
    Function Calc_Average
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Object_Id  number,
      i_Area_Id    number,
      i_Driver_Id  number,
      i_Period     date,
      i_Week_Day   number
    ) return number is
      result number;
    begin
      return v_Value_Cache(Make_Key(i_Area_Id, i_Driver_Id, Trunc(i_Period, 'mon'), i_Week_Day));
    exception
      when No_Data_Found then
        select avg(q.Fact_Value)
          into result
          from Hsc_Driver_Facts q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Object_Id = i_Object_Id
           and q.Area_Id = i_Area_Id
           and q.Driver_Id = i_Driver_Id
           and q.Fact_Type = Hsc_Pref.c_Fact_Type_Actual
           and q.Fact_Date between Trunc(Trunc(i_Period, 'mon') - 1, 'mon') and
               Trunc(i_Period, 'mon') - 1
           and Trunc(q.Fact_Date) - Trunc(q.Fact_Date, 'iw') + 1 = i_Week_Day;
      
        v_Value_Cache(Make_Key(i_Area_Id, i_Driver_Id, Trunc(i_Period, 'mon'), i_Week_Day)) := result;
      
        return result;
    end;
  begin
    for i in 1 .. v_Categories.Count
    loop
      v_Category.Val := v_Categories.r_Gmap(i);
    
      v_Area_Id   := v_Category.r_Number('area_id');
      v_Driver_Id := v_Category.r_Number('driver_id');
      v_Facts     := Glist();
    
      if v_Category.Has('predicted') then
        v_Facts.Val := Json_Array_t.Parse(v_Category.Val.Get_Clob('predicted'));
      end if;
    
      for k in 1 .. v_Facts.Count
      loop
        v_Fact.Val := v_Facts.r_Gmap(k);
      
        z_Hsc_Driver_Facts.Init(p_Row        => r_Fact,
                                i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Object_Id  => i_Object_Id,
                                i_Area_Id    => v_Area_Id,
                                i_Driver_Id  => v_Driver_Id,
                                i_Fact_Type  => v_Predict_Type,
                                i_Fact_Date  => Hac_Util.Unix_Ts_To_Date(Round(v_Fact.r_Number('fact_date') / 1000)),
                                i_Fact_Value => to_number(v_Fact.r_Varchar2('fact_value')));
      
        r_Fact.Fact_Id := Hsc_Util.Next_Fact_Id(i_Company_Id => r_Fact.Company_Id,
                                                i_Filial_Id  => r_Fact.Filial_Id,
                                                i_Object_Id  => r_Fact.Object_Id,
                                                i_Area_Id    => r_Fact.Area_Id,
                                                i_Driver_Id  => r_Fact.Driver_Id,
                                                i_Fact_Type  => r_Fact.Fact_Type,
                                                i_Fact_Date  => r_Fact.Fact_Date);
      
        if r_Fact.Fact_Type = Hsc_Pref.c_Fact_Type_Montly_Predict then
          v_Average := Calc_Average(i_Company_Id => r_Fact.Company_Id,
                                    i_Filial_Id  => r_Fact.Filial_Id,
                                    i_Object_Id  => r_Fact.Object_Id,
                                    i_Area_Id    => r_Fact.Area_Id,
                                    i_Driver_Id  => r_Fact.Driver_Id,
                                    i_Period     => r_Fact.Fact_Date,
                                    i_Week_Day   => Htt_Util.Iso_Week_Day_No(r_Fact.Fact_Date));
        
          if v_Average is not null then
            r_Fact.Fact_Value := ((r_Fact.Fact_Value + v_Average) / 2 + v_Average) / 2;
          end if;
        end if;
      
        Hsc_Api.Driver_Fact_Save(r_Fact);
      end loop;
    
      if v_Category.o_Varchar2('error_message') is not null then
        v_Error_Messages.Push(Fazo.Zip_Map('message',
                                           t('couldnt predict for $1{area_name}:$2{driver_name}',
                                             z_Hsc_Areas.Load                                  (i_Company_Id => i_Company_Id, --
                                                                                i_Filial_Id => i_Filial_Id, --
                                                                                i_Area_Id => v_Area_Id).Name,
                                             z_Hsc_Drivers.Load                                (i_Company_Id => i_Company_Id, --
                                                                              i_Filial_Id => i_Filial_Id, --
                                                                              i_Driver_Id => v_Driver_Id).Name),
                                           'log',
                                           v_Category.o_Varchar2('error_message')));
      end if;
    end loop;
  
    Result.Put('success_cnt', v_Categories.Count - v_Error_Messages.Count);
    Result.Put('errors', v_Error_Messages);
  
    return result;
  end;

end Hsc_Facts;
/
