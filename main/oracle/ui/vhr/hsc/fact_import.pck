create or replace package Ui_Vhr548 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Setting(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Template;
  ----------------------------------------------------------------------------------------------------
  Function Import_File(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap);
end Ui_Vhr548;
/
create or replace package body Ui_Vhr548 is
  ----------------------------------------------------------------------------------------------------
  type Column_Rt is record(
    Key         varchar2(1000),
    name        varchar2(100),
    Order_No    number,
    Is_Required varchar2(1));
  type Column_Nt is table of Column_Rt;
  ----------------------------------------------------------------------------------------------------
  -- template global variables
  ----------------------------------------------------------------------------------------------------
  g_Starting_Row    number;
  g_Default_Columns Column_Nt;
  g_Error_Messages  Arraylist;
  g_Errors          Arraylist;

  g_Objects_Source_Idx    number;
  g_Areas_Source_Idx      number;
  g_Drivers_Source_Idx    number;
  g_Fact_Types_Source_Idx number;

  g_Objects_Count    number;
  g_Areas_Count      number;
  g_Drivers_Count    number;
  g_Fact_Types_Count number;

  g_Fact Hsc_Driver_Facts%rowtype;
  ----------------------------------------------------------------------------------------------------
  c_Pc_Starting_Row constant varchar2(50) := 'UI-VHR548:STARTING_ROW';
  c_Pc_Column_Items constant varchar2(50) := 'UI-VHR548:COLUMN_ITEMS';

  c_Object_Name constant varchar2(50) := 'object_name';
  c_Area_Name   constant varchar2(50) := 'area_name';
  c_Driver_Name constant varchar2(50) := 'driver_name';
  c_Fact_Type   constant varchar2(50) := 'fact_type';
  c_Fact_Date   constant varchar2(50) := 'fact_date';
  c_Fact_Value  constant varchar2(50) := 'fact_value';

  c_Source_Table_First_Row constant number := 1;
  c_Source_Table_Last_Row  constant number := 102;

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
    return b.Translate('UI-VHR548:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            w.name
                       from hsc_objects q
                       join mhr_divisions w
                         on w.company_id = q.company_id
                        and w.filial_id = q.filial_id
                        and w.division_id = q.object_id
                        and w.state = :state
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('object_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Areas return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_areas',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('area_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from hsc_drivers q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.pcode is null
                        and q.state = :state',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('driver_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Default_Columns is
    v_Column  Column_Rt;
    v_Setting Hashmap := Nvl(Fazo.Parse_Map(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                                                         i_Filial_Id  => Ui.Filial_Id,
                                                         i_Code       => c_Pc_Column_Items)),
                             Hashmap());
    -------------------------------------------------- 
    Procedure Push
    (
      i_Key         varchar2,
      i_Column_Name varchar2,
      i_Is_Required varchar2
    ) is
    begin
      v_Column.Key         := i_Key;
      v_Column.Name        := i_Column_Name;
      v_Column.Order_No    := v_Column.Order_No + 1;
      v_Column.Is_Required := i_Is_Required;
    
      g_Default_Columns.Extend;
      g_Default_Columns(v_Column.Order_No) := v_Column;
    end;
  begin
    g_Default_Columns := Column_Nt();
    v_Column.Order_No := 0;
  
    Push(c_Object_Name, t('object_name'), 'Y');
    Push(c_Area_Name, t('area_name'), 'Y');
    Push(c_Driver_Name, t('driver_name'), 'Y');
    Push(c_Fact_Type, t('fact_type'), 'Y');
    Push(c_Fact_Date, t('fact_date'), 'Y');
    Push(c_Fact_Value, t('fact_value'), 'Y');
  
    if v_Setting.Count > 0 then
      for i in 1 .. g_Default_Columns.Count
      loop
        v_Column := g_Default_Columns(i);
      
        v_Column.Order_No := v_Setting.o_Number(v_Column.Key);
      
        g_Default_Columns(i) := v_Column;
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Column_Order_Number(i_Key varchar2) return varchar2 is
  begin
    for i in 1 .. g_Default_Columns.Count
    loop
      if g_Default_Columns(i).Key = i_Key then
        return g_Default_Columns(i).Order_No;
      end if;
    end loop;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Columns_All return Matrix_Varchar2 is
    v_Column Column_Rt;
    result   Matrix_Varchar2 := Matrix_Varchar2();
  begin
    for i in 1 .. g_Default_Columns.Count
    loop
      v_Column := g_Default_Columns(i);
    
      Fazo.Push(result,
                Array_Varchar2(v_Column.Key, v_Column.Name, v_Column.Order_No, v_Column.Is_Required));
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Starting_Row return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => c_Pc_Starting_Row),
               2);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables is
  begin
    g_Objects_Source_Idx    := null;
    g_Areas_Source_Idx      := null;
    g_Drivers_Source_Idx    := null;
    g_Fact_Types_Source_Idx := null;
  
    g_Objects_Count    := 0;
    g_Areas_Count      := 0;
    g_Drivers_Count    := 0;
    g_Fact_Types_Count := 0;
  
    g_Starting_Row := Starting_Row;
    g_Errors       := Arraylist();
  
    Set_Default_Columns;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Setting(p Hashmap) is
    v_Keys           Array_Varchar2 := p.r_Array_Varchar2('keys');
    v_Column_Numbers Array_Varchar2 := p.r_Array_Varchar2('column_numbers');
    v_Setting        Hashmap := Hashmap();
  begin
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Starting_Row,
                           i_Value      => p.o_Number('starting_row'));
  
    for i in 1 .. v_Keys.Count
    loop
      v_Setting.Put(v_Keys(i), v_Column_Numbers(i));
    end loop;
  
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Column_Items,
                           i_Value      => v_Setting.Json);
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('fact_types', Fazo.Zip_Matrix_Transposed(Hsc_Util.Driver_Fact_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Set_Global_Variables;
  
    Result.Put('starting_row', Starting_Row);
    Result.Put('items', Fazo.Zip_Matrix(Columns_All));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Source_Table return b_Table is
    v_Table     b_Table;
    v_Aux_Table b_Table;
  begin
    v_Table := b_Report.New_Table;
    v_Table.New_Row;
  
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Objects_Source_Idx := 1;
  
    for r in (select q.*
                from Mhr_Divisions q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.State = 'A'
                 and exists (select 1
                        from Hsc_Objects p
                       where p.Company_Id = Ui.Company_Id
                         and p.Filial_Id = Ui.Filial_Id
                         and p.Object_Id = q.Division_Id))
    loop
      v_Aux_Table.Data(r.Name);
      v_Aux_Table.New_Row;
    
      g_Objects_Count := g_Objects_Count + 1;
    end loop;
  
    v_Table.Data(v_Aux_Table);
  
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Areas_Source_Idx := 2;
  
    for r in (select q.*
                from Hsc_Areas q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.Data(r.Name);
      v_Aux_Table.New_Row;
    
      g_Areas_Count := g_Areas_Count + 1;
    end loop;
  
    v_Table.Data(v_Aux_Table);
  
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Drivers_Source_Idx := 3;
  
    for r in (select q.*
                from Hsc_Drivers q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.Data(r.Name);
      v_Aux_Table.New_Row;
    
      g_Drivers_Count := g_Drivers_Count + 1;
    end loop;
  
    v_Table.Data(v_Aux_Table);
  
    -- answer type
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Fact_Types_Source_Idx := 4;
  
    v_Aux_Table.Data(Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Actual));
    v_Aux_Table.New_Row;
    v_Aux_Table.Data(Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Weekly_Predict));
    v_Aux_Table.New_Row;
    v_Aux_Table.Data(Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Montly_Predict));
    v_Aux_Table.New_Row;
    v_Aux_Table.Data(Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Quarterly_Predict));
    v_Aux_Table.New_Row;
    v_Aux_Table.Data(Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Yearly_Predict));
    v_Aux_Table.New_Row;
  
    g_Fact_Types_Count := 5;
  
    v_Table.Data(v_Aux_Table);
  
    return v_Table;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template is
    v_Main_Table   b_Table;
    v_Source_Table b_Table;
    v_Data_Matrix  Matrix_Varchar2;
    v_Left_Matrix  Matrix_Varchar2;
    v_Source_Name  varchar2(10) := 'data';
    v_Column_Order number;
    v_Begin_Index  number;
  
    --------------------------------------------------     
    Procedure Set_Column
    (
      i_Column_Key   varchar2,
      i_Column_Data  varchar2,
      i_Column_Width number := null
    ) is
      v_Column_Order number := Column_Order_Number(i_Column_Key);
    begin
      if v_Column_Order is null then
        v_Left_Matrix.Extend;
        v_Left_Matrix(v_Left_Matrix.Count) := Array_Varchar2(i_Column_Data, i_Column_Width);
      else
        if v_Column_Order > v_Begin_Index then
          for i in v_Begin_Index + 1 .. v_Column_Order
          loop
            v_Data_Matrix.Extend;
            v_Data_Matrix(v_Data_Matrix.Count) := Array_Varchar2(null, null);
          end loop;
        
          v_Begin_Index := v_Column_Order;
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width);
        else
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width);
        end if;
      end if;
    end;
  
    --------------------------------------------------                   
    Procedure Push_Left_Data is
    begin
      for i in 1 .. v_Left_Matrix.Count
      loop
        v_Data_Matrix.Extend;
        v_Data_Matrix(v_Data_Matrix.Count) := v_Left_Matrix(i);
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Add_Data_Source
    (
      i_Column_Name       varchar2,
      i_Source_Column_Idx number,
      i_Source_Count      number
    ) is
    begin
      v_Column_Order := Column_Order_Number(i_Column_Name);
    
      if v_Column_Order is not null then
        v_Main_Table.Column_Data_Source(i_Column_Index  => v_Column_Order,
                                        i_First_Row     => c_Source_Table_First_Row,
                                        i_Last_Row      => c_Source_Table_Last_Row,
                                        i_Source_Sheet  => v_Source_Name,
                                        i_Source_Column => i_Source_Column_Idx,
                                        i_Source_Count  => i_Source_Count);
      end if;
    end;
  begin
    Set_Global_Variables;
  
    v_Data_Matrix := Matrix_Varchar2();
    v_Left_Matrix := Matrix_Varchar2();
    v_Begin_Index := 0;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => b_Report.Rt_Imp_Xlsx,
                                   i_File_Name   => Ui.Current_Form_Name);
  
    v_Source_Table := Source_Table;
    v_Main_Table   := b_Report.New_Table;
  
    v_Main_Table.Current_Style('header');
    v_Main_Table.New_Row;
  
    Set_Column(c_Object_Name, t('object_name'), 300);
    Set_Column(c_Area_Name, t('area_name'), 300);
    Set_Column(c_Driver_Name, t('driver_name'), 300);
    Set_Column(c_Fact_Type, t('fact_type'), 300);
    Set_Column(c_Fact_Date, t('fact_date'), 200);
    Set_Column(c_Fact_Value, t('fact_value'), 200);
  
    Add_Data_Source(i_Column_Name       => c_Object_Name,
                    i_Source_Column_Idx => g_Objects_Source_Idx,
                    i_Source_Count      => g_Objects_Count);
    Add_Data_Source(i_Column_Name       => c_Area_Name,
                    i_Source_Column_Idx => g_Areas_Source_Idx,
                    i_Source_Count      => g_Areas_Count);
    Add_Data_Source(i_Column_Name       => c_Driver_Name,
                    i_Source_Column_Idx => g_Drivers_Source_Idx,
                    i_Source_Count      => g_Drivers_Count);
    Add_Data_Source(i_Column_Name       => c_Fact_Type,
                    i_Source_Column_Idx => g_Fact_Types_Source_Idx,
                    i_Source_Count      => g_Fact_Types_Count);
  
    Push_Left_Data;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      v_Main_Table.Column_Width(i, v_Data_Matrix(i) (2));
      v_Main_Table.Data(v_Data_Matrix(i) (1));
    end loop;
  
    b_Report.Add_Sheet(t('facts'), v_Main_Table);
    b_Report.Add_Sheet(i_Name   => v_Source_Name, --
                       p_Table  => v_Source_Table,
                       i_Hidden => true);
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Object(i_Object_Name varchar2) is
  begin
    g_Fact.Object_Id := Mhr_Util.Division_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                     i_Filial_Id  => Ui.Filial_Id,
                                                     i_Name       => i_Object_Name);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with object name $2{object_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Object_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Area(i_Area_Name varchar2) is
  begin
    g_Fact.Area_Id := Hsc_Util.Take_Area_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id,
                                                    i_Name       => i_Area_Name);
  
    if g_Fact.Area_Id is null then
      b.Raise_Error(t('fact_import:cant find area with name $1{area_name}', i_Area_Name));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with area name $2{area_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Area_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Driver(i_Driver_Name varchar2) is
  begin
    g_Fact.Driver_Id := Hsc_Util.Take_Driver_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id,
                                                        i_Name       => i_Driver_Name);
  
    if g_Fact.Driver_Id is null then
      b.Raise_Error(t('fact_import:cant find driver with name $1{driver_name}', i_Driver_Name));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with driver name $2{driver_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Driver_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fact_Type(i_Fact_Type varchar2) is
    v_Fact_Types Matrix_Varchar2 := Hsc_Util.Driver_Fact_Types;
  begin
    g_Fact.Fact_Type := case i_Fact_Type
                          when Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Actual) then
                           Hsc_Pref.c_Fact_Type_Actual --
                          when Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Weekly_Predict) then
                           Hsc_Pref.c_Fact_Type_Weekly_Predict --
                          when Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Montly_Predict) then
                           Hsc_Pref.c_Fact_Type_Montly_Predict --
                          when Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Quarterly_Predict) then
                           Hsc_Pref.c_Fact_Type_Quarterly_Predict --
                          when Hsc_Util.t_Driver_Fact_Type(Hsc_Pref.c_Fact_Type_Yearly_Predict) then
                           Hsc_Pref.c_Fact_Type_Yearly_Predict --
                          else
                           null --
                        end;
  
    if g_Fact.Fact_Type is null then
      b.Raise_Error(t('fact_import: fact type $1{fact_type} must be in $2{allowed_types}',
                      i_Fact_Type,
                      Fazo.Gather(v_Fact_Types(2), ', ')));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with fact type $2{fact_type}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Fact_Type));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fact_Date(i_Fact_Date varchar2) is
  begin
    g_Fact.Fact_Date := Mr_Util.Convert_To_Date(i_Fact_Date);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with fact date $2{fact_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Fact_Date));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Fact_Value(i_Fact_Value varchar2) is
  begin
    g_Fact.Fact_Value := i_Fact_Value;
  
    if g_Fact.Fact_Value is null then
      b.Raise_Error(t('fact_import: fact value should be defined'));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with fact value $2{fact_value}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Fact_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Parse_Row
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
    v_Column_Number number;
  
    --------------------------------------------------                   
    Function Cell_Value(i_Column_Name varchar2) return varchar2 is
    begin
      v_Column_Number := Column_Order_Number(i_Column_Name);
    
      if v_Column_Number is not null then
        return i_Sheet.o_Varchar2(i_Row_Index, v_Column_Number);
      end if;
    
      return null;
    end;
  begin
    Set_Object(Cell_Value(c_Object_Name));
    Set_Area(Cell_Value(c_Area_Name));
    Set_Driver(Cell_Value(c_Driver_Name));
    Set_Fact_Type(Cell_Value(c_Fact_Type));
    Set_Fact_Date(Cell_Value(c_Fact_Date));
    Set_Fact_Value(Cell_Value(c_Fact_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Row(o_Items in out nocopy Arraylist) is
    v_Row Hashmap;
  begin
    if g_Error_Messages.Count = 0 then
      v_Row := z_Hsc_Driver_Facts.To_Map(g_Fact,
                                         z.Object_Id,
                                         z.Area_Id,
                                         z.Driver_Id,
                                         z.Fact_Type,
                                         z.Fact_Date,
                                         z.Fact_Value);
    
      v_Row.Put('object_name',
                z_Mhr_Divisions.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Division_Id => g_Fact.Object_Id).Name);
      v_Row.Put('area_name',
                z_Hsc_Areas.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Area_Id => g_Fact.Area_Id).Name);
      v_Row.Put('driver_name',
                z_Hsc_Drivers.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Driver_Id => g_Fact.Driver_Id).Name);
      v_Row.Put('fact_type_name', Hsc_Util.t_Driver_Fact_Type(g_Fact.Fact_Type));
    
      o_Items.Push(v_Row);
    end if;
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
  Function Import_File(p Hashmap) return Hashmap is
    v_Sheets Arraylist;
    v_Sheet  Excel_Sheet;
    v_Items  Arraylist := Arraylist();
    result   Hashmap := Hashmap();
  begin
    v_Sheets := p.r_Arraylist('template');
    v_Sheet  := Excel_Sheet(v_Sheets.r_Hashmap(1));
  
    Set_Global_Variables;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      g_Fact           := null;
      g_Error_Messages := Arraylist();
    
      Parse_Row(v_Sheet, i);
      Push_Row(v_Items);
    
      Push_Error(i);
    end loop;
  
    Result.Put('items', v_Items);
    Result.Put('errors', g_Errors);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Fact_Add(p Hashmap) is
    r_Fact Hsc_Driver_Facts%rowtype;
  begin
    z_Hsc_Driver_Facts.Init(p_Row        => r_Fact,
                            i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Object_Id  => p.r_Number('object_id'),
                            i_Area_Id    => p.r_Number('area_id'),
                            i_Driver_Id  => p.r_Number('driver_id'),
                            i_Fact_Type  => p.r_Varchar2('fact_type'),
                            i_Fact_Date  => p.r_Date('fact_date'),
                            i_Fact_Value => p.r_Number('fact_value'));
  
    r_Fact.Fact_Id := Hsc_Util.Next_Fact_Id(i_Company_Id => r_Fact.Company_Id,
                                            i_Filial_Id  => r_Fact.Filial_Id,
                                            i_Object_Id  => r_Fact.Object_Id,
                                            i_Area_Id    => r_Fact.Area_Id,
                                            i_Driver_Id  => r_Fact.Driver_Id,
                                            i_Fact_Type  => r_Fact.Fact_Type,
                                            i_Fact_Date  => r_Fact.Fact_Date);
  
    Hsc_Api.Driver_Fact_Save(r_Fact);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_List Arraylist := p.r_Arraylist('items');
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      Fact_Add(Treat(v_List.r_Hashmap(i) as Hashmap));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Objects
       set Company_Id = null,
           Filial_Id  = null,
           Object_Id  = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null,
           State       = null;
    update Hsc_Areas
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           name       = null,
           State      = null;
    update Hsc_Drivers
       set Company_Id = null,
           Filial_Id  = null,
           Driver_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr548;
/
