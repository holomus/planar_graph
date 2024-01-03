create or replace package Ui_Vhr468 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Division_Groups return Fazo_Query;
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
  ----------------------------------------------------------------------------------------------------
  Function Check_Template_Filters(p Hashmap) return Hashmap;
end Ui_Vhr468;
/
create or replace package body Ui_Vhr468 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code   Md_User_Settings.Setting_Code%type := 'ui_vhr468:settings';
  g_Request_Styles Fazo.Varchar2_Id_Aat;

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
    return b.Translate('UI-VHR468:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Penalty_Id
  (
    i_Date        date,
    i_Division_Id number
  ) return number is
    v_Penalty_Id number;
  begin
    select q.Penalty_Id
      into v_Penalty_Id
      from Hpr_Penalties q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Month <= Trunc(i_Date, 'mon')
       and q.Division_Id = i_Division_Id
       and q.State = 'A'
     order by q.Month desc
     fetch first 1 Rows only;
  
    return v_Penalty_Id;
  exception
    when No_Data_Found then
      begin
        select q.Penalty_Id
          into v_Penalty_Id
          from Hpr_Penalties q
         where q.Company_Id = Ui.Company_Id
           and q.Filial_Id = Ui.Filial_Id
           and q.Month <= Trunc(i_Date, 'mon')
           and q.Division_Id is null
           and q.State = 'A'
         order by q.Month desc
         fetch first 1 Rows only;
      
        return v_Penalty_Id;
      
      exception
        when No_Data_Found then
          return null;
      end;
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
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
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
  
    q.Number_Field('employee_id', 'staff_id', 'org_unit_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
  
    v_Matrix := Href_Util.Staff_Kinds;
  
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap) is
    v_Preferences Hashmap := p;
    r_Setting     Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                                i_Filial_Id  => Ui.Filial_Id);
  begin
    if r_Setting.Position_Enable = 'N' then
      v_Preferences.Put('position', 'N');
    end if;
  
    if r_Setting.Advanced_Org_Structure = 'N' then
      v_Preferences.Put('org_unit', 'N');
    end if;
  
    Ui.User_Setting_Save(i_Setting_Code => g_Setting_Code, i_Setting_Value => v_Preferences.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Preferences return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => g_Setting_Code,
                                               i_Default_Value => '{}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    r_Setting Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id,
                                                            i_Filial_Id  => Ui.Filial_Id);
    result    Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('begin_date',
                            Trunc(sysdate, 'mon'),
                            'end_date',
                            Trunc(sysdate),
                            'position_enable',
                            r_Setting.Position_Enable));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Track_Type_Exist
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Id  number,
    i_Begin_Time date,
    i_End_Time   date
  ) return boolean is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Htt_Tracks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Person_Id = i_Person_Id
       and q.Track_Datetime between i_Begin_Time and i_End_Time
       and q.Track_Type = Htt_Pref.c_Track_Type_Check
       and q.Is_Valid = 'Y'
       and Rownum = 1;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Exist
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number,
    o_Row          out Htt_Requests%rowtype
  ) return boolean is
    v_Request_Id number;
  begin
    select s.Request_Id
      into v_Request_Id
      from Htt_Timesheet_Requests s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Timesheet_Id = i_Timesheet_Id
     order by s.Request_Id
     fetch first row only;
  
    o_Row := z_Htt_Requests.Load(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Request_Id => v_Request_Id);
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cache_Timesheet_Facts
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Leave_Id   number,
    i_Leave_Ids  Array_Number,
    p_Calc       in out nocopy Calc
  ) is
  begin
    for f in (select q.Timesheet_Date, q.Time_Kind_Id, Nvl(sum(q.Fact_Value), 0) as Fact_Value
                from (select q.Timesheet_Date,
                             Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) Time_Kind_Id,
                             Tf.Fact_Value
                        from Htt_Timesheets q
                        join Htt_Timesheet_Facts Tf
                          on Tf.Company_Id = i_Company_Id
                         and Tf.Filial_Id = i_Filial_Id
                         and Tf.Timesheet_Id = q.Timesheet_Id
                        join Htt_Time_Kinds Tk
                          on Tk.Company_Id = i_Company_Id
                         and Tk.Time_Kind_Id = Tf.Time_Kind_Id
                       where q.Company_Id = i_Company_Id
                         and q.Filial_Id = i_Filial_Id
                         and q.Staff_Id = i_Staff_Id
                         and q.Timesheet_Date between i_Begin_Date and i_End_Date
                         and not exists (select 1
                                from Hlic_Unlicensed_Employees Le
                               where Le.Company_Id = i_Company_Id
                                 and Le.Employee_Id = q.Employee_Id
                                 and Le.Licensed_Date = q.Timesheet_Date)) q
               group by q.Timesheet_Date, q.Time_Kind_Id)
    loop
      if f.Time_Kind_Id member of i_Leave_Ids then
        f.Time_Kind_Id := i_Leave_Id;
      end if;
    
      p_Calc.Plus(f.Timesheet_Date, f.Time_Kind_Id, f.Fact_Value);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Report_Time_Kind_Ids
  (
    i_Company_Id  number,
    o_Turnout_Id  out number,
    o_Lack_Id     out number,
    o_Late_Id     out number,
    o_Early_Id    out number,
    o_Leave_Id    out number,
    o_Overtime_Id out number,
    o_Free_Id     out number,
    o_Leave_Ids   out Array_Number
  ) is
  begin
    o_Turnout_Id  := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
    o_Lack_Id     := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
    o_Late_Id     := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
    o_Early_Id    := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early);
    o_Leave_Id    := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Leave);
    o_Overtime_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
    o_Free_Id     := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    select Tk.Time_Kind_Id
      bulk collect
      into o_Leave_Ids
      from Htt_Time_Kinds Tk
     where Tk.Company_Id = i_Company_Id
       and Tk.Pcode in (Htt_Pref.c_Pcode_Time_Kind_Leave,
                        Htt_Pref.c_Pcode_Time_Kind_Leave_Full,
                        Htt_Pref.c_Pcode_Time_Kind_Sick,
                        Htt_Pref.c_Pcode_Time_Kind_Trip,
                        Htt_Pref.c_Pcode_Time_Kind_Vacation);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Time_Kind_Style
  (
    i_Time_Kind_Id number,
    i_Bg_Color     varchar2,
    i_Color        varchar2
  ) return varchar2 is
    v_Style_Name varchar2(100);
  begin
    return g_Request_Styles(i_Time_Kind_Id);
  exception
    when No_Data_Found then
      v_Style_Name := 'time_kind' || i_Time_Kind_Id;
    
      b_Report.New_Style(i_Style_Name        => v_Style_Name,
                         i_Parent_Style_Name => 'body_centralized',
                         i_Font_Color        => i_Color,
                         i_Background_Color  => i_Bg_Color);
    
      g_Request_Styles(i_Time_Kind_Id) := v_Style_Name;
    
      return v_Style_Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Location_Names
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return varchar2 is
    v_Location_Names Array_Varchar2;
  begin
    select q.Name
      bulk collect
      into v_Location_Names
      from Htt_Locations q
     where q.Company_Id = i_Company_Id
       and q.State = 'A'
       and exists (select 1
              from Htt_Location_Persons w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = i_Filial_Id
               and w.Location_Id = q.Location_Id
               and w.Person_Id = i_Employee_Id
               and not exists (select 1
                      from Htt_Blocked_Person_Tracking Bp
                     where Bp.Company_Id = w.Company_Id
                       and Bp.Filial_Id = w.Filial_Id
                       and Bp.Employee_Id = w.Person_Id));
  
    return Fazo.Gather(v_Location_Names, ', ');
  exception
    when No_Data_Found then
      return '';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Has_Many_Robots
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date,
    i_End_Date     date
  ) return boolean is
    v_Count     number;
    v_Div_Count number := 0;
    v_Job_Count number := 0;
  begin
    if i_Division_Ids is not null then
      v_Div_Count := i_Division_Ids.Count;
    end if;
  
    if i_Job_Ids is not null then
      v_Job_Count := i_Job_Ids.Count;
    end if;
  
    select count(Ag.Period)
      into v_Count
      from (select p.Company_Id, p.Filial_Id, p.Trans_Id, p.Period
              from Hpd_Agreements p
             where p.Company_Id = i_Company_Id
               and p.Filial_Id = i_Filial_Id
               and p.Staff_Id = i_Staff_Id
               and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
               and p.Action = Hpd_Pref.c_Transaction_Action_Continue
               and p.Period <= i_End_Date
               and p.Period >= (select max(q.Period)
                                  from Hpd_Agreements q
                                 where q.Company_Id = i_Company_Id
                                   and q.Filial_Id = i_Filial_Id
                                   and q.Staff_Id = i_Staff_Id
                                   and q.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                                   and p.Action = Hpd_Pref.c_Transaction_Action_Continue
                                   and q.Period <= i_Begin_Date)) Ag
      join Hpd_Trans_Robots Tr
        on Tr.Company_Id = Ag.Company_Id
       and Tr.Filial_Id = Ag.Filial_Id
       and Tr.Trans_Id = Ag.Trans_Id
       and (v_Div_Count = 0 or Tr.Division_Id member of i_Division_Ids)
       and (v_Job_Count = 0 or Tr.Job_Id member of i_Job_Ids);
  
    if v_Count = 1 then
      return true;
    else
      return false;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Robot_Parts
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Division_Ids Array_Number := null,
    i_Job_Ids      Array_Number := null,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Robot_Id     number := null
  ) return Uit_Htt.Staff_Robot_Part_Nt is
    v_Timesheet_Part     Uit_Htt.Timesheet_Part_Rt;
    v_Timesheet_Parts    Uit_Htt.Timesheet_Part_Nt := Uit_Htt.Timesheet_Part_Nt();
    v_Staff_Robot_Part   Uit_Htt.Staff_Robot_Part_Rt;
    v_Staff_Robot_Parts  Uit_Htt.Staff_Robot_Part_Nt := Uit_Htt.Staff_Robot_Part_Nt();
    v_Robot_Ids          Array_Number;
    v_Division_Ids       Array_Number;
    v_Job_Ids            Array_Number;
    v_Begin_Dates        Array_Date;
    v_End_Dates          Array_Date;
    v_Division_Ids_Count number := 0;
    v_Job_Ids_Count      number := 0;
    v_Cache_Robot_Id     Fazo.Number_Code_Aat;
    v_Robot_Index        number;
  begin
    if i_Division_Ids is not null then
      v_Division_Ids_Count := i_Division_Ids.Count;
    end if;
  
    if i_Job_Ids is not null then
      v_Job_Ids_Count := i_Job_Ids.Count;
    end if;
  
    select Rb.Robot_Id, Rb.Division_Id, Rb.Job_Id, Rb.Period_Begin, Rb.Period_End
      bulk collect
      into v_Robot_Ids, v_Division_Ids, v_Job_Ids, v_Begin_Dates, v_End_Dates
      from (select q.Robot_Id,
                   q.Division_Id,
                   q.Job_Id,
                   Qr.Period Period_Begin,
                   Nvl(Lead(Qr.Period - 1) Over(order by Qr.Period), i_End_Date) Period_End
              from (select p.Company_Id, p.Filial_Id, p.Staff_Id, p.Period, p.Trans_Id
                      from Hpd_Agreements p
                     where p.Company_Id = i_Company_Id
                       and p.Filial_Id = i_Filial_Id
                       and p.Staff_Id = i_Staff_Id
                       and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                       and p.Period > i_Begin_Date
                       and p.Period <= i_End_Date
                    union
                    select p.Company_Id,
                           p.Filial_Id,
                           p.Staff_Id,
                           Greatest(max(p.Period), i_Begin_Date),
                           max(p.Trans_Id) Keep(Dense_Rank last order by p.Period) Trans_Id
                      from Hpd_Agreements p
                     where p.Company_Id = i_Company_Id
                       and p.Filial_Id = i_Filial_Id
                       and p.Staff_Id = i_Staff_Id
                       and p.Trans_Type = Hpd_Pref.c_Transaction_Type_Robot
                       and p.Period <= i_Begin_Date
                     group by p.Company_Id, p.Filial_Id, p.Staff_Id, p.Trans_Type) Qr
              join Hpd_Trans_Robots q
                on q.Company_Id = Qr.Company_Id
               and q.Filial_Id = Qr.Filial_Id
               and q.Trans_Id = Qr.Trans_Id
             order by Qr.Period) Rb
     where (i_Robot_Id is null or Rb.Robot_Id = i_Robot_Id)
       and (v_Job_Ids_Count = 0 or Rb.Job_Id member of i_Job_Ids)
       and (v_Division_Ids_Count = 0 or Rb.Division_Id member of i_Division_Ids);
  
    for i in 1 .. v_Robot_Ids.Count
    loop
      v_Staff_Robot_Part := Uit_Htt.Staff_Robot_Part_Rt();
      v_Timesheet_Part   := Uit_Htt.Timesheet_Part_Rt();
    
      begin
        v_Robot_Index := v_Cache_Robot_Id(v_Robot_Ids(i));
      
        v_Timesheet_Part.Begin_Date := v_Begin_Dates(i);
        v_Timesheet_Part.End_Date   := v_End_Dates(i);
      
        v_Staff_Robot_Part := v_Staff_Robot_Parts(v_Robot_Index);
        v_Timesheet_Parts  := v_Staff_Robot_Part.Parts;
      
        v_Timesheet_Parts.Extend();
        v_Timesheet_Parts(v_Timesheet_Parts.Count) := v_Timesheet_Part;
      
        v_Staff_Robot_Part.Parts := v_Timesheet_Parts;
        v_Staff_Robot_Parts(v_Robot_Index) := v_Staff_Robot_Part;
      exception
        when No_Data_Found then
          v_Staff_Robot_Part := Uit_Htt.Staff_Robot_Part_Rt();
          v_Timesheet_Parts  := Uit_Htt.Timesheet_Part_Nt();
        
          v_Staff_Robot_Part.Robot_Id    := v_Robot_Ids(i);
          v_Staff_Robot_Part.Division_Id := v_Division_Ids(i);
          v_Staff_Robot_Part.Job_Id      := v_Job_Ids(i);
        
          v_Timesheet_Part.Begin_Date := v_Begin_Dates(i);
          v_Timesheet_Part.End_Date   := v_End_Dates(i);
        
          v_Timesheet_Parts.Extend();
          v_Timesheet_Parts(v_Timesheet_Parts.Count) := v_Timesheet_Part;
        
          v_Staff_Robot_Part.Parts := v_Timesheet_Parts;
        
          v_Cache_Robot_Id(v_Robot_Ids(i)) := v_Staff_Robot_Part.Parts.Count;
        
          v_Staff_Robot_Parts.Extend();
          v_Staff_Robot_Parts(v_Staff_Robot_Parts.Count) := v_Staff_Robot_Part;
      end;
    end loop;
  
    return v_Staff_Robot_Parts;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timesheets
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) return Uit_Htt.Timesheet_Data_Nt is
    v_Timesheet_Datas Uit_Htt.Timesheet_Data_Nt := Uit_Htt.Timesheet_Data_Nt();
  begin
    select q.Company_Id,
           q.Filial_Id,
           q.Employee_Id,
           q.Timesheet_Id,
           q.Timesheet_Date,
           q.Schedule_Id,
           q.Calendar_Id,
           q.Day_Kind,
           q.Track_Duration,
           q.Count_Late,
           q.Count_Early,
           q.Count_Lack,
           q.Shift_Begin_Time,
           q.Shift_End_Time,
           q.Input_Border,
           q.Output_Border,
           q.Begin_Time,
           q.End_Time,
           q.Break_Enabled,
           q.Break_Begin_Time,
           q.Break_End_Time,
           q.Plan_Time,
           q.Full_Time,
           q.Input_Time,
           q.Output_Time,
           q.Planned_Marks,
           q.Done_Marks,
           Td.Time_Kind_Id,
           Nvl2(Td.Time_Kind_Id, 'Y', 'N') as Timeoff_Exists,
           Nvl((select 'N'
                 from Hlic_Unlicensed_Employees Le
                where Le.Company_Id = i_Company_Id
                  and Le.Employee_Id = i_Filial_Id
                  and Le.Licensed_Date = Dates.Date_Value),
               'Y') as Licensed,
           Dates.Date_Value
      bulk collect
      into v_Timesheet_Datas
      from (select i_Begin_Date + (level - 1) as Date_Value
              from Dual
            connect by level <= (i_End_Date - i_Begin_Date + 1)) Dates
      left join Htt_Timesheets q
        on q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and Dates.Date_Value = q.Timesheet_Date
      left join Hpd_Timeoff_Days Td
        on Td.Company_Id = i_Company_Id
       and Td.Filial_Id = i_Filial_Id
       and Td.Staff_Id = i_Staff_Id
       and Td.Timeoff_Date = q.Timesheet_Date
     order by Dates.Date_Value;
  
    return v_Timesheet_Datas;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number,
    i_Job_Ids      Array_Number,
    i_Location_Ids Array_Number,
    i_Staff_Ids    Array_Number
  ) is
    r_Setting           Hrm_Settings %rowtype := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id,
                                                                       i_Filial_Id  => i_Filial_Id);
    v_Settings          Hashmap := Load_Preferences;
    v_Show_Staff_Number varchar2(1) := Nvl(v_Settings.o_Varchar2('staff_number'), 'N');
  
    v_Show_Position                boolean := r_Setting.Position_Enable = 'Y' and
                                              Nvl(v_Settings.o_Varchar2('position'), 'N') = 'Y';
    v_Show_Job                     boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Rank                    boolean := Nvl(v_Settings.o_Varchar2('rank'), 'N') = 'Y';
    v_Show_Division                boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Org_Unit                boolean := Nvl(v_Settings.o_Varchar2('org_unit'), 'N') = 'Y';
    v_Show_Location                boolean := Nvl(v_Settings.o_Varchar2('location'), 'N') = 'Y';
    v_Show_Schedule                boolean := Nvl(v_Settings.o_Varchar2('schedule'), 'N') = 'Y';
    v_Show_Manager                 boolean := Nvl(v_Settings.o_Varchar2('manager'), 'N') = 'Y';
    v_Show_Input_Output            boolean := Nvl(v_Settings.o_Varchar2('input_output'), 'N') = 'Y';
    v_Show_Overtime                boolean := Nvl(v_Settings.o_Varchar2('overtime'), 'N') = 'Y';
    v_Show_Free_Time               boolean := Nvl(v_Settings.o_Varchar2('free_time'), 'N') = 'Y';
    v_Show_Fact_Time               boolean := Nvl(v_Settings.o_Varchar2('fact_time'), 'N') = 'Y';
    v_Show_Late_Time               boolean := Nvl(v_Settings.o_Varchar2('late_time'), 'N') = 'Y';
    v_Show_Early_Output            boolean := Nvl(v_Settings.o_Varchar2('early_output'), 'N') = 'Y';
    v_Show_Worked_Days             boolean := Nvl(v_Settings.o_Varchar2('worked_days'), 'N') = 'Y';
    v_Show_Minutes                 boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words           boolean := v_Show_Minutes and
                                              Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Check_Track                  boolean := Nvl(v_Settings.o_Varchar2('check_track'), 'N') = 'Y';
    v_Check_Track_Schedule         boolean := Nvl(v_Settings.o_Varchar2('check_track_schedule'),
                                                  'N') = 'Y';
    v_Show_Dismissed_And_Not_Hired boolean := Nvl(v_Settings.o_Varchar2('dismissed_and_not_hired'),
                                                  'N') = 'Y';
  
    v_Division_Group_Id number := v_Settings.o_Number('division_group_id');
    v_Date_Colspan      number := 1;
    v_Sysdate           date := Trunc(sysdate);
    v_Location_Count    number := i_Location_Ids.Count;
    v_Staff_Count       number := i_Staff_Ids.Count;
  
    v_Division_Names Array_Varchar2;
    v_Job_Names      Array_Varchar2;
    v_Location_Names Array_Varchar2;
  
    r_Request      Htt_Requests%rowtype;
    r_Request_Kind Htt_Request_Kinds%rowtype;
  
    a                  b_Table := b_Report.New_Table();
    v_Split_Horizontal number := 1;
    v_Split_Vertical   number := 5;
    v_Column           number := 1;
    v_Text             varchar2(100 char);
    v_Style            varchar2(100);
    v_Input_Time       varchar2(5);
    v_Output_Time      varchar2(5);
    v_No_Time          varchar2(5) := 'xx:xx';
    v_Track_Exists     boolean;
    v_Calc             Calc;
    v_Timesheet_Calc   Calc;
    v_Param            Hashmap;
    v_Staff_Param      Hashmap;
  
    v_User_Id               number := Ui.User_Id;
    v_Access_All_Employees  varchar2(1);
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    v_Late_Time        number;
    v_Early_Output     number;
    v_Lack_Time        number;
    v_Free_Time        number;
    v_Turnout_Time     number;
    v_Fact_Time        number;
    v_Daily_Hours_Time number;
    v_Turnout_Id       number;
    v_Overtime_Id      number;
    v_Free_Id          number;
    v_Lack_Id          number;
    v_Late_Id          number;
    v_Early_Id         number;
    v_Leave_Id         number;
    v_Leave_Ids        Array_Number;
  
    v_Nls_Language      varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Part_Begin_Date   date;
    v_Part_End_Date     date;
    v_Closest_Date      date;
    v_Closest_Rank_Id   number;
    v_Staff_Robot_Part  Uit_Htt.Staff_Robot_Part_Rt;
    v_Staff_Robot_Parts Uit_Htt.Staff_Robot_Part_Nt;
    v_Timesheet_Datas   Uit_Htt.Timesheet_Data_Nt;
    v_Timesheet_Data    Uit_Htt.Timesheet_Data_Rt;
  
    t_Not_Come     varchar2(50 char) := t('not come short');
    t_Rest_Day     varchar2(50 char) := t('rest day short');
    t_Not_Licensed varchar2(50 char) := t('not licensed short');
    t_Leave        varchar2(50 char) := t('leave');
    t_Dismissed    varchar2(50 char) := t('dismissed');
    t_Not_Hired    varchar2(50 char) := t('not hired');
    t_Transfer     varchar2(50 char) := t('transfer');
    v_Count        number := 1;
  
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
    Procedure Put_Time(i_Seconds number) is
    begin
      if v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Seconds_Text(i_Seconds, v_Show_Minutes, v_Show_Minutes_Words));
      else
        a.Data(Nullif(Round(i_Seconds / 3600, 2), 0));
      end if;
    end;
  
    --------------------------------------------------
    Procedure Add_Request
    (
      i_Timesheet_Id   number,
      i_Timesheet_Date date,
      i_Calendar_Id    number,
      i_Day_Kind       varchar2
    ) is
      r_Request      Htt_Requests%rowtype;
      r_Request_Kind Htt_Request_Kinds%rowtype;
      r_Time_Kind    Htt_Time_Kinds%rowtype;
    begin
      if Request_Exist(i_Company_Id   => i_Company_Id,
                       i_Filial_Id    => i_Filial_Id,
                       i_Timesheet_Id => i_Timesheet_Id,
                       o_Row          => r_Request) then
        if r_Request.Request_Id is not null then
          r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => r_Request.Company_Id,
                                                     i_Request_Kind_Id => r_Request.Request_Kind_Id);
        
          r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => r_Request.Company_Id,
                                               i_Time_Kind_Id => r_Request_Kind.Time_Kind_Id);
        
          if r_Request_Kind.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Calendar_Days or
             r_Request_Kind.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Work_Days and
             i_Day_Kind = Htt_Pref.c_Day_Kind_Work or
             r_Request_Kind.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Production_Days and
             not Htt_Util.Is_Official_Rest_Day(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Calendar_Id => i_Calendar_Id,
                                               i_Date        => i_Timesheet_Date) then
            if r_Request.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day then
              v_Text := v_Text || ' / ' || r_Time_Kind.Letter_Code;
            else
              v_Text := r_Time_Kind.Letter_Code;
            
              if v_Show_Input_Output and (v_Input_Time is not null or v_Output_Time is not null) then
                v_Text := v_Text || --
                          ' (' || Nvl(v_Input_Time, v_No_Time) || ' - ' ||
                          Nvl(v_Output_Time, v_No_Time) || ')';
              end if;
            end if;
          
            v_Style := Get_Time_Kind_Style(r_Time_Kind.Time_Kind_Id,
                                           r_Time_Kind.Bg_Color,
                                           r_Time_Kind.Color);
          end if;
        else
          v_Text  := v_Text || ' / ' || t_Leave;
          v_Style := 'warning';
        end if;
      end if;
    end;
  
    --------------------------------------------------
    Procedure Add_Timeoff(i_Timeoff_Tk_Id number) is
      r_Time_Kind Htt_Time_Kinds%rowtype;
    begin
      r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => i_Company_Id,
                                           i_Time_Kind_Id => i_Timeoff_Tk_Id);
      v_Text      := r_Time_Kind.Letter_Code;
    
      if v_Show_Input_Output and (v_Input_Time is not null or v_Output_Time is not null) then
        v_Text := v_Text || ' (' || Nvl(v_Input_Time, v_No_Time) || ' - ' ||
                  Nvl(v_Output_Time, v_No_Time) || ')';
      end if;
    
      v_Style := Get_Time_Kind_Style(r_Time_Kind.Time_Kind_Id,
                                     r_Time_Kind.Bg_Color,
                                     r_Time_Kind.Color);
    end;
  
    --------------------------------------------------
    Procedure Get_Calendar_Day_Style
    (
      i_Company_Id number,
      i_Pcode      varchar2
    ) is
      r_Time_Kind Htt_Time_Kinds%rowtype;
    begin
      r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => i_Company_Id,
                                           i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                                                   i_Pcode      => i_Pcode));
    
      v_Text  := r_Time_Kind.Letter_Code;
      v_Style := Get_Time_Kind_Style(r_Time_Kind.Time_Kind_Id,
                                     r_Time_Kind.Bg_Color,
                                     r_Time_Kind.Color);
    end;
  
    --------------------------------------------------
    Procedure Set_Rest_Day
    (
      i_Timesheet_Id   number,
      i_Timesheet_Date date,
      i_Calendar_Id    number,
      i_Day_Kind       varchar2,
      i_Timeoff_Exists varchar2,
      i_Timeoff_Tk_Id  number
    ) is
    begin
      if v_Show_Input_Output and (v_Input_Time is not null or v_Output_Time is not null) then
        v_Text := v_Text || --
                  ' (' || Nvl(v_Input_Time, v_No_Time) || ' - ' || Nvl(v_Output_Time, v_No_Time) || ')';
      
        v_Track_Exists := true;
      end if;
    
      if i_Timeoff_Exists = 'N' then
        Add_Request(i_Timesheet_Id   => i_Timesheet_Id,
                    i_Timesheet_Date => i_Timesheet_Date,
                    i_Calendar_Id    => i_Calendar_Id,
                    i_Day_Kind       => i_Day_Kind);
      else
        Add_Timeoff(i_Timeoff_Tk_Id);
      end if;
    
      v_Calc.Plus('free_time', v_Free_Time);
    
      if v_Track_Exists then
        a.Data(v_Text, v_Style, i_Param => v_Param.Json());
      else
        if v_Input_Time is not null or v_Output_Time is not null then
          a.Data(v_Text, v_Style, i_Param => v_Param.Json());
        else
          a.Data(v_Text, v_Style);
        end if;
      end if;
    end;
  
    --------------------------------------------------
    Function Calc_Fact_Time return number is
      result number := v_Calc.Get_Value('intime');
    begin
      return result + v_Calc.Get_Value('free_time');
    end;
  begin
    -- info
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
      v_Split_Vertical := v_Split_Vertical + 1;
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
      v_Split_Vertical := v_Split_Vertical + 1;
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
      v_Split_Vertical := v_Split_Vertical + 1;
    end if;
  
    a.New_Row;
    a.Data(t('period: $1 - $2',
             to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
             to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => 5);
  
    -- header
    a.Current_Style('header');
    a.New_Row;
    a.New_Row;
  
    Print_Header(t('order no'), 1, 2, 50);
  
    if v_Show_Staff_Number = 'Y' then
      Print_Header(t('staff number'), 1, 2, 100);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    Print_Header(t('name'), 1, 2, 200);
  
    if v_Show_Position then
      Print_Header(t('robot'), 1, 2, 150);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    if v_Show_Job then
      Print_Header(t('job'), 1, 2, 150);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    if v_Show_Rank then
      Print_Header(t('rank'), 1, 2, 150);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    if v_Show_Division then
      Print_Header(t('division'), 1, 2, 150);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    if r_Setting.Advanced_Org_Structure = 'Y' and v_Show_Org_Unit then
      Print_Header(t('org unit'), 1, 2, 150);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    if v_Show_Location then
      Print_Header(t('location'), 1, 2, 150);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    if v_Show_Schedule then
      Print_Header(t('schedule'), 1, 2, 150);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    if v_Show_Manager then
      Print_Header(t('manager'), 1, 2, 200);
      v_Split_Horizontal := v_Split_Horizontal + 1;
    end if;
  
    for i in 0 .. i_End_Date - i_Begin_Date
    loop
      Print_Header(to_char(i_Begin_Date + i, 'DD'), v_Date_Colspan, 1, 75);
    end loop;
  
    Print_Header(t('plan time'), 1, 2, 75);
  
    if v_Show_Late_Time then
      Print_Header(t('late input'), 1, 2, 75);
    end if;
  
    if v_Show_Early_Output then
      Print_Header(t('early time'), 1, 2, 75);
    end if;
  
    if v_Show_Fact_Time then
      Print_Header(t('fact time'), 1, 2, 75);
    end if;
  
    Print_Header(t('intime'), 1, 2, 75);
  
    if v_Show_Overtime then
      Print_Header(t('overtime'), 1, 2, 75);
    end if;
  
    if v_Show_Free_Time then
      Print_Header(t('free time'), 1, 2, 75);
    end if;
  
    Print_Header(t('leave and absence'), 2, 1, 150);
    Print_Header(t('total time'), 1, 2, 75);
  
    if v_Show_Worked_Days then
      Print_Header(t('worked days'), 1, 2, 75);
    end if;
  
    a.New_Row;
    for i in 0 .. i_End_Date - i_Begin_Date
    loop
      Print_Header(to_char(i_Begin_Date + i, 'Dy', v_Nls_Language), v_Date_Colspan, 1, null);
    end loop;
  
    Print_Header(t('leave time'), 1, 1, null);
    Print_Header(t('absence time'), 1, 1, null);
  
    -- body
    a.Current_Style('body_centralized');
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
    v_Param                := Hashmap();
  
    if v_Access_All_Employees = 'N' then
      v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                    i_Direct             => true,
                                                                    i_Indirect           => true,
                                                                    i_Manual             => true,
                                                                    i_Gather_Chiefs      => false);
    end if;
  
    Load_Report_Time_Kind_Ids(i_Company_Id  => i_Company_Id,
                              o_Turnout_Id  => v_Turnout_Id,
                              o_Lack_Id     => v_Lack_Id,
                              o_Late_Id     => v_Late_Id,
                              o_Early_Id    => v_Early_Id,
                              o_Leave_Id    => v_Leave_Id,
                              o_Overtime_Id => v_Overtime_Id,
                              o_Free_Id     => v_Free_Id,
                              o_Leave_Ids   => v_Leave_Ids);
  
    for r in (select q.*, w.Name, w.Gender
                from Href_Staffs q
                join Mr_Natural_Persons w
                  on w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Employee_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and (v_Staff_Count = 0 or q.Staff_Id member of i_Staff_Ids)
                 and q.Hiring_Date <= i_End_Date
                 and i_Begin_Date <= Nvl(q.Dismissal_Date, i_Begin_Date)
                 and q.State = 'A'
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
               order by Decode(v_Show_Staff_Number, 'Y', q.Staff_Number, null), Lower(w.Name))
    loop
      v_Timesheet_Calc := Calc();
      Cache_Timesheet_Facts(i_Company_Id => r.Company_Id,
                            i_Filial_Id  => r.Filial_Id,
                            i_Staff_Id   => r.Staff_Id,
                            i_Begin_Date => i_Begin_Date,
                            i_End_Date   => i_End_Date,
                            i_Leave_Id   => v_Leave_Id,
                            i_Leave_Ids  => v_Leave_Ids,
                            p_Calc       => v_Timesheet_Calc);
    
      v_Timesheet_Datas := Load_Timesheets(i_Company_Id => r.Company_Id,
                                           i_Filial_Id  => r.Filial_Id,
                                           i_Staff_Id   => r.Staff_Id,
                                           i_Begin_Date => i_Begin_Date,
                                           i_End_Date   => i_End_Date);
    
      v_Staff_Robot_Parts := Get_Staff_Robot_Parts(i_Company_Id   => r.Company_Id,
                                                   i_Filial_Id    => r.Filial_Id,
                                                   i_Staff_Id     => r.Staff_Id,
                                                   i_Division_Ids => i_Division_Ids,
                                                   i_Job_Ids      => i_Job_Ids,
                                                   i_Begin_Date   => i_Begin_Date,
                                                   i_End_Date     => i_End_Date);
    
      for j in 1 .. v_Staff_Robot_Parts.Count
      loop
        v_Calc             := Calc();
        v_Staff_Robot_Part := v_Staff_Robot_Parts(j);
        v_Closest_Date     := v_Staff_Robot_Part.Parts(v_Staff_Robot_Part.Parts.Count).End_Date;
      
        if v_Show_Rank then
          v_Closest_Rank_Id := Hpd_Util.Get_Closest_Rank_Id(i_Company_Id => r.Company_Id,
                                                            i_Filial_Id  => r.Filial_Id,
                                                            i_Staff_Id   => r.Staff_Id,
                                                            i_Period     => v_Closest_Date);
        end if;
      
        v_Param.Put('person_id', r.Employee_Id);
        v_Staff_Param := Fazo.Zip_Map('staff_id',
                                      r.Staff_Id,
                                      'begin_date',
                                      v_Staff_Robot_Part.Parts(1).Begin_Date,
                                      'end_date',
                                      v_Closest_Date,
                                      'division_id',
                                      v_Staff_Robot_Part.Division_Id,
                                      'job_id',
                                      v_Staff_Robot_Part.Job_Id,
                                      'rank_id',
                                      v_Closest_Rank_Id);
        v_Staff_Param.Put('robot_id', v_Staff_Robot_Part.Robot_Id);
      
        -- staff data    
        a.New_Row;
        a.Data(v_Count);
      
        v_Count := v_Count + 1;
      
        if v_Show_Staff_Number = 'Y' then
          a.Data(r.Staff_Number);
        end if;
      
        a.Data(r.Name, 'body middle', i_Param => v_Staff_Param.Json());
      
        if v_Show_Position then
          a.Data(z_Mrf_Robots.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Robot_Id => v_Staff_Robot_Part.Robot_Id).Name);
        end if;
      
        if v_Show_Job then
          a.Data(z_Mhr_Jobs.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Job_Id => v_Staff_Robot_Part.Job_Id).Name);
        end if;
      
        if v_Show_Rank then
          a.Data(z_Mhr_Ranks.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Rank_Id => v_Closest_Rank_Id).Name);
        end if;
      
        if v_Show_Division then
          a.Data(z_Mhr_Divisions.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Division_Id => v_Staff_Robot_Part.Division_Id).Name);
        end if;
      
        if r_Setting.Advanced_Org_Structure = 'Y' and v_Show_Org_Unit then
          a.Data(z_Mhr_Divisions.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Division_Id => r.Org_Unit_Id).Name);
        end if;
      
        if v_Show_Location then
          a.Data(Get_Location_Names(i_Company_Id  => r.Company_Id,
                                    i_Filial_Id   => r.Filial_Id,
                                    i_Employee_Id => r.Employee_Id));
        end if;
      
        if v_Show_Schedule then
          a.Data(z_Htt_Schedules.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, --
                 i_Schedule_Id => Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => r.Company_Id, --
                 i_Filial_Id => r.Filial_Id, i_Staff_Id => r.Staff_Id, i_Period => v_Closest_Date)).Name);
        end if;
      
        if v_Show_Manager then
          a.Data(Uit_Hrm.Get_Manager_Name(i_Company_Id        => r.Company_Id,
                                          i_Filial_Id         => r.Filial_Id,
                                          i_Division_Id       => v_Staff_Robot_Part.Division_Id,
                                          i_Division_Group_Id => v_Division_Group_Id));
        end if;
      
        for i in 1 .. v_Staff_Robot_Part.Parts.Count
        loop
          v_Part_Begin_Date := v_Staff_Robot_Part.Parts(i).Begin_Date;
          v_Part_End_Date   := v_Staff_Robot_Part.Parts(i).End_Date;
        
          if i = 1 and v_Part_Begin_Date - i_Begin_Date > 0 then
            for d in 0 .. v_Part_Begin_Date - i_Begin_Date - 1
            loop
              if v_Show_Dismissed_And_Not_Hired then
                if r.Hiring_Date > i_Begin_Date + d then
                  v_Text  := t_Not_Hired;
                  v_Style := 'not_hired';
                  a.Data(v_Text, v_Style);
                else
                  a.Data(t_Transfer);
                end if;
              elsif r.Hiring_Date < i_Begin_Date then
                a.Data(t_Transfer);
              else
                a.Add_Data(1);
              end if;
            end loop;
          end if;
        
          if i > 1 and v_Part_Begin_Date - v_Staff_Robot_Part.Parts(i - 1).End_Date > 0 then
            for d in 1 .. v_Part_Begin_Date - v_Staff_Robot_Part.Parts(i - 1).End_Date - 1
            loop
              a.Data(t_Transfer);
            end loop;
          end if;
        
          -- daily data
          for z in 0 .. v_Part_End_Date - v_Part_Begin_Date
          loop
            v_Timesheet_Data := v_Timesheet_Datas(v_Part_Begin_Date - i_Begin_Date + 1 + z);
          
            if v_Timesheet_Data.Company_Id is null then
              if v_Show_Dismissed_And_Not_Hired then
                if r.Dismissal_Date < v_Timesheet_Data.Date_Value then
                  v_Text  := t_Dismissed;
                  v_Style := 'dismissed';
                  a.Data(v_Text, v_Style);
                else
                  a.Add_Data(1);
                end if;
              else
                a.Add_Data(1);
              end if;
            
              continue;
            end if;
          
            if v_Timesheet_Data.Day_Kind in
               (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) then
              v_Calc.Plus('plan_time', v_Timesheet_Data.Plan_Time);
            end if;
          
            if v_Timesheet_Data.Licensed = 'N' then
              a.Data(t_Not_Licensed, 'not_licensed');
              continue;
            end if;
          
            v_Turnout_Time := v_Timesheet_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date,
                                                         v_Turnout_Id);
            v_Free_Time    := v_Timesheet_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Free_Id);
            v_Lack_Time    := v_Timesheet_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Lack_Id);
            v_Late_Time    := v_Timesheet_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Late_Id);
            v_Early_Output := v_Timesheet_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date,
                                                         v_Early_Id);
          
            v_Fact_Time        := v_Turnout_Time + v_Free_Time;
            v_Daily_Hours_Time := v_Turnout_Time; -- it is also may be v_fact_time
          
            v_Param.Put('track_date', v_Timesheet_Data.Timesheet_Date);
          
            v_Input_Time   := to_char(v_Timesheet_Data.Input_Time, Href_Pref.c_Time_Format_Minute);
            v_Output_Time  := to_char(v_Timesheet_Data.Output_Time, Href_Pref.c_Time_Format_Minute);
            v_Text         := null;
            v_Style        := null;
            v_Track_Exists := false;
          
            case v_Timesheet_Data.Day_Kind
              when Htt_Pref.c_Day_Kind_Work then
                if v_Daily_Hours_Time > 0 or v_Input_Time is not null or v_Output_Time is not null then
                  if v_Show_Input_Output and v_Input_Time is not null and v_Output_Time is not null then
                    v_Text := v_Input_Time || ' - ' || v_Output_Time;
                  elsif v_Daily_Hours_Time = 0 and v_Input_Time is not null and
                        v_Output_Time is null then
                    v_Text := Nvl(v_Input_Time, v_No_Time) || ' - ' ||
                              Nvl(v_Output_Time, v_No_Time);
                  end if;
                
                  if v_Daily_Hours_Time > 0 then
                    if v_Text is null then
                      v_Text := Htt_Util.To_Time_Seconds_Text(v_Daily_Hours_Time,
                                                              v_Show_Minutes,
                                                              v_Show_Minutes_Words);
                    else
                      v_Text := v_Text || ' (' ||
                                Htt_Util.To_Time_Seconds_Text(v_Daily_Hours_Time,
                                                              v_Show_Minutes,
                                                              v_Show_Minutes_Words) || ')';
                    end if;
                  end if;
                
                  if v_Daily_Hours_Time < v_Timesheet_Data.Plan_Time or
                     v_Check_Track and
                     not Check_Track_Type_Exist(i_Company_Id => v_Timesheet_Data.Company_Id,
                                                i_Filial_Id  => v_Timesheet_Data.Filial_Id,
                                                i_Person_Id  => v_Timesheet_Data.Employee_Id,
                                                i_Begin_Time => v_Timesheet_Data.Shift_Begin_Time,
                                                i_End_Time   => v_Timesheet_Data.Shift_End_Time) then
                    v_Style := 'warning';
                  end if;
                else
                  if v_Timesheet_Data.Timesheet_Date <= v_Sysdate then
                    v_Text  := t_Not_Come;
                    v_Style := 'danger';
                  end if;
                end if;
              
                if v_Timesheet_Data.Timeoff_Exists = 'N' then
                  Add_Request(i_Timesheet_Id   => v_Timesheet_Data.Timesheet_Id,
                              i_Timesheet_Date => v_Timesheet_Data.Timesheet_Date,
                              i_Calendar_Id    => v_Timesheet_Data.Calendar_Id,
                              i_Day_Kind       => v_Timesheet_Data.Day_Kind);
                else
                  Add_Timeoff(v_Timesheet_Data.Timeoff_Tk_Id);
                end if;
              
                if v_Check_Track_Schedule and v_Timesheet_Data.Planned_Marks > 0 then
                  v_Style := null;
                  v_Text  := t('$1/$2', v_Timesheet_Data.Done_Marks, v_Timesheet_Data.Planned_Marks);
                  if v_Timesheet_Data.Timesheet_Date <= v_Sysdate then
                    if v_Timesheet_Data.Done_Marks = 0 then
                      v_Style := 'danger';
                    elsif v_Timesheet_Data.Done_Marks < v_Timesheet_Data.Planned_Marks then
                      v_Style := 'warning';
                    else
                      v_Style := 'success';
                    end if;
                  end if;
                end if;
              
                a.Data(v_Text, v_Style, i_Param => v_Param.Json());
              
                v_Calc.Plus('intime', v_Turnout_Time);
                v_Calc.Plus('leave_time',
                            v_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Leave_Id));
                v_Calc.Plus('absence_time', v_Late_Time + v_Lack_Time + v_Early_Output);
                v_Calc.Plus('free_time', v_Free_Time);
              
                if v_Show_Late_Time then
                  v_Calc.Plus('late_time', v_Late_Time);
                end if;
              
                if v_Show_Early_Output then
                  v_Calc.Plus('early_output', v_Early_Output);
                end if;
              
                if v_Show_Worked_Days and
                   Nvl(v_Timesheet_Data.Input_Time, v_Timesheet_Data.Output_Time) is not null or
                   v_Turnout_Time > 0 then
                  v_Calc.Plus('worked_days', 1);
                end if;
              when Htt_Pref.c_Day_Kind_Rest then
                v_Text := t_Rest_Day;
              
                if v_Input_Time is not null and v_Output_Time is not null then
                  v_Style := 'warning';
                else
                  v_Style := 'rest';
                end if;
              
                Set_Rest_Day(i_Timesheet_Id   => v_Timesheet_Data.Timesheet_Id,
                             i_Timesheet_Date => v_Timesheet_Data.Timesheet_Date,
                             i_Calendar_Id    => v_Timesheet_Data.Calendar_Id,
                             i_Day_Kind       => v_Timesheet_Data.Day_Kind,
                             i_Timeoff_Exists => v_Timesheet_Data.Timeoff_Exists,
                             i_Timeoff_Tk_Id  => v_Timesheet_Data.Timeoff_Tk_Id);
              when Htt_Pref.c_Day_Kind_Nonworking then
                Get_Calendar_Day_Style(i_Company_Id => v_Timesheet_Data.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Nonworking);
                Set_Rest_Day(i_Timesheet_Id   => v_Timesheet_Data.Timesheet_Id,
                             i_Timesheet_Date => v_Timesheet_Data.Timesheet_Date,
                             i_Calendar_Id    => v_Timesheet_Data.Calendar_Id,
                             i_Day_Kind       => v_Timesheet_Data.Day_Kind,
                             i_Timeoff_Exists => v_Timesheet_Data.Timeoff_Exists,
                             i_Timeoff_Tk_Id  => v_Timesheet_Data.Timeoff_Tk_Id);
              when Htt_Pref.c_Day_Kind_Holiday then
                Get_Calendar_Day_Style(i_Company_Id => v_Timesheet_Data.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Holiday);
                Set_Rest_Day(i_Timesheet_Id   => v_Timesheet_Data.Timesheet_Id,
                             i_Timesheet_Date => v_Timesheet_Data.Timesheet_Date,
                             i_Calendar_Id    => v_Timesheet_Data.Calendar_Id,
                             i_Day_Kind       => v_Timesheet_Data.Day_Kind,
                             i_Timeoff_Exists => v_Timesheet_Data.Timeoff_Exists,
                             i_Timeoff_Tk_Id  => v_Timesheet_Data.Timeoff_Tk_Id);
              when Htt_Pref.c_Day_Kind_Additional_Rest then
                Get_Calendar_Day_Style(i_Company_Id => v_Timesheet_Data.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Additional_Rest);
                Set_Rest_Day(i_Timesheet_Id   => v_Timesheet_Data.Timesheet_Id,
                             i_Timesheet_Date => v_Timesheet_Data.Timesheet_Date,
                             i_Calendar_Id    => v_Timesheet_Data.Calendar_Id,
                             i_Day_Kind       => v_Timesheet_Data.Day_Kind,
                             i_Timeoff_Exists => v_Timesheet_Data.Timeoff_Exists,
                             i_Timeoff_Tk_Id  => v_Timesheet_Data.Timeoff_Tk_Id);
              else
                a.Data;
            end case;
          
            if v_Show_Overtime then
              v_Calc.Plus('overtime',
                          v_Timesheet_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Overtime_Id));
            end if;
          
            if v_Timesheet_Data.Day_Kind <> Htt_Pref.c_Day_Kind_Work then
              v_Calc.Plus('rest_free_time', v_Free_Time);
            end if;
          end loop;
        
          if i = v_Staff_Robot_Part.Parts.Count and i_End_Date - v_Part_End_Date > 0 then
            for d in 1 .. i_End_Date - v_Part_End_Date
            loop
              a.Data(t_Transfer);
            end loop;
          end if;
        end loop;
      
        Put_Time(v_Calc.Get_Value('plan_time'));
      
        if v_Show_Late_Time then
          Put_Time(v_Calc.Get_Value('late_time'));
        end if;
      
        if v_Show_Early_Output then
          Put_Time(v_Calc.Get_Value('early_output'));
        end if;
      
        if v_Show_Fact_Time then
          Put_Time(Calc_Fact_Time);
        end if;
      
        Put_Time(v_Calc.Get_Value('intime'));
      
        if v_Show_Overtime then
          Put_Time(v_Calc.Get_Value('overtime'));
        end if;
      
        if v_Show_Free_Time then
          Put_Time(v_Calc.Get_Value('free_time'));
        end if;
      
        Put_Time(v_Calc.Get_Value('leave_time'));
        Put_Time(v_Calc.Get_Value('absence_time'));
        Put_Time(v_Calc.Get_Value('intime') + v_Calc.Get_Value('leave_time') +
                 v_Calc.Get_Value('overtime'));
      
        if v_Show_Worked_Days then
          a.Data(Nullif(v_Calc.Get_Value('worked_days'), 0));
        end if;
      end loop;
    end loop;
  
    b_Report.Add_Sheet(i_Name             => Ui.Current_Form_Name,
                       p_Table            => a,
                       i_Param            => Fazo.Zip_Map('begin_date', i_Begin_Date,'end_date', i_End_Date).Json,
                       i_Split_Horizontal => v_Split_Horizontal,
                       i_Split_Vertical   => v_Split_Vertical);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Staff
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Begin_Date  date,
    i_End_Date    date,
    i_Robot_Id    number := null,
    i_Division_Id number := null,
    i_Job_Id      number := null,
    i_Rank_Id     number := null
  ) is
    r_Setting  Hrm_Settings %rowtype := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id,
                                                              i_Filial_Id  => i_Filial_Id);
    v_Settings Hashmap := Load_Preferences;
  
    v_Show_Position     boolean := r_Setting.Position_Enable = 'Y' and
                                   Nvl(v_Settings.o_Varchar2('position'), 'N') = 'Y';
    v_Show_Staff_Number boolean := Nvl(v_Settings.o_Varchar2('staff_number'), 'N') = 'Y';
    v_Show_Job          boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Rank         boolean := Nvl(v_Settings.o_Varchar2('rank'), 'N') = 'Y';
    v_Show_Division     boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Location     boolean := Nvl(v_Settings.o_Varchar2('location'), 'N') = 'Y';
    v_Show_Schedule     boolean := Nvl(v_Settings.o_Varchar2('schedule'), 'N') = 'Y';
    v_Show_Manager      boolean := Nvl(v_Settings.o_Varchar2('manager'), 'N') = 'Y';
    --
    v_Show_Late_Time       boolean := Nvl(v_Settings.o_Varchar2('late_time'), 'N') = 'Y';
    v_Show_Early_Output    boolean := Nvl(v_Settings.o_Varchar2('early_output'), 'N') = 'Y';
    v_Show_Overtime        boolean := Nvl(v_Settings.o_Varchar2('overtime'), 'N') = 'Y';
    v_Show_Free_Time       boolean := Nvl(v_Settings.o_Varchar2('free_time'), 'N') = 'Y';
    v_Show_Minutes         boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words   boolean := v_Show_Minutes and
                                      Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Check_Track          boolean := Nvl(v_Settings.o_Varchar2('check_track'), 'N') = 'Y';
    v_Check_Track_Schedule boolean := Nvl(v_Settings.o_Varchar2('check_track_schedule'), 'N') = 'Y';
  
    v_Division_Group_Id number := v_Settings.o_Number('division_group_id');
    v_Division_Ids      Array_Number;
    v_Job_Ids           Array_Number;
  
    r_Person Mr_Natural_Persons%rowtype;
    r_Staff  Href_Staffs%rowtype;
  
    a                b_Table := b_Report.New_Table();
    v_Split_Vertical number := 6;
    v_Column         number := 1;
    v_Fact_Colspan   number;
    v_Input_Time     varchar2(5);
    v_Output_Time    varchar2(5);
    v_No_Time        varchar2(5) := 'xx:xx';
    v_Style          varchar2(100);
    v_Sysdate        date := Trunc(sysdate);
    v_Calc           Calc := Calc();
    v_Param          Hashmap;
  
    v_Late_Time         number;
    v_Early_Output      number;
    v_Lack_Time         number;
    v_Overtime          number;
    v_Free_Time         number;
    v_Fact_Time         number;
    v_Leave_Time        number;
    v_Turnout_Time      number;
    v_Turnout_Id        number;
    v_Overtime_Id       number;
    v_Free_Id           number;
    v_Lack_Id           number;
    v_Late_Id           number;
    v_Early_Id          number;
    v_Leave_Id          number;
    v_Leave_Ids         Array_Number;
    v_Nls_Language      varchar2(100) := Uit_Href.Get_Nls_Language;
    v_Part_Begin_Date   date;
    v_Part_End_Date     date;
    v_Staff_Robot_Part  Uit_Htt.Staff_Robot_Part_Rt;
    v_Staff_Robot_Parts Uit_Htt.Staff_Robot_Part_Nt;
    v_Timesheet_Datas   Uit_Htt.Timesheet_Data_Nt;
    v_Timesheet_Data    Uit_Htt.Timesheet_Data_Rt;
  
    t_Not_Come_Male    varchar2(50 char) := t('not come male');
    t_Not_Come_Female  varchar2(50 char) := t('not come female');
    t_Rest_Day         varchar2(50 char) := t('rest day');
    t_Not_Licensed_Day varchar2(50 char) := t('not licensed day');
    t_Leave            varchar2(50 char) := t('leave');
  
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
    Procedure Put_Time(i_Seconds number) is
    begin
      if v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Seconds_Text(i_Seconds, v_Show_Minutes, v_Show_Minutes_Words));
      else
        a.Data(Nullif(Round(i_Seconds / 3600, 2), 0));
      end if;
    end;
  
    --------------------------------------------------
    Procedure Add_Request
    (
      i_Timesheet_Id   number,
      i_Timesheet_Date date,
      i_Calendar_Id    number,
      i_Day_Kind       varchar2
    ) is
      r_Request      Htt_Requests%rowtype;
      r_Request_Kind Htt_Request_Kinds%rowtype;
      r_Time_Kind    Htt_Time_Kinds%rowtype;
    begin
      if Request_Exist(i_Company_Id   => i_Company_Id,
                       i_Filial_Id    => i_Filial_Id,
                       i_Timesheet_Id => i_Timesheet_Id,
                       o_Row          => r_Request) then
        if r_Request.Request_Id is not null then
          r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => r_Request.Company_Id,
                                                     i_Request_Kind_Id => r_Request.Request_Kind_Id);
        
          r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => r_Request.Company_Id,
                                               i_Time_Kind_Id => r_Request_Kind.Time_Kind_Id);
        
          v_Style := Get_Time_Kind_Style(r_Time_Kind.Time_Kind_Id,
                                         r_Time_Kind.Bg_Color,
                                         r_Time_Kind.Color);
        
          if r_Request_Kind.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Calendar_Days or
             r_Request_Kind.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Work_Days and
             i_Day_Kind = Htt_Pref.c_Day_Kind_Work or
             r_Request_Kind.Day_Count_Type = Htt_Pref.c_Day_Count_Type_Production_Days and
             not Htt_Util.Is_Official_Rest_Day(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Calendar_Id => i_Calendar_Id,
                                               i_Date        => i_Timesheet_Date) then
            if r_Request.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day then
              a.Data(r_Time_Kind.Letter_Code || ' ' ||
                     Nvl(to_char(r_Request.Begin_Time, Href_Pref.c_Time_Format_Minute) || ' - ' ||
                         to_char(r_Request.End_Time, Href_Pref.c_Time_Format_Minute),
                         v_No_Time),
                     v_Style);
            else
              a.Data(r_Time_Kind.Name, v_Style);
            end if;
          else
            a.Data;
          end if;
        else
          a.Data(t_Leave, 'warning');
        end if;
      else
        a.Data;
      end if;
    end;
  
    --------------------------------------------------
    Procedure Add_Timeoff(i_Timeoff_Tk_Id number) is
      r_Time_Kind Htt_Time_Kinds%rowtype;
    begin
      r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => i_Company_Id,
                                           i_Time_Kind_Id => i_Timeoff_Tk_Id);
      v_Style     := Get_Time_Kind_Style(r_Time_Kind.Time_Kind_Id,
                                         r_Time_Kind.Bg_Color,
                                         r_Time_Kind.Color);
    
      a.Data(r_Time_Kind.Name, v_Style);
    end;
  
    --------------------------------------------------
    Procedure Set_Calendar_Day
    (
      i_Pcode     varchar2,
      i_Plan_Time varchar2 := null -- this is for non-working day
    ) is
      r_Time_Kind Htt_Time_Kinds%rowtype;
    begin
      r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => i_Company_Id,
                                           i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                                                                   i_Pcode      => i_Pcode));
    
      a.Data(r_Time_Kind.Name || case when i_Plan_Time is not null then '(' || i_Plan_Time || ')' else null end,
             Get_Time_Kind_Style(i_Time_Kind_Id => r_Time_Kind.Time_Kind_Id,
                                 i_Bg_Color     => r_Time_Kind.Bg_Color,
                                 i_Color        => r_Time_Kind.Color),
             i_Colspan => 3);
    end;
  
    --------------------------------------------------
    Function Calc_Fact_Time
    (
      i_Turnout   number,
      i_Free_Time number
    ) return number is
      result number := i_Turnout;
    begin
      return result + i_Free_Time;
    end;
  begin
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id);
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id,
                                          i_Person_Id  => r_Staff.Employee_Id);
  
    v_Param := Fazo.Zip_Map('person_id', r_Staff.Employee_Id);
  
    --info
    a.Current_Style('root bold');
    a.New_Row;
  
    if v_Show_Staff_Number then
      a.New_Row;
      a.Data(t('staff number: $1', r_Staff.Staff_Number), i_Colspan => 5);
      v_Split_Vertical := v_Split_Vertical + 1;
    end if;
  
    a.New_Row;
    a.Data(t('employee: $1', r_Person.Name), i_Colspan => 5);
  
    a.New_Row;
    a.Data(t('period: $1 - $2',
             to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
             to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => 5);
  
    if v_Show_Position then
      a.New_Row;
      a.Data(t('position: $1',
               z_Mrf_Robots.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Robot_Id => Nvl(i_Robot_Id, r_Staff.Robot_Id)).Name),
             i_Colspan => 5);
    end if;
  
    if v_Show_Job then
      a.New_Row;
      a.Data(t('job: $1',
               z_Mhr_Jobs.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Job_Id => Nvl(i_Job_Id, r_Staff.Job_Id)).Name),
             i_Colspan => 5);
    end if;
  
    if v_Show_Rank then
      a.New_Row;
      a.Data(t('rank: $1',
               z_Mhr_Ranks.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Rank_Id => i_Rank_Id).Name),
             i_Colspan => 5);
    end if;
  
    if v_Show_Division then
      a.New_Row;
      a.Data(t('division: $1',
               z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Division_Id => Nvl(i_Division_Id, r_Staff.Division_Id)).Name),
             i_Colspan => 5);
    end if;
  
    if v_Show_Location then
      a.New_Row;
      a.Data(t('location: $1',
               Get_Location_Names(i_Company_Id  => r_Staff.Company_Id,
                                  i_Filial_Id   => r_Staff.Filial_Id,
                                  i_Employee_Id => r_Staff.Employee_Id)),
             i_Colspan => 5);
    end if;
  
    if v_Show_Schedule then
      a.New_Row;
      a.Data(t('schedule: $1',
               z_Htt_Schedules.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Schedule_Id => r_Staff.Schedule_Id).Name),
             i_Colspan => 5);
    end if;
  
    if v_Show_Manager then
      a.New_Row;
      a.Data(t('manager: $1',
               Uit_Hrm.Get_Manager_Name(i_Company_Id        => i_Company_Id,
                                        i_Filial_Id         => i_Filial_Id,
                                        i_Division_Id       => Nvl(i_Division_Id, r_Staff.Division_Id),
                                        i_Division_Group_Id => v_Division_Group_Id)),
             i_Colspan => 5);
    end if;
  
    -- header
    a.Current_Style('header');
  
    a.New_Row;
    a.New_Row;
    Print_Header(t('date'), 1, 2, 100);
    Print_Header(t('day'), 1, 2, 50);
    Print_Header(t('plan'), 3, 1, 75);
    Print_Header(t('fact'), 3, 1, 75);
  
    if v_Check_Track_Schedule then
      Print_Header(t('track schedule'), 1, 2, 25);
    end if;
  
    Print_Header(t('leave'), 1, 2, 75);
  
    if v_Show_Late_Time then
      Print_Header(t('late input'), 1, 2, 75);
    end if;
  
    if v_Show_Early_Output then
      Print_Header(t('early time'), 1, 2, 75);
    end if;
  
    Print_Header(t('intime'), 1, 2, 75);
  
    if v_Show_Overtime then
      Print_Header(t('overtime'), 1, 2, 75);
    end if;
  
    if v_Show_Free_Time then
      Print_Header(t('free time'), 1, 2, 75);
    end if;
  
    Print_Header(t('leave and absence'), 2, 1, 75);
    Print_Header(t('total'), 1, 2, 75);
  
    a.New_Row;
  
    a.Data(t('input'));
    a.Data(t('output'));
    a.Data(t('plan_time'));
    --
    a.Data(t('input'));
    a.Data(t('output'));
    a.Data(t('fact time'));
    --
    a.Data(t('leave time'));
    a.Data(t('absence time'));
  
    -- body
    a.Current_Style('body_centralized');
  
    v_Fact_Colspan := v_Column - 6;
  
    Load_Report_Time_Kind_Ids(i_Company_Id  => i_Company_Id,
                              o_Turnout_Id  => v_Turnout_Id,
                              o_Lack_Id     => v_Lack_Id,
                              o_Late_Id     => v_Late_Id,
                              o_Early_Id    => v_Early_Id,
                              o_Leave_Id    => v_Leave_Id,
                              o_Overtime_Id => v_Overtime_Id,
                              o_Free_Id     => v_Free_Id,
                              o_Leave_Ids   => v_Leave_Ids);
  
    Cache_Timesheet_Facts(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => i_Filial_Id,
                          i_Staff_Id   => i_Staff_Id,
                          i_Begin_Date => i_Begin_Date,
                          i_End_Date   => i_End_Date,
                          i_Leave_Id   => v_Leave_Id,
                          i_Leave_Ids  => v_Leave_Ids,
                          p_Calc       => v_Calc);
  
    if i_Division_Id is not null then
      v_Division_Ids := Array_Number(i_Division_Id);
    end if;
  
    if i_Job_Id is not null then
      v_Job_Ids := Array_Number(i_Job_Id);
    end if;
  
    v_Staff_Robot_Parts := Get_Staff_Robot_Parts(i_Company_Id   => i_Company_Id,
                                                 i_Filial_Id    => i_Filial_Id,
                                                 i_Staff_Id     => r_Staff.Staff_Id,
                                                 i_Division_Ids => v_Division_Ids,
                                                 i_Job_Ids      => v_Job_Ids,
                                                 i_Begin_Date   => i_Begin_Date,
                                                 i_End_Date     => i_End_Date,
                                                 i_Robot_Id     => i_Robot_Id);
  
    v_Timesheet_Datas := Load_Timesheets(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Staff_Id   => r_Staff.Staff_Id,
                                         i_Begin_Date => i_Begin_Date,
                                         i_End_Date   => i_End_Date);
  
    v_Staff_Robot_Part := v_Staff_Robot_Parts(1);
  
    for j in 1 .. v_Staff_Robot_Part.Parts.Count
    loop
      v_Part_Begin_Date := v_Staff_Robot_Part.Parts(j).Begin_Date;
      v_Part_End_Date   := v_Staff_Robot_Part.Parts(j).End_Date;
    
      for d in 0 .. v_Part_End_Date - v_Part_Begin_Date
      loop
        v_Timesheet_Data := v_Timesheet_Datas(v_Part_Begin_Date - i_Begin_Date + d + 1);
      
        if v_Timesheet_Data.Company_Id is null then
          continue;
        end if;
      
        v_Style := null;
      
        v_Param.Put('track_date', v_Timesheet_Data.Timesheet_Date);
      
        v_Input_Time  := to_char(v_Timesheet_Data.Input_Time, Href_Pref.c_Time_Format_Minute);
        v_Output_Time := to_char(v_Timesheet_Data.Output_Time, Href_Pref.c_Time_Format_Minute);
      
        a.New_Row;
      
        if v_Timesheet_Data.Licensed = 'Y' and
           (v_Input_Time is not null or v_Output_Time is not null) then
          a.Data(to_char(v_Timesheet_Data.Timesheet_Date, 'dd/mm/yyyy'), i_Param => v_Param.Json());
        else
          a.Data(to_char(v_Timesheet_Data.Timesheet_Date, 'dd/mm/yyyy'));
        end if;
      
        a.Data(to_char(v_Timesheet_Data.Timesheet_Date, 'Dy', v_Nls_Language));
      
        -- plan
        case v_Timesheet_Data.Day_Kind
          when Htt_Pref.c_Day_Kind_Work then
            a.Data(to_char(v_Timesheet_Data.Begin_Time, Href_Pref.c_Time_Format_Minute));
            a.Data(to_char(v_Timesheet_Data.End_Time, Href_Pref.c_Time_Format_Minute));
            Put_Time(v_Timesheet_Data.Plan_Time);
          
            v_Calc.Plus('plan_time', v_Timesheet_Data.Plan_Time);
          when Htt_Pref.c_Day_Kind_Rest then
            if v_Input_Time is not null and v_Output_Time is not null then
              v_Style := 'warning';
            else
              v_Style := 'rest';
            end if;
          
            a.Data(t_Rest_Day, v_Style, i_Colspan => 3);
          when Htt_Pref.c_Day_Kind_Holiday then
            Set_Calendar_Day(Htt_Pref.c_Pcode_Time_Kind_Holiday);
          when Htt_Pref.c_Day_Kind_Additional_Rest then
            Set_Calendar_Day(Htt_Pref.c_Pcode_Time_Kind_Additional_Rest);
          when Htt_Pref.c_Day_Kind_Nonworking then
            Set_Calendar_Day(Htt_Pref.c_Pcode_Time_Kind_Nonworking,
                             Htt_Util.To_Time_Text(Round(v_Timesheet_Data.Plan_Time / 60, 2),
                                                   v_Show_Minutes));
          
            v_Calc.Plus('plan_time', v_Timesheet_Data.Plan_Time);
          else
            a.Add_Data(3);
        end case;
      
        -- fact
        if v_Timesheet_Data.Licensed = 'N' then
          a.Data(t_Not_Licensed_Day, 'not_licensed', i_Colspan => v_Fact_Colspan);
          continue;
        end if;
      
        v_Turnout_Time := v_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Turnout_Id);
        v_Overtime     := v_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Overtime_Id);
        v_Free_Time    := v_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Free_Id);
        v_Lack_Time    := v_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Lack_Id);
        v_Late_Time    := v_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Late_Id);
        v_Early_Output := v_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Early_Id);
        v_Leave_Time   := v_Calc.Get_Value(v_Timesheet_Data.Timesheet_Date, v_Leave_Id);
      
        v_Style     := null;
        v_Fact_Time := Calc_Fact_Time(i_Turnout => v_Turnout_Time, i_Free_Time => v_Free_Time);
      
        if v_Input_Time is not null or v_Output_Time is not null then
          if v_Timesheet_Data.Day_Kind = Htt_Pref.c_Day_Kind_Work and
             (v_Turnout_Time < v_Timesheet_Data.Plan_Time or
             v_Check_Track and
             not Check_Track_Type_Exist(i_Company_Id => v_Timesheet_Data.Company_Id,
                                         i_Filial_Id  => v_Timesheet_Data.Filial_Id,
                                         i_Person_Id  => v_Timesheet_Data.Employee_Id,
                                         i_Begin_Time => v_Timesheet_Data.Shift_Begin_Time,
                                         i_End_Time   => v_Timesheet_Data.Shift_End_Time)) then
            v_Style := 'warning';
          end if;
        
          a.Data(Nvl(v_Input_Time, v_No_Time), v_Style);
          a.Data(Nvl(v_Output_Time, v_No_Time), v_Style);
          a.Data(Htt_Util.To_Time_Seconds_Text(v_Fact_Time, v_Show_Minutes), v_Style);
        elsif v_Timesheet_Data.Day_Kind = Htt_Pref.c_Day_Kind_Work and
              v_Timesheet_Data.Timesheet_Date <= v_Sysdate then
          if r_Person.Gender = Md_Pref.c_Pg_Male then
            a.Data(t_Not_Come_Male, 'danger', i_Colspan => 3);
          else
            a.Data(t_Not_Come_Female, 'danger', i_Colspan => 3);
          end if;
        else
          a.Add_Data(3);
        end if;
      
        if v_Check_Track_Schedule then
          v_Style := null;
          if v_Timesheet_Data.Timesheet_Date <= v_Sysdate then
            if v_Timesheet_Data.Done_Marks = 0 then
              v_Style := 'danger';
            elsif v_Timesheet_Data.Done_Marks < v_Timesheet_Data.Planned_Marks then
              v_Style := 'warning';
            else
              v_Style := 'success';
            end if;
          end if;
          if v_Timesheet_Data.Planned_Marks > 0 then
            a.Data(t('$1/$2', v_Timesheet_Data.Done_Marks, v_Timesheet_Data.Planned_Marks),
                   v_Style);
          else
            a.Data;
          end if;
        end if;
      
        if v_Timesheet_Data.Timeoff_Exists = 'N' then
          Add_Request(i_Timesheet_Id   => v_Timesheet_Data.Timesheet_Id,
                      i_Timesheet_Date => v_Timesheet_Data.Timesheet_Date,
                      i_Calendar_Id    => v_Timesheet_Data.Calendar_Id,
                      i_Day_Kind       => v_Timesheet_Data.Day_Kind);
        else
          Add_Timeoff(v_Timesheet_Data.Timeoff_Tk_Id);
        end if;
      
        if v_Show_Late_Time then
          if v_Late_Time > 0 then
            Put_Time(v_Late_Time);
          else
            a.Data;
          end if;
        end if;
      
        if v_Show_Early_Output then
          if v_Early_Output > 0 then
            Put_Time(v_Early_Output);
          else
            a.Data;
          end if;
        end if;
      
        if v_Turnout_Time > 0 then
          Put_Time(v_Turnout_Time);
        else
          a.Data;
        end if;
      
        if v_Show_Overtime then
          if v_Overtime > 0 then
            Put_Time(v_Overtime);
          else
            a.Data;
          end if;
        end if;
      
        if v_Show_Free_Time then
          if v_Free_Time > 0 then
            Put_Time(v_Free_Time);
          else
            a.Data;
          end if;
        end if;
      
        if v_Leave_Time > 0 then
          Put_Time(v_Leave_Time);
        else
          a.Data;
        end if;
      
        if (v_Lack_Time + v_Late_Time + v_Early_Output) > 0 or v_Early_Output > 0 then
          Put_Time(v_Lack_Time + v_Late_Time + v_Early_Output);
        else
          a.Data;
        end if;
      
        a.Data(Htt_Util.To_Time_Seconds_Text(v_Turnout_Time + v_Leave_Time + v_Overtime,
                                             v_Show_Minutes,
                                             v_Show_Minutes_Words));
      
        -- calc total
        v_Calc.Plus('fact_time', v_Fact_Time);
      
        if v_Show_Late_Time then
          v_Calc.Plus('late_time', v_Late_Time);
        end if;
      
        if v_Show_Early_Output then
          v_Calc.Plus('early_output', v_Early_Output);
        end if;
      
        v_Calc.Plus('intime', v_Turnout_Time);
      
        if v_Show_Overtime then
          v_Calc.Plus('overtime', v_Overtime);
        end if;
      
        v_Calc.Plus('free_time', v_Free_Time);
        v_Calc.Plus('leave_time', v_Leave_Time);
        v_Calc.Plus('absence_time', v_Late_Time + v_Lack_Time + v_Early_Output);
        v_Calc.Plus('total', v_Turnout_Time + v_Leave_Time + v_Overtime);
      end loop;
    
      if v_Staff_Robot_Part.Parts.Count > j then
        a.New_Row;
        a.Data(t('transfer period'), 'transfer_period', i_Colspan => v_Column - 1);
      end if;
    end loop;
  
    a.Current_Style('footer');
  
    a.New_Row;
    a.Data(t('total'), 'footer right', i_Colspan => 4);
    Put_Time(v_Calc.Get_Value('plan_time'));
  
    a.Add_Data(2);
    Put_Time(v_Calc.Get_Value('fact_time'));
  
    if v_Check_Track_Schedule then
      a.Data;
    end if;
  
    a.Data();
    if v_Show_Late_Time then
      Put_Time(v_Calc.Get_Value('late_time'));
    end if;
  
    if v_Show_Early_Output then
      Put_Time(v_Calc.Get_Value('early_output'));
    end if;
  
    Put_Time(v_Calc.Get_Value('intime'));
  
    if v_Show_Overtime then
      Put_Time(v_Calc.Get_Value('overtime'));
    end if;
  
    if v_Show_Free_Time then
      Put_Time(v_Calc.Get_Value('free_time'));
    end if;
  
    Put_Time(v_Calc.Get_Value('leave_time'));
    Put_Time(v_Calc.Get_Value('absence_time'));
    Put_Time(v_Calc.Get_Value('total'));
  
    b_Report.Add_Sheet(i_Name           => Ui.Current_Form_Name,
                       p_Table          => a,
                       i_Split_Vertical => v_Split_Vertical);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Division_Id   number;
    v_Job_Id        number;
    v_Staff_Ids     Array_Number;
    v_Employee_Id   number;
    v_Employee_Name Md_Persons.Name%type;
    v_Param         Hashmap;
    v_Staff_Param   Hashmap;
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
  
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.r_Varchar2('cell_param'));
      if v_Param.Has('staff_id') then
        v_Staff_Param := Fazo.Zip_Map('staff_ids',
                                      v_Param.r_Number('staff_id'),
                                      'begin_date',
                                      v_Param.r_Date('begin_date'),
                                      'end_date',
                                      v_Param.r_Date('end_date'),
                                      'division_id',
                                      v_Param.r_Number('division_id'),
                                      'job_id',
                                      v_Param.r_Number('job_id'),
                                      'rank_id',
                                      v_Param.o_Number('rank_id'));
        v_Staff_Param.Put('robot_id', v_Param.r_Number('robot_id'));
      
        b_Report.Redirect_To_Report('/vhr/rep/htt/timesheet_with_transfer:run', v_Staff_Param);
      else
        b_Report.Redirect_To_Form('/vhr/htt/track_list', v_Param);
      end if;
    else
      if v_Staff_Ids.Count = 1 then
        v_Employee_Id   := z_Href_Staffs.Load(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id, i_Staff_Id => v_Staff_Ids(1)).Employee_Id;
        v_Employee_Name := ' (' || z_Md_Persons.Load(i_Company_Id => v_Company_Id, i_Person_Id => v_Employee_Id).Name || ')';
      end if;
    
      b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                     i_File_Name   => Ui.Current_Form_Name || v_Employee_Name);
    
      -- body centralized
      b_Report.New_Style(i_Style_Name        => 'body_centralized',
                         i_Parent_Style_Name => 'body',
                         i_Horizontal_Align  => b_Report.a_Center,
                         i_Vertical_Align    => b_Report.a_Middle);
      -- rest
      b_Report.New_Style(i_Style_Name        => 'rest',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Font_Color        => '#16365c',
                         i_Background_Color  => '#daeef3');
    
      -- warning
      b_Report.New_Style(i_Style_Name        => 'warning',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Background_Color  => '#ffeb9c',
                         i_Font_Color        => '#9c6500');
      -- danger
      b_Report.New_Style(i_Style_Name        => 'danger',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Background_Color  => '#ffc7ce',
                         i_Font_Color        => '#9c0006');
    
      -- success
      b_Report.New_Style(i_Style_Name        => 'success',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Background_Color  => '#c6efce',
                         i_Font_Color        => '#006100');
      -- not licensed
      b_Report.New_Style(i_Style_Name        => 'not_licensed',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Background_Color  => '#f18a97',
                         i_Font_Color        => '#1a0dab');
    
      -- dismissed
      b_Report.New_Style(i_Style_Name        => 'dismissed',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Background_Color  => '#ffffff',
                         i_Font_Color        => '#010b13');
    
      -- not_hired
      b_Report.New_Style(i_Style_Name        => 'not_hired',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Background_Color  => '#ffffff',
                         i_Font_Color        => '#010b13');
    
      -- transfer_period
      b_Report.New_Style(i_Style_Name        => 'transfer_period',
                         i_Parent_Style_Name => 'body_centralized',
                         i_Background_Color  => '#D5D5D5',
                         i_Font_Bold         => false);
    
      if p.o_Number('robot_id') is not null or
         (v_Staff_Ids.Count = 1 and
          Check_Has_Many_Robots(i_Company_Id   => v_Company_Id,
                                i_Filial_Id    => v_Filial_Id,
                                i_Staff_Id     => v_Staff_Ids(1),
                                i_Division_Ids => p.o_Array_Number('division_ids'),
                                i_Job_Ids      => p.o_Array_Number('job_ids'),
                                i_Begin_Date   => p.r_Date('begin_date'),
                                i_End_Date     => p.r_Date('end_date'))) then
        if p.o_Array_Number('division_ids') is not null and p.o_Array_Number('division_ids').Count = 1 then
          v_Division_Id := p.o_Array_Number('division_ids') (1);
        end if;
      
        if p.o_Array_Number('job_ids') is not null and p.o_Array_Number('job_ids').Count = 1 then
          v_Job_Id := p.o_Array_Number('job_ids') (1);
        end if;
      
        Run_Staff(i_Company_Id  => v_Company_Id,
                  i_Filial_Id   => v_Filial_Id,
                  i_Staff_Id    => v_Staff_Ids(1),
                  i_Begin_Date  => p.r_Date('begin_date'),
                  i_End_Date    => p.r_Date('end_date'),
                  i_Robot_Id    => p.o_Number('robot_id'),
                  i_Division_Id => Nvl(v_Division_Id, p.o_Number('division_id')),
                  i_Job_Id      => Nvl(v_Job_Id, p.o_Number('job_id')),
                  i_Rank_Id     => p.o_Number('rank_id'));
      else
        Run_All(i_Company_Id   => v_Company_Id,
                i_Filial_Id    => v_Filial_Id,
                i_Begin_Date   => Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon')),
                i_End_Date     => Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate))),
                i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
                i_Job_Ids      => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
                i_Location_Ids => Nvl(p.o_Array_Number('location_ids'), Array_Number()),
                i_Staff_Ids    => v_Staff_Ids);
      end if;
    
      b_Report.Close_Book();
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Template_Filters(p Hashmap) return Hashmap is
    v_Filial_Ids   Array_Number := p.o_Array_Number('filial_id');
    v_Job_Ids      Array_Number := p.o_Array_Number('job_id');
    v_Location_Ids Array_Number := p.o_Array_Number('location_id');
    v_Staff_Ids    Array_Number := p.o_Array_Number('staff_id');
    v_Matrix       Matrix_Varchar2;
    v_Filial_Id    number;
    v_Min_Date     date := p.r_Date('min_date');
    v_Max_Date     date := p.r_Date('max_date');
    result         Hashmap := Hashmap();
  begin
    if not Ui.Is_Filial_Head then
      v_Filial_Id := Ui.Filial_Id;
    end if;
  
    select Array_Varchar2(q.Filial_Id, q.Name)
      bulk collect
      into v_Matrix
      from Md_Filials q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id member of v_Filial_Ids
       and q.State = 'A';
  
    Result.Put('filials', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Job_Id, q.Name)
      bulk collect
      into v_Matrix
      from Mhr_Jobs q
     where q.Company_Id = Ui.Company_Id
       and (v_Filial_Id is null or q.Filial_Id = v_Filial_Id)
       and q.Job_Id member of v_Job_Ids
       and q.State = 'A';
  
    Result.Put('jobs', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Location_Id, q.Name)
      bulk collect
      into v_Matrix
      from Htt_Locations q
     where q.Company_Id = Ui.Company_Id
       and q.Location_Id member of v_Location_Ids
       and q.State = 'A'
       and exists (select 1
              from Htt_Location_Filials Lf
             where Lf.Company_Id = Ui.Company_Id
               and (v_Filial_Id is null or Lf.Filial_Id = v_Filial_Id)
               and Lf.Location_Id = q.Location_Id);
  
    Result.Put('locations', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(w.Staff_Id,
                          (select w.Name
                             from Mr_Natural_Persons w
                            where w.Company_Id = Ui.Company_Id
                              and w.Person_Id = w.Employee_Id))
      bulk collect
      into v_Matrix
      from Href_Staffs w
     where w.Company_Id = Ui.Company_Id
       and (v_Filial_Id is null or w.Filial_Id = v_Filial_Id)
       and w.Staff_Id member of v_Staff_Ids
       and w.Hiring_Date <= v_Max_Date
       and (w.Dismissal_Date is null or w.Dismissal_Date >= v_Min_Date)
       and w.State = 'A'
       and exists (select 1
              from Mhr_Employees e
             where e.Company_Id = Ui.Company_Id
               and e.Filial_Id = w.Filial_Id
               and e.Employee_Id = w.Employee_Id
               and e.State = 'A');
  
    Result.Put('staffs', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Staff_Kind     = null,
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
    update Mhr_Division_Groups
       set Company_Id        = null,
           Division_Group_Id = null,
           name              = null,
           State             = null;
  end;

end Ui_Vhr468;
/
