create or replace package Ui_Vhr446 is
  ----------------------------------------------------------------------------------------------------
  Procedure Template(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Import(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Calendars return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Robots(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Robots(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Calendar_Days(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Name(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Name(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Load_Preferences return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Robot_Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Robot_Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Check_By_Calendar_Limit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr446;
/
create or replace package body Ui_Vhr446 is
  ----------------------------------------------------------------------------------------------------  
  type Registry_Rt is record(
    Staff_Id number,
    Robot_Id number,
    Days     Matrix_Varchar2);

  ----------------------------------------------------------------------------------------------------  
  g_Starting_Row           number;
  g_Registry_Kind          varchar2(1);
  g_Days_Count             number;
  g_Month                  date;
  g_Error_Messages         Arraylist;
  g_Errors                 Arraylist;
  g_Registry               Registry_Rt;
  g_Cache_Begin_Time       Fazo.Varchar2_Code_Aat;
  g_Cache_End_Time         Fazo.Varchar2_Code_Aat;
  g_Cache_Break_Enabled    Fazo.Varchar2_Code_Aat;
  g_Cache_Break_Begin_Time Fazo.Varchar2_Code_Aat;
  g_Cache_Break_End_Time   Fazo.Varchar2_Code_Aat;
  g_Cache_Plan_Time        Fazo.Varchar2_Code_Aat;

  ----------------------------------------------------------------------------------------------------
  c_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr446:settings';

  ----------------------------------------------------------------------------------------------------
  c_Employee_Id     constant varchar2(50) := 'employee_id';
  c_Robot_Id        constant varchar2(50) := 'robot_id';
  c_Symbol_Rest_Day constant varchar2(50) := 'В'; -- (В)ыходной

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
    return b.Translate('UI-VHR446:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Global_Variables(p Hashmap) is
  begin
    g_Starting_Row  := 3;
    g_Month         := p.r_Date('month');
    g_Registry_Kind := Uit_Htt.Get_Registry_Kind;
    g_Errors        := Arraylist();
  
    select cast(to_char(Last_Day(g_Month), 'DD') as int)
      into g_Days_Count
      from Dual;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Metadata return b_Table is
    v_Settings Hashmap := Load_Preferences();
    v_List     Arraylist;
    v_Data     Hashmap;
    a          b_Table;
  begin
    a := b_Report.New_Table;
    a.New_Row;
    a.Current_Style('header');
  
    a.Column_Width(1, 200);
    a.Data(t('code'));
  
    a.Column_Width(2, 200);
    a.Data(t('begin time'));
  
    a.Column_Width(3, 200);
    a.Data(t('end time'));
  
    a.Column_Width(4, 200);
    a.Data(t('break enabled(Y or N (Y-yes, N-no))'));
  
    a.Column_Width(5, 200);
    a.Data(t('begin break time'));
  
    a.Column_Width(6, 200);
    a.Data(t('end break time'));
  
    a.Column_Width(7, 200);
    a.Data(t('plan time'));
  
    a.New_Row;
    a.Current_Style('example text');
  
    a.Column_Width(1, 200);
    a.Data(t('example'));
  
    a.Column_Width(2, 200);
    a.Data('09:00');
  
    a.Column_Width(3, 200);
    a.Data('18:00');
  
    a.Column_Width(4, 200);
    a.Data('Y');
  
    a.Column_Width(5, 200);
    a.Data('13:00');
  
    a.Column_Width(6, 200);
    a.Data('14:00');
  
    a.Column_Width(7, 200);
    a.Data('08:00');
  
    a.Current_Style('suggestion');
  
    a.Column_Width(8, 50);
    a.Data('');
    a.Data(t('1-all data types must be text') || Chr(10) || --
           t('2-code must be unique') || Chr(10) ||
           t('3-if there is no break, the beginning and the end of the break do not need to be written'),
           i_Colspan => 6,
           i_Rowspan => 10);
  
    -- shift list
    v_List := Nvl(v_Settings.o_Arraylist('shift_list'), Arraylist());
  
    for i in 1 .. v_List.Count
    loop
      v_Data := Treat(v_List.r_Hashmap(i) as Hashmap);
      a.New_Row;
    
      a.Column_Width(1, 200);
      a.Data(v_Data.o_Varchar2('code'), 'text');
    
      a.Column_Width(2, 200);
      a.Data(v_Data.o_Varchar2('begin_time'), 'text');
    
      a.Column_Width(3, 200);
      a.Data(v_Data.o_Varchar2('end_time'), 'text');
    
      a.Column_Width(4, 200);
      a.Data(v_Data.o_Varchar2('break_enabled'), 'text');
    
      a.Column_Width(5, 200);
      a.Data(v_Data.o_Varchar2('break_begin_time'), 'text');
    
      a.Column_Width(6, 200);
      a.Data(v_Data.o_Varchar2('break_end_time'), 'text');
    
      a.Column_Width(7, 200);
      a.Data(v_Data.o_Varchar2('plan_time'), 'text');
    end loop;
  
    return a;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Template(p Hashmap) is
    a               b_Table;
    v_Metadata      b_Table;
    v_Source_Name   varchar2(10) := 'data';
    v_Metadata_Name varchar2(10) := 'metadata';
    v_Clarifier_Ids Array_Number := Nvl(p.o_Array_Number('clarifier_ids'), Array_Number());
    v_Division_Ids  Array_Number;
    v_Matrix        Matrix_Varchar2;
    v_Column        number := 1;
    v_Col_Count     number;
    v_Curr_Date     date;
    v_Style_Name    varchar2(50);
    v_Nls_Language  varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Month         date := Trunc(sysdate);
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number,
      i_Style_Name   varchar2
    ) is
    begin
      a.Data(i_Name, i_Style_Name => i_Style_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
    
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  begin
    Set_Global_Variables(p);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                           i_Indirect => true,
                                                           i_Manual   => true);
    end if;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => b_Report.Rt_Imp_Xlsx,
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- rest
    b_Report.New_Style(i_Style_Name        => 'rest',
                       i_Parent_Style_Name => 'header',
                       i_Font_Color        => '#16365c',
                       i_Background_Color  => '#f8cbad');
  
    -- work
    b_Report.New_Style(i_Style_Name        => 'work',
                       i_Parent_Style_Name => 'header',
                       i_Font_Color        => '#16365c',
                       i_Background_Color  => '#d9e1f2');
  
    -- example
    b_Report.New_Style(i_Style_Name        => 'example',
                       i_Parent_Style_Name => 'header',
                       i_Font_Color        => '#16365c',
                       i_Background_Color  => '#c6efce',
                       i_Font_Bold         => false);
  
    -- suggestion
    b_Report.New_Style(i_Style_Name        => 'suggestion',
                       i_Parent_Style_Name => 'header',
                       i_Font_Color        => '#16365c',
                       i_Background_Color  => 'white',
                       i_Horizontal_Align  => Option_Number(1));
  
    a := b_Report.New_Table;
    a.New_Row;
  
    v_Metadata   := Metadata;
    v_Style_Name := 'header';
  
    Print_Header(t('id'), 1, 2, 100, v_Style_Name);
  
    if g_Registry_Kind = Htt_Pref.c_Registry_Kind_Robot then
      Print_Header(t('robot_name'), 1, 2, 300, v_Style_Name);
    end if;
  
    Print_Header(t('employee_name'), 1, 2, 300, v_Style_Name);
    Print_Header(t('division_name'), 1, 2, 150, v_Style_Name);
    Print_Header(t('job_name'), 1, 2, 150, v_Style_Name);
  
    for i in 1 .. g_Days_Count
    loop
      Print_Header(i, 1, 1, 100, v_Style_Name);
    end loop;
  
    a.New_Row;
    for i in 0 .. g_Days_Count - 1
    loop
      v_Curr_Date  := to_date(g_Month + i, 'DD.MM.YYYY');
      v_Style_Name := 'work';
    
      if to_char(v_Curr_Date, 'd') in (6, 7) then
        v_Style_Name := 'rest';
      end if;
    
      Print_Header(to_char(v_Curr_Date, 'Dy', v_Nls_Language), 1, 1, 100, v_Style_Name);
    end loop;
  
    if g_Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      select Array_Varchar2(q.Staff_Id,
                            Np.Name,
                            (select Div.Name
                               from Mhr_Divisions Div
                              where Div.Company_Id = q.Company_Id
                                and Div.Filial_Id = q.Filial_Id
                                and Div.Division_Id = q.Division_Id),
                            (select Job.Name
                               from Mhr_Jobs Job
                              where Job.Company_Id = q.Company_Id
                                and Job.Filial_Id = q.Filial_Id
                                and Job.Job_Id = q.Job_Id))
        bulk collect
        into v_Matrix
        from Href_Staffs q
        join Mr_Natural_Persons Np
          on Np.Company_Id = q.Company_Id
         and Np.Person_Id = q.Employee_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Hiring_Date <= Last_Day(v_Month)
         and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Month)
         and q.State = 'A'
         and q.Staff_Id member of
       v_Clarifier_Ids
         and (Uit_Href.User_Access_All_Employees = 'Y' or
             q.Org_Unit_Id in (select Column_Value
                                  from table(v_Division_Ids)))
       order by Np.Name;
    
      v_Col_Count := 4;
    else
      select Array_Varchar2(q.Robot_Id,
                            q.Name,
                            (select Np.Name
                               from Mr_Natural_Persons Np
                              where Np.Company_Id = q.Company_Id
                                and Np.Person_Id = q.Person_Id),
                            (select Div.Name
                               from Mhr_Divisions Div
                              where Div.Company_Id = q.Company_Id
                                and Div.Filial_Id = q.Filial_Id
                                and Div.Division_Id = q.Division_Id),
                            (select Job.Name
                               from Mhr_Jobs Job
                              where Job.Company_Id = q.Company_Id
                                and Job.Filial_Id = q.Filial_Id
                                and Job.Job_Id = q.Job_Id))
        bulk collect
        into v_Matrix
        from Mrf_Robots q
        join Hrm_Robots r
          on r.Company_Id = q.Company_Id
         and r.Filial_Id = q.Filial_Id
         and r.Robot_Id = q.Robot_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and r.Opened_Date <= Last_Day(v_Month)
         and (r.Closed_Date is null or r.Closed_Date >= v_Month)
         and q.State = 'A'
         and q.Robot_Id member of
       v_Clarifier_Ids
         and (Uit_Href.User_Access_All_Employees = 'Y' or
             r.Org_Unit_Id in (select Column_Value
                                  from table(v_Division_Ids)))
       order by q.Name;
    
      v_Col_Count := 5;
    end if;
  
    for i in 1 .. v_Matrix.Count
    loop
      a.New_Row;
    
      for j in 1 .. v_Col_Count
      loop
        a.Data(v_Matrix(i) (j));
      end loop;
    end loop;
  
    b_Report.Add_Sheet(i_Name             => v_Source_Name,
                       p_Table            => a,
                       i_Split_Vertical   => 2,
                       i_Split_Horizontal => v_Col_Count);
  
    -- add metadata
    b_Report.Add_Sheet(i_Name  => v_Metadata_Name, --
                       p_Table => v_Metadata);
  
    b_Report.Close_Book;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Staff_Id(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Registry.Staff_Id := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id, --
                           i_Filial_Id => Ui.Filial_Id, --
                           i_Staff_Id => i_Value).Staff_Id;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with staff $2{staff_id}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Robot_Id(i_Value varchar2) is
  begin
    if i_Value is null then
      return;
    end if;
  
    g_Registry.Robot_Id := z_Mrf_Robots.Load(i_Company_Id => Ui.Company_Id, --
                           i_Filial_Id => Ui.Filial_Id, --
                           i_Robot_Id => i_Value).Robot_Id;
  
  exception
    when others then
      g_Error_Messages.Push(t('$1{error message} with robot $2{robot_id}',
                              b.Trim_Ora_Error(sqlerrm),
                              i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Parse_Days
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
    v_Matrix    Matrix_Varchar2 := Matrix_Varchar2();
    v_Start_Col number;
    v_Code      varchar2(100);
    v_Curr_Date date;
  begin
    if g_Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      v_Start_Col := 5;
    else
      v_Start_Col := 6;
    end if;
  
    for i in 0 .. g_Days_Count - 1
    loop
      v_Code      := i_Sheet.o_Varchar2(i_Row_Index, i + v_Start_Col);
      v_Curr_Date := to_date(g_Month + i, 'DD.MM.YYYY');
    
      if v_Code is null or v_Code = c_Symbol_Rest_Day then
        Fazo.Push(v_Matrix,
                  Array_Varchar2('09:00',
                                 '18:00',
                                 'Y',
                                 '13:00',
                                 '14:00',
                                 '08:00',
                                 Htt_Pref.c_Day_Kind_Rest,
                                 v_Curr_Date));
      else
        Fazo.Push(v_Matrix,
                  Array_Varchar2(g_Cache_Begin_Time(v_Code),
                                 g_Cache_End_Time(v_Code),
                                 g_Cache_Break_Enabled(v_Code),
                                 g_Cache_Break_Begin_Time(v_Code),
                                 g_Cache_Break_End_Time(v_Code),
                                 g_Cache_Plan_Time(v_Code),
                                 Htt_Pref.c_Day_Kind_Work,
                                 v_Curr_Date));
      end if;
    end loop;
  
    g_Registry.Days := v_Matrix;
  
  exception
    when No_Data_Found then
      b.Raise_Error(t('code not found in metadata, please check code to correctly, date: $1{date}, row: $2{row}, code: $3{code}',
                      v_Curr_Date,
                      i_Row_Index,
                      v_Code));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Parse_Column
  (
    i_Sheet       Excel_Sheet,
    i_Row_Index   number,
    i_Column_Name varchar2
  ) is
  begin
    case i_Column_Name
      when c_Employee_Id then
        Set_Staff_Id(i_Sheet.o_Varchar2(i_Row_Index, 1));
      when c_Robot_Id then
        Set_Robot_Id(i_Sheet.o_Varchar2(i_Row_Index, 1));
      else
        null;
    end case;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Parse_Item
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
  begin
    if g_Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      Parse_Column(i_Sheet, i_Row_Index, c_Employee_Id);
    else
      Parse_Column(i_Sheet, i_Row_Index, c_Robot_Id);
    end if;
  
    Parse_Days(i_Sheet, i_Row_Index);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Data_To_Hashmap return Hashmap is
    v_Data Hashmap := Hashmap();
  begin
    if g_Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      v_Data.Put('staff_id', g_Registry.Staff_Id);
    else
      v_Data.Put('robot_id', g_Registry.Robot_Id);
    end if;
  
    v_Data.Put('days', Fazo.Zip_Matrix(g_Registry.Days));
  
    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Push_Item(o_Items in out nocopy Arraylist) is
  begin
    if g_Registry_Kind = Htt_Pref.c_Registry_Kind_Staff and g_Registry.Staff_Id is not null then
      o_Items.Push(Data_To_Hashmap);
    elsif g_Registry_Kind = Htt_Pref.c_Registry_Kind_Robot and g_Registry.Robot_Id is not null then
      o_Items.Push(Data_To_Hashmap);
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
  Procedure Cache_Metadata
  (
    i_Sheet     Excel_Sheet,
    i_Row_Index number
  ) is
    v_Code varchar2(100) := i_Sheet.o_Varchar2(i_Row_Index, 1);
  begin
    if v_Code is not null then
      g_Cache_Begin_Time(v_Code) := i_Sheet.o_Varchar2(i_Row_Index, 2);
      g_Cache_End_Time(v_Code) := i_Sheet.o_Varchar2(i_Row_Index, 3);
      g_Cache_Break_Enabled(v_Code) := i_Sheet.o_Varchar2(i_Row_Index, 4);
      g_Cache_Break_Begin_Time(v_Code) := Nvl(i_Sheet.o_Varchar2(i_Row_Index, 5), '13:00');
      g_Cache_Break_End_Time(v_Code) := Nvl(i_Sheet.o_Varchar2(i_Row_Index, 6), '14:00');
      g_Cache_Plan_Time(v_Code) := i_Sheet.o_Varchar2(i_Row_Index, 7);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Import(p Hashmap) return Hashmap is
    v_Sheets   Arraylist;
    v_Sheet    Excel_Sheet;
    v_Metadata Excel_Sheet;
    v_Items    Arraylist := Arraylist();
    result     Hashmap := Hashmap();
  begin
    v_Sheets   := p.r_Arraylist('template');
    v_Sheet    := Excel_Sheet(v_Sheets.r_Hashmap(1));
    v_Metadata := Excel_Sheet(v_Sheets.r_Hashmap(2));
  
    Set_Global_Variables(p);
  
    -- cache metadata  
    for i in g_Starting_Row - 1 .. v_Metadata.Count_Row
    loop
      continue when v_Metadata.Is_Empty_Row(i);
    
      Cache_Metadata(v_Metadata, i);
    end loop;
  
    for i in g_Starting_Row .. v_Sheet.Count_Row
    loop
      continue when v_Sheet.Is_Empty_Row(i);
    
      g_Registry       := null;
      g_Error_Messages := Arraylist();
    
      Parse_Item(v_Sheet, i);
      Push_Item(v_Items);
    
      Push_Error(i);
    end loop;
  
    Result.Put('items', v_Items);
    Result.Put('errors', g_Errors);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Calendars return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_calendars',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('calendar_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query        varchar2(4000);
    v_Params       Hashmap;
    v_Schedule_Id  number := Htt_Util.Schedule_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Filial_Id  => Ui.Filial_Id,
                                                  i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule);
    v_Access_All   varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Subordinates Array_Number := Href_Util.Get_Subordinates(Ui.Company_Id,
                                                              Ui.Filial_Id,
                                                              'N',
                                                              Ui.User_Id,
                                                              'Y');
    q              Fazo_Query;
  begin
    v_Query := 'select s.staff_id, s.employee_id
                  from href_staffs s
                 where s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and (:division_id is null or s.division_id = :division_id)
                   and s.hiring_date <= last_day(:month)
                   and (s.dismissal_date is null or s.dismissal_date >= :month)
                   and s.state = ''A''
                   and (:access_all = ''Y'' or s.staff_id member of :subordinates)
                   and exists (select 1
                          from hpd_agreements ag
                          join hpd_trans_schedules ts
                            on ts.company_id = ag.company_id
                           and ts.filial_id = ag.filial_id
                           and ts.trans_id = ag.trans_id
                           and ts.schedule_id = :schedule_id
                         where ag.company_id = :company_id
                           and ag.filial_id = :filial_id
                           and ag.staff_id = s.staff_id
                           and ag.trans_type = :schedule_trans_type
                           and ag.period >= (select nvl(max(agg.period), :month) 
                                               from hpd_agreements agg 
                                              where agg.company_id = s.company_id 
                                                and agg.filial_id = s.filial_id 
                                                and agg.staff_id = s.staff_id 
                                                and agg.trans_type = :schedule_trans_type
                                                and agg.period <= :month)
                           and ag.period <= last_day(:month))
                   and not exists (select 1
                          from htt_schedule_registries sr
                          join htt_registry_units ru
                            on ru.company_id = sr.company_id
                           and ru.filial_id = sr.filial_id
                           and ru.registry_id = sr.registry_id
                           and ru.staff_id = s.staff_id
                         where sr.company_id = :company_id
                           and sr.filial_id = :filial_id
                           and sr.month = :month
                           and sr.posted = ''Y'')';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'month',
                             p.r_Date('month'),
                             'division_id',
                             p.o_Number('division_id'),
                             'schedule_id',
                             v_Schedule_Id,
                             'schedule_trans_type',
                             Hpd_Pref.c_Transaction_Type_Schedule);
    v_Params.Put('subordinates', v_Subordinates);
    v_Params.Put('access_all', v_Access_All);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id');
    q.Map_Field('name',
                'select np.name 
                   from mr_natural_persons np 
                  where np.company_id = :company_id 
                    and np.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Robots(p Hashmap) return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query := 'select q.robot_id,
                       q.division_id,
                       q.name
                  from mrf_robots q
                  join hrm_robots r
                    on r.company_id = q.company_id
                   and r.filial_id = q.filial_id
                   and r.robot_id = q.robot_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and r.opened_date <= last_day(:month)
                   and (r.closed_date is null or r.closed_date >= :month)
                   and q.state = ''A''
                   and (:division_id is null or q.division_id = :division_id)
                   and not exists (select 1
                              from htt_schedule_registries sr
                              join htt_registry_units ru
                                on ru.company_id = sr.company_id
                               and ru.filial_id = sr.filial_id
                               and ru.registry_id = sr.registry_id
                               and ru.robot_id = q.robot_id
                             where sr.company_id = :company_id
                               and sr.filial_id = :filial_id
                               and sr.month = :month
                               and sr.posted = ''Y'')';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'division_id',
                             p.o_Number('division_id'),
                             'month',
                             p.r_Date('month'));
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and r.org_unit_id in (select column_value from table(:division_ids))';
    
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('robot_id', 'division_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staffs(p Hashmap) return Hashmap is
    v_Month        date := p.r_Date('month');
    v_Division_Id  number := p.o_Number('division_id');
    v_Staff_Ids    Array_Number := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
    v_Matrix       Matrix_Varchar2;
    v_Schedule_Id  number := Htt_Util.Schedule_Id(i_Company_Id => Ui.Company_Id,
                                                  i_Filial_Id  => Ui.Filial_Id,
                                                  i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule);
    v_Access_All   varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Subordinates Array_Number := Href_Util.Get_Subordinates(Ui.Company_Id,
                                                              Ui.Filial_Id,
                                                              'N',
                                                              Ui.User_Id,
                                                              'Y');
    result         Hashmap := Hashmap();
  begin
    select Array_Varchar2(s.Staff_Id,
                          Np.Name,
                          (select Rob.Name
                             from Mrf_Robots Rob
                            where Rob.Company_Id = s.Company_Id
                              and Rob.Filial_Id = s.Filial_Id
                              and Rob.Robot_Id = s.Robot_Id))
      bulk collect
      into v_Matrix
      from Href_Staffs s
      join Mr_Natural_Persons Np
        on Np.Company_Id = s.Company_Id
       and Np.Person_Id = s.Employee_Id
     where s.Company_Id = Ui.Company_Id
       and s.Filial_Id = Ui.Filial_Id
       and s.Staff_Id not member of v_Staff_Ids
       and (v_Access_All = 'Y' or s.Staff_Id member of v_Subordinates)
       and (v_Division_Id is null or s.Division_Id = v_Division_Id)
       and s.Hiring_Date <= Last_Day(v_Month)
       and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Month)
       and s.State = 'A'
       and exists
     (select 1
              from Hpd_Agreements Ag
              join Hpd_Trans_Schedules Ts
                on Ts.Company_Id = Ag.Company_Id
               and Ts.Filial_Id = Ag.Filial_Id
               and Ts.Trans_Id = Ag.Trans_Id
               and Ts.Schedule_Id = v_Schedule_Id
             where Ag.Company_Id = Ui.Company_Id
               and Ag.Filial_Id = Ui.Filial_Id
               and Ag.Staff_Id = s.Staff_Id
               and Ag.Trans_Type = Hpd_Pref.c_Transaction_Type_Schedule
               and Ag.Period >= (select Nvl(max(Agg.Period), v_Month)
                                   from Hpd_Agreements Agg
                                  where Agg.Company_Id = s.Company_Id
                                    and Agg.Filial_Id = s.Filial_Id
                                    and Agg.Staff_Id = s.Staff_Id
                                    and Agg.Trans_Type = Hpd_Pref.c_Transaction_Type_Schedule
                                    and Agg.Period <= v_Month)
               and Ag.Period <= Last_Day(v_Month))
       and not exists (select 1
              from Htt_Schedule_Registries Sr
              join Htt_Registry_Units Ru
                on Ru.Company_Id = Sr.Company_Id
               and Ru.Filial_Id = Sr.Filial_Id
               and Ru.Registry_Id = Sr.Registry_Id
               and Ru.Staff_Id = s.Staff_Id
             where Sr.Company_Id = Ui.Company_Id
               and Sr.Filial_Id = Ui.Filial_Id
               and Sr.Month = v_Month
               and Sr.Posted = 'Y')
     order by Np.Name;
  
    Result.Put('staffs', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Robots(p Hashmap) return Hashmap is
    v_Month        date := p.r_Date('month');
    v_Division_Id  number := p.o_Number('division_id');
    v_Division_Ids Array_Number;
    v_Robot_Ids    Array_Number := Nvl(p.o_Array_Number('robot_ids'), Array_Number());
    v_Matrix       Matrix_Varchar2;
    result         Hashmap := Hashmap();
  begin
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                           i_Indirect => true,
                                                           i_Manual   => true);
    end if;
  
    select Array_Varchar2(q.Robot_Id, min(q.Name), Listagg(Np.Name, ', '))
      bulk collect
      into v_Matrix
      from Mrf_Robots q
      join Hrm_Robots r
        on r.Company_Id = q.Company_Id
       and r.Filial_Id = q.Filial_Id
       and r.Robot_Id = q.Robot_Id
      left join Mrf_Robot_Persons Rp
        on Rp.Company_Id = q.Company_Id
       and Rp.Filial_Id = q.Filial_Id
       and Rp.Robot_Id = q.Robot_Id
      left join Mr_Natural_Persons Np
        on Np.Company_Id = Rp.Company_Id
       and Np.Person_Id = Rp.Person_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and r.Opened_Date <= Last_Day(v_Month)
       and (r.Closed_Date is null or r.Closed_Date >= v_Month)
       and q.State = 'A'
       and q.Robot_Id not member of v_Robot_Ids
       and (v_Division_Id is null or q.Division_Id = v_Division_Id)
       and not exists (select 1
              from Htt_Schedule_Registries Sr
              join Htt_Registry_Units Ru
                on Ru.Company_Id = Sr.Company_Id
               and Ru.Filial_Id = Sr.Filial_Id
               and Ru.Registry_Id = Sr.Registry_Id
               and Ru.Robot_Id = q.Robot_Id
             where Sr.Company_Id = Ui.Company_Id
               and Sr.Filial_Id = Ui.Filial_Id
               and Sr.Month = v_Month
               and Sr.Posted = 'Y')
       and (Uit_Href.User_Access_All_Employees = 'Y' or
           r.Org_Unit_Id in (select Column_Value
                                from table(v_Division_Ids)))
     group by q.Robot_Id
     order by min(q.Name);
  
    Result.Put('robots', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Calendar_Days(p Hashmap) return Hashmap is
    v_Calendar_Id number := p.r_Number('calendar_id');
    v_Month       date := p.r_Date('month');
    v_Matrix      Matrix_Varchar2;
    result        Hashmap := Hashmap();
  begin
    select Array_Varchar2(s.Calendar_Date, s.Name, s.Day_Kind, s.Swapped_Date)
      bulk collect
      into v_Matrix
      from Htt_Calendar_Days s
     where s.Company_Id = Ui.Company_Id
       and s.Filial_Id = Ui.Filial_Id
       and s.Calendar_Id = v_Calendar_Id
       and (Trunc(s.Calendar_Date, 'mon') = v_Month and
           (s.Swapped_Date is null or Trunc(s.Swapped_Date, 'mon') = v_Month));
  
    Result.Put('calendar_days', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Name(p Hashmap) return varchar2 is
    v_Robot_Name varchar2(200);
    v_Staff_Id   number := p.r_Number('staff_id');
  begin
    select (select r.Name
              from Mrf_Robots r
             where r.Company_Id = q.Company_Id
               and r.Filial_Id = q.Filial_Id
               and r.Robot_Id = q.Robot_Id)
      into v_Robot_Name
      from Href_Staffs q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Id = v_Staff_Id;
  
    return v_Robot_Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Name(p Hashmap) return varchar2 is
    v_Staff_Names Array_Varchar2;
    v_Robot_Id    number := p.r_Number('robot_id');
  begin
    select (select Np.Name
              from Mr_Natural_Persons Np
             where Np.Company_Id = Rp.Company_Id
               and Np.Person_Id = Rp.Person_Id)
      bulk collect
      into v_Staff_Names
      from Mrf_Robot_Persons Rp
     where Rp.Company_Id = Ui.Company_Id
       and Rp.Filial_Id = Ui.Filial_Id
       and Rp.Robot_Id = v_Robot_Id;
  
    return Fazo.Gather(v_Staff_Names, ', ');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap) is
  begin
    Ui.User_Setting_Save(i_Setting_Code => c_Setting_Code, i_Setting_Value => p.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Preferences return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => c_Setting_Code,
                                               i_Default_Value => '{}'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References(i_Division_Id number := null) return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('sk_custom',
                           Htt_Pref.c_Schedule_Kind_Custom,
                           'sk_hourly',
                           Htt_Pref.c_Schedule_Kind_Hourly,
                           'sk_flexible',
                           Htt_Pref.c_Schedule_Kind_Flexible,
                           'additional_time_type_allowed',
                           Htt_Pref.c_Additional_Time_Type_Allowed,
                           'additional_time_type_extra',
                           Htt_Pref.c_Additional_Time_Type_Extra);
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
  
    if Uit_Htt.Get_Registry_Kind = Htt_Pref.c_Registry_Kind_Staff then
      Result.Put('schedule_id',
                 Htt_Util.Schedule_Id(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model
  (
    p      Hashmap,
    i_Form varchar2
  ) return Hashmap is
    v_Schedule_Kind varchar2(1) := p.r_Varchar2('schedule_kind');
    result          Hashmap;
  begin
    Uit_Htt.Assert_Access_To_Schedule_Kind(i_Schedule_Kind => v_Schedule_Kind, i_Form => i_Form);
  
    result := Fazo.Zip_Map('advanced_settings',
                           'N',
                           'use_calendar',
                           'N',
                           'registry_date',
                           Trunc(sysdate),
                           'month',
                           to_char(sysdate, Href_Pref.c_Date_Format_Month));
  
    Result.Put('schedule_kind', v_Schedule_Kind);
    Result.Put('registry_kind', Uit_Htt.Get_Registry_Kind);
    Result.Put('take_holidays', 'Y');
    Result.Put('take_nonworking', 'Y');
    Result.Put('take_additional_rest_days', 'Y');
    Result.Put('count_late', 'Y');
    Result.Put('count_early', 'Y');
    Result.Put('count_lack', 'Y');
    Result.Put('count_free', 'Y');
    Result.Put('gps_turnout_enabled', 'N');
    Result.Put('gps_use_location', 'N');
    Result.Put('use_marks', 'N');
    Result.Put('advanced_setting', 'N');
    Result.Put('additional_time_type', Htt_Pref.c_Additional_Time_Type_Allowed);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Add_Model(p Hashmap) return Hashmap is
  begin
    return Add_Model(p => p, i_Form => Htt_Pref.c_Staff_Schedule_Registry_List_Form);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Add_Model(p Hashmap) return Hashmap is
  begin
    return Add_Model(p => p, i_Form => Htt_Pref.c_Robot_Schedule_Registry_List_Form);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model
  (
    p      Hashmap,
    i_Form varchar2
  ) return Hashmap is
    v_Registry_Id          number := p.r_Number('registry_id');
    v_Unit_Ids             Array_Number;
    v_Matrix               Matrix_Varchar2;
    v_Marks_Used           varchar2(1) := 'N';
    v_Additional_Time_Type varchar2(1) := Htt_Pref.c_Additional_Time_Type_Allowed;
    v_Advanced_Setting     varchar2(1) := 'N';
    result                 Hashmap;
    r_Registry             Htt_Schedule_Registries%rowtype;
  
    -------------------------------------------------- 
    Function Advanced_Settings
    (
      i_Registry   Htt_Schedule_Registries%rowtype,
      i_Marks_Used varchar2
    ) return varchar2 is
    begin
      if i_Registry.Shift = 0 and i_Registry.Input_Acceptance = 0 and
         i_Registry.Output_Acceptance = 0 and i_Registry.Track_Duration = 1440 and
         i_Registry.Count_Late = 'Y' and i_Registry.Count_Early = 'Y' and
         i_Registry.Count_Lack = 'Y' and i_Registry.Count_Free = 'Y' and i_Marks_Used = 'N' then
        return 'N';
      else
        return 'Y';
      end if;
    end;
  begin
    r_Registry := z_Htt_Schedule_Registries.Load(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Registry_Id => v_Registry_Id);
  
    Uit_Htt.Assert_Access_Registry_Kind(r_Registry.Registry_Kind);
    Uit_Htt.Assert_Access_To_Schedule_Kind(i_Schedule_Kind => r_Registry.Schedule_Kind,
                                           i_Form          => i_Form);
  
    result := z_Htt_Schedule_Registries.To_Map(r_Registry,
                                               z.Registry_Id,
                                               z.Registry_Date,
                                               z.Registry_Number,
                                               z.Registry_Kind,
                                               z.Schedule_Kind,
                                               z.Division_Id,
                                               z.Note,
                                               z.Posted,
                                               z.Shift,
                                               z.Input_Acceptance,
                                               z.Output_Acceptance,
                                               z.Track_Duration,
                                               z.Count_Late,
                                               z.Count_Lack,
                                               z.Count_Early,
                                               z.Count_Free,
                                               z.Gps_Turnout_Enabled,
                                               z.Gps_Use_Location,
                                               z.Gps_Max_Interval,
                                               z.Allowed_Late_Time,
                                               z.Allowed_Early_Time,
                                               z.Begin_Late_Time,
                                               z.End_Early_Time,
                                               z.Calendar_Id,
                                               z.Take_Holidays,
                                               z.Take_Nonworking,
                                               z.Take_Additional_Rest_Days);
  
    if r_Registry.Begin_Late_Time <> 0 or r_Registry.End_Early_Time <> 0 then
      v_Additional_Time_Type := Htt_Pref.c_Additional_Time_Type_Extra;
    end if;
  
    if r_Registry.Allowed_Late_Time <> 0 or r_Registry.Allowed_Early_Time <> 0 or
       v_Additional_Time_Type = Htt_Pref.c_Additional_Time_Type_Extra then
      v_Advanced_Setting := 'Y';
    end if;
  
    Result.Put('additional_time_type', v_Additional_Time_Type);
    Result.Put('advanced_setting', v_Advanced_Setting);
  
    select Array_Varchar2(q.Unit_Id,
                           q.Staff_Id,
                           case
                             when q.Staff_Id is not null then
                              (select (select Np.Name
                                         from Mr_Natural_Persons Np
                                        where Np.Company_Id = Hs.Company_Id
                                          and Np.Person_Id = Hs.Employee_Id)
                                 from Href_Staffs Hs
                                where Hs.Company_Id = q.Company_Id
                                  and Hs.Filial_Id = q.Filial_Id
                                  and Hs.Staff_Id = q.Staff_Id)
                             when q.Robot_Id is not null then
                              (select Listagg((select Np.Name
                                                from Mr_Natural_Persons Np
                                               where Np.Company_Id = Rp.Company_Id
                                                 and Np.Person_Id = Rp.Person_Id),
                                              ', ')
                                 from Mrf_Robot_Persons Rp
                                where Rp.Company_Id = q.Company_Id
                                  and Rp.Filial_Id = q.Filial_Id
                                  and Rp.Robot_Id = q.Robot_Id)
                           end,
                           q.Robot_Id,
                           case
                             when q.Staff_Id is not null then
                              (select (select r.Name
                                         from Mrf_Robots r
                                        where r.Company_Id = Hs.Company_Id
                                          and r.Filial_Id = Hs.Filial_Id
                                          and r.Robot_Id = Hs.Robot_Id)
                                 from Href_Staffs Hs
                                where Hs.Company_Id = q.Company_Id
                                  and Hs.Filial_Id = q.Filial_Id
                                  and Hs.Staff_Id = q.Staff_Id)
                             when q.Robot_Id is not null then
                              (select Mr.Name
                                 from Mrf_Robots Mr
                                where Mr.Company_Id = q.Company_Id
                                  and Mr.Filial_Id = q.Filial_Id
                                  and Mr.Robot_Id = q.Robot_Id)
                           end,
                           q.Monthly_Days,
                           q.Monthly_Minutes),
           q.Unit_Id
      bulk collect
      into v_Matrix, v_Unit_Ids
      from Htt_Registry_Units q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Registry_Id = v_Registry_Id
     order by q.Unit_Id;
  
    Result.Put('units', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(Sd.Unit_Id,
                          Sd.Schedule_Date,
                          Sd.Day_Kind,
                          Sd.Break_Enabled,
                          Sd.Full_Time,
                          Sd.Plan_Time,
                          Sd.Shift_Begin_Time,
                          Sd.Shift_End_Time,
                          Sd.Input_Border,
                          Sd.Output_Border,
                          to_char(Sd.Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(Sd.End_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(Sd.Break_Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(Sd.Break_End_Time, Href_Pref.c_Time_Format_Minute))
      bulk collect
      into v_Matrix
      from Htt_Unit_Schedule_Days Sd
     where Sd.Company_Id = Ui.Company_Id
       and Sd.Filial_Id = Ui.Filial_Id
       and Sd.Unit_Id member of v_Unit_Ids
     order by Sd.Schedule_Date;
  
    Result.Put('days', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(Dm.Unit_Id, Dm.Schedule_Date, Dm.Begin_Time, Dm.End_Time)
      bulk collect
      into v_Matrix
      from Htt_Unit_Schedule_Day_Marks Dm
     where Dm.Company_Id = Ui.Company_Id
       and Dm.Filial_Id = Ui.Filial_Id
       and Dm.Unit_Id member of v_Unit_Ids
     order by Dm.Begin_Time;
  
    Result.Put('marks', Fazo.Zip_Matrix(v_Matrix));
  
    if v_Matrix.Count > 0 then
      v_Marks_Used := 'Y';
    end if;
  
    Result.Put('month', to_char(r_Registry.Month, Href_Pref.c_Date_Format_Month));
    Result.Put('use_calendar', case when r_Registry.Calendar_Id is null then 'N' else 'Y' end);
    Result.Put('calendar_name',
               z_Htt_Calendars.Take(i_Company_Id => r_Registry.Company_Id, i_Filial_Id => r_Registry.Filial_Id, i_Calendar_Id => r_Registry.Calendar_Id).Name);
    Result.Put('advanced_settings', Advanced_Settings(r_Registry, i_Marks_Used => v_Marks_Used));
    Result.Put('use_marks', v_Marks_Used);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Edit_Model(p Hashmap) return Hashmap is
  begin
    return Edit_Model(p => p, i_Form => Htt_Pref.c_Staff_Schedule_Registry_List_Form);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Edit_Model(p Hashmap) return Hashmap is
  begin
    return Edit_Model(p => p, i_Form => Htt_Pref.c_Robot_Schedule_Registry_List_Form);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Fill_Marks
  (
    o_Unit  in out nocopy Htt_Pref.Registry_Unit_Rt,
    i_Marks Arraylist,
    i_Days  Arraylist
  ) is
    v_Day_Marks    Htt_Pref.Schedule_Day_Marks_Rt;
    v_Day          Hashmap;
    v_Schedule_Day Hashmap;
    v_Mark         Hashmap;
    v_Marks        Arraylist;
  begin
    for i in 1 .. i_Marks.Count
    loop
      v_Day          := Treat(i_Marks.r_Hashmap(i) as Hashmap);
      v_Schedule_Day := Treat(i_Days.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Schedule_Day_Marks_New(o_Schedule_Day_Marks => v_Day_Marks,
                                      i_Schedule_Date      => v_Day.r_Date('schedule_date'),
                                      i_Begin_Date         => v_Schedule_Day.o_Number('begin_time'),
                                      i_End_Date           => v_Schedule_Day.o_Number('end_time'));
    
      v_Marks := v_Day.r_Arraylist('marks');
    
      for j in 1 .. v_Marks.Count
      loop
        v_Mark := Treat(v_Marks.r_Hashmap(j) as Hashmap);
      
        Htt_Util.Schedule_Marks_Add(o_Marks      => v_Day_Marks.Marks,
                                    i_Begin_Time => v_Mark.r_Number('begin_time'),
                                    i_End_Time   => v_Mark.r_Number('end_time'));
      end loop;
    
      o_Unit.Unit_Marks.Extend();
      o_Unit.Unit_Marks(o_Unit.Unit_Marks.Count) := v_Day_Marks;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Fill_Days
  (
    o_Unit in out nocopy Htt_Pref.Registry_Unit_Rt,
    i_Days Arraylist
  ) is
    v_Day  Htt_Pref.Schedule_Day_Rt;
    v_Item Hashmap;
  begin
    for i in 1 .. i_Days.Count
    loop
      v_Item := Treat(i_Days.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Schedule_Day_New(o_Day              => v_Day,
                                i_Schedule_Date    => v_Item.r_Date('schedule_date'),
                                i_Day_Kind         => v_Item.r_Varchar2('day_kind'),
                                i_Begin_Time       => v_Item.o_Number('begin_time'),
                                i_End_Time         => v_Item.o_Number('end_time'),
                                i_Break_Enabled    => v_Item.o_Varchar2('break_enabled'),
                                i_Break_Begin_Time => v_Item.o_Number('break_begin_time'),
                                i_Break_End_Time   => v_Item.o_Number('break_end_time'),
                                i_Plan_Time        => v_Item.o_Number('plan_time'));
    
      o_Unit.Unit_Days.Extend();
      o_Unit.Unit_Days(o_Unit.Unit_Days.Count) := v_Day;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Fill_Units
  (
    o_Registry in out nocopy Htt_Pref.Schedule_Registry_Rt,
    i_Units    Arraylist
  ) is
    v_Unit Htt_Pref.Registry_Unit_Rt;
    v_Item Hashmap;
  begin
    for i in 1 .. i_Units.Count
    loop
      v_Item := Treat(i_Units.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Registry_Unit_New(o_Registry_Unit   => v_Unit,
                                 i_Unit_Id         => Coalesce(v_Item.o_Number('unit_id'),
                                                               Htt_Next.Unit_Id),
                                 i_Staff_Id        => v_Item.o_Number('staff_id'),
                                 i_Robot_Id        => v_Item.o_Number('robot_id'),
                                 i_Monthly_Minutes => v_Item.r_Number('monthly_minutes'),
                                 i_Monthly_Days    => v_Item.r_Number('monthly_days'));
    
      Fill_Days(v_Unit, v_Item.r_Arraylist('days'));
      Fill_Marks(v_Unit, v_Item.o_Arraylist('marks'), v_Item.r_Arraylist('days'));
    
      o_Registry.Units.Extend();
      o_Registry.Units(o_Registry.Units.Count) := v_Unit;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_By_Calendar_Limit(p Hashmap) return Hashmap is
    v_Company_Id                 number := Ui.Company_Id;
    v_Filial_Id                  number := Ui.Filial_Id;
    v_Plan_Time_Limit            number;
    v_Plan_Time                  number;
    v_Monthly_Days               number;
    v_Monthly_Limit              number;
    v_Tomorrow_Day_Kind          varchar2(1);
    v_Tomorrow_Calendar_Day_Kind varchar2(1);
    v_Date                       date;
    v_Month_Begin                date := p.r_Date('month');
    v_Month_End                  date := Last_Day(v_Month_Begin);
    v_Calendar_Id                number := p.o_Number('calendar_id');
    v_Units                      Arraylist := p.r_Arraylist('units');
    v_Unit                       Hashmap;
    v_Days                       Arraylist;
    v_Day                        Hashmap;
    r_Calendar                   Htt_Calendars%rowtype;
    r_Week_Day                   Htt_Calendar_Week_Days%rowtype;
    v_Exceeded_Months            Matrix_Varchar2 := Matrix_Varchar2();
    v_Exceeded_Days              Matrix_Varchar2 := Matrix_Varchar2();
    result                       Hashmap := Hashmap();
  begin
    r_Calendar := z_Htt_Calendars.Take(i_Company_Id  => v_Company_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Calendar_Id => v_Calendar_Id);
  
    v_Monthly_Limit := v_Month_End - v_Month_Begin + 1 -
                       Htt_Util.Official_Rest_Days_Count(i_Company_Id  => v_Company_Id,
                                                         i_Filial_Id   => v_Filial_Id,
                                                         i_Calendar_Id => v_Calendar_Id,
                                                         i_Begin_Date  => v_Month_Begin,
                                                         i_End_Date    => v_Month_End);
  
    for i in 1 .. v_Units.Count
    loop
      v_Unit         := Treat(v_Units.r_Hashmap(i) as Hashmap);
      v_Days         := v_Unit.r_Arraylist('days');
      v_Monthly_Days := v_Unit.r_Number('monthly_days');
    
      for j in 1 .. v_Days.Count
      loop
        v_Day                        := Treat(v_Days.r_Hashmap(j) as Hashmap);
        v_Plan_Time                  := v_Day.r_Number('plan_time');
        v_Date                       := v_Day.r_Date('schedule_date');
        v_Tomorrow_Day_Kind          := v_Day.o_Varchar2('tomorrow_day_kind');
        v_Tomorrow_Calendar_Day_Kind := v_Day.o_Varchar2('tomorrow_calendar_day_kind');
      
        if Nvl(v_Day.o_Varchar2('calendar_day_kind'), v_Day.r_Varchar2('day_kind')) in
           (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) and
           r_Calendar.Daily_Limit = 'Y' then
          r_Week_Day := z_Htt_Calendar_Week_Days.Take(i_Company_Id  => r_Calendar.Company_Id,
                                                      i_Filial_Id   => r_Calendar.Filial_Id,
                                                      i_Calendar_Id => r_Calendar.Calendar_Id,
                                                      i_Order_No    => Htt_Util.Iso_Week_Day_No(v_Date));
        
          v_Plan_Time_Limit := r_Week_Day.Plan_Time;
        
          if Htt_Pref.c_Day_Kind_Holiday in (v_Tomorrow_Day_Kind, v_Tomorrow_Calendar_Day_Kind) then
            v_Plan_Time_Limit := Greatest(0, v_Plan_Time_Limit - r_Week_Day.Preholiday_Time);
          end if;
        
          if Htt_Pref.c_Day_Kind_Rest in (v_Tomorrow_Day_Kind, v_Tomorrow_Calendar_Day_Kind) or --
             Htt_Pref.c_Day_Kind_Additional_Rest in
             (v_Tomorrow_Day_Kind, v_Tomorrow_Calendar_Day_Kind) then
            v_Plan_Time_Limit := Greatest(0, v_Plan_Time_Limit - r_Week_Day.Preweekend_Time);
          end if;
        
          if v_Plan_Time > v_Plan_Time_Limit then
            Fazo.Push(v_Exceeded_Days,
                      Array_Varchar2(Nvl(v_Unit.o_Varchar2('staff_name'),
                                         v_Unit.o_Varchar2('robot_name')),
                                     v_Date,
                                     v_Plan_Time,
                                     v_Plan_Time_Limit));
          end if;
        end if;
      end loop;
    
      if r_Calendar.Monthly_Limit = 'Y' and v_Monthly_Limit <> v_Monthly_Days then
        Fazo.Push(v_Exceeded_Months,
                  Array_Varchar2(Nvl(v_Unit.o_Varchar2('staff_name'),
                                     v_Unit.o_Varchar2('robot_name')),
                                 v_Monthly_Days,
                                 v_Monthly_Limit));
      end if;
    end loop;
  
    Result.Put('exceeded_days', Fazo.Zip_Matrix(v_Exceeded_Days));
    Result.Put('exceeded_months', Fazo.Zip_Matrix(v_Exceeded_Months));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p             Hashmap,
    i_Registry_Id number
  ) return Hashmap is
    v_Schedule_Kind varchar2(1) := p.r_Varchar2('schedule_kind');
    v_Registry      Htt_Pref.Schedule_Registry_Rt;
  begin
    Uit_Htt.Assert_Access_Registry_Kind(p.r_Varchar2('registry_kind'));
  
    Htt_Util.Schedule_Registry_New(o_Schedule_Registry         => v_Registry,
                                   i_Company_Id                => Ui.Company_Id,
                                   i_Filial_Id                 => Ui.Filial_Id,
                                   i_Registry_Id               => i_Registry_Id,
                                   i_Registry_Date             => p.r_Date('registry_date'),
                                   i_Registry_Number           => p.o_Varchar2('registry_number'),
                                   i_Registry_Kind             => p.r_Varchar2('registry_kind'),
                                   i_Schedule_Kind             => v_Schedule_Kind,
                                   i_Month                     => p.r_Date('month'),
                                   i_Division_Id               => p.o_Number('division_id'),
                                   i_Note                      => p.o_Varchar2('note'),
                                   i_Shift                     => p.r_Number('shift'),
                                   i_Input_Acceptance          => p.r_Number('input_acceptance'),
                                   i_Output_Acceptance         => p.r_Number('output_acceptance'),
                                   i_Track_Duration            => p.r_Number('track_duration'),
                                   i_Count_Late                => p.r_Varchar2('count_late'),
                                   i_Count_Early               => p.r_Varchar2('count_early'),
                                   i_Count_Lack                => p.r_Varchar2('count_lack'),
                                   i_Count_Free                => p.r_Varchar2('count_free'),
                                   i_Gps_Turnout_Enabled       => Nvl(p.o_Varchar2('gps_turnout_enabled'),
                                                                      'N'),
                                   i_Gps_Use_Location          => Nvl(p.o_Varchar2('gps_use_location'),
                                                                      'N'),
                                   i_Gps_Max_Interval          => p.o_Number('gps_max_interval'),
                                   i_Allowed_Late_Time         => Nvl(p.o_Number('allowed_late_time'),
                                                                      0),
                                   i_Allowed_Early_Time        => Nvl(p.o_Number('allowed_early_time'),
                                                                      0),
                                   i_Begin_Late_Time           => Nvl(p.o_Number('begin_late_time'),
                                                                      0),
                                   i_End_Early_Time            => Nvl(p.o_Number('end_early_time'),
                                                                      0),
                                   i_Calendar_Id               => p.o_Number('calendar_id'),
                                   i_Take_Holidays             => p.r_Varchar2('take_holidays'),
                                   i_Take_Nonworking           => p.r_Varchar2('take_nonworking'),
                                   i_Take_Additional_Rest_Days => p.r_Varchar2('take_additional_rest_days'));
  
    Fill_Units(v_Registry, p.r_Arraylist('units'));
  
    Htt_Api.Schedule_Registry_Save(v_Registry);
  
    if p.r_Varchar2('posted') = 'Y' then
      Htt_Api.Schedule_Registry_Post(i_Registry_Id => i_Registry_Id,
                                     i_Company_Id  => Ui.Company_Id,
                                     i_Filial_Id   => Ui.Filial_Id);
    end if;
  
    return Fazo.Zip_Map('registry_id', i_Registry_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Htt_Next.Registry_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Registry Htt_Schedule_Registries%rowtype;
  begin
    r_Registry := z_Htt_Schedule_Registries.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                                      i_Filial_Id   => Ui.Filial_Id,
                                                      i_Registry_Id => p.r_Number('registry_id'));
  
    if r_Registry.Posted = 'Y' then
      Htt_Api.Schedule_Registry_Unpost(i_Registry_Id => r_Registry.Registry_Id,
                                       i_Company_Id  => r_Registry.Company_Id,
                                       i_Filial_Id   => r_Registry.Filial_Id,
                                       i_Repost      => true);
    end if;
  
    return save(p, r_Registry.Registry_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Calendars
       set Company_Id  = null,
           Filial_Id   = null,
           Calendar_Id = null,
           name        = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Division_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Hpd_Agreements
       set Company_Id = null,
           Filial_Id  = null,
           Staff_Id   = null,
           Trans_Type = null,
           Period     = null,
           Trans_Id   = null;
    update Hpd_Trans_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Trans_Id    = null,
           Schedule_Id = null;
    update Htt_Schedule_Registries
       set Company_Id  = null,
           Filial_Id   = null,
           Registry_Id = null,
           month       = null,
           Posted      = null;
    update Htt_Registry_Units
       set Company_Id  = null,
           Filial_Id   = null,
           Unit_Id     = null,
           Registry_Id = null,
           Staff_Id    = null,
           Robot_Id    = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Division_Id = null,
           name        = null,
           State       = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Schedule_Id = null;
  end;

end Ui_Vhr446;
/
