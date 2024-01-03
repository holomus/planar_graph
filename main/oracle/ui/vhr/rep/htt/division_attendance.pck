create or replace package Ui_Vhr304 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr304;
/
create or replace package body Ui_Vhr304 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr304:settings';

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
    return b.Translate('UI-VHR304:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Function Query_Divisions return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query(Uit_Hrm.Departments_Query(i_Only_Active => true),
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('division_id', 'division_group_id');
    q.Varchar2_Field('name', 'state');
  
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
    result Hashmap := Hashmap();
  begin
  
    Result.Put('data',
               Fazo.Zip_Map('begin_date', Trunc(sysdate, 'mon'), 'end_date', Trunc(sysdate)));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sign(i_Number number) return varchar2 is
  begin
    return case when i_Number < 0 then '-' else '' end;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Division
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Begin_Date        date,
    i_End_Date          date,
    i_Division_Group_Id number,
    i_Division_Ids      Array_Number
  ) is
    v_Settings Hashmap := Load_Preferences;
  
    v_Division_Group     boolean := Nvl(v_Settings.o_Varchar2('division_group'), 'N') = 'Y';
    v_Show_Minutes       boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
  
    a              b_Table := b_Report.New_Table();
    v_Date_Colspan number := 3;
    v_Column       number := 1;
  
    v_Divisions_Count      number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
    r_Schedule_Day         Htt_Schedule_Days%rowtype;
  
    v_Plan_Hours   number;
    v_Fact_Hours   number;
    v_Plan_Sum     number;
    v_Fact_Sum     number;
    v_Diff_Hours   number;
    v_Curr_Date    date;
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header_Col
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
    Procedure Print_Header is
    begin
      a.Current_Style('header');
    
      a.New_Row;
      a.New_Row;
    
      Print_Header_Col(t('rownum'), 1, 2, 50);
      Print_Header_Col(t('division'), 1, 2, 200);
      Print_Header_Col(t('schedule'), 1, 2, 200);
    
      for i in 0 .. i_End_Date - i_Begin_Date
      loop
        Print_Header_Col(to_char(i_Begin_Date + i, Href_Pref.c_Date_Format_Day),
                         v_Date_Colspan,
                         1,
                         75);
      end loop;
    
      Print_Header_Col(t('total'), v_Date_Colspan, 1, 75);
    
      a.New_Row;
      for i in 0 .. i_End_Date - i_Begin_Date + 1
      loop
        Print_Header_Col(t('plan time'), 1, 1, 75);
        Print_Header_Col(t('fact time'), 1, 1, 75);
        Print_Header_Col(t('diff time'), 1, 1, 75);
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Info is
    begin
      a.Current_Style('root bold');
    
      a.New_Row;
      a.New_Row;
      a.Data(t('period: $1 - $2',
               to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
               to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
             i_Colspan => 5);
    
      if v_Division_Group and i_Division_Group_Id <> -1 then
        a.New_Row;
      
        a.Data(t('division group: $1',
                 z_Mhr_Division_Groups.Take(i_Company_Id => i_Company_Id, --
                 i_Division_Group_Id => i_Division_Group_Id).Name),
               i_Colspan => 5);
      end if;
    end;
  begin
    -- info
    Print_Info;
  
    --header
    Print_Header;
  
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
  
    v_Divisions_Count := v_Filter_Division_Ids.Count;
  
    for r in (select Qr.*, Rownum
                from (select q.Name Division_Name,
                             q.Division_Id,
                             Ds.Schedule_Id,
                             (select Ch.Name
                                from Htt_Schedules Ch
                               where Ch.Company_Id = Ds.Company_Id
                                 and Ch.Filial_Id = Ds.Filial_Id
                                 and Ch.Schedule_Id = Ds.Schedule_Id) Schedule_Name
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
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and (i_Division_Group_Id = -1 or q.Division_Group_Id = i_Division_Group_Id)
                         and (v_Access_All_Employees = 'Y' and v_Divisions_Count = 0 or
                             q.Division_Id in
                             (select Qr.Column_Value
                                 from table(v_Filter_Division_Ids) Qr))
                         and q.State = 'A'
                       order by q.Name) Qr)
    loop
      a.New_Row;
    
      v_Plan_Sum := 0;
      v_Fact_Sum := 0;
    
      a.Data(r.Rownum);
      a.Data(r.Division_Name);
      a.Data(r.Schedule_Name);
    
      for i in 0 .. i_End_Date - i_Begin_Date
      loop
        v_Curr_Date := i_Begin_Date + i;
      
        r_Schedule_Day := z_Htt_Schedule_Days.Take(i_Company_Id    => i_Company_Id,
                                                   i_Filial_Id     => i_Filial_Id,
                                                   i_Schedule_Id   => r.Schedule_Id,
                                                   i_Schedule_Date => v_Curr_Date);
      
        v_Plan_Hours := r_Schedule_Day.Full_Time * 60;
      
        if r_Schedule_Day.Company_Id is null then
          a.Add_Data(3);
          continue;
        end if;
      
        with Division_Employees as
         (select Ag.Staff_Id
            from Hpd_Agreements Ag
            join Hpd_Trans_Robots Tr
              on Tr.Company_Id = Ag.Company_Id
             and Tr.Filial_Id = Ag.Filial_Id
             and Tr.Trans_Id = Ag.Trans_Id
             and Tr.Division_Id = r.Division_Id
           where Ag.Company_Id = i_Company_Id
             and Ag.Filial_Id = i_Filial_Id
             and Ag.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
             and Ag.Period = (select max(w.Period)
                                from Hpd_Agreements w
                               where w.Company_Id = i_Company_Id
                                 and w.Filial_Id = i_Filial_Id
                                 and w.Staff_Id = Ag.Staff_Id
                                 and w.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                                 and w.Period <= v_Curr_Date)),
        Division_Tracks as
         (select Tt.Track_Id
            from Htt_Timesheet_Tracks Tt
           where Tt.Company_Id = i_Company_Id
             and Tt.Filial_Id = i_Filial_Id
             and Tt.Timesheet_Id in
                 (select w.Timesheet_Id
                    from Htt_Timesheets w
                   where w.Company_Id = i_Company_Id
                     and w.Filial_Id = i_Filial_Id
                     and w.Timesheet_Date = v_Curr_Date
                     and w.Staff_Id in (select q.Staff_Id
                                          from Division_Employees q))),
        Filtered_Tracks as
         (select Qr.Track_Id,
                 Qr.Track_Datetime,
                 Qr.Track_Type,
                 Lag(Qr.Track_Type) Over(order by Qr.Track_Datetime, Qr.Track_Type) Prev_Type,
                 Lead(Qr.Track_Type) Over(order by Qr.Track_Datetime, Qr.Track_Type) Next_Type
            from (select t.Track_Id,
                         Greatest(Least(t.Track_Datetime, r_Schedule_Day.Shift_End_Time),
                                  r_Schedule_Day.Shift_Begin_Time) Track_Datetime,
                         t.Track_Type,
                         Lag(t.Track_Type) Over(partition by t.Person_Id order by t.Track_Datetime, t.Track_Type) Prev_Type,
                         Lead(t.Track_Type) Over(partition by t.Person_Id order by t.Track_Datetime, t.Track_Type) Next_Type
                    from Htt_Tracks t
                   where t.Company_Id = i_Company_Id
                     and t.Filial_Id = i_Filial_Id
                     and t.Track_Type in (Htt_Pref.c_Track_Type_Input, Htt_Pref.c_Track_Type_Output)
                     and t.Track_Id in (select q.Track_Id
                                          from Division_Tracks q)) Qr
           where Qr.Track_Type = Htt_Pref.c_Track_Type_Input
             and Qr.Next_Type is not null
             and (Qr.Track_Type <> Qr.Prev_Type or Qr.Prev_Type is null)
              or Qr.Track_Type = Htt_Pref.c_Track_Type_Output
             and Qr.Prev_Type is not null
             and Qr.Track_Type <> Qr.Prev_Type)
        select sum(Greatest(Round((Least(Rs.Next_Time, r_Schedule_Day.End_Time) -
                                  Greatest(Rs.Track_Datetime, r_Schedule_Day.Begin_Time)) * 86400),
                            0))
          into v_Fact_Hours
          from (select Ft.Track_Datetime,
                       Lead(Ft.Track_Datetime) Over(order by Ft.Track_Datetime, Ft.Track_Type) Next_Time,
                       Ft.Track_Type
                  from Filtered_Tracks Ft
                 where Ft.Track_Type = Htt_Pref.c_Track_Type_Input
                   and Ft.Next_Type is not null
                   and (Ft.Track_Type <> Ft.Prev_Type or Ft.Prev_Type is null)
                    or Ft.Track_Type = Htt_Pref.c_Track_Type_Output
                   and Ft.Prev_Type is not null
                   and (Ft.Track_Type <> Ft.Next_Type or Ft.Next_Type is null)) Rs
         where Rs.Track_Type = Htt_Pref.c_Track_Type_Input;
      
        v_Fact_Hours := Nvl(v_Fact_Hours, 0);
      
        v_Diff_Hours := v_Fact_Hours - v_Plan_Hours;
      
        a.Data(Htt_Util.To_Time_Seconds_Text(v_Plan_Hours, v_Show_Minutes, v_Show_Minutes_Words));
        a.Data(Htt_Util.To_Time_Seconds_Text(v_Fact_Hours, v_Show_Minutes, v_Show_Minutes_Words));
        a.Data(Sign(v_Diff_Hours) ||
               Htt_Util.To_Time_Seconds_Text(Abs(v_Diff_Hours),
                                             v_Show_Minutes,
                                             v_Show_Minutes_Words));
      
        v_Fact_Sum := v_Fact_Sum + v_Fact_Hours;
        v_Plan_Sum := v_Plan_Sum + v_Plan_Hours;
      end loop;
    
      v_Diff_Hours := v_Fact_Sum - v_Plan_Sum;
    
      a.Data(Htt_Util.To_Time_Seconds_Text(v_Plan_Sum, v_Show_Minutes, v_Show_Minutes_Words));
      a.Data(Htt_Util.To_Time_Seconds_Text(v_Fact_Sum, v_Show_Minutes, v_Show_Minutes_Words));
      a.Data(Sign(v_Diff_Hours) ||
             Htt_Util.To_Time_Seconds_Text(Abs(v_Diff_Hours), v_Show_Minutes, v_Show_Minutes_Words));
    end loop;
  
    b_Report.Add_Sheet(i_Name => t('division_attendace'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  -- currently not used
  Procedure Run_Staff
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Begin_Date        date,
    i_End_Date          date,
    i_Division_Group_Id number,
    i_Division_Ids      Array_Number
  ) is
    v_Settings Hashmap := Load_Preferences;
  
    v_Division_Group     boolean := Nvl(v_Settings.o_Varchar2('division_group'), 'N') = 'Y';
    v_Show_Minutes       boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
  
    a              b_Table := b_Report.New_Table();
    v_Date_Colspan number := 3;
    v_Column       number := 1;
  
    v_Divisions_Count      number := i_Division_Ids.Count;
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    v_Filter_Division_Ids  Array_Number := i_Division_Ids;
  
    v_Free_Id      number;
    v_Plan_Sum     number;
    v_Fact_Sum     number;
    v_Diff_Hours   number;
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Print_Header_Col
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
    Procedure Print_Header is
    begin
      a.Current_Style('header');
    
      a.New_Row;
      a.New_Row;
    
      Print_Header_Col(t('rownum'), 1, 2, 50);
      Print_Header_Col(t('division'), 1, 2, 200);
      Print_Header_Col(t('staff name'), 1, 2, 250);
      Print_Header_Col(t('schedule'), 1, 2, 200);
    
      for i in 0 .. i_End_Date - i_Begin_Date
      loop
        Print_Header_Col(to_char(i_Begin_Date + i, Href_Pref.c_Date_Format_Day),
                         v_Date_Colspan,
                         1,
                         150);
      end loop;
    
      Print_Header_Col(t('total'), v_Date_Colspan, 1, 150);
    
      a.New_Row;
      for i in 0 .. i_End_Date - i_Begin_Date + 1
      loop
        Print_Header_Col(t('plan time'), 1, 1, 50);
        Print_Header_Col(t('fact time'), 1, 1, 50);
        Print_Header_Col(t('diff time'), 1, 1, 50);
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Info is
    begin
      a.Current_Style('root bold');
    
      a.New_Row;
      a.New_Row;
      a.Data(t('period: $1 - $2',
               to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
               to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
             i_Colspan => 5);
    
      if v_Division_Group and i_Division_Group_Id <> -1 then
        a.New_Row;
      
        a.Data(t('division group: $1',
                 z_Mhr_Division_Groups.Take(i_Company_Id => i_Company_Id, --
                 i_Division_Group_Id => i_Division_Group_Id).Name),
               i_Colspan => 5);
      end if;
    end;
  begin
    v_Free_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    -- info
    Print_Info;
  
    -- header
    Print_Header;
  
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
  
    v_Divisions_Count := v_Filter_Division_Ids.Count;
  
    for r in (select Qr.*, Rownum
                from (select q.*,
                             w.Name Staff_Name,
                             (select Dv.Name
                                from Mhr_Divisions Dv
                               where Dv.Company_Id = q.Company_Id
                                 and Dv.Filial_Id = q.Filial_Id
                                 and Dv.Division_Id = q.Division_Id) Division_Name,
                             (select Ch.Name
                                from Htt_Schedules Ch
                               where Ch.Company_Id = q.Company_Id
                                 and Ch.Filial_Id = q.Filial_Id
                                 and Ch.Schedule_Id = q.Schedule_Id) Schedule_Name
                        from Href_Staffs q
                        join Mr_Natural_Persons w
                          on w.Company_Id = q.Company_Id
                         and w.Person_Id = q.Employee_Id
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and q.Hiring_Date <= i_End_Date
                         and i_Begin_Date <= Nvl(q.Dismissal_Date, i_Begin_Date)
                         and q.State = 'A'
                         and (v_Access_All_Employees = 'Y' and v_Divisions_Count = 0 or --
                             q.Division_Id member of v_Filter_Division_Ids)
                       order by w.Name) Qr)
    loop
      a.New_Row;
    
      a.Data(r.Rownum);
      a.Data(r.Division_Name);
      a.Data(r.Staff_Name);
      a.Data(r.Schedule_Name);
    
      v_Plan_Sum := 0;
      v_Fact_Sum := 0;
    
      for Tsht in (select q.*,
                          (select Tf.Fact_Value
                             from Htt_Timesheet_Facts Tf
                            where Tf.Company_Id = q.Company_Id
                              and Tf.Filial_Id = q.Filial_Id
                              and Tf.Timesheet_Id = q.Timesheet_Id
                              and Tf.Time_Kind_Id = v_Free_Id) Fact_Time,
                          Dates.Date_Value
                     from (select i_Begin_Date + (level - 1) Date_Value
                             from Dual
                           connect by level <= (i_End_Date - i_Begin_Date + 1)) Dates
                     left join Htt_Timesheets q
                       on q.Company_Id = r.Company_Id
                      and q.Filial_Id = r.Filial_Id
                      and q.Staff_Id = r.Staff_Id
                      and Dates.Date_Value = q.Timesheet_Date
                    order by Dates.Date_Value)
      loop
        if Tsht.Company_Id is null then
          a.Add_Data(3);
          continue;
        end if;
      
        v_Plan_Sum := v_Plan_Sum + Tsht.Plan_Time;
        v_Fact_Sum := v_Fact_Sum + Tsht.Fact_Time;
      
        v_Diff_Hours := Tsht.Plan_Time - Tsht.Fact_Time;
      
        a.Data(Htt_Util.To_Time_Seconds_Text(Tsht.Plan_Time, v_Show_Minutes, v_Show_Minutes_Words));
        a.Data(Htt_Util.To_Time_Seconds_Text(Tsht.Fact_Time, v_Show_Minutes, v_Show_Minutes_Words));
        a.Data(Htt_Util.To_Time_Seconds_Text(v_Diff_Hours, v_Show_Minutes, v_Show_Minutes_Words));
      end loop;
    
      v_Diff_Hours := v_Plan_Sum - v_Fact_Sum;
    
      a.Data(Htt_Util.To_Time_Seconds_Text(v_Plan_Sum, v_Show_Minutes, v_Show_Minutes_Words));
      a.Data(Htt_Util.To_Time_Seconds_Text(v_Fact_Sum, v_Show_Minutes, v_Show_Minutes_Words));
      a.Data(Htt_Util.To_Time_Seconds_Text(v_Diff_Hours, v_Show_Minutes, v_Show_Minutes_Words));
    end loop;
  
    b_Report.Add_Sheet(i_Name => t('staff_attendace'), p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Begin_Date        date := Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon'));
    v_End_Date          date := Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate)));
    v_Division_Group_Id number := Nvl(p.o_Number('division_group_id'), -1);
    v_Division_Ids      Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
  begin
    b_Report.Open_Book_With_Styles(p.o_Varchar2('rt'));
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    Run_Division(i_Company_Id        => v_Company_Id,
                 i_Filial_Id         => v_Filial_Id,
                 i_Begin_Date        => v_Begin_Date,
                 i_End_Date          => v_End_Date,
                 i_Division_Group_Id => v_Division_Group_Id,
                 i_Division_Ids      => v_Division_Ids);
  
    b_Report.Close_Book();
  end;

end Ui_Vhr304;
/
