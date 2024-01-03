create or replace package Ui_Vhr600 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Filials return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Time_Kinds return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr600;
/
create or replace package body Ui_Vhr600 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr600:settings';

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
    return b.Translate('UI-VHR600:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Filials return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from md_filials q
                      where q.company_id = :company_id
                        and q.filial_id <> :filial_head
                        and q.state = ''A''',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_head', Ui.Filial_Head));
  
    q.Number_Field('filial_id', 'order_no');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Time_Kinds return Fazo_Query is
    v_Param Hashmap;
    q       Fazo_Query;
  begin
    v_Param := Fazo.Zip_Map('company_id', Ui.Company_Id, 'requestable_state', 'Y', 'state', 'A');
  
    v_Param.Put('time_kind_leave', Htt_Pref.c_Pcode_Time_Kind_Leave);
    v_Param.Put('time_kind_leave_full', Htt_Pref.c_Pcode_Time_Kind_Leave_Full);
    v_Param.Put('time_kind_sick_leave', Htt_Pref.c_Pcode_Time_Kind_Sick);
    v_Param.Put('time_kind_business_trip', Htt_Pref.c_Pcode_Time_Kind_Trip);
    v_Param.Put('time_kind_vacation', Htt_Pref.c_Pcode_Time_Kind_Vacation);
  
    q := Fazo_Query('select tk.*
                       from htt_time_kinds tk
                      where tk.company_id = :company_id
                        and tk.requestable = :requestable_state
                        and tk.state = :state
                        and nvl(tk.parent_id, tk.time_kind_id) in
                            (select q.time_kind_id
                               from htt_time_kinds q
                              where q.company_id = :company_id
                                and q.pcode in (:time_kind_leave,
                                                :time_kind_leave_full,
                                                :time_kind_sick_leave,
                                                :time_kind_business_trip,
                                                :time_kind_vacation))',
                    v_Param);
  
    q.Number_Field('time_kind_id');
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
    result Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('begin_date', Trunc(sysdate, 'mon'), 'end_date', Trunc(sysdate)));
  
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Filial_Names(i_Filial_Ids Array_Number) return varchar2 is
    v_Filial_Names varchar2(3000 char);
  begin
    select Listagg(t.Name, ', ')
      into v_Filial_Names
      from Md_Filials t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id <> Ui.Filial_Head
       and t.State = 'A'
       and t.Filial_Id in (select Column_Value
                             from table(i_Filial_Ids))
     order by t.Order_No;
  
    return v_Filial_Names;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employees_Count
  (
    i_Filial_Id number,
    i_Date      date
  ) return number is
    v_Count number;
  begin
    select count(t.Employee_Id)
      into v_Count
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Hiring_Date <= i_Date
       and Nvl(t.Dismissal_Date, i_Date) >= i_Date
       and t.State = 'A';
  
    return v_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hired_Employees_Count
  (
    i_Filial_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Count number;
  begin
    select count(t.Employee_Id)
      into v_Count
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Hiring_Date between i_Begin_Date and i_End_Date
       and t.State = 'A';
  
    return v_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Trial_Period_Employees_Count
  (
    i_Filial_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Count number;
  begin
    select count(t.Employee_Id)
      into v_Count
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Hiring_Date <= i_End_Date
       and Nvl(t.Dismissal_Date, i_End_Date) >= i_End_Date
       and t.State = 'A'
       and exists (select 1
              from Hpd_Hirings q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = t.Filial_Id
               and q.Staff_Id = t.Staff_Id
               and q.Trial_Period > 0
               and (t.Hiring_Date + q.Trial_Period) >= i_Begin_Date);
  
    return v_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissed_Employees_Count
  (
    i_Filial_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return number is
    v_Count number;
  begin
    select count(t.Employee_Id)
      into v_Count
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Dismissal_Date between i_Begin_Date and i_End_Date
       and t.State = 'A';
  
    return v_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employees_By_Gender_Count
  (
    i_Filial_Id number,
    i_Date      date,
    i_Gender    varchar2
  ) return number is
    v_Count number;
  begin
    select count(t.Employee_Id)
      into v_Count
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Hiring_Date <= i_Date
       and Nvl(t.Dismissal_Date, i_Date) >= i_Date
       and t.State = 'A'
       and exists (select 1
              from Mr_Natural_Persons q
             where q.Company_Id = t.Company_Id
               and q.Person_Id = t.Employee_Id
               and q.Gender = i_Gender);
  
    return v_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Part_Time_Employees_Count
  (
    i_Filial_Id number,
    i_Date      date
  ) return number is
    v_Count number;
  begin
    select count(distinct t.Employee_Id)
      into v_Count
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Hiring_Date <= i_Date
       and Nvl(t.Dismissal_Date, i_Date) >= i_Date
       and t.State = 'A'
       and exists
     (select 1
              from Hpd_Agreements q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = t.Filial_Id
               and q.Staff_Id = t.Staff_Id
               and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
               and q.Action = Hpd_Pref.c_Transaction_Action_Continue
               and q.Period = (select max(w.Period)
                                 from Hpd_Agreements w
                                where w.Company_Id = q.Company_Id
                                  and w.Filial_Id = q.Filial_Id
                                  and w.Staff_Id = q.Staff_Id
                                  and w.Trans_Type = q.Trans_Type
                                  and w.Action = q.Action
                                  and w.Period <= i_Date)
               and exists
             (select 1
                      from Hpd_Trans_Robots k
                     where k.Company_Id = q.Company_Id
                       and k.Filial_Id = q.Filial_Id
                       and k.Trans_Id = q.Trans_Id
                       and k.Employment_Type <> Hpd_Pref.c_Employment_Type_Main_Job));
  
    return v_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employees_By_Time_Kind_Count
  (
    i_Filial_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Time_Kind_Id number
  ) return number is
    v_Count number;
  begin
    select count(t.Employee_Id)
      into v_Count
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Hiring_Date <= i_End_Date
       and Nvl(t.Dismissal_Date, i_End_Date) >= i_End_Date
       and t.State = 'A'
       and exists (select 1
              from Htt_Timesheets q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = t.Filial_Id
               and q.Staff_Id = t.Staff_Id
               and q.Employee_Id = t.Employee_Id
               and q.Timesheet_Date between i_Begin_Date and i_End_Date
               and exists (select 1
                      from Htt_Timesheet_Facts w
                     where w.Company_Id = q.Company_Id
                       and w.Filial_Id = q.Filial_Id
                       and w.Timesheet_Id = q.Timesheet_Id
                       and w.Time_Kind_Id = i_Time_Kind_Id));
  
    return v_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Begin_Date date,
    i_End_Date   date,
    i_Filial_Ids Array_Number := null
  ) is
    a b_Table := b_Report.New_Table();
  
    v_Settings     Hashmap := Load_Preferences;
    v_Time_Kinds   Arraylist := Nvl(v_Settings.o_Arraylist('time_kinds'), Arraylist());
    v_Time_Kind    Hashmap;
    v_Time_Kind_Id number;
  
    v_Filial_Count number := i_Filial_Ids.Count;
    v_Rownum       number := 0;
    v_Col_Index    number := 0;
    v_Col_Size     number := 9 + v_Time_Kinds.Count;
  
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Calc         Calc := Calc();
    v_Value        number;
    v_Param        Hashmap;
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Val     => i_Name, --
             i_Colspan => i_Colspan,
             i_Rowspan => i_Rowspan);
    
      for i in 1 .. i_Colspan
      loop
        v_Col_Index := v_Col_Index + 1;
        a.Column_Width(i_Column_Index => v_Col_Index, i_Width => i_Column_Width);
      end loop;
    end;
  begin
    --------------------------------------------------
    -- document root
    --------------------------------------------------
    a.Current_Style('root bold');
    a.New_Row;
    a.New_Row;
  
    if i_Filial_Ids.Count > 0 then
      a.Data(i_Val => t('filials: $1', Filial_Names(i_Filial_Ids)), i_Colspan => v_Col_Size);
      a.New_Row;
    end if;
  
    a.Data(i_Val     => t('period: $1 - $2',
                          to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
                          to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => v_Col_Size);
  
    --------------------------------------------------
    -- document header
    --------------------------------------------------
    a.Current_Style('header middle primary');
    a.New_Row;
    a.New_Row;
  
    Print_Header(t('rownum'), 1, 2, 50);
    Print_Header(t('filial names'), 1, 2, 300);
    Print_Header(t('employees count for $1', i_End_Date), 1, 2, 200);
    Print_Header(t('hired employees count'), 1, 2, 100);
    Print_Header(t('trial period employees count'), 1, 2, 100);
    Print_Header(t('dismissed employees count'), 1, 2, 100);
    Print_Header(t('female employees count'), 1, 2, 100);
    Print_Header(t('male employees count'), 1, 2, 100);
    Print_Header(t('from them'), 1 + v_Time_Kinds.Count, 1, 100);
  
    a.New_Row;
    a.Data(i_Val => t('part time employees'), i_Style_Name => 'header primary');
  
    for i in 1 .. v_Time_Kinds.Count
    loop
      v_Time_Kind := Treat(v_Time_Kinds.r_Hashmap(i) as Hashmap);
    
      a.Data(i_Val => v_Time_Kind.r_Varchar2('name'), i_Style_Name => 'header primary');
    end loop;
  
    --------------------------------------------------
    -- document body
    --------------------------------------------------
    for r in (select t.Filial_Id, t.Name Filial_Name
                from Md_Filials t
               where t.Company_Id = Ui.Company_Id
                 and t.Filial_Id <> Ui.Filial_Head
                 and t.State = 'A'
                 and (v_Filial_Count = 0 or
                     t.Filial_Id in (select Column_Value
                                        from table(i_Filial_Ids)))
               order by t.Order_No)
    loop
      a.Current_Style('body_centralized');
      a.New_Row;
    
      v_Rownum := v_Rownum + 1;
      a.Data(v_Rownum);
    
      v_Param := Fazo.Zip_Map('is_redirected',
                              'Y',
                              'filial_id',
                              r.Filial_Id,
                              'begin_date',
                              i_Begin_Date,
                              'end_date',
                              i_End_Date,
                              'setting_code',
                              g_Setting_Code);
    
      a.Data(i_Val => r.Filial_Name, i_Param => v_Param.Json);
    
      --
      v_Value := Employees_Count(i_Filial_Id => r.Filial_Id, i_Date => i_End_Date);
      v_Calc.Plus('employees', v_Value);
      a.Data(v_Value);
    
      --
      v_Value := Hired_Employees_Count(i_Filial_Id  => r.Filial_Id,
                                       i_Begin_Date => i_Begin_Date,
                                       i_End_Date   => i_End_Date);
      v_Calc.Plus('hired_employees', v_Value);
      a.Data(v_Value);
    
      --
      v_Value := Trial_Period_Employees_Count(i_Filial_Id  => r.Filial_Id,
                                              i_Begin_Date => i_Begin_Date,
                                              i_End_Date   => i_End_Date);
      v_Calc.Plus('trial_period_employees', v_Value);
      a.Data(v_Value);
    
      --
      v_Value := Dismissed_Employees_Count(i_Filial_Id  => r.Filial_Id,
                                           i_Begin_Date => i_Begin_Date,
                                           i_End_Date   => i_End_Date);
      v_Calc.Plus('dismissed_employees', v_Value);
      a.Data(v_Value);
    
      --
      v_Value := Employees_By_Gender_Count(i_Filial_Id => r.Filial_Id,
                                           i_Date      => i_End_Date,
                                           i_Gender    => Md_Pref.c_Pg_Female);
      v_Calc.Plus('female_employees', v_Value);
      a.Data(v_Value);
    
      --
      v_Value := Employees_By_Gender_Count(i_Filial_Id => r.Filial_Id,
                                           i_Date      => i_End_Date,
                                           i_Gender    => Md_Pref.c_Pg_Male);
      v_Calc.Plus('male_employees', v_Value);
      a.Data(v_Value);
    
      --
      v_Value := Part_Time_Employees_Count(i_Filial_Id => r.Filial_Id, i_Date => i_End_Date);
      v_Calc.Plus('part_time_employees', v_Value);
      a.Data(v_Value);
    
      --
      for i in 1 .. v_Time_Kinds.Count
      loop
        v_Time_Kind    := Treat(v_Time_Kinds.r_Hashmap(i) as Hashmap);
        v_Time_Kind_Id := v_Time_Kind.r_Number('time_kind_id');
      
        v_Value := Employees_By_Time_Kind_Count(i_Filial_Id    => r.Filial_Id,
                                                i_Begin_Date   => i_Begin_Date,
                                                i_End_Date     => i_End_Date,
                                                i_Time_Kind_Id => v_Time_Kind_Id);
      
        v_Calc.Plus('employees_by_time_kind:' || v_Time_Kind_Id, v_Value);
        a.Data(v_Value);
      end loop;
    end loop;
  
    --------------------------------------------------
    -- document footer
    --------------------------------------------------
    a.Current_Style('footer');
    a.New_Row;
  
    a.Data(i_Val        => t('total'), --
           i_Style_Name => 'footer',
           i_Colspan    => 2);
  
    a.Data(v_Calc.Get_Value('employees'));
    a.Data(v_Calc.Get_Value('hired_employees'));
    a.Data(v_Calc.Get_Value('trial_period_employees'));
    a.Data(v_Calc.Get_Value('dismissed_employees'));
    a.Data(v_Calc.Get_Value('female_employees'));
    a.Data(v_Calc.Get_Value('male_employees'));
    a.Data(v_Calc.Get_Value('part_time_employees'));
  
    for i in 1 .. v_Time_Kinds.Count
    loop
      v_Time_Kind := Treat(v_Time_Kinds.r_Hashmap(i) as Hashmap);
      a.Data(v_Calc.Get_Value('employees_by_time_kind:' || v_Time_Kind.r_Number('time_kind_id')));
    end loop;
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Param Hashmap;
  begin
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.r_Varchar2('cell_param'));
      b_Report.Redirect_To_Report('/vhr/rep/href/general_summary_detail:run', v_Param);
    else
      b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                     i_File_Name   => Ui.Current_Form_Name);
      -- custom styles
      b_Report.New_Style(i_Style_Name        => 'body_centralized',
                         i_Parent_Style_Name => 'body',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
    
      b_Report.New_Style(i_Style_Name => 'primary', i_Background_Color => '#9cc2e5');
    
      Run_All(i_Begin_Date => Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon')),
              i_End_Date   => Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate))),
              i_Filial_Ids => Nvl(p.o_Array_Number('filial_ids'), Array_Number()));
    
      b_Report.Close_Book();
    end if;
  end;

end Ui_Vhr600;
/
