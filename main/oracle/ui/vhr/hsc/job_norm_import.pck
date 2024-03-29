create or replace package Ui_Vhr561 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
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
end Ui_Vhr561;
/
create or replace package body Ui_Vhr561 is
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

  g_Jobs_Source_Idx number;

  g_Jobs_Count number;

  g_Norm Hsc_Job_Norms%rowtype;
  ----------------------------------------------------------------------------------------------------
  c_Pc_Starting_Row constant varchar2(50) := 'UI-VHR561:STARTING_ROW';
  c_Pc_Column_Items constant varchar2(50) := 'UI-VHR561:COLUMN_ITEMS';

  c_Month          constant varchar2(50) := 'month';
  c_Job_Name       constant varchar2(50) := 'job_name';
  c_Monthly_Hours  constant varchar2(50) := 'monthly_hours';
  c_Monthly_Days   constant varchar2(50) := 'monthly_days';
  c_Idle_Margin    constant varchar2(50) := 'idle_margin';
  c_Absense_Margin constant varchar2(50) := 'absense_margin';

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
    return b.Translate('UI-VHR561:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Objects return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_divisions t
                      where t.company_id = :company_id
                        and t.filial_id = :filial_id
                        and t.state = :state
                        and exists (select 1
                               from hsc_object_groups s
                              where s.company_id = t.company_id
                                and s.filial_id = t.filial_id
                                and s.division_group_id = t.division_group_id)',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'));
  
    q.Number_Field('division_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
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
  
    Push(c_Job_Name, t('job_name'), 'Y');
    Push(c_Month, t('month'), 'Y');
    Push(c_Monthly_Hours, t('monthly_hours'), 'Y');
    Push(c_Monthly_Days, t('monthly_days'), 'Y');
    Push(c_Idle_Margin, t('idle_margin'), 'Y');
    Push(c_Absense_Margin, t('absense_margin'), 'Y');
  
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
    g_Jobs_Source_Idx := null;
  
    g_Jobs_Count := 0;
  
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
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Set_Global_Variables;
  
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
    v_Table     b_Table;
    v_Aux_Table b_Table;
  begin
    v_Table := b_Report.New_Table;
    v_Table.New_Row;
  
    -- jobs
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Jobs_Source_Idx := 1;
  
    for r in (select q.*
                from Mhr_Jobs q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.Data(r.Name);
      v_Aux_Table.New_Row;
    
      g_Jobs_Count := g_Jobs_Count + 1;
    end loop;
  
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
  
    v_Source_Table := Source_Table(i_Company_Id => Ui.Company_Id, --
                                   i_Filial_Id  => Ui.Filial_Id);
    v_Main_Table   := b_Report.New_Table;
  
    v_Main_Table.Current_Style('header');
    v_Main_Table.New_Row;
  
    Set_Column(c_Job_Name, t('job_name'), 300);
    Set_Column(c_Month, t('month'), 100);
    Set_Column(c_Monthly_Hours, t('monthly_hours'), 100);
    Set_Column(c_Monthly_Days, t('monthly_days'), 100);
    Set_Column(c_Idle_Margin, t('idle_margin'), 100);
    Set_Column(c_Absense_Margin, t('absense_margin'), 100);
  
    Add_Data_Source(i_Column_Name       => c_Job_Name,
                    i_Source_Column_Idx => g_Jobs_Source_Idx,
                    i_Source_Count      => g_Jobs_Count);
  
    Push_Left_Data;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      v_Main_Table.Column_Width(i, v_Data_Matrix(i) (2));
      v_Main_Table.Data(v_Data_Matrix(i) (1));
    end loop;
  
    b_Report.Add_Sheet(t('norms'), v_Main_Table);
    b_Report.Add_Sheet(i_Name   => v_Source_Name, --
                       p_Table  => v_Source_Table,
                       i_Hidden => true);
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Job(i_Job_Name varchar2) is
  begin
    g_Norm.Job_Id := Mhr_Util.Job_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_Name       => i_Job_Name);
  
    if g_Norm.Job_Id is null then
      b.Raise_Error(t('norm_import:cant find job with name $1{job_name}', i_Job_Name));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with job name $2{job_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Job_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Month(i_Month varchar2) is
  begin
    g_Norm.Month := to_date(i_Month, Href_Pref.c_Date_Format_Month);
  
    if g_Norm.Month is null then
      b.Raise_Error(t('norm_import: month should be defined'));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with month $2{month}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Month));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Monthly_Hours(i_Monthly_Hours varchar2) is
  begin
    g_Norm.Monthly_Hours := i_Monthly_Hours;
  
    if g_Norm.Monthly_Hours is null then
      b.Raise_Error(t('norm_import: monthly hours should be defined'));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with monthly hours $2{monthly_hours}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Monthly_Hours));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Monthly_Days(i_Monthly_Days varchar2) is
  begin
    g_Norm.Monthly_Days := i_Monthly_Days;
  
    if g_Norm.Monthly_Days is null then
      b.Raise_Error(t('norm_import: monthly days should be defined'));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with monthky days $2{monthly_days}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Monthly_Days));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Idle_Margin(i_Idle_Margin varchar2) is
  begin
    g_Norm.Idle_Margin := i_Idle_Margin;
  
    if g_Norm.Idle_Margin is null then
      b.Raise_Error(t('norm_import: idle margin should be defined'));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with idle margin $2{idle_margin}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Idle_Margin));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Absense_Margin(i_Absense_Margin varchar2) is
  begin
    g_Norm.Absense_Margin := i_Absense_Margin;
  
    if g_Norm.Absense_Margin is null then
      b.Raise_Error(t('norm_import: absense margin should be defined'));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with absense margin $2{absense_margin}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Absense_Margin));
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
    Set_Job(Cell_Value(c_Job_Name));
    Set_Month(Cell_Value(c_Month));
    Set_Monthly_Hours(Cell_Value(c_Monthly_Hours));
    Set_Monthly_Days(Cell_Value(c_Monthly_Days));
    Set_Idle_Margin(Cell_Value(c_Idle_Margin));
    Set_Absense_Margin(Cell_Value(c_Absense_Margin));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Row(o_Items in out nocopy Arraylist) is
    v_Row Hashmap;
  begin
    if g_Error_Messages.Count = 0 then
      v_Row := z_Hsc_Job_Norms.To_Map(g_Norm,
                                      z.Job_Id,
                                      z.Monthly_Hours,
                                      z.Monthly_Days,
                                      z.Idle_Margin,
                                      z.Absense_Margin,
                                      z.Round_Model_Type);
    
      v_Row.Put('job_name',
                z_Mhr_Jobs.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Job_Id => g_Norm.Job_Id).Name);
      v_Row.Put('month', to_char(g_Norm.Month, Href_Pref.c_Date_Format_Month));
    
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
    v_Object_Id number;
    v_Sheets    Arraylist;
    v_Sheet     Excel_Sheet;
    v_Items     Arraylist := Arraylist();
    result      Hashmap := Hashmap();
  begin
    v_Object_Id := p.r_Number('object_id');
    v_Sheets    := p.r_Arraylist('template');
    v_Sheet     := Excel_Sheet(v_Sheets.r_Hashmap(1));
  
    Set_Global_Variables;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      g_Norm           := null;
      g_Norm.Object_Id := v_Object_Id;
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
  Procedure Norm_Add
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    p            Hashmap
  ) is
    r_Norm Hsc_Job_Norms%rowtype;
  begin
    z_Hsc_Job_Norms.Init(p_Row            => r_Norm,
                         i_Company_Id     => i_Company_Id,
                         i_Filial_Id      => i_Filial_Id,
                         i_Object_Id      => i_Object_Id,
                         i_Division_Id    => null,
                         i_Job_Id         => p.r_Number('job_id'),
                         i_Month          => p.r_Date('month', 'mm.yyyy'),
                         i_Monthly_Hours  => p.r_Varchar2('monthly_hours'),
                         i_Monthly_Days   => p.r_Varchar2('monthly_days'),
                         i_Idle_Margin    => p.r_Varchar2('idle_margin'),
                         i_Absense_Margin => p.r_Varchar2('absense_margin'));
  
    r_Norm.Norm_Id := Hsc_Util.Next_Job_Norm_Id(i_Company_Id  => r_Norm.Company_Id,
                                                i_Filial_Id   => r_Norm.Filial_Id,
                                                i_Object_Id   => r_Norm.Object_Id,
                                                i_Division_Id => r_Norm.Division_Id,
                                                i_Job_Id      => r_Norm.Job_Id,
                                                i_Month       => r_Norm.Month);
  
    Hsc_Api.Job_Norm_Save(r_Norm);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_List Arraylist := p.r_Arraylist('items');
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      Norm_Add(i_Company_Id => Ui.Company_Id,
               i_Filial_Id  => Ui.Filial_Id,
               i_Object_Id  => p.r_Number('object_id'),
               p            => Treat(v_List.r_Hashmap(i) as Hashmap));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Object_Groups
       set Company_Id        = null,
           Filial_Id         = null,
           Division_Group_Id = null;
    update Mhr_Divisions
       set Company_Id        = null,
           Filial_Id         = null,
           Division_Id       = null,
           name              = null,
           Parent_Id         = null,
           Division_Group_Id = null,
           State             = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr561;
/
