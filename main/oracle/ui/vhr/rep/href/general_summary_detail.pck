create or replace package Ui_Vhr601 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Time_Kinds return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr601;
/
create or replace package body Ui_Vhr601 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr601:settings';

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
    return b.Translate('UI-VHR601:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Function Load_Preferences(i_Is_Filial_Head boolean := null) return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => g_Setting_Code,
                                               i_Default_Value => '{}',
                                               i_Filial_Head   => i_Is_Filial_Head));
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
  Function Actual_Staff_Ids
  (
    i_Filial_Id number,
    i_Date      date
  ) return Array_Number is
    v_Staff_Ids Array_Number;
  begin
    select t.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Hiring_Date <= i_Date
       and Nvl(t.Dismissal_Date, i_Date) >= i_Date
       and t.State = 'A';
  
    return v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Hired_Staff_Ids
  (
    i_Filial_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Array_Number is
    v_Staff_Ids Array_Number;
  begin
    select t.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Hiring_Date between i_Begin_Date and i_End_Date
       and t.State = 'A';
  
    return v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Trial_Period_Staff_Ids
  (
    i_Filial_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Array_Number is
    v_Staff_Ids Array_Number;
  begin
    select t.Staff_Id
      bulk collect
      into v_Staff_Ids
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
  
    return v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissed_Staff_Ids
  (
    i_Filial_Id  number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Array_Number is
    v_Staff_Ids Array_Number;
  begin
    select t.Staff_Id
      bulk collect
      into v_Staff_Ids
      from Href_Staffs t
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and t.Dismissal_Date between i_Begin_Date and i_End_Date
       and t.State = 'A';
  
    return v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gender_Staff_Ids
  (
    i_Filial_Id number,
    i_Date      date,
    i_Gender    varchar2
  ) return Array_Number is
    v_Staff_Ids Array_Number;
  begin
    select t.Staff_Id
      bulk collect
      into v_Staff_Ids
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
  
    return v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Part_Time_Staff_Ids
  (
    i_Filial_Id number,
    i_Date      date
  ) return Array_Number is
    v_Staff_Ids Array_Number;
  begin
    select t.Staff_Id
      bulk collect
      into v_Staff_Ids
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
  
    return v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Time_Kind_Staff_Ids
  (
    i_Filial_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Time_Kind_Id number
  ) return Array_Number is
    v_Staff_Ids Array_Number;
  begin
    select t.Staff_Id
      bulk collect
      into v_Staff_Ids
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
  
    return v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run
  (
    i_Filial_Id                number,
    i_Begin_Date               date,
    i_End_Date                 date,
    i_Document_Name            varchar2,
    i_Staff_Ids                Array_Number,
    i_Is_Trial_Period_Document boolean := false
  ) is
    a b_Table := b_Report.New_Table();
  
    v_Hiring_Date    date;
    v_Trial_End_Date date;
  
    v_Rownum       number := 0;
    v_Col_Index    number := 0;
    v_Col_Size     number := 4;
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
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
    if i_Is_Trial_Period_Document then
      v_Col_Size := v_Col_Size + 2;
    end if;
  
    --------------------------------------------------
    -- document root
    --------------------------------------------------
    a.Current_Style('root bold');
    a.New_Row;
    a.New_Row;
  
    a.Data(i_Val => i_Document_Name, i_Colspan => v_Col_Size);
    a.New_Row;
  
    a.Data(i_Val     => t('filial: $1',
                          z_Md_Filials.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => i_Filial_Id).Name),
           i_Colspan => v_Col_Size);
    a.New_Row;
  
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
  
    Print_Header(t('rownum'), 1, 1, 50);
    Print_Header(t('employee name'), 1, 1, 400);
  
    if i_Is_Trial_Period_Document then
      Print_Header(t('trial period begin'), 1, 1, 200);
      Print_Header(t('trial period end'), 1, 1, 200);
    end if;
  
    Print_Header(t('division name'), 1, 1, 300);
    Print_Header(t('job name'), 1, 1, 300);
  
    --------------------------------------------------
    -- document body
    --------------------------------------------------  
    for r in (select t.Staff_Id,
                     t.Employee_Id,
                     (select q.Name
                        from Mr_Natural_Persons q
                       where q.Company_Id = t.Company_Id
                         and q.Person_Id = t.Employee_Id) Employee_Name,
                     (select w.Name
                        from Mhr_Divisions w
                       where w.Company_Id = t.Company_Id
                         and w.Filial_Id = t.Filial_Id
                         and w.Division_Id = t.Division_Id) Division_Name,
                     (select k.Name
                        from Mhr_Jobs k
                       where k.Company_Id = t.Company_Id
                         and k.Filial_Id = t.Filial_Id
                         and k.Job_Id = t.Job_Id) Job_Name
                from Href_Staffs t
               where t.Company_Id = Ui.Company_Id
                 and t.Filial_Id = i_Filial_Id
                 and t.Staff_Id in (select Column_Value
                                      from table(i_Staff_Ids))
               order by Division_Name, Job_Name, Employee_Name)
    loop
      a.Current_Style('body_centralized');
      a.New_Row;
    
      v_Rownum := v_Rownum + 1;
      a.Data(v_Rownum);
      a.Data(r.Employee_Name);
    
      if i_Is_Trial_Period_Document then
        select q.Hiring_Date, q.Hiring_Date + q.Trial_Period
          into v_Hiring_Date, v_Trial_End_Date
          from Hpd_Hirings q
         where q.Company_Id = Ui.Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Staff_Id = r.Staff_Id;
      
        a.Data(to_char(v_Hiring_Date, 'dd mon yyyy', v_Nls_Language));
        a.Data(to_char(v_Trial_End_Date, 'dd mon yyyy', v_Nls_Language));
      end if;
    
      a.Data(r.Division_Name);
      a.Data(r.Job_Name);
    end loop;
  
    b_Report.Add_Sheet(i_Name => i_Document_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
    v_Filial_Id  number := Ui.Filial_Id;
    v_Staff_Ids  Array_Number;
    v_Begin_Date date := Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon'));
    v_End_Date   date := Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate)));
    v_Settings   Hashmap;
    v_Time_Kinds Arraylist;
    v_Time_Kind  Hashmap;
  begin
    if p.o_Varchar2('is_redirected') = 'Y' then
      v_Filial_Id    := p.r_Varchar2('filial_id');
      g_Setting_Code := p.r_Varchar2('setting_code');
      v_Settings     := Load_Preferences(true);
    else
      v_Settings := Load_Preferences;
    end if;
  
    v_Time_Kinds := Nvl(v_Settings.o_Arraylist('time_kinds'), Arraylist());
  
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
    -- custom styles
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    b_Report.New_Style(i_Style_Name => 'primary', i_Background_Color => '#9cc2e5');
  
    -- all actual employees
    v_Staff_Ids := Actual_Staff_Ids(v_Filial_Id, v_End_Date);
    Run(i_Filial_Id     => v_Filial_Id,
        i_Begin_Date    => v_Begin_Date,
        i_End_Date      => v_End_Date,
        i_Document_Name => t('employees $1{count}', v_Staff_Ids.Count),
        i_Staff_Ids     => v_Staff_Ids);
  
    -- hired employees
    v_Staff_Ids := Hired_Staff_Ids(v_Filial_Id, v_Begin_Date, v_End_Date);
    Run(i_Filial_Id     => v_Filial_Id,
        i_Begin_Date    => v_Begin_Date,
        i_End_Date      => v_End_Date,
        i_Document_Name => t('hired employees $1{count}', v_Staff_Ids.Count),
        i_Staff_Ids     => v_Staff_Ids);
  
    -- trial period employees
    v_Staff_Ids := Trial_Period_Staff_Ids(v_Filial_Id, v_Begin_Date, v_End_Date);
    Run(i_Filial_Id                => v_Filial_Id,
        i_Begin_Date               => v_Begin_Date,
        i_End_Date                 => v_End_Date,
        i_Document_Name            => t('trial period employees $1{count}', v_Staff_Ids.Count),
        i_Staff_Ids                => v_Staff_Ids,
        i_Is_Trial_Period_Document => true);
  
    -- dismissed employees
    v_Staff_Ids := Dismissed_Staff_Ids(v_Filial_Id, v_Begin_Date, v_End_Date);
    Run(i_Filial_Id     => v_Filial_Id,
        i_Begin_Date    => v_Begin_Date,
        i_End_Date      => v_End_Date,
        i_Document_Name => t('dismissed employees $1{count}', v_Staff_Ids.Count),
        i_Staff_Ids     => v_Staff_Ids);
  
    -- female employees
    v_Staff_Ids := Gender_Staff_Ids(v_Filial_Id, v_End_Date, Md_Pref.c_Pg_Female);
    Run(i_Filial_Id     => v_Filial_Id,
        i_Begin_Date    => v_Begin_Date,
        i_End_Date      => v_End_Date,
        i_Document_Name => t('female employees $1{count}', v_Staff_Ids.Count),
        i_Staff_Ids     => v_Staff_Ids);
  
    -- male employees
    v_Staff_Ids := Gender_Staff_Ids(v_Filial_Id, v_End_Date, Md_Pref.c_Pg_Male);
    Run(i_Filial_Id     => v_Filial_Id,
        i_Begin_Date    => v_Begin_Date,
        i_End_Date      => v_End_Date,
        i_Document_Name => t('male employees $1{count}', v_Staff_Ids.Count),
        i_Staff_Ids     => v_Staff_Ids);
  
    -- part time employees
    v_Staff_Ids := Part_Time_Staff_Ids(v_Filial_Id, v_End_Date);
    Run(i_Filial_Id     => v_Filial_Id,
        i_Begin_Date    => v_Begin_Date,
        i_End_Date      => v_End_Date,
        i_Document_Name => t('part time employees $1{count}', v_Staff_Ids.Count),
        i_Staff_Ids     => v_Staff_Ids);
  
    -- time kind employees
    for i in 1 .. v_Time_Kinds.Count
    loop
      v_Time_Kind := Treat(v_Time_Kinds.r_Hashmap(i) as Hashmap);
      v_Staff_Ids := Time_Kind_Staff_Ids(v_Filial_Id,
                                         v_Begin_Date,
                                         v_End_Date,
                                         v_Time_Kind.r_Number('time_kind_id'));
    
      Run(i_Filial_Id     => v_Filial_Id,
          i_Begin_Date    => v_Begin_Date,
          i_End_Date      => v_End_Date,
          i_Document_Name => t('$1{time kind name} employees $2{count}',
                               v_Time_Kind.r_Varchar2('name'),
                               v_Staff_Ids.Count),
          i_Staff_Ids     => v_Staff_Ids);
    end loop;
  
    b_Report.Close_Book();
  end;

end Ui_Vhr601;
/
