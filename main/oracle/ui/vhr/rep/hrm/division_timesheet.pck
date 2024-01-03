create or replace package Ui_Vhr459 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr459;
/
create or replace package body Ui_Vhr459 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr459:settings';

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
    return b.Translate('UI-VHR459:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Procedure Save_Preferences(p Hashmap) is
  begin
    Ui.User_Setting_Save(i_Setting_Code => g_Setting_Code, i_Setting_Value => p.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Preferences return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => g_Setting_Code,
                                               i_Default_Value => '{}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Division_Ids         Array_Number;
    v_Accessable_Div_Ids   Array_Number;
    v_Matrix               Matrix_Varchar2;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    result                 Hashmap := Hashmap();
  begin
    if v_Access_All_Employees = 'N' then
      v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                           i_Indirect         => true,
                                                           i_Manual           => true,
                                                           i_Only_Departments => 'Y');
    end if;
  
    select q.Division_Id
      bulk collect
      into v_Accessable_Div_Ids
      from Mhr_Divisions q
      join Hrm_Divisions Dv
        on Dv.Company_Id = q.Company_Id
       and Dv.Filial_Id = q.Filial_Id
       and Dv.Division_Id = q.Division_Id
       and Dv.Is_Department = 'Y'
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and (v_Access_All_Employees = 'Y' or --
           q.Division_Id in (select Column_Value
                                from table(v_Division_Ids)))
       and exists (select 1
              from Hrm_Division_Schedules Ds
             where Ds.Company_Id = q.Company_Id
               and Ds.Filial_Id = q.Filial_Id
               and Ds.Division_Id = q.Division_Id);
  
    select distinct q.Parent_Id
      bulk collect
      into v_Division_Ids
      from Mhr_Parent_Divisions q
      join Hrm_Divisions Dv
        on Dv.Company_Id = q.Company_Id
       and Dv.Filial_Id = q.Filial_Id
       and Dv.Division_Id = q.Parent_Id
       and Dv.Is_Department = 'Y'
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Division_Id in (select *
                               from table(v_Accessable_Div_Ids));
  
    v_Division_Ids := v_Division_Ids multiset union v_Accessable_Div_Ids;
  
    select Array_Varchar2(q.Division_Id,
                           q.Name,
                           q.Parent_Id,
                           case
                             when q.Division_Id in (select *
                                                      from table(v_Accessable_Div_Ids)) then
                              'Y'
                             else
                              'N'
                           end)
      bulk collect
      into v_Matrix
      from Mhr_Divisions q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Division_Id in (select Column_Value
                               from table(v_Division_Ids))
     order by Lower(q.Name);
  
    Result.Put('divisions', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('settings', Load_Preferences);
    Result.Put('begin_date', Trunc(sysdate, 'mon'));
    Result.Put('end_date', Trunc(sysdate));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Division
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_End_Date      date,
    i_Begin_Date    date,
    i_Division_Id   number,
    i_Division_Name Mhr_Divisions.Name%type
  ) is
    a b_Table := b_Report.New_Table();
  
    v_Settings            Hashmap := Load_Preferences;
    v_Column              number := 1;
    v_Style_Name          varchar2(50) := 'yellow';
    v_Total               number := 0;
    v_Lack_Time           number;
    v_Total_Time          number;
    v_Cache               Array_Number;
    v_Marge_Datetime      date;
    v_Parts_Count         number;
    v_Time_Parts          Htt_Pref.Time_Part_Nt;
    v_Date                date;
    v_Employee_Id         number;
    v_Manager_Name        varchar2(752);
    v_Division_Group_Id   number;
    v_Division_Group_Name varchar2(200);
    v_Day_Kind            varchar2(1);
    v_Curr_Date           date := Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                            i_Filial_Id  => i_Filial_Id);
    v_Schedule_Id         number := z_Hrm_Division_Schedules.Take(i_Company_Id => i_Company_Id, --
                                    i_Filial_Id => i_Filial_Id, --
                                    i_Division_Id => i_Division_Id).Schedule_Id;
  
    v_Show_Manager        boolean := Nvl(v_Settings.o_Varchar2('manager'), 'N') = 'Y';
    v_Show_Minutes        boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words  boolean := v_Show_Minutes and
                                     Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Show_Division_Group boolean := Nvl(v_Settings.o_Varchar2('division_group'), 'N') = 'Y';
    v_Nls_Language        varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(i_Column_Index => v_Column, i_Width => i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Put_Time
    (
      i_Minutes    number,
      i_Style_Name varchar2,
      i_Rowspan    number := null
    ) is
    begin
      if v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Text(i_Minutes, v_Show_Minutes, v_Show_Minutes_Words),
               i_Style_Name,
               i_Rowspan => i_Rowspan);
      else
        a.Data(Nullif(Round(i_Minutes / 60, 2), 0), i_Style_Name, i_Rowspan => i_Rowspan);
      end if;
    end;
  begin
    Uit_Href.Assert_Access_To_Division(i_Division_Id => i_Division_Id);
  
    a.Current_Style('root bold');
    a.New_Row;
  
    --info
    a.New_Row;
    a.Data(t('date range: $1 - $2',
             to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
             to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => 8);
  
    a.New_Row;
    a.Data(t('division name: $1', i_Division_Name), i_Colspan => 5);
  
    if v_Show_Manager then
      v_Employee_Id := z_Hrm_Division_Managers.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Division_Id => i_Division_Id).Employee_Id;
    
      if v_Employee_Id is not null then
        v_Manager_Name := z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id, i_Person_Id => v_Employee_Id).Name;
      
        a.New_Row;
        a.Data(t('manager name: $1', v_Manager_Name), i_Colspan => 5);
      end if;
    end if;
  
    if v_Show_Division_Group then
      v_Division_Group_Id := z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Division_Id => i_Division_Id).Division_Group_Id;
    
      if v_Division_Group_Id is not null then
        v_Division_Group_Name := z_Mhr_Division_Groups.Load(i_Company_Id => i_Company_Id, i_Division_Group_Id => v_Division_Group_Id).Name;
      
        a.New_Row;
        a.Data(t('division group name: $1', v_Division_Group_Name), i_Colspan => 5);
      end if;
    end if;
  
    -- header
    a.Current_Style('header');
    a.New_Row;
    a.New_Row;
  
    Print_Header(t('date'), 1, 1, 200);
    Print_Header(t('lack time periods'), 1, 1, 100);
    Print_Header(t('lack time values'), 1, 1, 75);
    Print_Header(t('total lack time'), 1, 1, 75);
  
    -- body
    a.Current_Style('body_centralized');
  
    for i in 0 ..(i_End_Date - i_Begin_Date)
    loop
      v_Marge_Datetime := null;
      v_Date           := i_Begin_Date + i;
    
      if v_Date = Trunc(v_Curr_Date) then
        v_Marge_Datetime := v_Curr_Date;
      end if;
    
      v_Time_Parts  := Uit_Htt.Division_Ommited_Times(i_Company_Id     => i_Company_Id,
                                                      i_Filial_Id      => i_Filial_Id,
                                                      i_Division_Id    => i_Division_Id,
                                                      i_Period         => v_Date,
                                                      i_Merge_Datetime => v_Marge_Datetime);
      v_Parts_Count := v_Time_Parts.Count;
    
      if v_Parts_Count = 0 then
        v_Day_Kind := z_Htt_Schedule_Days.Take(i_Company_Id => i_Company_Id, --
                      i_Filial_Id => i_Filial_Id, --
                      i_Schedule_Id => v_Schedule_Id, --
                      i_Schedule_Date => v_Date).Day_Kind;
      
        if v_Day_Kind is null then
          continue;
        end if;
      
        a.New_Row;
        a.Data(to_char(v_Date, Href_Pref.c_Date_Format_Day));
      
        if v_Day_Kind = Htt_Pref.c_Day_Kind_Work then
          a.Data(t('lack period not found'), 'not_found', i_Colspan => 3);
        else
          a.Data(t('rest day'), 'rest', i_Colspan => 3);
        end if;
      
        continue;
      else
        a.New_Row;
        a.Data(to_char(v_Date, Href_Pref.c_Date_Format_Day), i_Rowspan => v_Parts_Count);
      end if;
    
      if v_Style_Name is null then
        v_Style_Name := 'yellow';
      else
        v_Style_Name := null;
      end if;
    
      v_Total_Time := 0;
      v_Cache      := Array_Number();
      v_Cache.Extend(v_Parts_Count);
    
      for i in 1 .. v_Parts_Count
      loop
        v_Lack_Time := Round((Trunc(v_Time_Parts(i).Output_Time, 'mi') -
                             Trunc(v_Time_Parts(i).Input_Time, 'mi')) * 1440,
                             2);
      
        v_Cache(i) := v_Lack_Time;
        v_Total_Time := v_Total_Time + v_Lack_Time;
      end loop;
    
      for i in 1 .. v_Parts_Count
      loop
        a.Data(to_char(v_Time_Parts(i).Input_Time, 'hh24:mi') || ' - ' ||
               to_char(v_Time_Parts(i).Output_Time, 'hh24:mi'),
               v_Style_Name);
      
        Put_Time(v_Cache(i), v_Style_Name);
      
        if i = 1 then
          Put_Time(v_Total_Time, v_Style_Name, v_Parts_Count);
        end if;
      
        if i != v_Parts_Count then
          a.New_Row;
        end if;
      end loop;
    
      v_Total := v_Total + v_Total_Time;
    end loop;
  
    a.Current_Style('footer');
  
    a.New_Row;
    a.Data(t('total'), 'footer center', v_Column - 2);
    a.Data(Htt_Util.To_Time_Text(v_Total, v_Show_Minutes, v_Show_Minutes_Words));
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number
  ) is
    a b_Table := b_Report.New_Table();
  
    v_Settings             Hashmap := Load_Preferences;
    v_Column               number := 1;
    v_Style_Name           varchar2(50) := 'yellow';
    v_Total                number := 0;
    v_Day_Count            number := i_End_Date - i_Begin_Date + 1;
    v_Division_Cnt         number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    v_Lack_Time            number;
    v_Total_Range          number;
    v_Total_Time           number;
    v_Marge_Datetime       date;
    v_Row_Exists           boolean;
    v_Date                 date;
    v_Time_Parts           Htt_Pref.Time_Part_Nt;
    v_Total_Days           Fazo.Number_Id_Aat;
    v_Curr_Date            date := Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                             i_Filial_Id  => i_Filial_Id);
  
    v_Show_Manager        boolean := Nvl(v_Settings.o_Varchar2('manager'), 'N') = 'Y';
    v_Show_Minutes        boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words  boolean := v_Show_Minutes and
                                     Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Show_Division_Group boolean := Nvl(v_Settings.o_Varchar2('division_group'), 'N') = 'Y';
    v_Division_Group_Id   number := v_Settings.o_Number('division_group_id');
    v_Nls_Language        varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(i_Column_Index => v_Column, i_Width => i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Put_Time
    (
      i_Minutes    number,
      i_Style_Name varchar2,
      i_Rowspan    number := null
    ) is
    begin
      if v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Text(i_Minutes, v_Show_Minutes, v_Show_Minutes_Words),
               i_Style_Name,
               i_Rowspan => i_Rowspan);
      else
        a.Data(Nullif(Round(i_Minutes / 60, 2), 0), i_Style_Name, i_Rowspan => i_Rowspan);
      end if;
    end;
  begin
    Uit_Htt.Enable_Division_Cache(i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Period_Begin => i_Begin_Date,
                                  i_Period_End   => i_End_Date);
  
    for i in 0 .. i_End_Date - i_Begin_Date
    loop
      v_Total_Days(i) := 0;
    end loop;
  
    a.Current_Style('root bold');
    a.New_Row;
  
    --info
    a.New_Row;
    a.Data(t('date range: $1 - $2',
             to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
             to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => 8);
  
    -- header
    a.Current_Style('header');
    a.New_Row;
    a.New_Row;
  
    Print_Header(t('division name'), 1, 2, 200);
  
    if v_Show_Division_Group then
      Print_Header(t('division group'), 1, 2, 200);
    end if;
  
    if v_Show_Manager then
      Print_Header(t('manager name'), 1, 2, 200);
    end if;
  
    Print_Header(t('schedule'), 1, 2, 200);
  
    for i in 0 ..(i_End_Date - i_Begin_Date)
    loop
      Print_Header(to_char(i_Begin_Date + i, 'DD'), 1, 1, 75);
    end loop;
  
    Print_Header(t('total lack time'), 1, 2, 75);
  
    a.New_Row;
    for i in 0 ..(i_End_Date - i_Begin_Date)
    loop
      Print_Header(to_char(i_Begin_Date + i, 'Dy', v_Nls_Language), 1, 1, 75);
    end loop;
  
    -- body
    a.Current_Style('body_centralized');
  
    if v_Access_All_Employees = 'N' then
      v_Filter_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct           => true,
                                                                  i_Indirect         => true,
                                                                  i_Manual           => true,
                                                                  i_Only_Departments => 'Y');
    
      if i_Division_Ids.Count > 0 then
        v_Filter_Division_Ids := v_Filter_Division_Ids multiset intersect i_Division_Ids;
      end if;
    end if;
  
    v_Division_Cnt := v_Filter_Division_Ids.Count;
  
    for Div in (select Rownum,
                       q.Division_Id,
                       q.Name,
                       (select Dg.Name
                          from Mhr_Division_Groups Dg
                         where Dg.Company_Id = q.Company_Id
                           and Dg.Division_Group_Id = q.Division_Group_Id) as Division_Group_Name,
                       (select Np.Name
                          from Mr_Natural_Persons Np
                         where Np.Company_Id = Dm.Company_Id
                           and Np.Person_Id = Dm.Employee_Id) as Manager_Name,
                       (select Sch.Name
                          from Htt_Schedules Sch
                         where Sch.Company_Id = Ds.Company_Id
                           and Sch.Filial_Id = Ds.Filial_Id
                           and Sch.Schedule_Id = Ds.Schedule_Id) as Schedule_Name
                  from Mhr_Divisions q
                  join Hrm_Divisions Dv
                    on Dv.Company_Id = q.Company_Id
                   and Dv.Filial_Id = q.Filial_Id
                   and Dv.Division_Id = q.Division_Id
                   and Dv.Is_Department = 'Y'
                  join Hrm_Division_Schedules Ds
                    on Ds.Company_Id = q.Company_Id
                   and Ds.Filial_Id = q.Filial_Id
                   and Ds.Division_Id = q.Division_Id
                  left join Hrm_Division_Managers Dm
                    on Dm.Company_Id = q.Company_Id
                   and Dm.Filial_Id = q.Filial_Id
                   and Dm.Division_Id = q.Division_Id
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and q.State = 'A'
                   and (v_Access_All_Employees = 'Y' and v_Division_Cnt = 0 or --
                       q.Division_Id member of v_Filter_Division_Ids))
    loop
      v_Row_Exists  := false;
      v_Total_Range := 0;
    
      for i in 0 ..(i_End_Date - i_Begin_Date)
      loop
        v_Date           := i_Begin_Date + i;
        v_Marge_Datetime := null;
      
        if v_Date = Trunc(v_Curr_Date) then
          v_Marge_Datetime := v_Curr_Date;
        end if;
      
        v_Time_Parts := Uit_Htt.Division_Ommited_Times(i_Company_Id     => i_Company_Id,
                                                       i_Filial_Id      => i_Filial_Id,
                                                       i_Division_Id    => Div.Division_Id,
                                                       i_Period         => v_Date,
                                                       i_Merge_Datetime => v_Marge_Datetime);
      
        if v_Time_Parts.Count > 0 then
          v_Row_Exists := true;
          exit;
        end if;
      end loop;
    
      if not v_Row_Exists then
        continue;
      end if;
    
      if v_Style_Name is null then
        v_Style_Name := 'yellow';
      else
        v_Style_Name := null;
      end if;
    
      a.New_Row;
      a.Data(Div.Name,
             v_Style_Name,
             i_Param => Fazo.Zip_Map('division_id', Div.Division_Id).Json());
    
      if v_Show_Division_Group then
        a.Data(Div.Division_Group_Name, v_Style_Name);
      end if;
    
      if v_Show_Manager then
        a.Data(Uit_Hrm.Get_Manager_Name(i_Company_Id        => i_Company_Id,
                                        i_Filial_Id         => i_Filial_Id,
                                        i_Division_Id       => Div.Division_Id,
                                        i_Division_Group_Id => v_Division_Group_Id),
               v_Style_Name);
      end if;
    
      a.Data(Div.Schedule_Name, v_Style_Name);
    
      for i in 0 ..(i_End_Date - i_Begin_Date)
      loop
        v_Date           := i_Begin_Date + i;
        v_Marge_Datetime := null;
      
        if v_Date = Trunc(v_Curr_Date) then
          v_Marge_Datetime := v_Curr_Date;
        end if;
      
        v_Time_Parts := Uit_Htt.Division_Ommited_Times(i_Company_Id     => i_Company_Id,
                                                       i_Filial_Id      => i_Filial_Id,
                                                       i_Division_Id    => Div.Division_Id,
                                                       i_Period         => v_Date,
                                                       i_Merge_Datetime => v_Marge_Datetime);
        v_Total_Time := 0;
      
        for j in 1 .. v_Time_Parts.Count
        loop
          v_Lack_Time := Round((Trunc(v_Time_Parts(j).Output_Time, 'mi') -
                               Trunc(v_Time_Parts(j).Input_Time, 'mi')) * 1440,
                               2);
        
          v_Total_Time := v_Total_Time + v_Lack_Time;
        end loop;
      
        v_Total_Days(i) := v_Total_Days(i) + v_Total_Time;
        v_Total_Range := v_Total_Range + v_Total_Time;
      
        Put_Time(v_Total_Time, v_Style_Name);
      end loop;
    
      v_Total := v_Total + v_Total_Range;
    
      a.Data(Htt_Util.To_Time_Text(v_Total_Range, v_Show_Minutes, v_Show_Minutes_Words));
    end loop;
  
    a.Current_Style('footer');
  
    a.New_Row;
    a.Data(t('total'), 'footer center', v_Column - 2 * v_Day_Count - 2);
  
    for i in 0 ..(i_End_Date - i_Begin_Date)
    loop
      a.Data(Htt_Util.To_Time_Text(v_Total_Days(i), v_Show_Minutes, v_Show_Minutes_Words));
    end loop;
  
    a.Data(Htt_Util.To_Time_Text(v_Total, v_Show_Minutes, v_Show_Minutes_Words));
  
    b_Report.Add_Sheet(i_Name  => Ui.Current_Form_Name,
                       p_Table => a,
                       i_Param => Fazo.Zip_Map('begin_date', i_Begin_Date,'end_date', i_End_Date).Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Division_Ids  Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Division_Name Mhr_Divisions.Name%type;
    v_File_Name     varchar2(1000);
    v_Param         Hashmap;
  begin
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.r_Varchar2('cell_param'));
    
      if v_Param.Has('division_id') then
        v_Param := Fazo.Zip_Map('division_ids', v_Param.r_Number('division_id'));
      
        v_Param.Put_All(Fazo.Parse_Map(p.r_Varchar2('table_param')));
        b_Report.Redirect_To_Report('/vhr/rep/hrm/division_timesheet:run', v_Param);
      end if;
    else
      v_File_Name := Ui.Current_Form_Name;
    
      if v_Division_Ids.Count = 1 then
        v_Division_Name := z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Division_Id => v_Division_Ids(1)).Name;
        v_File_Name     := v_File_Name || ' (' || v_Division_Name || ')';
      end if;
    
      b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                     i_File_Name   => v_File_Name);
    
      -- body centralized
      b_Report.New_Style(i_Style_Name        => 'body_centralized',
                         i_Parent_Style_Name => 'body',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
    
      -- yellow style
      b_Report.New_Style(i_Style_Name        => 'yellow',
                         i_Parent_Style_Name => 'header',
                         i_Background_Color  => '#fff2cc',
                         i_Font_Bold         => false);
    
      -- not found style
      b_Report.New_Style(i_Style_Name        => 'not_found',
                         i_Parent_Style_Name => 'header',
                         i_Background_Color  => '#dfd0f4',
                         i_Font_Bold         => false);
    
      -- rest
      b_Report.New_Style(i_Style_Name        => 'rest',
                         i_Parent_Style_Name => 'header',
                         i_Background_Color  => '#daeef3',
                         i_Font_Bold         => false);
    
      if v_Division_Ids.Count = 1 then
        Run_Division(i_Company_Id    => v_Company_Id,
                     i_Filial_Id     => v_Filial_Id,
                     i_Begin_Date    => p.r_Date('begin_date'),
                     i_End_Date      => p.r_Date('end_date'),
                     i_Division_Id   => v_Division_Ids(1),
                     i_Division_Name => v_Division_Name);
      else
        Run_All(i_Company_Id   => v_Company_Id,
                i_Filial_Id    => v_Filial_Id,
                i_Begin_Date   => p.r_Date('begin_date'),
                i_End_Date     => p.r_Date('end_date'),
                i_Division_Ids => v_Division_Ids);
      end if;
    
      b_Report.Close_Book();
    end if;
  end;

end Ui_Vhr459;
/
