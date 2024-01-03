create or replace package Ui_Vhr475 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr475;
/
create or replace package body Ui_Vhr475 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr475:settings';

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
    return b.Translate('UI-VHR475:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Function Query_Locations return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.location_id, q.name
                       from htt_locations q
                      where q.company_id = :company_id
                        and q.state = ''A''
                        and exists (select 1
                               from htt_location_filials w
                              where w.company_id = q.company_id
                                and w.filial_id = :filial_id
                                and w.location_id = q.location_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('location_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
  
    Result.Put('data', Fazo.Zip_Map('period', Trunc(sysdate)));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query varchar2(32767);
    q       Fazo_Query;
  begin
    v_Query := 'select *
                  from href_staffs w
                 where w.company_id = :company_id
                   and w.filial_id = :filial_id
                   and w.hiring_date <= :max_date
                   and (w.dismissal_date is null or
                       w.dismissal_date >= :min_date)
                   and w.state = ''A''
                   and exists (select 1
                          from mhr_employees e
                         where e.company_id = :company_id
                           and e.filial_id = :filial_id
                           and e.employee_id = w.employee_id
                           and e.state = ''A'')';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'min_date',
                                 p.r_Date('begin_date'),
                                 'max_date',
                                 p.r_Date('end_date')));
  
    q.Number_Field('employee_id', 'staff_id', 'division_id');
    q.Varchar2_Field('staff_number');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Marks
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Period       date,
    i_Division_Ids Array_Number,
    i_Job_Ids      Array_Number,
    i_Location_Ids Array_Number,
    i_Staff_Ids    Array_Number
  ) is
    v_Settings Hashmap := Load_Preferences;
  
    v_Show_Staff_Number varchar2(1) := Nvl(v_Settings.o_Varchar2('staff_number'), 'N');
  
    v_Show_Job           boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Division      boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Location      boolean := Nvl(v_Settings.o_Varchar2('location'), 'N') = 'Y';
    v_Show_Minutes       boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words boolean := v_Show_Minutes and
                                    Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
  
    v_Division_Count number := i_Division_Ids.Count;
    v_Job_Count      number := i_Job_Ids.Count;
    v_Location_Count number := i_Location_Ids.Count;
    v_Staff_Count    number := i_Staff_Ids.Count;
  
    v_Division_Names Array_Varchar2;
    v_Job_Names      Array_Varchar2;
    v_Location_Names Array_Varchar2;
  
    a        b_Table := b_Report.New_Table();
    v_Column number := 1;
    v_Style  varchar2(100);
  
    v_User_Id               number := Ui.User_Id;
    v_Access_All_Employees  varchar2(1);
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    v_Turnout_Tk_Ids Array_Number := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => i_Company_Id,
                                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
  
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    --------------------------------------------------
    Procedure Put_Time
    (
      i_Seconds number,
      i_Rowspan number
    ) is
    begin
      if v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Seconds_Text(i_Seconds, v_Show_Minutes, v_Show_Minutes_Words),
               i_Rowspan => i_Rowspan);
      else
        a.Data(Nullif(Round(i_Seconds / 3600, 2), 0), i_Rowspan => i_Rowspan);
      end if;
    end;
  
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
        a.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Info is
    begin
      a.Current_Style('root bold');
    
      a.New_Row;
      if i_Division_Ids.Count > 0 then
        a.New_Row;
      
        select d.Name
          bulk collect
          into v_Division_Names
          from Mhr_Divisions d
         where d.Company_Id = i_Company_Id
           and d.Filial_Id = i_Filial_Id
           and d.Division_Id member of i_Division_Ids;
      
        a.Data(t('division: $1', Fazo.Gather(v_Division_Names, ', ')), i_Colspan => 5);
      end if;
    
      if i_Job_Ids.Count > 0 then
        a.New_Row;
      
        select d.Name
          bulk collect
          into v_Job_Names
          from Mhr_Jobs d
         where d.Company_Id = i_Company_Id
           and d.Filial_Id = i_Filial_Id
           and d.Job_Id member of i_Job_Ids;
      
        a.Data(t('job: $1', Fazo.Gather(v_Job_Names, ', ')), i_Colspan => 5);
      end if;
    
      if i_Location_Ids.Count > 0 then
        a.New_Row;
      
        select q.Name
          bulk collect
          into v_Location_Names
          from Htt_Locations q
         where q.Company_Id = i_Company_Id
           and q.Location_Id member of i_Location_Ids
           and q.State = 'A'
           and exists (select 1
                  from Htt_Location_Filials w
                 where w.Company_Id = q.Company_Id
                   and w.Filial_Id = Ui.Filial_Id
                   and w.Location_Id = q.Location_Id);
      
        a.Data(t('location: $1', Fazo.Gather(v_Location_Names, ', ')), i_Colspan => 5);
      end if;
    
      a.New_Row;
      a.Data(t('date: $1', --
               to_char(i_Period, 'dd mon yyyy', v_Nls_Language)),
             i_Colspan => 5);
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
    begin
      a.Current_Style('header');
    
      a.New_Row;
      Print_Header(t('rownum'), 1, 2, 50);
    
      if v_Show_Staff_Number = 'Y' then
        Print_Header(t('staff number'), 1, 2, 100);
      end if;
    
      Print_Header(t('staff_name'), 1, 2, 250);
    
      if v_Show_Division then
        Print_Header(t('division'), 1, 2, 150);
      end if;
    
      if v_Show_Job then
        Print_Header(t('job'), 1, 2, 150);
      end if;
    
      if v_Show_Location then
        Print_Header(t('location'), 1, 2, 150);
      end if;
    
      Print_Header(t('plan'), 3, 1, 100);
    
      Print_Header(t('fact'), 3, 1, 100);
    
      Print_Header(t('marks'), 7, 1, 100);
    
      a.New_Row;
    
      -- plan
      Print_Header(t('plan_begin'), 1, 1, 100);
      Print_Header(t('plan_end'), 1, 1, 100);
      Print_Header(t('plan_time'), 1, 1, 100);
    
      -- fact
      Print_Header(t('fact_input'), 1, 1, 100);
      Print_Header(t('fact_output'), 1, 1, 100);
      Print_Header(t('fact_time'), 1, 1, 100);
    
      -- marks
      Print_Header(t('marks_plan'), 1, 1, 100);
      Print_Header(t('marks_fact'), 1, 1, 100);
      Print_Header(t('mark_begin'), 1, 1, 100);
      Print_Header(t('mark_end'), 1, 1, 100);
      Print_Header(t('mark_datetime'), 1, 1, 100);
      Print_Header(t('mark_location'), 2, 1, 100);
    end;
  
  begin
    Print_Info;
  
    Print_Header;
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
  
    if v_Access_All_Employees = 'N' then
      v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                    i_Direct             => true,
                                                                    i_Indirect           => true,
                                                                    i_Manual             => true,
                                                                    i_Gather_Chiefs      => false);
    end if;
  
    for r in (select Qr.*, --
                     (select Dv.Name
                        from Mhr_Divisions Dv
                       where Dv.Company_Id = i_Company_Id
                         and Dv.Filial_Id = i_Filial_Id
                         and Dv.Division_Id = Qr.Division_Id) Div_Name,
                     (select Jb.Name
                        from Mhr_Jobs Jb
                       where Jb.Company_Id = i_Company_Id
                         and Jb.Filial_Id = i_Filial_Id
                         and Jb.Job_Id = Qr.Job_Id) Job_Name,
                     (select Listagg(Lc.Name, ', ')
                        from Htt_Locations Lc
                       where Lc.Company_Id = i_Company_Id
                         and Lc.State = 'A'
                         and exists
                       (select 1
                                from Htt_Location_Persons w
                               where w.Company_Id = i_Company_Id
                                 and w.Filial_Id = i_Filial_Id
                                 and w.Location_Id = Lc.Location_Id
                                 and w.Person_Id = Qr.Employee_Id
                                 and not exists (select 1
                                        from Htt_Blocked_Person_Tracking Bp
                                       where Bp.Company_Id = w.Company_Id
                                         and Bp.Filial_Id = w.Filial_Id
                                         and Bp.Employee_Id = w.Person_Id))) Loc_Names,
                     Rownum Row_Num,
                     Qr.Planned_Marks Rowspan
                from (select Tt.Timesheet_Id,
                             q.Staff_Number,
                             q.Division_Id,
                             q.Job_Id,
                             q.Employee_Id,
                             w.Name,
                             to_char(Tt.Begin_Time, Href_Pref.c_Time_Format_Minute) Begin_Time,
                             to_char(Tt.End_Time, Href_Pref.c_Time_Format_Minute) End_Time,
                             Tt.Plan_Time,
                             to_char(Tt.Input_Time, Href_Pref.c_Time_Format_Minute) Input_Time,
                             to_char(Tt.Output_Time, Href_Pref.c_Time_Format_Minute) Output_Time,
                             Tt.Planned_Marks,
                             Nullif(Tt.Done_Marks, 0) Done_Marks,
                             (select sum(Tf.Fact_Value)
                                from Htt_Timesheet_Facts Tf
                               where Tf.Company_Id = Tt.Company_Id
                                 and Tf.Filial_Id = Tt.Filial_Id
                                 and Tf.Timesheet_Id = Tt.Timesheet_Id
                                 and Tf.Time_Kind_Id member of v_Turnout_Tk_Ids) Fact_Time
                        from Href_Staffs q
                        join Mr_Natural_Persons w
                          on w.Company_Id = q.Company_Id
                         and w.Person_Id = q.Employee_Id
                        join Htt_Timesheets Tt
                          on Tt.Company_Id = q.Company_Id
                         and Tt.Filial_Id = q.Filial_Id
                         and Tt.Staff_Id = q.Staff_Id
                         and Tt.Timesheet_Date = i_Period
                         and Tt.Planned_Marks > 0
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and (v_Division_Count = 0 or q.Division_Id member of i_Division_Ids)
                         and (v_Job_Count = 0 or q.Job_Id member of i_Job_Ids)
                         and (v_Staff_Count = 0 or q.Staff_Id member of i_Staff_Ids)
                         and q.Hiring_Date <= i_Period
                         and i_Period <= Nvl(q.Dismissal_Date, i_Period)
                         and q.State = 'A'
                         and not exists (select 1
                                from Hlic_Unlicensed_Employees Le
                               where Le.Company_Id = q.Company_Id
                                 and Le.Employee_Id = q.Employee_Id
                                 and Le.Licensed_Date = i_Period)
                         and exists
                       (select 1
                                from Mhr_Employees e
                               where e.Company_Id = i_Company_Id
                                 and e.Filial_Id = i_Filial_Id
                                 and e.Employee_Id = q.Employee_Id
                                 and e.State = 'A')
                         and (v_Location_Count = 0 or exists
                              (select 1
                                 from Htt_Location_Persons Lp
                                where Lp.Company_Id = q.Company_Id
                                  and Lp.Filial_Id = q.Filial_Id
                                  and Lp.Location_Id member of i_Location_Ids
                                  and Lp.Person_Id = q.Employee_Id
                                  and not exists (select 1
                                         from Htt_Blocked_Person_Tracking Bp
                                        where Bp.Company_Id = Lp.Company_Id
                                          and Bp.Filial_Id = Lp.Filial_Id
                                          and Bp.Employee_Id = Lp.Person_Id)))
                         and (v_Access_All_Employees = 'Y' or q.Employee_Id = v_User_Id or --
                             q.Org_Unit_Id member of v_Subordinate_Divisions)
                       order by Decode(v_Show_Staff_Number, 'Y', q.Staff_Number, null)) Qr)
    loop
      if mod(r.Row_Num, 2) = 1 then
        a.Current_Style('body_centralized');
      else
        a.Current_Style('body_even');
      end if;
    
      a.New_Row;
    
      a.Data(r.Row_Num, i_Rowspan => r.Rowspan);
    
      if v_Show_Staff_Number = 'Y' then
        a.Data(r.Staff_Number, i_Rowspan => r.Rowspan);
      end if;
    
      a.Data(r.Name, i_Rowspan => r.Rowspan);
    
      if v_Show_Division then
        a.Data(r.Div_Name, i_Rowspan => r.Rowspan);
      end if;
    
      if v_Show_Job then
        a.Data(r.Job_Name, i_Rowspan => r.Rowspan);
      end if;
    
      if v_Show_Location then
        a.Data(r.Loc_Names, i_Rowspan => r.Rowspan);
      end if;
    
      -- plan
      a.Data(r.Begin_Time, i_Rowspan => r.Rowspan);
      a.Data(r.End_Time, i_Rowspan => r.Rowspan);
      Put_Time(r.Plan_Time, i_Rowspan => r.Rowspan);
    
      -- fact
      a.Data(r.Input_Time, i_Rowspan => r.Rowspan);
      a.Data(r.Output_Time, i_Rowspan => r.Rowspan);
      Put_Time(r.Fact_Time, i_Rowspan => r.Rowspan);
    
      -- marks
      a.Data(r.Planned_Marks, i_Rowspan => r.Rowspan);
      a.Data(r.Done_Marks, i_Rowspan => r.Rowspan);
    
      for Mk in (select Qr.*,
                        to_char(Tr.Track_Datetime, Href_Pref.c_Time_Format_Minute) Track_Datetime,
                        (select Lc.Name
                           from Htt_Locations Lc
                          where Lc.Company_Id = i_Company_Id
                            and Lc.Location_Id = Tr.Location_Id) Location_Name,
                        Rownum Rn
                   from (select to_char(Tm.Begin_Time, Href_Pref.c_Time_Format_Minute) Begin_Time,
                                to_char(Tm.End_Time, Href_Pref.c_Time_Format_Minute) End_Time,
                                Tm.Done,
                                (select Tt.Track_Id
                                   from Htt_Timesheet_Tracks Tt
                                  where Tt.Company_Id = i_Company_Id
                                    and Tt.Filial_Id = i_Filial_Id
                                    and Tt.Timesheet_Id = r.Timesheet_Id
                                    and Tt.Track_Type = Htt_Pref.c_Track_Type_Check
                                    and Tt.Track_Datetime between Tm.Begin_Time and Tm.End_Time
                                    and Rownum = 1) Track_Id
                           from Htt_Timesheet_Marks Tm
                          where Tm.Company_Id = i_Company_Id
                            and Tm.Filial_Id = i_Filial_Id
                            and Tm.Timesheet_Id = r.Timesheet_Id) Qr
                   left join Htt_Tracks Tr
                     on Tr.Company_Id = i_Company_Id
                    and Tr.Filial_Id = i_Filial_Id
                    and Tr.Track_Id = Qr.Track_Id)
      loop
        if Mk.Rn > 1 then
          a.New_Row;
        end if;
      
        if Mk.Done = 'Y' then
          v_Style := null;
        else
          v_Style := 'missed';
        end if;
      
        a.Data(Mk.Begin_Time, v_Style);
        a.Data(Mk.End_Time, v_Style);
        a.Data(Mk.Track_Datetime, v_Style);
        a.Data(Mk.Location_Name, v_Style, i_Colspan => 2);
      end loop;
    end loop;
  
    b_Report.Add_Sheet(i_Name  => Ui.Current_Form_Name,
                       p_Table => a,
                       i_Param => Fazo.Zip_Map('period', i_Period).Json);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
    v_Staff_Ids  Array_Number;
  begin
    v_Staff_Ids := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
  
    for i in 1 .. v_Staff_Ids.Count
    loop
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Ids(i),
                                      i_All      => true,
                                      i_Self     => true,
                                      i_Direct   => true,
                                      i_Undirect => true);
    end loop;
  
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- style body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
    -- style missed mark
    b_Report.New_Style(i_Style_Name        => 'missed',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => 'bisque',
                       i_Font_Color        => '#9c6500');
  
    -- body centralized odd
    b_Report.New_Style(i_Style_Name        => 'body_even',
                       i_Parent_Style_Name => 'body_centralized',
                       i_Background_Color  => '#EAEAEA');
  
    Run_Marks(i_Company_Id   => v_Company_Id,
              i_Filial_Id    => v_Filial_Id,
              i_Period       => Nvl(p.o_Date('period'), Trunc(sysdate)),
              i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
              i_Job_Ids      => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
              i_Location_Ids => Nvl(p.o_Array_Number('location_ids'), Array_Number()),
              i_Staff_Ids    => v_Staff_Ids);
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
           Org_Unit_Id    = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
  end;

end Ui_Vhr475;
/
