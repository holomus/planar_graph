create or replace package Ui_Vhr566 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Job return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedule return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Template;
  ----------------------------------------------------------------------------------------------------
  Function Import_File(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap);
end Ui_Vhr566;
/
create or replace package body Ui_Vhr566 is
  ----------------------------------------------------------------------------------------------------  
  type Staff_Rt is record(
    Staff_Id      number,
    name          varchar2(752 char),
    Hiring_Date   date,
    Division_Id   number,
    Division_Name varchar2(200 char),
    Job_Id        number,
    Job_Name      varchar2(200 char),
    Schedule_Id   number,
    Schedule_Name varchar2(100 char));

  ----------------------------------------------------------------------------------------------------  
  g_Division_Count number;
  g_Job_Count      number;
  g_Schedule_Count number;
  g_Starting_Row   number;
  g_Errors         Arraylist;
  g_Error_Messages Arraylist;
  g_Staff          Staff_Rt;

  c_Staff_Id    constant varchar2(50) := 'staff_id';
  c_Name        constant varchar2(50) := 'name';
  c_Hiring_Date constant varchar2(50) := 'hiring_date';
  c_Division    constant varchar2(50) := 'division';
  c_Job         constant varchar2(50) := 'job';
  c_Schedule    constant varchar2(50) := 'schedule';

  ---------------------------------------------------------------------------------------------------- 
  g_Columns Matrix_Varchar2 := Matrix_Varchar2(Array_Varchar2(c_Staff_Id, 1),
                                               Array_Varchar2(c_Name, 2),
                                               Array_Varchar2(c_Hiring_Date, 3),
                                               Array_Varchar2(c_Division, 4),
                                               Array_Varchar2(c_Job, 5),
                                               Array_Varchar2(c_Schedule, 6));

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
    return b.Translate('UI-VHR566:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Division return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query(Uit_Hrm.Departments_Query(i_Only_Active => true),
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('division_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Job return Fazo_Query is
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
  Function Query_Schedule return Fazo_Query is
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
  Function Default_Column_Number(i_Key varchar2) return varchar2 is
  begin
    for i in 1 .. g_Columns.Count
    loop
      if g_Columns(i) (1) = i_Key then
        return g_Columns(i)(2);
      end if;
    end loop;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Columns_All return Matrix_Varchar2 is
    v_Matrix1 Matrix_Varchar2;
    v_Matrix2 Matrix_Varchar2;
  begin
    v_Matrix1 := Matrix_Varchar2(Array_Varchar2(c_Staff_Id, t('staff_id'), 1),
                                 Array_Varchar2(c_Name, t('name'), 2),
                                 Array_Varchar2(c_Hiring_Date, t('hiring date'), 3),
                                 Array_Varchar2(c_Division, t('division'), 4),
                                 Array_Varchar2(c_Job, t('job'), 5),
                                 Array_Varchar2(c_Schedule, t('schedule'), 6));
  
    select *
      bulk collect
      into v_Matrix2
      from table(v_Matrix1)
     order by to_number(Fazo.Column_Varchar2(Column_Value, 3));
  
    return v_Matrix2;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables is
  begin
    g_Starting_Row := 2;
    g_Errors       := Arraylist();
  end;

  ----------------------------------------------------------------------------------------------------
  Function Source_Table return b_Table is
    a b_Table;
    c b_Table;
  begin
    a := b_Report.New_Table;
    a.New_Row;
  
    -- division
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Division_Count := 0;
    for r in (select q.Name
                from Mhr_Divisions q
                join Hrm_Divisions Dv
                  on Dv.Company_Id = q.Company_Id
                 and Dv.Filial_Id = q.Filial_Id
                 and Dv.Division_Id = q.Division_Id
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and Dv.Is_Department = 'Y'
                 and q.State = 'A')
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Division_Count := g_Division_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- job
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Job_Count := 0;
    for r in (select q.Name
                from Mhr_Jobs q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.State = 'A')
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Job_Count := g_Job_Count + 1;
    end loop;
  
    a.Data(c);
  
    -- schedule
    c := b_Report.New_Table;
    c.New_Row;
  
    g_Schedule_Count := 0;
    for r in (select q.Name
                from Htt_Schedules q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.State = 'A')
    loop
      c.Data(r.Name);
      c.New_Row;
      g_Schedule_Count := g_Schedule_Count + 1;
    end loop;
  
    a.Data(c);
  
    return a;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template is
    a              b_Table;
    v_Source_Table b_Table;
    v_Source_Name  varchar2(100) := 'data';
    v_Columns_All  Matrix_Varchar2;
    v_Data_Matrix  Matrix_Varchar2;
    v_Left_Matrix  Matrix_Varchar2;
    v_Begin_Index  number;
    v_Curr_Date    date := Trunc(sysdate);
  
    --------------------------------------------------     
    Function Column_Order(i_Key varchar2) return number is
      v_Column_Order number;
    begin
      for i in 1 .. v_Columns_All.Count
      loop
        if v_Columns_All(i) (1) = i_Key then
          v_Column_Order := v_Columns_All(i) (3);
          exit;
        end if;
      end loop;
    
      return v_Column_Order;
    end;
  
    --------------------------------------------------     
    Procedure Set_Column
    (
      i_Column_Key   varchar2,
      i_Column_Data  varchar2,
      i_Column_Width number := null
    ) is
      v_Column_Order number := Column_Order(i_Column_Key);
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
  begin
    v_Columns_All := Columns_All;
    v_Data_Matrix := Matrix_Varchar2();
    v_Left_Matrix := Matrix_Varchar2();
    v_Begin_Index := 0;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => b_Report.Rt_Imp_Xlsx,
                                   i_File_Name   => Ui.Current_Form_Name);
  
    v_Source_Table := Source_Table;
  
    a := b_Report.New_Table;
    a.Current_Style('header');
    a.New_Row;
  
    Set_Column(c_Staff_Id, t('staff_id'), 100);
    Set_Column(c_Name, t('name'), 200);
    Set_Column(c_Hiring_Date, t('hiring date'), 150);
    Set_Column(c_Division, t('division'), 150);
    Set_Column(c_Job, t('job'), 150);
    Set_Column(c_Schedule, t('schedule'), 150);
  
    Push_Left_Data;
  
    -- source data
    a.Column_Data_Source(Column_Order(c_Division), 1, 102, v_Source_Name, 1, g_Division_Count); -- division
    a.Column_Data_Source(Column_Order(c_Job), 1, 102, v_Source_Name, 2, g_Job_Count); -- job
    a.Column_Data_Source(Column_Order(c_Schedule), 1, 102, v_Source_Name, 3, g_Schedule_Count); -- schedule
  
    for i in 1 .. v_Data_Matrix.Count
    loop
      a.Column_Width(i, v_Data_Matrix(i) (2));
      a.Data(v_Data_Matrix(i) (1));
    end loop;
  
    a.Current_Style('root');
  
    for r in (select q.Staff_Id,
                     q.Hiring_Date,
                     (select w.Name
                        from Mr_Natural_Persons w
                       where w.Company_Id = q.Company_Id
                         and w.Person_Id = q.Employee_Id) as Employee_Name,
                     (select w.Name
                        from Mhr_Divisions w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Division_Id = q.Division_Id) as Division_Name,
                     (select w.Name
                        from Mhr_Jobs w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Job_Id = q.Job_Id) as Job_Name,
                     (select w.Name
                        from Htt_Schedules w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Schedule_Id = q.Schedule_Id) as Schedule_Name
                from Href_Staffs q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Hiring_Date <= v_Curr_Date
                 and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Curr_Date)
                 and q.State = 'A')
    loop
      a.New_Row;
    
      Set_Column(c_Staff_Id, r.Staff_Id, 100);
      Set_Column(c_Name, r.Employee_Name, 200);
      Set_Column(c_Hiring_Date, r.Hiring_Date, 150);
      Set_Column(c_Division, r.Division_Name, 150);
      Set_Column(c_Job, r.Job_Name, 150);
      Set_Column(c_Schedule, r.Schedule_Name, 150);
    
      for i in 1 .. v_Data_Matrix.Count
      loop
        a.Column_Width(i, v_Data_Matrix(i) (2));
        a.Data(v_Data_Matrix(i) (1));
      end loop;
    end loop;
  
    b_Report.Add_Sheet(t('employees'), a);
  
    -- template data  
    b_Report.Add_Sheet(v_Source_Name, v_Source_Table);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Staff_Id(i_Staff_Id varchar2) is
  begin
    if i_Staff_Id is not null then
      select t.Staff_Id
        into g_Staff.Staff_Id
        from Href_Staffs t
       where t.Company_Id = Ui.Company_Id
         and t.Filial_Id = Ui.Filial_Id
         and t.Staff_Id = to_number(i_Staff_Id);
    else
      g_Error_Messages.Push(t('staff id is null, please set staff id'));
    end if;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with staff id $2{staff id}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Employee_Name(i_Name varchar2) is
  begin
    g_Staff.Name := i_Name;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with employee name $2{employee name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Hiring_Date(i_Value varchar2) is
  begin
    g_Staff.Hiring_Date := Mr_Util.Convert_To_Date(i_Value);
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with hiring date $2{hiring_date}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Division(i_Value varchar2) is
  begin
    g_Staff.Division_Id := Mhr_Util.Division_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id,
                                                        i_Name       => i_Value);
  
    g_Staff.Division_Name := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with division $2{division name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Job(i_Value varchar2) is
  begin
    g_Staff.Job_Id := Mhr_Util.Job_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id,
                                              i_Name       => i_Value);
  
    g_Staff.Job_Name := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with job $2{job name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Schedule(i_Value varchar2) is
  begin
    g_Staff.Schedule_Id := Htt_Util.Schedule_Id_By_Name(i_Company_Id => Ui.Company_Id,
                                                        i_Filial_Id  => Ui.Filial_Id,
                                                        i_Name       => i_Value);
  
    g_Staff.Schedule_Name := i_Value;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with schedule $2{schedule name}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Parse_Row
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
    v_Column_Number number;
    v_Cell_Value    varchar2(300);
  
    --------------------------------------------------                   
    Function Cell_Value(i_Column_Name varchar2) return varchar2 is
    begin
      v_Column_Number := Default_Column_Number(i_Column_Name);
      v_Cell_Value    := i_Sheet.o_Varchar2(i_Row_Index, v_Column_Number);
    
      return v_Cell_Value;
    end;
  begin
    Set_Staff_Id(Cell_Value(c_Staff_Id));
    Set_Employee_Name(Cell_Value(c_Name));
    Set_Hiring_Date(Cell_Value(c_Hiring_Date));
    Set_Division(Cell_Value(c_Division));
    Set_Job(Cell_Value(c_Job));
    Set_Schedule(Cell_Value(c_Schedule));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Staff_To_Array return Array_Varchar2 is
  begin
    return Array_Varchar2(g_Staff.Staff_Id,
                          g_Staff.Name,
                          g_Staff.Hiring_Date,
                          g_Staff.Division_Id,
                          g_Staff.Division_Name,
                          g_Staff.Job_Id,
                          g_Staff.Job_Name,
                          g_Staff.Schedule_Id,
                          g_Staff.Schedule_Name);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Row(o_Items in out nocopy Matrix_Varchar2) is
  begin
    if g_Error_Messages.Count = 0 then
      o_Items.Extend;
      o_Items(o_Items.Count) := Staff_To_Array;
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
    
      g_Staff          := null;
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
  Procedure Hiring_Change(p Hashmap) is
    v_Staff_Id   number := p.r_Number('staff_id');
    v_Journal_Id number := Uit_Hpd.Get_Las_Hiring_Journal_Id(v_Staff_Id);
    p_Journal    Hpd_Pref.Hiring_Journal_Rt;
  begin
    -- unpost Journal
    Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                           i_Filial_Id  => Ui.Filial_Id,
                           i_Journal_Id => v_Journal_Id,
                           i_Repost     => true);
  
    p_Journal := Uit_Hpd.Fill_Hiring_Data(i_Journal_Id  => v_Journal_Id,
                                          i_Staff_Id    => v_Staff_Id,
                                          i_Hiring_Date => p.r_Date('hiring_date'),
                                          i_Division_Id => p.r_Number('division_id'),
                                          i_Job_Id      => p.r_Number('job_id'),
                                          i_Schedule_Id => p.r_Number('schedule_id'));
  
    Hpd_Api.Hiring_Journal_Save(p_Journal);
    Hpd_Api.Journal_Post(i_Company_Id => p_Journal.Company_Id,
                         i_Filial_Id  => p_Journal.Filial_Id,
                         i_Journal_Id => p_Journal.Journal_Id);
  
    Hpd_Api.Journal_Repairing(i_Company_Id => p_Journal.Company_Id,
                              i_Filial_Id  => p_Journal.Filial_Id,
                              i_Journal_Id => p_Journal.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Import_Data(p Hashmap) is
    v_List Arraylist := p.r_Arraylist('items');
    v_Item Hashmap;
  begin
    Set_Global_Variables;
  
    for i in 1 .. v_List.Count
    loop
      v_Item := Treat(v_List.r_Hashmap(i) as Hashmap);
    
      Hiring_Change(v_Item);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
  end;

end Ui_Vhr566;
/
