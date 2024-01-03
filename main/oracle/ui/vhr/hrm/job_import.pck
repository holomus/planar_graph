create or replace package Ui_Vhr667 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Roles return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Job_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Coa return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Setting(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Template;
  ----------------------------------------------------------------------------------------------------
  Function Import_File(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Function Name_Is_Unique(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Code_Is_Unique(p Hashmap) return varchar2;
end Ui_Vhr667;
/
create or replace package body Ui_Vhr667 is
  ----------------------------------------------------------------------------------------------------  
  type Job_Rt is record(
    Job_Name       varchar2(200 char),
    Code           varchar2(50 char),
    Role_Name      varchar2(200 char),
    Role_Id        number(20),
    Job_Group_Name varchar2(200 char),
    Job_Group_Id   number(20),
    Coa_Name       varchar2(200 char),
    Coa_Id         number(20));
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
  g_Job             Job_Rt;
  ----------------------------------------------------------------------------------------------------  
  c_Pc_Starting_Row constant varchar2(50) := 'UI-VHR667:STARTING_ROW';
  c_Pc_Column_Items constant varchar2(50) := 'UI-VHR667:COLUMN_ITEMS';

  c_Job_Name  constant varchar2(50) := 'job_name';
  c_Role      constant varchar2(50) := 'role';
  c_Job_Group constant varchar2(50) := 'job_group';
  c_Job_Coa   constant varchar2(50) := 'job_coa';
  c_Code      constant varchar2(50) := 'code';

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
    return b.Translate('UI-VHR667:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Roles return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_roles', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('role_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Job_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_job_groups', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('job_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Coa return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mk_coa', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('coa_id');
    q.Varchar2_Field('gen_name');
  
    return q;
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
    Push(c_Role, t('role'), 'N');
    Push(c_Job_Group, t('job_group'), 'N');
    Push(c_Job_Coa, t('job_coa'), 'N');
    Push(c_Code, t('code'), 'N');
  
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
  Procedure Set_Global_Variables is
  begin
    g_Starting_Row := Starting_Row;
    g_Errors       := Arraylist();
  
    Set_Default_Columns;
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
  Function Source_Table return b_Table is
    v_Table     b_Table;
    v_Aux_Table b_Table;
  begin
    v_Table := b_Report.New_Table;
    v_Table.New_Row;
  
    -- Roles
    v_Aux_Table := b_Report.New_Table;
  
    for r in (select *
                from Md_Roles q
               where q.Company_Id = Ui.Company_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.New_Row;
      v_Aux_Table.Data(r.Name);
    end loop;
  
    -- for preventing "empty rows" error
    if v_Aux_Table.Is_Empty then
      v_Aux_Table.New_Row;
    end if;
  
    v_Table.Data(v_Aux_Table);
  
    -- Job Groups
    v_Aux_Table := b_Report.New_Table;
  
    for r in (select *
                from Mhr_Job_Groups q
               where q.Company_Id = Ui.Company_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.New_Row;
      v_Aux_Table.Data(r.Name);
    end loop;
  
    -- for preventing "empty rows" error
    if v_Aux_Table.Is_Empty then
      v_Aux_Table.New_Row;
    end if;
  
    v_Table.Data(v_Aux_Table);
  
    --Coa 
    v_Aux_Table := b_Report.New_Table;
  
    for r in (select *
                from Mk_Coa q
               where q.Company_Id = Ui.Company_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.New_Row;
      v_Aux_Table.Data(r.Gen_Name);
    end loop;
  
    -- for preventing "empty rows" error
    if v_Aux_Table.Is_Empty then
      v_Aux_Table.New_Row;
    end if;
  
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
      i_Column_Width number := null,
      i_Style        varchar2 := null
    ) is
      v_Order_Column number := Column_Order_Number(i_Column_Key);
    begin
      if v_Order_Column is null then
        v_Left_Matrix.Extend;
        v_Left_Matrix(v_Left_Matrix.Count) := Array_Varchar2(i_Column_Data, i_Column_Width, i_Style);
      else
        if v_Order_Column > v_Begin_Index then
          for i in v_Begin_Index + 1 .. v_Order_Column
          loop
            v_Data_Matrix.Extend;
            v_Data_Matrix(v_Data_Matrix.Count) := Array_Varchar2(null, null);
          end loop;
        
          v_Begin_Index := v_Order_Column;
          v_Data_Matrix(v_Order_Column) := Array_Varchar2(i_Column_Data, i_Column_Width, i_Style);
        else
          v_Data_Matrix(v_Order_Column) := Array_Varchar2(i_Column_Data, i_Column_Width, i_Style);
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
  
    b_Report.New_Style(i_Style_Name        => 'danger',
                       i_Parent_Style_Name => 'header',
                       i_Background_Color  => '#ffc7ce',
                       i_Font_Color        => '#9c0006');
  
    v_Main_Table := b_Report.New_Table;
  
    v_Main_Table.Current_Style('header');
    v_Main_Table.New_Row;
  
    Set_Column(c_Job_Name, t('job_name'), 300, 'danger');
    Set_Column(c_Role, t('role'), 200);
    Set_Column(c_Job_Group, t('job_group'), 200);
    Set_Column(c_Job_Coa, t('job_coa'), 200);
    Set_Column(c_Code, t('code'), 100);
  
    Push_Left_Data;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      v_Main_Table.Column_Width(i, v_Data_Matrix(i) (2));
      v_Main_Table.Data(v_Data_Matrix(i) (1), v_Data_Matrix(i) (3));
    end loop;
  
    v_Column_Order := Column_Order_Number(c_Role);
  
    if v_Column_Order is not null then
      v_Main_Table.Column_Data_Source(i_Column_Index  => v_Column_Order,
                                      i_First_Row     => c_Source_Table_First_Row,
                                      i_Last_Row      => c_Source_Table_Last_Row,
                                      i_Source_Sheet  => v_Source_Name,
                                      i_Source_Column => 1,
                                      i_Source_Count  => 100);
    end if;
  
    v_Column_Order := Column_Order_Number(c_Job_Group);
  
    if v_Column_Order is not null then
      v_Main_Table.Column_Data_Source(i_Column_Index  => v_Column_Order,
                                      i_First_Row     => c_Source_Table_First_Row,
                                      i_Last_Row      => c_Source_Table_Last_Row,
                                      i_Source_Sheet  => v_Source_Name,
                                      i_Source_Column => 2,
                                      i_Source_Count  => 100);
    end if;
  
    v_Column_Order := Column_Order_Number(c_Job_Coa);
  
    if v_Column_Order is not null then
      v_Main_Table.Column_Data_Source(i_Column_Index  => v_Column_Order,
                                      i_First_Row     => c_Source_Table_First_Row,
                                      i_Last_Row      => c_Source_Table_Last_Row,
                                      i_Source_Sheet  => v_Source_Name,
                                      i_Source_Column => 3,
                                      i_Source_Count  => 100);
    end if;
    v_Source_Table := Source_Table;
  
    b_Report.Add_Sheet(t('jobs'), v_Main_Table);
    b_Report.Add_Sheet(i_Name   => v_Source_Name, --
                       p_Table  => v_Source_Table,
                       i_Hidden => true);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Job_Name(i_Job_Name varchar2) is
  begin
    g_Job.Job_Name := i_Job_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with job name $2{job_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Job_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Code(i_Code varchar2) is
  begin
    g_Job.Code := i_Code;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with code $2{code}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Code));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Role(i_Role_Name varchar2) is
    v_Id number;
  begin
    if i_Role_Name is null then
      return;
    end if;
  
    g_Job.Role_Name := i_Role_Name;
  
    select q.Role_Id
      into v_Id
      from Md_Roles q
     where q.Company_Id = Ui.Company_Id
       and q.Name = i_Role_Name;
  
    g_Job.Role_Id := v_Id;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with role $2{role_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Role_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Job_Group(i_Job_Group_Name varchar2) is
    v_Id number;
  begin
    if i_Job_Group_Name is null then
      return;
    end if;
  
    g_Job.Job_Group_Name := i_Job_Group_Name;
  
    select q.Job_Group_Id
      into v_Id
      from Mhr_Job_Groups q
     where q.Company_Id = Ui.Company_Id
       and q.Name = i_Job_Group_Name;
  
    g_Job.Job_Group_Id := v_Id;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with job group $2{job_group}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Job_Group_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Coa(i_Coa_Name varchar2) is
    v_Id number;
  begin
    if i_Coa_Name is null then
      return;
    end if;
  
    g_Job.Coa_Name := i_Coa_Name;
  
    select q.Coa_Id
      into v_Id
      from Mk_Coa q
     where q.Company_Id = Ui.Company_Id
       and q.Gen_Name = i_Coa_Name;
  
    g_Job.Coa_Id := v_Id;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with coa $2{coa}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Coa_Name));
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
    Set_Job_Name(Cell_Value(c_Job_Name));
    Set_Code(Cell_Value(c_Code));
    Set_Role(Cell_Value(c_Role));
    Set_Job_Group(Cell_Value(c_Job_Group));
    Set_Coa(Cell_Value(c_Job_Coa));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Job_To_Array return Array_Varchar2 is
    v_Jobs Array_Varchar2 := Array_Varchar2();
  
    -------------------------------------------------- 
    Procedure Push(i_Data varchar2) is
    begin
      Fazo.Push(v_Jobs, i_Data);
    end;
  begin
    Push(g_Job.Job_Name);
    Push(g_Job.Code);
    Push(g_Job.Job_Group_Name);
    Push(g_Job.Job_Group_Id);
    Push(g_Job.Role_Name);
    Push(g_Job.Role_Id);
    Push(g_Job.Coa_Name);
    Push(g_Job.Coa_Id);
  
    return v_Jobs;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Row(o_Items in out nocopy Matrix_Varchar2) is
  begin
    if g_Error_Messages.Count = 0 then
      o_Items.Extend;
      o_Items(o_Items.Count) := Job_To_Array;
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
    v_Items  Matrix_Varchar2 := Matrix_Varchar2();
    result   Hashmap := Hashmap();
  begin
    v_Sheets := p.r_Arraylist('template');
    v_Sheet  := Excel_Sheet(v_Sheets.r_Hashmap(1));
  
    Set_Global_Variables;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      g_Job            := null;
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
  Procedure Job_Add(p Hashmap) is
    r_Data Mhr_Jobs%rowtype;
  begin
    r_Data := z_Mhr_Jobs.To_Row(p, z.Name, z.Code, z.Expense_Coa_Id, z.Job_Group_Id);
  
    r_Data.Company_Id        := Ui.Company_Id;
    r_Data.Filial_Id         := Ui.Filial_Id;
    r_Data.Job_Id            := Mhr_Next.Job_Id;
    r_Data.State             := 'A';
    r_Data.c_Divisions_Exist := 'N';
  
    Mhr_Api.Job_Save(r_Data);
  
    if p.o_Number('role_id') is not null then
      Hrm_Api.Job_Roles_Save(i_Company_Id => Ui.Company_Id,
                             i_Filial_Id  => Ui.Filial_Id,
                             i_Job_Id     => r_Data.Job_Id,
                             i_Role_Ids   => Array_Number(p.o_Number('role_id')));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_List Arraylist := p.r_Arraylist('items');
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      Job_Add(Treat(v_List.r_Hashmap(i) as Hashmap));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Table        => Zt.Mhr_Jobs,
                                  i_Column       => z.Name,
                                  i_Column_Value => p.r_Varchar2('name'),
                                  i_Check_Case   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Table        => Zt.Mhr_Jobs,
                                  i_Column       => z.Code,
                                  i_Column_Value => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Md_Roles
       set Company_Id = null,
           Role_Id    = null,
           name       = null,
           State      = null;
    update Mhr_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null,
           name         = null,
           State        = null;
    update Mk_Coa
       set Company_Id = null,
           Coa_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr667;
/
