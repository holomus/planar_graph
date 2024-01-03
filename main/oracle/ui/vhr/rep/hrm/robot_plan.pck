create or replace package Ui_Vhr582 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr582;
/
create or replace package body Ui_Vhr582 is
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
    return b.Translate('UI-VHR582:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('begin_date',
                           Trunc(sysdate, 'mon'),
                           'end_date',
                           Trunc(Last_Day(sysdate)));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Is_Department => 'Y')));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Robot_Plan
  (
    i_Begin_Date  date,
    i_End_Date    date,
    i_Division_Id number,
    i_Job_Ids     Array_Number
  ) is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Job_Cnt              number := i_Job_Ids.Count;
    v_Date_Cnt             number := i_End_Date - i_Begin_Date + 1;
    t_Busy                 varchar2(150) := t('busy');
    t_Free                 varchar2(150) := t('free');
    t_Rest_Day_Short       varchar2(150) := t('rest day short');
    t_Holiday_Short        varchar2(150) := t('holiday short');
    t_Rest_Day             varchar2(150) := t('rest day');
    t_Addtitional_Rest_Day varchar2(150) := t('additional rest day short');
    t_No_Data              varchar2(150) := t('no data');
    v_Nls_Language         varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Key                  varchar2(100);
    v_Date                 date;
    v_Keys                 Fazo.Boolean_Code_Aat;
    v_Calc                 Calc := Calc();
    v_Robot_Staffs         Matrix_Varchar2;
    v_Staff_Schedule_Days  Matrix_Varchar2;
    v_Order_No             number := 1;
    v_Colspan              number := 6;
    a                      b_Table := b_Report.New_Table();
  
    -------------------------------------------------- 
    Procedure Print_Info is
      v_Limit   number := 5;
      v_Colspan number := 11;
      v_Names   Array_Varchar2 := Array_Varchar2();
    begin
      a.Current_Style('root bold');
      a.New_Row;
      a.New_Row;
      a.Data(t('period: $1{begin_date} - $2{end_date}',
               to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
               to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
             i_Colspan => v_Colspan);
    
      if i_Division_Id is not null then
        a.New_Row;
        a.Data(t('division: $1{division_name}',
                 z_Mhr_Divisions.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Division_Id => i_Division_Id).Name),
               i_Colspan => v_Colspan);
      end if;
    
      if v_Job_Cnt > 0 then
        a.New_Row;
        v_Limit := Least(v_Limit, v_Job_Cnt);
        v_Names.Extend(v_Limit);
      
        for i in 1 .. v_Limit
        loop
          v_Names(i) := z_Mhr_Jobs.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Job_Id => i_Job_Ids(i)).Name;
        end loop;
      
        if v_Job_Cnt > v_Limit then
          Fazo.Push(v_Names, t('other...'));
        end if;
      
        a.Data(t('jobs: $1{job_names}', Fazo.Gather(v_Names, ', ')), i_Colspan => v_Colspan);
      end if;
    end;
  
    -------------------------------------------------- 
    Procedure Print_Header is
      v_Col_Number number := 1;
    
      -------------------- 
      Procedure Print_Header_Data
      (
        i_Title   varchar2,
        i_Size    number,
        i_Style   varchar2 := null,
        i_Rowspan number := null
      ) is
      begin
        a.Column_Width(v_Col_Number, i_Size);
        a.Data(i_Title, i_Style, i_Rowspan => i_Rowspan);
        v_Col_Number := v_Col_Number + 1;
      end;
    begin
      a.Current_Style('header');
    
      a.New_Row;
      Print_Header_Data(t('#'), 50, null, 2);
      Print_Header_Data(t('staff name'), 250, null, 2);
    
      if i_Division_Id is null then
        Print_Header_Data(t('division name'), 200, null, 2);
      end if;
    
      Print_Header_Data(t('job name'), 150, null, 2);
      Print_Header_Data(t('code'), 80, null, 2);
      Print_Header_Data(t('rank name'), 80, null, 2);
      Print_Header_Data(t('state'), 80, null, 2);
    
      for i in 1 .. v_Date_Cnt
      loop
        Print_Header_Data(to_char(i_Begin_Date + i - 1, 'Dy', v_Nls_Language), 100, 'blue');
      end loop;
    
      Print_Header_Data(t('days off quant'), 100, 'blue', 2);
    
      a.New_Row;
      for i in 1 .. v_Date_Cnt
      loop
        a.Data(to_char(i_Begin_Date + i - 1, 'dd.mon', v_Nls_Language), 'light_green');
      end loop;
    end;
  begin
    -- info
    Print_Info;
  
    -- header
    Print_Header;
  
    -- body
    a.Current_Style('body_centralized');
  
    for r in (select q.Robot_Id,
                     (select s.Name
                        from Mhr_Divisions s
                       where s.Company_Id = q.Company_Id
                         and s.Filial_Id = q.Filial_Id
                         and s.Division_Id = q.Division_Id) Division_Name,
                     (select j.Name
                        from Mhr_Jobs j
                       where j.Company_Id = q.Company_Id
                         and j.Filial_Id = q.Filial_Id
                         and j.Job_Id = q.Job_Id) Job_Name,
                     q.Code,
                     (select e.Name
                        from Mhr_Ranks e
                       where e.Company_Id = q.Company_Id
                         and e.Filial_Id = q.Filial_Id
                         and e.Rank_Id = k.Rank_Id) Rank_Name,
                     (case
                        when Rt.Fte > 0 then
                         t_Free
                        else
                         t_Busy
                      end) State,
                     k.Opened_Date,
                     k.Closed_Date
                from Mrf_Robots q
                join Hrm_Robots k
                  on k.Company_Id = q.Company_Id
                 and k.Filial_Id = q.Filial_Id
                 and k.Robot_Id = q.Robot_Id
                join Hrm_Robot_Turnover Rt
                  on Rt.Company_Id = q.Company_Id
                 and Rt.Filial_Id = q.Filial_Id
                 and Rt.Robot_Id = q.Robot_Id
                 and Rt.Period = (select max(Qt.Period)
                                    from Hrm_Robot_Turnover Qt
                                   where Qt.Company_Id = q.Company_Id
                                     and Qt.Filial_Id = q.Filial_Id
                                     and Qt.Robot_Id = q.Robot_Id
                                     and Qt.Period <= i_End_Date)
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and (i_Division_Id is null or --
                     q.Division_Id = i_Division_Id or --
                     exists (select 1
                               from Mhr_Parent_Divisions Dp
                              where Dp.Company_Id = q.Company_Id
                                and Dp.Filial_Id = q.Filial_Id
                                and Dp.Division_Id = q.Division_Id
                                and Dp.Parent_Id = i_Division_Id))
                 and k.Opened_Date <= i_End_Date
                 and (k.Closed_Date is null or --
                     k.Closed_Date >= i_Begin_Date)
                 and (v_Job_Cnt = 0 or --
                     q.Job_Id member of i_Job_Ids)
               order by Job_Name)
    loop
      select Array_Varchar2(c.Staff_Id,
                            (select w.Name
                               from Mr_Natural_Persons w
                              where w.Company_Id = v_Company_Id
                                and w.Person_Id = (select s.Employee_Id
                                                     from Href_Staffs s
                                                    where s.Company_Id = v_Company_Id
                                                      and s.Filial_Id = v_Filial_Id
                                                      and s.Staff_Id = c.Staff_Id)))
        bulk collect
        into v_Robot_Staffs
        from Hpd_Agreements_Cache c
       where c.Company_Id = v_Company_Id
         and c.Filial_Id = v_Filial_Id
         and c.Robot_Id = r.Robot_Id
         and Greatest(c.Begin_Date, i_Begin_Date) <= Least(c.End_Date, i_End_Date)
       group by c.Staff_Id;
    
      continue when v_Robot_Staffs.Count = 0;
    
      Dbms_Output.Put_Line(r.Opened_Date || ' ' || r.Closed_Date);
    
      a.New_Row;
      a.Data(v_Order_No, i_Rowspan => v_Robot_Staffs.Count);
      a.Data(v_Robot_Staffs(1) (2));
    
      v_Order_No := v_Order_No + 1;
    
      if i_Division_Id is null then
        a.Data(r.Division_Name, i_Rowspan => v_Robot_Staffs.Count);
      end if;
    
      a.Data(r.Job_Name, i_Rowspan => v_Robot_Staffs.Count);
      a.Data(r.Code, i_Rowspan => v_Robot_Staffs.Count);
      a.Data(r.Rank_Name, i_Rowspan => v_Robot_Staffs.Count);
      a.Data(r.State, i_Rowspan => v_Robot_Staffs.Count);
    
      for j in 1 .. v_Robot_Staffs.Count
      loop
        if j > 1 then
          a.New_Row;
          a.Data(v_Robot_Staffs(j) (2)); -- staff name
        end if;
      
        v_Staff_Schedule_Days := Matrix_Varchar2();
        v_Staff_Schedule_Days.Extend(i_End_Date - i_Begin_Date + 1);
      
        for Period in (select *
                         from Hpd_Agreements_Cache q
                        where q.Company_Id = v_Company_Id
                          and q.Filial_Id = v_Filial_Id
                          and q.Staff_Id = v_Robot_Staffs(j)
                        (1)
                          and q.Robot_Id = r.Robot_Id
                          and Greatest(q.Begin_Date, i_Begin_Date) <= Least(q.End_Date, i_End_Date))
        loop
          for Tsh in (select *
                        from Htt_Timesheets t
                       where t.Company_Id = v_Company_Id
                         and t.Filial_Id = v_Filial_Id
                         and t.Staff_Id = Period.Staff_Id
                         and t.Timesheet_Date between Greatest(Period.Begin_Date, i_Begin_Date) and
                             Least(Period.End_Date, i_End_Date))
          loop
            v_Staff_Schedule_Days(Tsh.Timesheet_Date - i_Begin_Date + 1) := Array_Varchar2(to_char(Tsh.Begin_Time,
                                                                                                   'HH24:mi') ||
                                                                                           ' - ' ||
                                                                                           to_char(Tsh.End_Time,
                                                                                                   'HH24:mi'),
                                                                                           Tsh.Day_Kind,
                                                                                           Tsh.Timesheet_Date);
          end loop;
        end loop;
      
        for i in 1 .. v_Staff_Schedule_Days.Count
        loop
          if Fazo.Is_Empty(v_Staff_Schedule_Days(i)) then
            a.Data;
            v_Calc.Plus(i_Begin_Date + i - 1, t_No_Data, 1);
            v_Keys(t_No_Data) := true;
            continue;
          end if;
        
          case v_Staff_Schedule_Days(i) (2)
            when Htt_Pref.c_Day_Kind_Work then
              a.Data(v_Staff_Schedule_Days(i) (1));
              v_Calc.Plus(v_Staff_Schedule_Days(i) (3), v_Staff_Schedule_Days(i) (1), 1);
              v_Keys(v_Staff_Schedule_Days(i)(1)) := true;
            when Htt_Pref.c_Day_Kind_Rest then
              a.Data(t_Rest_Day_Short, 'yellow');
              v_Calc.Plus(v_Staff_Schedule_Days(i) (3), t_Rest_Day, 1);
              v_Calc.Plus(r.Robot_Id, v_Robot_Staffs(j) (1), t_Rest_Day, 1);
              v_Keys(t_Rest_Day) := true;
            when Htt_Pref.c_Day_Kind_Holiday then
              a.Data(t_Holiday_Short, 'green');
              v_Calc.Plus(v_Staff_Schedule_Days(i) (3), t_Rest_Day, 1);
              v_Calc.Plus(r.Robot_Id, v_Robot_Staffs(j) (1), t_Rest_Day, 1);
              v_Keys(t_Rest_Day) := true;
            when Htt_Pref.c_Day_Kind_Additional_Rest then
              a.Data(t_Addtitional_Rest_Day, 'green');
              v_Calc.Plus(v_Staff_Schedule_Days(i) (3), t_Rest_Day, 1);
              v_Calc.Plus(r.Robot_Id, v_Robot_Staffs(j) (1), t_Rest_Day, 1);
              v_Keys(t_Rest_Day) := true;
            else
              a.Data;
              v_Calc.Plus(v_Staff_Schedule_Days(i) (3), t_No_Data, 1);
              v_Keys(t_No_Data) := true;
          end case;
        end loop;
      
        a.Data(Nullif(v_Calc.Get_Value(r.Robot_Id, v_Robot_Staffs(j) (1), t_Rest_Day), 0));
      end loop;
    
      for i in 1 .. i_End_Date - i_Begin_Date + 1
      loop
        v_Date := i_Begin_Date + i - 1;
      
        if r.Opened_Date <= v_Date and v_Date <= Nvl(r.Closed_Date, v_Date) then
          v_Calc.Plus(v_Date, 'robot_count', 1);
        end if;
      end loop;
    end loop;
  
    v_Key := v_Keys.First;
  
    if i_Division_Id is null then
      v_Colspan := v_Colspan + 1;
    end if;
  
    while v_Key is not null
    loop
      a.New_Row;
      a.Data(v_Key, 'body right', i_Colspan => v_Colspan);
    
      for i in 1 .. v_Date_Cnt
      loop
        a.Data(Nullif(v_Calc.Get_Value(i_Begin_Date + i - 1, v_Key), 0), 'body number');
      end loop;
    
      a.Data;
      v_Key := v_Keys.Next(v_Key);
    end loop;
  
    a.New_Row;
    a.Data(t('total robots'), 'body right', i_Colspan => v_Colspan);
  
    for i in 1 .. v_Date_Cnt
    loop
      a.Data(Nullif(v_Calc.Get_Value(i_Begin_Date + i - 1, 'robot_count'), 0), 'body number');
    end loop;
  
    a.Data;
  
    b_Report.Add_Sheet(i_Name => t('robot_plan'), p_Table => a);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Begin_Date  date := p.r_Date('begin_date');
    v_End_Date    date := p.r_Date('end_date');
    v_Division_Id number := p.o_Number('division_id');
    v_Job_Ids     Array_Number := Nvl(p.o_Array_Number('job_ids'), Array_Number());
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
    -- yellow
    b_Report.New_Style(i_Style_Name        => 'yellow',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#ffc000');
    -- red
    b_Report.New_Style(i_Style_Name        => 'red',
                       i_Parent_Style_Name => 'header',
                       i_Background_Color  => '#da9694');
    -- green
    b_Report.New_Style(i_Style_Name        => 'green',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#00b005');
    -- light_green
    b_Report.New_Style(i_Style_Name        => 'light_green',
                       i_Parent_Style_Name => 'header',
                       i_Background_Color  => '#9cd45e');
    -- blue
    b_Report.New_Style(i_Style_Name        => 'blue',
                       i_Parent_Style_Name => 'header',
                       i_Background_Color  => '#003296',
                       i_Font_Color        => '#ffffff');
  
    Run_Robot_Plan(i_Begin_Date  => v_Begin_Date,
                   i_End_Date    => v_End_Date,
                   i_Division_Id => v_Division_Id,
                   i_Job_Ids     => v_Job_Ids);
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
  end;
end Ui_Vhr582;
/
