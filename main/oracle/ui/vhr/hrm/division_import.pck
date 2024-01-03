create or replace package Ui_Vhr670 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robots return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Subfilials return Fazo_Query;
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
end Ui_Vhr670;
/
create or replace package body Ui_Vhr670 is
  ----------------------------------------------------------------------------------------------------
  type Division_Rt is record(
    name                varchar2(200 char),
    Code                varchar2(50 char),
    Parent_Id           number,
    Parent_Name         varchar2(200 char),
    Division_Group_Id   number,
    Division_Group_Name varchar2(200 char),
    Schedule_Id         number,
    Schedule_Name       varchar2(100 char),
    Manager_Id          number, -- robot_id
    Manager_Name        varchar2(752 char), -- robot_name or person_name
    Opened_Date         date,
    Closed_Date         date,
    Subfilial_Id        number,
    Subfilial_Name      varchar2(200 char),
    Is_Department       varchar2(100));

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
  g_Division        Division_Rt;
  g_Source_Count    Fazo.Number_Code_Aat;
  g_Settings        Hrm_Settings%rowtype;

  ----------------------------------------------------------------------------------------------------
  c_Pc_Starting_Row constant varchar2(50) := 'UI-VHR670:STARTING_ROW';
  c_Pc_Column_Items constant varchar2(50) := 'UI-VHR670:COLUMN_ITEMS';

  c_Division_Name       constant varchar2(50) := 'division_name';
  c_Code                constant varchar2(50) := 'code';
  c_Parent_Name         constant varchar2(50) := 'parent_name';
  c_Division_Group_Name constant varchar2(50) := 'division_group_name';
  c_Schedule_Name       constant varchar2(50) := 'schedule_name';
  c_Manager_Name        constant varchar2(50) := 'manager_name';
  c_Opened_Date         constant varchar2(50) := 'opened_date';
  c_Closed_Date         constant varchar2(50) := 'closed_date';
  c_Subfilial_Name      constant varchar2(50) := 'subfilial_name';
  c_Division_Type       constant varchar2(50) := 'division_type';

  c_Source_Table_First_Row constant number := 1;
  c_Source_Table_Last_Row  constant number := 102;

  ----------------------------------------------------------------------------------------------------
  t_Division_Name       constant varchar2(200 char) := t('division_name');
  t_Code                constant varchar2(200 char) := t('code');
  t_Parent_Name         constant varchar2(200 char) := t('parent_name');
  t_Division_Group_Name constant varchar2(200 char) := t('division_group_name');
  t_Schedule_Name       constant varchar2(200 char) := t('schedule_name');
  t_Manager_Name        constant varchar2(200 char) := t('manager_name');
  t_Opened_Date         constant varchar2(200 char) := t('opened_date');
  t_Closed_Date         constant varchar2(200 char) := t('closed_date');
  t_Subfilial_Name      constant varchar2(200 char) := t('subfilial_name');
  t_Division_Type       constant varchar2(200 char) := t('division_type');

  t_Dt_Department constant varchar2(200 char) := t('department');
  t_Dt_Team       constant varchar2(200 char) := t('team');

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
    return b.Translate('UI-VHR670:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_division_groups',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('division_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robots return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select mr.robot_id,
                            mr.person_id,
                            mr.name robot_name
                       from mrf_robots mr
                      where mr.company_id = :company_id
                        and mr.filial_id = :filial_id
                        and exists (select 1
                               from hrm_robots hr
                              where hr.company_id = :company_id
                                and hr.filial_id = :filial_id
                                and hr.robot_id = mr.robot_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('robot_id');
    q.Map_Field('name',
                '$robot_name || '' (''|| (select pw.name from md_persons pw where pw.company_id = :company_id and pw.person_id = $person_id) ||'')''');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from href_staffs t
                      where t.company_id = :company_id
                        and t.filial_id = :filial_id
                        and t.staff_kind = :staff_kind_primary
                        and t.hiring_date <= trunc(sysdate)
                        and (t.dismissal_date is null or t.dismissal_date >= trunc(sysdate))
                        and t.state = ''A''',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'staff_kind_primary',
                                 Href_Pref.c_Staff_Kind_Primary));
  
    q.Number_Field('robot_id', 'employee_id');
    q.Refer_Field('name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons np
                    where np.company_id = :company_id');
    return q;
  end;

  ----------------------------------------------------------------------------------------------------        
  Function Query_Subfilials return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mrf_subfilials', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('subfilial_id');
    q.Varchar2_Field('name');
  
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
  
    Push(c_Division_Name, t_Division_Name, 'Y');
    Push(c_Code, t_Code, 'N');
    Push(c_Parent_Name, t_Parent_Name, 'N');
    Push(c_Division_Group_Name, t_Division_Group_Name, 'N');
    Push(c_Schedule_Name, t_Schedule_Name, 'N');
    Push(c_Manager_Name, t_Manager_Name, 'N');
    Push(c_Opened_Date, t_Opened_Date, 'Y');
    Push(c_Closed_Date, t_Closed_Date, 'N');
    Push(c_Subfilial_Name, t_Subfilial_Name, 'N');
  
    if g_Settings.Advanced_Org_Structure = 'Y' then
      Push(c_Division_Type, t_Division_Type, 'Y');
    end if;
  
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
    g_Source_Count := Fazo.Number_Code_Aat();
    g_Settings     := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id);
  
    Set_Default_Columns;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions',
               Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false, i_Is_Department => 'N')));
  
    Result.Put('t_division_kind_team', Hrm_Util.t_Division_Kind_Team);
    Result.Put('t_division_kind_department', Hrm_Util.t_Division_Kind_Department);
    Result.Put('position_enable', g_Settings.Position_Enable);
    Result.Put('advanced_org_structure', g_Settings.Advanced_Org_Structure);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Set_Global_Variables;
  
    Result.Put('starting_row', Starting_Row);
    Result.Put('items', Fazo.Zip_Matrix(Columns_All));
    Result.Put('reference', References);
  
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
    v_Matrix    Matrix_Varchar2;
  begin
    v_Table := b_Report.New_Table;
    v_Table.New_Row;
  
    --------------------------------------------------
    -- Parent division
    v_Aux_Table := b_Report.New_Table;
  
    v_Matrix := Uit_Hrm.Divisions(i_Check_Access => false, i_Is_Department => 'N');
  
    for i in 1 .. v_Matrix.Count
    loop
      v_Aux_Table.New_Row;
      v_Aux_Table.Data(v_Matrix(i) (2)); -- name
    end loop;
  
    -- for preventing "empty rows" error
    if v_Aux_Table.Is_Empty then
      v_Aux_Table.New_Row;
    end if;
  
    g_Source_Count(c_Parent_Name) := v_Aux_Table.z_Row_No;
    v_Table.Data(v_Aux_Table);
  
    --------------------------------------------------
    -- Division group
    v_Aux_Table := b_Report.New_Table;
  
    for r in (select *
                from Mhr_Division_Groups q
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
  
    g_Source_Count(c_Division_Group_Name) := v_Aux_Table.z_Row_No;
    v_Table.Data(v_Aux_Table);
  
    --------------------------------------------------
    -- Schedule
    v_Aux_Table := b_Report.New_Table;
  
    for r in (select *
                from Htt_Schedules q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.New_Row;
      v_Aux_Table.Data(r.Name);
    end loop;
  
    -- for preventing "empty rows" error
    if v_Aux_Table.Is_Empty then
      v_Aux_Table.New_Row;
    end if;
  
    g_Source_Count(c_Schedule_Name) := v_Aux_Table.z_Row_No;
    v_Table.Data(v_Aux_Table);
  
    --------------------------------------------------
    -- Manager
    v_Aux_Table := b_Report.New_Table;
  
    if g_Settings.Position_Enable = 'Y' then
      for r in (select Mr.Name || ' (' || (select Pw.Name
                                             from Md_Persons Pw
                                            where Pw.Company_Id = Mr.Company_Id
                                              and Pw.Person_Id = Mr.Person_Id) || ')' Robot_Name
                  from Mrf_Robots Mr
                 where Mr.Company_Id = Ui.Company_Id
                   and Mr.Filial_Id = Ui.Filial_Id
                   and exists (select 1
                          from Hrm_Robots Hr
                         where Hr.Company_Id = Mr.Company_Id
                           and Hr.Filial_Id = Mr.Filial_Id
                           and Hr.Robot_Id = Mr.Robot_Id))
      loop
        v_Aux_Table.New_Row;
        v_Aux_Table.Data(r.Robot_Name);
      end loop;
    else
      for r in (select (select Np.Name
                          from Mr_Natural_Persons Np
                         where Np.Company_Id = t.Company_Id
                           and Np.Person_Id = t.Employee_Id) Employee_Name
                  from Href_Staffs t
                 where t.Company_Id = Ui.Company_Id
                   and t.Filial_Id = Ui.Filial_Id
                   and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                   and t.Hiring_Date <= Trunc(sysdate)
                   and (t.Dismissal_Date is null or t.Dismissal_Date >= Trunc(sysdate))
                   and t.State = 'A'
                 order by 1)
      loop
        v_Aux_Table.New_Row;
        v_Aux_Table.Data(r.Employee_Name);
      end loop;
    end if;
  
    -- for preventing "empty rows" error
    if v_Aux_Table.Is_Empty then
      v_Aux_Table.New_Row;
    end if;
  
    g_Source_Count(c_Manager_Name) := v_Aux_Table.z_Row_No;
    v_Table.Data(v_Aux_Table);
  
    --------------------------------------------------
    -- Subfilials
    v_Aux_Table := b_Report.New_Table;
  
    for r in (select *
                from Mrf_Subfilials q
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
  
    g_Source_Count(c_Subfilial_Name) := v_Aux_Table.z_Row_No;
    v_Table.Data(v_Aux_Table);
  
    --------------------------------------------------
    -- Division type
    v_Aux_Table := b_Report.New_Table;
  
    if g_Settings.Advanced_Org_Structure = 'Y' then
      v_Aux_Table.New_Row;
      v_Aux_Table.Data(t_Dt_Department);
    
      v_Aux_Table.New_Row;
      v_Aux_Table.Data(t_Dt_Team);
    
      g_Source_Count(c_Division_Type) := v_Aux_Table.z_Row_No;
      v_Table.Data(v_Aux_Table);
    end if;
  
    return v_Table;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template is
    v_Main_Table   b_Table;
    v_Source_Table b_Table;
    v_Data_Matrix  Matrix_Varchar2;
    v_Left_Matrix  Matrix_Varchar2;
    v_Source_Name  varchar2(10) := 'data';
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
  
    --------------------------------------------------
    Procedure Add_Data_Source
    (
      i_Column_Name       varchar2,
      i_Source_Column_Idx number,
      i_Source_Count      number
    ) is
      v_Column_Order number;
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
  
    b_Report.New_Style(i_Style_Name        => 'danger',
                       i_Parent_Style_Name => 'header',
                       i_Background_Color  => '#ffc7ce',
                       i_Font_Color        => '#9c0006');
  
    v_Main_Table := b_Report.New_Table;
  
    v_Main_Table.Current_Style('header');
    v_Main_Table.New_Row;
  
    Set_Column(c_Division_Name, t_Division_Name, 300, 'danger');
    Set_Column(c_Code, t_Code, 100);
    Set_Column(c_Parent_Name, t_Parent_Name, 300);
    Set_Column(c_Division_Group_Name, t_Division_Group_Name, 300);
    Set_Column(c_Schedule_Name, t_Schedule_Name, 300);
    Set_Column(c_Manager_Name, t_Manager_Name, 400);
    Set_Column(c_Opened_Date, t_Opened_Date, 200, 'danger');
    Set_Column(c_Closed_Date, t_Closed_Date, 200);
    Set_Column(c_Subfilial_Name, t_Subfilial_Name, 200);
  
    if g_Settings.Advanced_Org_Structure = 'Y' then
      Set_Column(c_Division_Type, t_Division_Type, 200, 'danger');
    end if;
  
    Push_Left_Data;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      v_Main_Table.Column_Width(i, v_Data_Matrix(i) (2));
      v_Main_Table.Data(v_Data_Matrix(i) (1), v_Data_Matrix(i) (3));
    end loop;
  
    v_Source_Table := Source_Table;
  
    -- Parent division name
    Add_Data_Source(i_Column_Name       => c_Parent_Name,
                    i_Source_Column_Idx => 1,
                    i_Source_Count      => g_Source_Count(c_Parent_Name));
  
    -- Division group name
    Add_Data_Source(i_Column_Name       => c_Division_Group_Name,
                    i_Source_Column_Idx => 2,
                    i_Source_Count      => g_Source_Count(c_Division_Group_Name));
  
    -- Schedule name
    Add_Data_Source(i_Column_Name       => c_Schedule_Name,
                    i_Source_Column_Idx => 3,
                    i_Source_Count      => g_Source_Count(c_Schedule_Name));
  
    -- Manager name
    Add_Data_Source(i_Column_Name       => c_Manager_Name,
                    i_Source_Column_Idx => 4,
                    i_Source_Count      => g_Source_Count(c_Manager_Name));
  
    -- Subfilial name
    Add_Data_Source(i_Column_Name       => c_Subfilial_Name,
                    i_Source_Column_Idx => 5,
                    i_Source_Count      => g_Source_Count(c_Subfilial_Name));
  
    if g_Settings.Advanced_Org_Structure = 'Y' then
      -- Division type
      Add_Data_Source(i_Column_Name       => c_Division_Type,
                      i_Source_Column_Idx => 6,
                      i_Source_Count      => g_Source_Count(c_Division_Type));
    end if;
  
    b_Report.Add_Sheet(t('divisions'), v_Main_Table);
    b_Report.Add_Sheet(i_Name   => v_Source_Name, --
                       p_Table  => v_Source_Table,
                       i_Hidden => true);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Division(i_Division_Name varchar2) is
  begin
    g_Division.Name := i_Division_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with division name $2{division_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Division_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Code(i_Code varchar2) is
  begin
    g_Division.Code := i_Code;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with code $2{code}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Code));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Parent(i_Parent_Name varchar2) is
    v_Id number;
  begin
    if i_Parent_Name is null then
      return;
    end if;
  
    g_Division.Parent_Name := i_Parent_Name;
  
    select t.Division_Id
      into v_Id
      from Mhr_Divisions t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Name = i_Parent_Name
       and t.State = 'A';
  
    g_Division.Parent_Id := v_Id;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with parent division name $2{parent_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Parent_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Division_Group(i_Division_Group_Name varchar2) is
    v_Id number;
  begin
    if i_Division_Group_Name is null then
      return;
    end if;
  
    g_Division.Division_Group_Name := i_Division_Group_Name;
  
    select q.Division_Group_Id
      into v_Id
      from Mhr_Division_Groups q
     where q.Company_Id = Ui.Company_Id
       and q.Name = i_Division_Group_Name
       and q.State = 'A';
  
    g_Division.Division_Group_Id := v_Id;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with division group name $2{division_group_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Division_Group_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Schedule(i_Schedule_Name varchar2) is
    v_Id number;
  begin
    if i_Schedule_Name is null then
      return;
    end if;
  
    g_Division.Schedule_Name := i_Schedule_Name;
  
    select q.Schedule_Id
      into v_Id
      from Htt_Schedules q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Name = i_Schedule_Name
       and q.State = 'A';
  
    g_Division.Schedule_Id := v_Id;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with schedule name $2{schedule_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Schedule_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Manager(i_Manager_Name varchar2) is
    v_Id number;
  begin
    if i_Manager_Name is null then
      return;
    end if;
  
    g_Division.Manager_Name := i_Manager_Name;
  
    if g_Settings.Position_Enable = 'Y' then
      select t.Robot_Id
        into v_Id
        from (select Mr.Robot_Id,
                     Mr.Name || ' (' || (select Pw.Name
                                           from Md_Persons Pw
                                          where Pw.Company_Id = Mr.Company_Id
                                            and Pw.Person_Id = Mr.Person_Id) || ')' Robot_Name
                from Mrf_Robots Mr
               where Mr.Company_Id = Ui.Company_Id
                 and Mr.Filial_Id = Ui.Filial_Id
                 and exists (select 1
                        from Hrm_Robots Hr
                       where Hr.Company_Id = Mr.Company_Id
                         and Hr.Filial_Id = Mr.Filial_Id
                         and Hr.Robot_Id = Mr.Robot_Id)) t
       where t.Robot_Name = i_Manager_Name;
    else
      select t.Robot_Id
        into v_Id
        from Href_Staffs t
       where t.Company_Id = Ui.Company_Id
         and t.Filial_Id = Ui.Filial_Id
         and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
         and t.Hiring_Date <= Trunc(sysdate)
         and (t.Dismissal_Date is null or t.Dismissal_Date >= Trunc(sysdate))
         and t.State = 'A'
         and exists (select 1
                from Mr_Natural_Persons Np
               where Np.Company_Id = t.Company_Id
                 and Np.Person_Id = t.Employee_Id
                 and Np.Name = i_Manager_Name);
    end if;
  
    g_Division.Manager_Id := v_Id;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with manager name $2{manager_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Manager_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Opened_Date(i_Opened_Date varchar2) is
  begin
    g_Division.Opened_Date := Mr_Util.Convert_To_Date(i_Opened_Date);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with opened date $2{opened_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Opened_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Closed_Date(i_Closed_Date varchar2) is
  begin
    g_Division.Closed_Date := Mr_Util.Convert_To_Date(i_Closed_Date);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with closed date $2{closed_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Closed_Date));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Subfilial(i_Subfilial_Name varchar2) is
    v_Id number;
  begin
    if i_Subfilial_Name is null then
      return;
    end if;
  
    g_Division.Subfilial_Name := i_Subfilial_Name;
  
    select q.Subfilial_Id
      into v_Id
      from Mrf_Subfilials q
     where q.Company_Id = Ui.Company_Id
       and q.Name = i_Subfilial_Name
       and q.State = 'A';
  
    g_Division.Subfilial_Id := v_Id;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with subfilial name $2{subfilial_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Subfilial_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Division_Type(i_Division_Type varchar2) is
  begin
    if g_Settings.Advanced_Org_Structure = 'Y' and i_Division_Type = t_Dt_Team then
      g_Division.Is_Department := 'N';
    else
      g_Division.Is_Department := 'Y';
    end if;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with division type $2{division_type}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Division_Type));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Parse_Row
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
    --------------------------------------------------                   
    Function Cell_Value(i_Column_Name varchar2) return varchar2 is
      v_Column_Number number;
    begin
      v_Column_Number := Column_Order_Number(i_Column_Name);
    
      if v_Column_Number is not null then
        return i_Sheet.o_Varchar2(i_Row_Index, v_Column_Number);
      end if;
    
      return null;
    end;
  begin
    Set_Division(Cell_Value(c_Division_Name));
    Set_Code(Cell_Value(c_Code));
    Set_Parent(Cell_Value(c_Parent_Name));
    Set_Division_Group(Cell_Value(c_Division_Group_Name));
    Set_Schedule(Cell_Value(c_Schedule_Name));
    Set_Manager(Cell_Value(c_Manager_Name));
    Set_Opened_Date(Cell_Value(c_Opened_Date));
    Set_Closed_Date(Cell_Value(c_Closed_Date));
    Set_Subfilial(Cell_Value(c_Subfilial_Name));
    Set_Division_Type(Cell_Value(c_Division_Type));
  
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Division_To_Array return Array_Varchar2 is
    v_Division Array_Varchar2 := Array_Varchar2();
  
    -------------------------------------------------- 
    Procedure Push(i_Data varchar2) is
    begin
      Fazo.Push(v_Division, i_Data);
    end;
  begin
    Push(g_Division.Name);
    Push(g_Division.Code);
    Push(g_Division.Parent_Id);
    Push(g_Division.Parent_Name);
    Push(g_Division.Division_Group_Id);
    Push(g_Division.Division_Group_Name);
    Push(g_Division.Schedule_Id);
    Push(g_Division.Schedule_Name);
    Push(g_Division.Manager_Id);
    Push(g_Division.Manager_Name);
    Push(g_Division.Opened_Date);
    Push(g_Division.Closed_Date);
    Push(g_Division.Subfilial_Id);
    Push(g_Division.Subfilial_Name);
    Push(g_Division.Is_Department);
  
    return v_Division;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Row(o_Items in out nocopy Matrix_Varchar2) is
  begin
    if g_Error_Messages.Count = 0 then
      o_Items.Extend;
      o_Items(o_Items.Count) := Division_To_Array;
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
    
      g_Division       := null;
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
  Procedure Division_Add(p Hashmap) is
    r_Row      Mhr_Divisions%rowtype;
    v_Division Hrm_Pref.Division_Rt;
  begin
    r_Row := z_Mhr_Divisions.To_Row(p,
                                    z.Name,
                                    z.Parent_Id,
                                    z.Division_Group_Id,
                                    z.Opened_Date,
                                    z.Closed_Date,
                                    z.Code);
  
    r_Row.Company_Id  := Ui.Company_Id;
    r_Row.Filial_Id   := Ui.Filial_Id;
    r_Row.Division_Id := Mhr_Next.Division_Id;
    r_Row.State       := 'A';
  
    Hrm_Util.Division_New(o_Division      => v_Division,
                          i_Division      => r_Row,
                          i_Schedule_Id   => p.o_Number('schedule_id'),
                          i_Manager_Id    => p.o_Number('manager_id'),
                          i_Is_Department => p.o_Varchar2('is_department'),
                          i_Subfilial_Id  => p.o_Number('subfilial_id'));
  
    Hrm_Api.Division_Save(v_Division);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_List Arraylist := p.r_Arraylist('items');
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      Division_Add(Treat(v_List.r_Hashmap(i) as Hashmap));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Name_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Table        => Zt.Mhr_Divisions,
                                  i_Column       => z.Name,
                                  i_Column_Value => p.r_Varchar2('name'),
                                  i_Check_Case   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Code_Is_Unique(p Hashmap) return varchar2 is
  begin
    return Href_Util.Check_Unique(i_Company_Id   => Ui.Company_Id,
                                  i_Table        => Zt.Mhr_Divisions,
                                  i_Column       => z.Code,
                                  i_Column_Value => p.o_Varchar2('code'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mhr_Division_Groups
       set Company_Id        = null,
           Division_Group_Id = null,
           name              = null,
           State             = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           name       = null,
           Person_Id  = null;
    update Hrm_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Kind     = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Robot_Id       = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null;
    update Mrf_Subfilials
       set Company_Id   = null,
           Subfilial_Id = null,
           name         = null,
           State        = null;
    Uie.x(Uit_Href.Get_Staff_Status(null, null, null));
  end;

end Ui_Vhr670;
/
