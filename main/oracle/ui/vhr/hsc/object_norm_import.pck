create or replace package Ui_Vhr558 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Areas(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Processes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Actions(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
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
end Ui_Vhr558;
/
create or replace package body Ui_Vhr558 is
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
  g_Week_Day        Fazo.Varchar2_Code_Aat;
  g_Starting_Row    number;
  g_Default_Columns Column_Nt;
  g_Error_Messages  Arraylist;
  g_Errors          Arraylist;

  g_Areas_Source_Idx     number;
  g_Processes_Source_Idx number;
  g_Actions_Source_Idx   number;
  g_Drivers_Source_Idx   number;
  g_Jobs_Source_Idx      number;

  g_Areas_Count     number;
  g_Processes_Count number;
  g_Actions_Count   number;
  g_Drivers_Count   number;
  g_Jobs_Count      number;

  g_Norm             Hsc_Object_Norms%rowtype;
  g_Action_Frequency varchar2(500 char);
  ----------------------------------------------------------------------------------------------------
  c_Pc_Starting_Row constant varchar2(50) := 'UI-VHR558:STARTING_ROW';
  c_Pc_Column_Items constant varchar2(50) := 'UI-VHR558:COLUMN_ITEMS';

  c_Area_Name        constant varchar2(50) := 'area_name';
  c_Process_Name     constant varchar2(50) := 'process_name';
  c_Action_Name      constant varchar2(50) := 'action_name';
  c_Driver_Name      constant varchar2(50) := 'driver_name';
  c_Job_Name         constant varchar2(50) := 'job_name';
  c_Time_Value       constant varchar2(50) := 'time_value';
  c_Action_Frequency constant varchar2(50) := 'action_frequncy';

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
    return b.Translate('UI-VHR558:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Function Query_Areas(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from hsc_areas q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and (q.c_division_groups_exist = ''N''
                            or exists (select 1
                                  from hsc_area_division_groups w
                                 where w.company_id = q.company_id
                                   and w.filial_id = q.filial_id
                                   and w.area_id = q.area_id
                                   and w.division_group_id = :division_group_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_group_id',
                                 p.r_Number('division_group_id'),
                                 'state',
                                 'A'));
  
    q.Number_Field('area_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Processes return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_processes',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('process_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Actions(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_process_actions',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'process_id',
                                 p.r_Number('process_id'),
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('action_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Drivers return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hsc_drivers',
                    Fazo.Zip_Map('company_id', --
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('driver_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from mhr_jobs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and (q.c_divisions_exist = ''N''
                            or exists (select 1
                                  from mhr_job_divisions w
                                 where w.company_id = q.company_id
                                   and w.filial_id = q.filial_id
                                   and w.job_id = q.job_id
                                   and w.division_id = :division_id))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.r_Number('division_id'),
                                 'state',
                                 'A'));
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Action_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Action_Id  number
  ) return varchar2 is
    r_Action Hsc_Process_Actions%rowtype;
  begin
    r_Action := z_Hsc_Process_Actions.Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Action_Id  => i_Action_Id);
  
    return z_Hsc_Processes.Load(i_Company_Id => r_Action.Company_Id,
                                i_Filial_Id  => r_Action.Filial_Id,
                                i_Process_Id => r_Action.Process_Id).Name || '/' || r_Action.Name;
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
  
    Push(c_Area_Name, t('area_name'), 'Y');
    Push(c_Process_Name, t('process_name'), 'Y');
    Push(c_Action_Name, t('action_name'), 'Y');
    Push(c_Driver_Name, t('driver_name'), 'Y');
    Push(c_Job_Name, t('job_name'), 'Y');
    Push(c_Time_Value, t('time_value'), 'Y');
    Push(c_Action_Frequency, t('action_frequency'), 'Y');
  
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
    g_Week_Day('пн') := 1;
    g_Week_Day('вт') := 2;
    g_Week_Day('ср') := 3;
    g_Week_Day('чт') := 4;
    g_Week_Day('пт') := 5;
    g_Week_Day('сб') := 6;
    g_Week_Day('вс') := 7;
  
    g_Areas_Source_Idx     := null;
    g_Processes_Source_Idx := null;
    g_Actions_Source_Idx   := null;
    g_Drivers_Source_Idx   := null;
    g_Jobs_Source_Idx      := null;
  
    g_Areas_Count     := 0;
    g_Processes_Count := 0;
    g_Actions_Count   := 0;
    g_Drivers_Count   := 0;
    g_Jobs_Count      := 0;
  
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
    return Fazo.Zip_Map('driver_constant_id',
                        Hsc_Util.Driver_Constant_Id(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id));
  
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
  
    -- areas
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Areas_Source_Idx := 1;
  
    for r in (select q.*
                from Hsc_Areas q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.Data(r.Name);
      v_Aux_Table.New_Row;
    
      g_Areas_Count := g_Areas_Count + 1;
    end loop;
  
    v_Table.Data(v_Aux_Table);
  
    -- processes
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Processes_Source_Idx := 2;
  
    for r in (select q.*
                from Hsc_Processes q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.Data(r.Name);
      v_Aux_Table.New_Row;
    
      g_Processes_Count := g_Processes_Count + 1;
    end loop;
  
    v_Table.Data(v_Aux_Table);
  
    -- actions
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Actions_Source_Idx := 3;
  
    for r in (select q.*
                from Hsc_Process_Actions q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.Data(Action_Name(i_Company_Id => r.Company_Id,
                                   i_Filial_Id  => r.Filial_Id,
                                   i_Action_Id  => r.Action_Id));
      v_Aux_Table.New_Row;
    
      g_Actions_Count := g_Actions_Count + 1;
    end loop;
  
    v_Table.Data(v_Aux_Table);
  
    -- drivers
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Drivers_Source_Idx := 4;
  
    for r in (select q.*
                from Hsc_Drivers q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.State = 'A')
    loop
      v_Aux_Table.Data(r.Name);
      v_Aux_Table.New_Row;
    
      g_Drivers_Count := g_Drivers_Count + 1;
    end loop;
  
    v_Table.Data(v_Aux_Table);
  
    -- jobs
    v_Aux_Table := b_Report.New_Table;
    v_Aux_Table.New_Row;
  
    g_Jobs_Source_Idx := 5;
  
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
  
    v_Source_Table := Source_Table(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
    v_Main_Table   := b_Report.New_Table;
  
    v_Main_Table.Current_Style('header');
    v_Main_Table.New_Row;
  
    Set_Column(c_Area_Name, t('area_name'), 300);
    Set_Column(c_Process_Name, t('process_name'), 300);
    Set_Column(c_Action_Name, t('action_name'), 300);
    Set_Column(c_Driver_Name, t('driver_name'), 300);
    Set_Column(c_Job_Name, t('job_name'), 300);
    Set_Column(c_Time_Value, t('time_value'), 200);
    Set_Column(c_Action_Frequency, t('action_frequency'), 200);
  
    Add_Data_Source(i_Column_Name       => c_Area_Name,
                    i_Source_Column_Idx => g_Areas_Source_Idx,
                    i_Source_Count      => g_Areas_Count);
    Add_Data_Source(i_Column_Name       => c_Process_Name,
                    i_Source_Column_Idx => g_Processes_Source_Idx,
                    i_Source_Count      => g_Processes_Count);
    Add_Data_Source(i_Column_Name       => c_Action_Name,
                    i_Source_Column_Idx => g_Actions_Source_Idx,
                    i_Source_Count      => g_Actions_Count);
    Add_Data_Source(i_Column_Name       => c_Driver_Name,
                    i_Source_Column_Idx => g_Drivers_Source_Idx,
                    i_Source_Count      => g_Drivers_Count);
    Add_Data_Source(i_Column_Name       => c_Job_Name,
                    i_Source_Column_Idx => g_Jobs_Source_Idx,
                    i_Source_Count      => g_Jobs_Count);
  
    Push_Left_Data;
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      v_Main_Table.Column_Width(i, v_Data_Matrix(i) (2));
      v_Main_Table.Data(v_Data_Matrix(i) (1));
    end loop;
  
    v_Main_Table.Current_Style('root');
  
    for i in 1 .. 100
    loop
      v_Main_Table.New_Row;
      v_Main_Table.Add_Data(5);
      v_Main_Table.Data('', 'text');
    end loop;
  
    b_Report.Add_Sheet(t('norms'), v_Main_Table);
    b_Report.Add_Sheet(i_Name   => v_Source_Name, --
                       p_Table  => v_Source_Table,
                       i_Hidden => true);
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Area(i_Area_Name varchar2) is
  begin
    g_Norm.Area_Id := Hsc_Util.Take_Area_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id,
                                                    i_Name       => i_Area_Name);
  
    if g_Norm.Area_Id is null then
      b.Raise_Error(t('norm_import:cant find area with name $1{area_name}', i_Area_Name));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with area name $2{area_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Area_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Process(i_Process_Name varchar2) is
  begin
    g_Norm.Process_Id := Hsc_Util.Take_Process_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                          i_Filial_Id  => Ui.Filial_Id,
                                                          i_Name       => i_Process_Name);
  
    if g_Norm.Process_Id is null then
      b.Raise_Error(t('norm_import:cant find process with name $1{process_name}', i_Process_Name));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with process name $2{process_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Process_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Action(i_Action_Name varchar2) is
  begin
    g_Norm.Action_Id := Hsc_Util.Take_Action_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id,
                                                        i_Process_Id => g_Norm.Process_Id,
                                                        i_Name       => i_Action_Name);
  
    if g_Norm.Action_Id is null then
      b.Raise_Error(t('norm_import:cant find action with name $1{action_name}', i_Action_Name));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with action name $2{action_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Action_Name));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Driver(i_Driver_Name varchar2) is
  begin
    g_Norm.Driver_Id := Hsc_Util.Take_Driver_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id,
                                                        i_Name       => i_Driver_Name);
  
    if g_Norm.Driver_Id is null then
      b.Raise_Error(t('norm_import:cant find driver with name $1{driver_name}', i_Driver_Name));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with driver name $2{driver_name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Driver_Name));
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
  Procedure Set_Time_Value(i_Time_Value varchar2) is
  begin
    g_Norm.Time_Value := Regexp_Substr(i_Time_Value, '[^:]+', 1, 1) * 3600 +
                         Regexp_Substr(i_Time_Value, '[^:]+', 1, 2) * 60 +
                         Regexp_Substr(i_Time_Value, '[^:]+', 1, 3);
  
    if g_Norm.Time_Value is null then
      b.Raise_Error(t('norm_import: time value should be defined'));
    end if;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with time value $2{time_value}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Time_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Action_Frequency(i_Action_Frequency varchar2) is
  begin
    if g_Norm.Driver_Id =
       Hsc_Util.Driver_Constant_Id(i_Company_Id => Ui.Company_Id, --
                                   i_Filial_Id  => Ui.Filial_Id) and --
       i_Action_Frequency is null then
      b.Raise_Error(t('norm_import: action frequency should be defined'));
    end if;
  
    g_Action_Frequency := i_Action_Frequency;
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with action frequency $2{action_frequency}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Action_Frequency));
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
    Set_Area(Cell_Value(c_Area_Name));
    Set_Process(Cell_Value(c_Process_Name));
    Set_Action(Regexp_Substr(Cell_Value(c_Action_Name), '[^/]+$', 1, 1));
    Set_Driver(Cell_Value(c_Driver_Name));
    Set_Job(Cell_Value(c_Job_Name));
    Set_Time_Value(Cell_Value(c_Time_Value));
    Set_Action_Frequency(Cell_Value(c_Action_Frequency));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Row(o_Items in out nocopy Arraylist) is
    v_Row Hashmap;
  begin
    if g_Error_Messages.Count = 0 then
      v_Row := z_Hsc_Object_Norms.To_Map(g_Norm,
                                         z.Area_Id,
                                         z.Process_Id,
                                         z.Action_Id,
                                         z.Driver_Id,
                                         z.Job_Id,
                                         z.Time_Value);
    
      v_Row.Put('area_name',
                z_Hsc_Areas.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Area_Id => g_Norm.Area_Id).Name);
      v_Row.Put('process_name',
                z_Hsc_Processes.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Process_Id => g_Norm.Process_Id).Name);
      v_Row.Put('action_name',
                z_Hsc_Process_Actions.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Action_Id => g_Norm.Action_Id).Name);
      v_Row.Put('driver_name',
                z_Hsc_Drivers.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Driver_Id => g_Norm.Driver_Id).Name);
      v_Row.Put('job_name',
                z_Mhr_Jobs.Load(i_Company_Id => Ui.Company_Id, --
                i_Filial_Id => Ui.Filial_Id, --
                i_Job_Id => g_Norm.Job_Id).Name);
      v_Row.Put('action_frequency', g_Action_Frequency);
    
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
    
      g_Norm           := null;
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
    v_Action_Period varchar2(1);
    v_Day_Actions   Array_Varchar2;
    v_Day_No        varchar2(2 char);
    v_Frequency     varchar2(20);
    v_Norm          Hsc_Pref.Object_Norm_Rt;
  begin
    if p.r_Number('driver_id') =
       Hsc_Util.Driver_Constant_Id(i_Company_Id => i_Company_Id, --
                                   i_Filial_Id  => i_Filial_Id) then
      v_Day_Actions   := Fazo.Split(Regexp_Replace(p.r_Varchar2('action_frequency'), ' ', ''), ',');
      v_Action_Period := case
                           when to_number(Regexp_Substr(v_Day_Actions(1), '^[0-9]')) > 0 then
                            Hsc_Pref.c_Action_Period_Month
                           else
                            Hsc_Pref.c_Action_Period_Week
                         end;
    end if;
  
    Hsc_Util.Object_Norm_New(o_Norm          => v_Norm,
                             i_Company_Id    => i_Company_Id,
                             i_Filial_Id     => i_Filial_Id,
                             i_Object_Id     => i_Object_Id,
                             i_Norm_Id       => null,
                             i_Process_Id    => p.r_Number('process_id'),
                             i_Action_Id     => p.r_Number('action_id'),
                             i_Driver_Id     => p.r_Number('driver_id'),
                             i_Area_Id       => p.r_Number('area_id'),
                             i_Division_Id   => p.o_Number('division_id'),
                             i_Job_Id        => p.r_Number('job_id'),
                             i_Time_Value    => p.r_Number('time_value'),
                             i_Action_Period => v_Action_Period);
  
    v_Norm.Norm_Id := Hsc_Util.Next_Object_Norm_Id(i_Company_Id  => v_Norm.Company_Id,
                                                   i_Filial_Id   => v_Norm.Filial_Id,
                                                   i_Object_Id   => v_Norm.Object_Id,
                                                   i_Process_Id  => v_Norm.Process_Id,
                                                   i_Action_Id   => v_Norm.Action_Id,
                                                   i_Driver_Id   => v_Norm.Driver_Id,
                                                   i_Area_Id     => v_Norm.Area_Id,
                                                   i_Division_Id => v_Norm.Division_Id,
                                                   i_Job_Id      => v_Norm.Job_Id);
  
    if v_Action_Period is not null then
      for i in 1 .. v_Day_Actions.Count
      loop
        v_Day_No    := Regexp_Substr(v_Day_Actions(i), '[^(]+', 1, 1);
        v_Frequency := Regexp_Substr(v_Day_Actions(i), '([^(]+)\)', 1, 1, null, 1);
      
        if v_Action_Period = Hsc_Pref.c_Action_Period_Week then
          v_Day_No := g_Week_Day(Lower(v_Day_No));
        end if;
      
        Hsc_Util.Object_Norm_Add_Action(p_Norm      => v_Norm,
                                        i_Day_No    => to_number(v_Day_No),
                                        i_Frequency => to_number(v_Frequency));
      end loop;
    end if;
  
    Hsc_Api.Object_Norm_Save(v_Norm);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_Object_Ids Array_Number := p.r_Array_Number('object_ids');
    v_List       Arraylist := p.r_Arraylist('items');
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      for j in 1 .. v_Object_Ids.Count
      loop
        Norm_Add(i_Company_Id => Ui.Company_Id,
                 i_Filial_Id  => Ui.Filial_Id,
                 i_Object_Id  => v_Object_Ids(j),
                 p            => Treat(v_List.r_Hashmap(i) as Hashmap));
      end loop;
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
    update Hsc_Areas
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           name       = null,
           State      = null;
    update Hsc_Processes
       set Company_Id = null,
           Filial_Id  = null,
           Process_Id = null,
           name       = null,
           State      = null;
    update Hsc_Process_Actions
       set Company_Id = null,
           Filial_Id  = null,
           Action_Id  = null,
           Process_Id = null,
           name       = null,
           State      = null;
    update Hsc_Drivers
       set Company_Id = null,
           Filial_Id  = null,
           Driver_Id  = null,
           name       = null,
           State      = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr558;
/
