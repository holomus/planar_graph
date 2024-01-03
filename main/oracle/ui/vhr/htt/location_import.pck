create or replace package Ui_Vhr272 is
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Template;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Settings(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Import_File(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap);
end Ui_Vhr272;
/
create or replace package body Ui_Vhr272 is
  ----------------------------------------------------------------------------------------------------  
  type Location_Rt is record(
    name               varchar2(300 char),
    Location_Type_Name varchar2(100 char),
    Division_Name      varchar2(100 char),
    Time_Zone          varchar2(64),
    Region_Name        varchar2(100 char),
    Address            varchar2(200 char),
    Latlng             varchar2(50 char),
    Accuracy           number,
    Prohibited         varchar2(1),
    State              varchar2(1),
    Code               varchar2(50),
    Employees          varchar2(2000 char));
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
  g_Starting_Row        number;
  g_Default_Columns     Column_Nt;
  g_Error_Messages      Arraylist;
  g_Errors              Arraylist;
  g_Location            Location_Rt;
  g_Location_Type_Count number;
  g_Divisions_Count     number;
  g_Timezone_Count      number;
  g_Region_Count        number;
  ----------------------------------------------------------------------------------------------------
  c_Pref_Employee_Identifier constant varchar2(50) := 'UI_VHR272:EMPLOYEE_IDENTIFIER';
  c_Pc_Starting_Row          constant varchar2(50) := 'UI-VHR272:STARTING_ROW';
  c_Pc_Column_Items          constant varchar2(50) := 'UI-VHR272:COLUMN_ITEMS';
  ----------------------------------------------------------------------------------------------------
  c_Name               constant varchar2(50) := 'name';
  c_Location_Type_Name constant varchar2(50) := 'location_type_name';
  c_Division_Name      constant varchar2(50) := 'division_name';
  c_Time_Zone          constant varchar2(50) := 'time_zone';
  c_Region_Name        constant varchar2(50) := 'region_name';
  c_Address            constant varchar2(50) := 'address';
  c_Latlng             constant varchar2(50) := 'latlng';
  c_Accuracy           constant varchar2(50) := 'accuracy';
  c_Prohibited         constant varchar2(50) := 'prohibited';
  c_State              constant varchar2(50) := 'state';
  c_Code               constant varchar2(50) := 'code';
  c_Employees          constant varchar2(50) := 'employees';
  ----------------------------------------------------------------------------------------------------
  c_Ei_Name            constant varchar2(1) := 'N';
  c_Ei_Employee_Number constant varchar2(1) := 'E';
  c_Ei_Tin             constant varchar2(1) := 'T';
  c_Ei_Code            constant varchar2(1) := 'C';
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
    return b.Translate('UI-VHR272:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Employee_Identifier(i_Employee_Identifier varchar2) return varchar2 is
  begin
    return case i_Employee_Identifier --
    when c_Ei_Name then t('employee_identifier:name') --
    when c_Ei_Employee_Number then t('employee_identifier:employee_number') --
    when c_Ei_Tin then t('employee_identifier:tin') --
    when c_Ei_Code then t('employee_identifier:code') --
    end;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Location_Type_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Location_Type_Id
      into result
      from Htt_Location_Types q
     where q.Company_Id = i_Company_Id
       and q.Name = i_Name
       and Rownum = 1;
  
    return result;
  
  exception
    when No_Data_Found then
      b.Raise_Error(t('location_type_id_by_name: location type not found, location_type_name=$1',
                      i_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Time_Zone_Code_By_Name(i_Name varchar2) return varchar2 is
    v_Lang_Code varchar2(5) := z_Md_Companies.Load(Ui.Company_Id).Lang_Code;
    result      varchar2(64);
  begin
    select q.Timezone_Code
      into result
      from Md_Timezones q
     where Decode(v_Lang_Code, 'en', q.Name_En, q.Name_Ru) = i_Name
       and q.State = 'A'
       and Rownum = 1;
  
    return result;
  
  exception
    when No_Data_Found then
      b.Raise_Error(t('time_zone_code_by_name: time zone not found, name=$1', i_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Region_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return varchar2 is
    result number;
  begin
    select q.Region_Id
      into result
      from Md_Regions q
     where q.Company_Id = i_Company_Id
       and q.Name = i_Name;
  
    return result;
  
  exception
    when No_Data_Found then
      b.Raise_Error(t('region_id_by_name: region not found, name=$1', i_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Id_By_Number
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Employee_Number varchar2
  ) return number is
    result number;
  begin
    select q.Employee_Id
      into result
      from Mhr_Employees q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and Upper(q.Employee_Number) = Upper(i_Employee_Number);
  
    return result;
  
  exception
    when No_Data_Found then
      b.Raise_Error(t('employee_id_by_number: employee not found, employee_number=$1',
                      i_Employee_Number));
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
  
    Push(c_Name, t('name'), 'Y');
    Push(c_Location_Type_Name, t('location_type_name'), 'N');
    Push(c_Division_Name, t('division_name'), 'N');
    Push(c_Time_Zone, t('time_zone'), 'N');
    Push(c_Region_Name, t('region_name'), 'N');
    Push(c_Address, t('address'), 'N');
    Push(c_Latlng, t('latlng'), 'Y');
    Push(c_Accuracy, t('accuracy'), 'Y');
    Push(c_Code, t('code'), 'N');
    Push(c_Prohibited, t('prohibited'), 'Y');
    Push(c_State, t('state'), 'Y');
    Push(c_Employees, t('employees'), 'Y');
  
    if v_Setting.Count > 0 then
      for i in 1 .. g_Default_Columns.Count
      loop
        v_Column          := g_Default_Columns(i);
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
    Result.Extend(g_Default_Columns.Count);
  
    for i in 1 .. g_Default_Columns.Count
    loop
      v_Column := g_Default_Columns(i);
    
      result(i) := Array_Varchar2(v_Column.Key,
                                  v_Column.Name,
                                  v_Column.Order_No,
                                  v_Column.Is_Required);
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
  Procedure Save_Settings(p Hashmap) is
    v_Keys           Array_Varchar2 := p.r_Array_Varchar2('keys');
    v_Column_Numbers Array_Varchar2 := p.r_Array_Varchar2('column_numbers');
    v_Setting        Hashmap := Hashmap();
  begin
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pc_Starting_Row,
                           i_Value      => p.o_Number('starting_row'));
  
    Md_Api.Preference_Save(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Code       => c_Pref_Employee_Identifier,
                           i_Value      => p.r_Varchar2('employee_identifier'));
  
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
  Function Employee_Identifier return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Code       => c_Pref_Employee_Identifier),
               c_Ei_Name);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables is
  begin
    g_Starting_Row := Starting_Row;
    g_Errors       := Arraylist();
  
    Set_Default_Columns;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    Set_Global_Variables;
  
    v_Matrix := Matrix_Varchar2();
    Fazo.Push(v_Matrix, c_Ei_Name, t_Employee_Identifier(c_Ei_Name));
    Fazo.Push(v_Matrix, c_Ei_Employee_Number, t_Employee_Identifier(c_Ei_Employee_Number));
    Fazo.Push(v_Matrix, c_Ei_Tin, t_Employee_Identifier(c_Ei_Tin));
    Fazo.Push(v_Matrix, c_Ei_Code, t_Employee_Identifier(c_Ei_Code));
  
    Result.Put('employee_identifiers', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('employee_identifier', Employee_Identifier);
    Result.Put('starting_row', Starting_Row);
    Result.Put('items', Fazo.Zip_Matrix(Columns_All));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Source_Table
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return b_Table is
    v_Lang_Code varchar2(5) := z_Md_Companies.Load(Ui.Company_Id).Lang_Code;
    a           b_Table;
    c           b_Table;
  begin
    a := b_Report.New_Table;
  
    -- location type
    c                     := b_Report.New_Table;
    g_Location_Type_Count := 0;
  
    for r in (select *
                from Htt_Location_Types q
               where q.Company_Id = i_Company_Id
               order by q.Name)
    loop
      c.New_Row;
      c.Data(r.Name);
    
      g_Location_Type_Count := g_Location_Type_Count + 1;
    end loop;
  
    c.New_Row;
    a.New_Row;
    a.Data(c);
  
    -- division name
    c                 := b_Report.New_Table;
    g_Divisions_Count := 0;
  
    for r in (select *
                from Mhr_Divisions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.State = 'A'
               order by q.Name)
    loop
      c.New_Row;
      c.Data(r.Name);
    
      g_Divisions_Count := g_Divisions_Count + 1;
    end loop;
  
    c.New_Row;
    a.Data(c);
  
    -- timezone
    c                := b_Report.New_Table;
    g_Timezone_Count := 0;
  
    for r in (select Decode(v_Lang_Code, 'en', q.Name_En, q.Name_Ru) as name
                from Md_Timezones q
               where q.State = 'A'
               order by q.Order_No, name)
    loop
      c.New_Row;
      c.Data(r.Name);
    
      g_Timezone_Count := g_Timezone_Count + 1;
    end loop;
  
    c.New_Row;
    a.Data(c);
  
    -- region
    c              := b_Report.New_Table;
    g_Region_Count := 0;
  
    for r in (select *
                from Md_Regions q
               where q.Company_Id = i_Company_Id
              connect by prior q.Region_Id = q.Parent_Id
               start with q.Parent_Id is null)
    loop
      c.New_Row;
      c.Data(r.Name);
    
      g_Region_Count := g_Region_Count + 1;
    end loop;
  
    c.New_Row;
    a.Data(c);
  
    -- prohibited
    c := b_Report.New_Table;
  
    c.New_Row;
    c.Data('Y');
    c.New_Row;
    c.Data('N');
  
    a.Data(c);
  
    -- state
    c := b_Report.New_Table;
  
    c.New_Row;
    c.Data('A');
    c.New_Row;
    c.Data('P');
  
    a.Data(c);
  
    return a;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template is
    a              b_Table;
    v_Data_Matrix  Matrix_Varchar2;
    v_Left_Matrix  Matrix_Varchar2;
    v_Begin_Index  number;
    v_Source_Name  varchar2(10) := 'data';
    v_Source_Table b_Table;
  
    --------------------------------------------------     
    Procedure Set_Column
    (
      i_Column_Key   varchar2,
      i_Column_Data  varchar2,
      i_Column_Width number := null,
      i_Style        varchar2 := null
    ) is
      v_Column_Order number := Column_Order_Number(i_Column_Key);
    begin
      if v_Column_Order is null then
        v_Left_Matrix.Extend;
        v_Left_Matrix(v_Left_Matrix.Count) := Array_Varchar2(i_Column_Data, i_Column_Width, i_Style);
      else
        if v_Column_Order > v_Begin_Index then
          for i in v_Begin_Index + 1 .. v_Column_Order
          loop
            v_Data_Matrix.Extend;
            v_Data_Matrix(v_Data_Matrix.Count) := Array_Varchar2(null, null, null);
          end loop;
        
          v_Begin_Index := v_Column_Order;
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width, i_Style);
        else
          v_Data_Matrix(v_Column_Order) := Array_Varchar2(i_Column_Data, i_Column_Width, i_Style);
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
  begin
    Set_Global_Variables;
  
    v_Data_Matrix := Matrix_Varchar2();
    v_Left_Matrix := Matrix_Varchar2();
    v_Begin_Index := 0;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => b_Report.Rt_Imp_Xlsx,
                                   i_File_Name   => Ui.Current_Form_Name);
  
    v_Source_Table := Source_Table(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    b_Report.New_Style(i_Style_Name        => 'danger',
                       i_Parent_Style_Name => 'header',
                       i_Background_Color  => '#ffc7ce',
                       i_Font_Color        => '#9c0006');
  
    a := b_Report.New_Table;
  
    -- header  
    a.New_Row;
    Set_Column(c_Name, t('name'), 200, 'danger');
    Set_Column(c_Location_Type_Name, t('location_type name'), 200);
    Set_Column(c_Division_Name, t('division name'), 200);
    Set_Column(c_Time_Zone, t('time zone'), 200);
    Set_Column(c_Region_Name, t('region name'), 200);
    Set_Column(c_Address, t('address'), 200);
    Set_Column(c_Latlng, t('lat lng'), 200, 'danger');
    Set_Column(c_Accuracy, t('accuracy'), 200, 'danger');
    Set_Column(c_Code, t('code'), 200);
    Set_Column(c_Prohibited, t('prohibited'), 200, 'danger');
    Set_Column(c_State, t('state'), 200, 'danger');
    Set_Column(c_Employees, t('employees ($1)', t_Employee_Identifier(Employee_Identifier)), 500);
    Push_Left_Data;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      a.Column_Width(i, v_Data_Matrix(i) (2));
      a.Data(v_Data_Matrix(i) (1), v_Data_Matrix(i) (3));
    end loop;
  
    -- column data sources
    if g_Location_Type_Count > 0 then
      a.Column_Data_Source(Column_Order_Number(c_Location_Type_Name),
                           1,
                           102,
                           v_Source_Name,
                           1,
                           g_Location_Type_Count); -- location type
    end if;
  
    if g_Divisions_Count > 0 then
      a.Column_Data_Source(Column_Order_Number(c_Division_Name),
                           1,
                           102,
                           v_Source_Name,
                           2,
                           g_Divisions_Count); -- division name
    end if;
  
    if g_Timezone_Count > 0 then
      a.Column_Data_Source(Column_Order_Number(c_Time_Zone),
                           1,
                           102,
                           v_Source_Name,
                           3,
                           g_Timezone_Count); -- timezone
    end if;
  
    if g_Region_Count > 0 then
      a.Column_Data_Source(Column_Order_Number(c_Region_Name),
                           1,
                           102,
                           v_Source_Name,
                           4,
                           g_Region_Count); -- region
    end if;
  
    a.Column_Data_Source(Column_Order_Number(c_Prohibited), 1, 2, v_Source_Name, 5, 2); -- prohibited
    a.Column_Data_Source(Column_Order_Number(c_State), 1, 2, v_Source_Name, 6, 2); -- state
  
    b_Report.Add_Sheet(i_Name  => t('location import'), --
                       p_Table => a);
  
    -- template data  
    b_Report.Add_Sheet(i_Name  => v_Source_Name, --
                       p_Table => v_Source_Table);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Name(i_Name varchar2) is
  begin
    g_Location.Name := i_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with location name $2{name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Location_Type(i_Location_Type_Name varchar2) is
  begin
    g_Location.Location_Type_Name := i_Location_Type_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with location type name $2{location_type_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Location_Type_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Division_Name(i_Division_Name varchar2) is
  begin
    g_Location.Division_Name := i_Division_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with division name $2{division_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Division_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Time_Zone(i_Time_Zone varchar2) is
  begin
    g_Location.Time_Zone := i_Time_Zone;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with time zone $2{time_zone}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Time_Zone));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Region_Name(i_Region_Name varchar2) is
  begin
    g_Location.Region_Name := i_Region_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with region name $2{region_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Region_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Address(i_Address varchar2) is
  begin
    g_Location.Address := i_Address;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with address $2{address}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Address));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Lat_Lng(i_Latlng varchar2) is
  begin
    g_Location.Latlng := i_Latlng;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with lat lng $2{latlng}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Latlng));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Accuracy(i_Accuracy varchar2) is
  begin
    g_Location.Accuracy := i_Accuracy;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with accuracy $2{accuracy}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Accuracy));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Code(i_Code varchar2) is
  begin
    g_Location.Code := i_Code;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with code $2{code}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Code));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Prohibited(i_Prohibited varchar2) is
  begin
    g_Location.Prohibited := i_Prohibited;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with prohibited $2{prohibited}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Prohibited));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_State(i_State varchar2) is
  begin
    g_Location.State := i_State;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with state $2{state}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_State));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Employee(i_Employees varchar2) is
  begin
    g_Location.Employees := i_Employees;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with employees $2{employees}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Employees));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Location_To_Array return Array_Varchar2 is
    v_Location Array_Varchar2 := Array_Varchar2();
  
    -------------------------------------------------- 
    Procedure Push(i_Data varchar2) is
    begin
      Fazo.Push(v_Location, i_Data);
    end;
  begin
    Push(g_Location.Name);
    Push(g_Location.Location_Type_Name);
    Push(g_Location.Division_Name);
    Push(g_Location.Time_Zone);
    Push(g_Location.Region_Name);
    Push(g_Location.Address);
    Push(g_Location.Latlng);
    Push(g_Location.Accuracy);
    Push(g_Location.Code);
    Push(g_Location.Prohibited);
    Push(g_Location.State);
    Push(g_Location.Employees);
  
    return v_Location;
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
    Set_Name(Cell_Value(c_Name));
    Set_Location_Type(Cell_Value(c_Location_Type_Name));
    Set_Division_Name(Cell_Value(c_Division_Name));
    Set_Time_Zone(Cell_Value(c_Time_Zone));
    Set_Region_Name(Cell_Value(c_Region_Name));
    Set_Address(Cell_Value(c_Address));
    Set_Lat_Lng(Cell_Value(c_Latlng));
    Set_Accuracy(Cell_Value(c_Accuracy));
    Set_Code(Cell_Value(c_Code));
    Set_Prohibited(Cell_Value(c_Prohibited));
    Set_State(Cell_Value(c_State));
    Set_Employee(Cell_Value(c_Employees));
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
  Procedure Push_Row(o_Items in out nocopy Matrix_Varchar2) is
  begin
    if g_Error_Messages.Count = 0 then
      o_Items.Extend;
      o_Items(o_Items.Count) := Location_To_Array;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Import_File(p Hashmap) return Hashmap is
    v_Sheets Arraylist;
    v_Sheet  Excel_Sheet;
    v_Items  Matrix_Varchar2 := Matrix_Varchar2();
    result   Hashmap := Hashmap();
  begin
    v_Sheets := p.r_Arraylist('template');
    v_Sheet  := Excel_Sheet(v_Sheets.r_Hashmap(1));
  
    Set_Global_Variables;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      g_Location       := null;
      g_Error_Messages := Arraylist();
    
      Parse_Row(v_Sheet, i);
      Push_Row(v_Items);
      Push_Error(i);
    end loop;
  
    Result.Put('items', Fazo.Zip_Matrix(v_Items));
    Result.Put('errors', g_Errors);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Location_Add(p Hashmap) is
    v_Filial_Id number := Ui.Filial_Id;
    r_Location  Htt_Locations%rowtype;
  
    --------------------------------------------------
    Procedure Location_Add_Person
    (
      i_Person_Identifiers Array_Varchar2,
      i_Pref_Value         varchar2
    ) is
      v_Person_Ids Array_Number := Array_Number();
    begin
      v_Person_Ids.Extend(i_Person_Identifiers.Count);
    
      case i_Pref_Value
        when c_Ei_Name then
          for i in 1 .. i_Person_Identifiers.Count
          loop
            v_Person_Ids(i) := Md_Util.Person_Id_By_Name(i_Company_Id => r_Location.Company_Id,
                                                         i_Name       => trim(i_Person_Identifiers(i)));
          end loop;
        when c_Ei_Code then
          for i in 1 .. i_Person_Identifiers.Count
          loop
            v_Person_Ids(i) := Md_Util.Person_Id_By_Code(i_Company_Id => r_Location.Company_Id,
                                                         i_Code       => trim(i_Person_Identifiers(i)));
          end loop;
        when c_Ei_Tin then
          for i in 1 .. i_Person_Identifiers.Count
          loop
            v_Person_Ids(i) := Mr_Util.Person_Id_By_Tin(i_Company_Id => r_Location.Company_Id,
                                                        i_Tin        => trim(i_Person_Identifiers(i)));
          end loop;
        when c_Ei_Employee_Number then
          for i in 1 .. i_Person_Identifiers.Count
          loop
            v_Person_Ids(i) := Employee_Id_By_Number(i_Company_Id      => r_Location.Company_Id,
                                                     i_Filial_Id       => v_Filial_Id,
                                                     i_Employee_Number => trim(i_Person_Identifiers(i)));
          end loop;
      end case;
    
      for i in 1 .. v_Person_Ids.Count
      loop
        Htt_Api.Location_Add_Person(i_Company_Id  => r_Location.Company_Id,
                                    i_Filial_Id   => v_Filial_Id,
                                    i_Location_Id => r_Location.Location_Id,
                                    i_Person_Id   => v_Person_Ids(i));
      end loop;
    end;
  begin
    r_Location := z_Htt_Locations.To_Row(p,
                                         z.Name,
                                         z.Address,
                                         z.Latlng,
                                         z.Accuracy,
                                         z.Prohibited,
                                         z.State,
                                         z.Code);
  
    r_Location.Company_Id  := Ui.Company_Id;
    r_Location.Location_Id := Htt_Next.Location_Id;
  
    if p.o_Varchar2('location_type_name') is not null then
      r_Location.Location_Type_Id := Location_Type_Id_By_Name(i_Company_Id => r_Location.Company_Id,
                                                              i_Name       => p.o_Varchar2('location_type_name'));
    end if;
  
    if p.o_Varchar2('time_zone') is not null then
      r_Location.Timezone_Code := Time_Zone_Code_By_Name(i_Name => p.o_Varchar2('time_zone'));
    end if;
  
    if p.o_Varchar2('region_name') is not null then
      r_Location.Region_Id := Region_Id_By_Name(i_Company_Id => r_Location.Company_Id,
                                                i_Name       => p.o_Varchar2('region_name'));
    end if;
  
    Htt_Api.Location_Save(r_Location);
  
    if not Ui.Is_Filial_Head then
      Htt_Api.Location_Add_Filial(i_Company_Id  => r_Location.Company_Id,
                                  i_Filial_Id   => v_Filial_Id,
                                  i_Location_Id => r_Location.Location_Id);
    
      if p.o_Varchar2('division_name') is not null then
        Htt_Api.Location_Add_Division(i_Company_Id  => r_Location.Company_Id,
                                      i_Filial_Id   => v_Filial_Id,
                                      i_Location_Id => r_Location.Location_Id,
                                      i_Division_Id => Mhr_Util.Division_Id_By_Name(i_Company_Id => r_Location.Company_Id,
                                                                                    i_Filial_Id  => v_Filial_Id,
                                                                                    i_Name       => p.o_Varchar2('division_name')));
      end if;
    
      if p.o_Varchar2('employees') is not null then
        Location_Add_Person(i_Person_Identifiers => Fazo.Split(i_Val       => p.o_Varchar2('employees'),
                                                               i_Delimiter => ','),
                            i_Pref_Value         => Nvl(Md_Pref.Load(i_Company_Id => r_Location.Company_Id,
                                                                     i_Filial_Id  => v_Filial_Id,
                                                                     i_Code       => c_Pref_Employee_Identifier),
                                                        c_Ei_Name));
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_List Arraylist := p.r_Arraylist('items');
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      Location_Add(Treat(v_List.r_Hashmap(i) as Hashmap));
    end loop;
  end;

end Ui_Vhr272;
/
