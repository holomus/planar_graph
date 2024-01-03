create or replace package Ui_Vhr101 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Groups return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Filials return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Telegram_Staffs return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Time_Kinds return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Telegram_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Run_Telegram(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Check_Template_Filters(p Hashmap) return Hashmap;
end Ui_Vhr101;
/
create or replace package body Ui_Vhr101 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code   Md_User_Settings.Setting_Code%type := 'ui_vhr101:settings';
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
    return b.Translate('UI-VHR101:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Penalty_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Date        date,
    i_Division_Id number
  ) return number is
    v_Penalty_Id number;
  begin
    select q.Penalty_Id
      into v_Penalty_Id
      from Hpr_Penalties q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
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
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
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
  Function Query_Filials return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select p.*
                       from md_filials p
                      where p.company_id = :company_id
                        and p.filial_id <> :filial_head
                        and p.state = :state',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_head',
                                 Ui.Filial_Head,
                                 'state',
                                 'A'));
  
    q.Number_Field('filial_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query is
    v_Param Hashmap := Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A');
    q       Fazo_Query;
  begin
    if not Ui.Is_Filial_Head then
      v_Param.Put('filial_id', Ui.Filial_Id);
    end if;
  
    q := Fazo_Query('mhr_jobs', v_Param, true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query is
    v_Query varchar2(32767);
    v_Param Hashmap := Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A');
    q       Fazo_Query;
  begin
    v_Query := 'select q.location_id, q.name
                  from htt_locations q
                 where q.company_id = :company_id
                   and q.state = :state';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || ' and exists (select 1
                             from htt_location_filials w
                            where w.company_id = q.company_id
                              and w.filial_id = :filial_id
                              and w.location_id = q.location_id) ';
    
      v_Param.Put('filial_id', Ui.Filial_Id);
    end if;
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('location_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Param  Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'min_date',
                            p.r_Date('begin_date'),
                            'max_date',
                            p.r_Date('end_date'));
  
    v_Query := 'select *
                  from href_staffs w
                 where w.company_id = :company_id
                   and w.hiring_date <= :max_date
                   and (w.dismissal_date is null or
                       w.dismissal_date >= :min_date)
                   and w.state = ''A''
                   and exists (select 1
                          from mhr_employees e
                         where e.company_id = :company_id
                           and e.filial_id = w.filial_id
                           and e.employee_id = w.employee_id
                           and e.state = ''A'')';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || ' and w.filial_id = :filial_id ';
    
      v_Param.Put('filial_id', Ui.Filial_Id);
    end if;
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('employee_id', 'staff_id', 'division_id');
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
  Function Query_Telegram_Staffs return Fazo_Query is
    v_Query varchar2(32767);
    q       Fazo_Query;
  begin
    v_Query := 'select w.company_id,
                       w.filial_id,
                       w.staff_id code,
                       w.employee_id,
                       w.division_id,
                       w.org_unit_id
                  from href_staffs w
                 where w.company_id = :company_id
                   and w.filial_id = :filial_id
                   and w.state = ''A''';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query, Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('employee_id');
    q.Varchar2_Field('code');
  
    q.Map_Field('title',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
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
    if not Ui.Is_Filial_Head then
      -- divisions are used in the model only when the report is opened in non-head filial
      Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    end if;
  
    Result.Put('data',
               Fazo.Zip_Map('begin_date', Trunc(sysdate, 'mon'), 'end_date', Trunc(sysdate)));
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Telegram_Model return Hashmap is
    v_Filters Arraylist := Arraylist();
  begin
    Ktb_Util.Add_Date_Range_Filter(p               => v_Filters,
                                   i_Code          => 'begin_end',
                                   i_Title         => t('range date'),
                                   i_Begin_Keyword => 'begin_date',
                                   i_End_Keyword   => 'end_date',
                                   i_Button_Title  => t('select range'));
    Ktb_Util.Add_Multi_Select_Filter(p              => v_Filters,
                                     i_Code         => 'staff_ids',
                                     i_Title        => t('staffs'),
                                     i_Button_Title => t('select staffs'),
                                     i_Action       => ':query_telegram_staffs');
  
    return Ktb_Util.Build_Model(i_Action  => ':run_telegram',
                                i_Title   => t('report attendence'),
                                i_Filters => v_Filters);
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
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number,
    i_Begin_Date    date,
    i_End_Date      date,
    i_Leave_Key     varchar2,
    i_Leave_Ids     Array_Number,
    i_Time_Kind_Ids Array_Number,
    i_Leave_By_Coef varchar2,
    p_Calc          in out nocopy Calc
  ) is
  begin
    for f in (select q.Timesheet_Date, q.Time_Kind_Id, Nvl(sum(q.Fact_Value), 0) as Fact_Value
                from (select q.Timesheet_Date,
                             case
                                when Tk.Time_Kind_Id member of i_Time_Kind_Ids then
                                 Tk.Time_Kind_Id
                                else
                                 Nvl(Tk.Parent_Id, Tk.Time_Kind_Id)
                              end Time_Kind_Id,
                             case
                                when i_Leave_By_Coef = 'Y' and --
                                     Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) member of i_Leave_Ids then
                                 Tf.Fact_Value * Nvl(Tk.Timesheet_Coef, 0)
                                else
                                 Tf.Fact_Value
                              end as Fact_Value
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
        p_Calc.Plus(f.Timesheet_Date, i_Leave_Key, f.Fact_Value);
      end if;
    
      p_Calc.Plus(f.Timesheet_Date, f.Time_Kind_Id, f.Fact_Value);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Plan_Time
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Staff_Id       number,
    i_Hiring_Date    date,
    i_Dismissal_Date date,
    i_Robot_Id       number,
    i_Schedule_Id    number,
    i_Begin_Date     date,
    i_End_Date       date
  ) return number is
    v_Robot_Schedule_Id number := Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                                                       i_Filial_Id  => i_Filial_Id,
                                                       i_Pcode      => Htt_Pref.c_Pcode_Individual_Robot_Schedule);
    v_Staff_Schedule_Id number := Htt_Util.Schedule_Id(i_Company_Id => i_Company_Id,
                                                       i_Filial_Id  => i_Filial_Id,
                                                       i_Pcode      => Htt_Pref.c_Pcode_Individual_Staff_Schedule);
    v_Robot_Id          number;
    v_Schedule_Id       number;
    result              number := 0;
  
    --------------------------------------------------
    Procedure Plan_Time
    (
      i_Begin_Date  date,
      i_End_Date    date,
      i_Schedule_Id number,
      i_Robot_Id    number
    ) is
      v_Plan_Time number;
    begin
      if i_Schedule_Id = v_Robot_Schedule_Id then
        select sum(q.Plan_Time)
          into v_Plan_Time
          from Htt_Robot_Schedule_Days q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Robot_Id = i_Robot_Id
           and q.Schedule_Date between i_Begin_Date and i_End_Date;
      elsif i_Schedule_Id = v_Staff_Schedule_Id then
        select sum(q.Plan_Time)
          into v_Plan_Time
          from Htt_Staff_Schedule_Days q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Staff_Id = i_Staff_Id
           and q.Schedule_Date between i_Begin_Date and i_End_Date;
      else
        select sum(q.Plan_Time)
          into v_Plan_Time
          from Htt_Schedule_Days q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Schedule_Id = i_Schedule_Id
           and q.Schedule_Date between i_Begin_Date and i_End_Date;
      end if;
    
      result := result + 60 * Nvl(v_Plan_Time, 0);
    end;
  begin
    if i_Hiring_Date > i_Begin_Date then
      v_Schedule_Id := Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => i_Company_Id,
                                                        i_Filial_Id  => i_Filial_Id,
                                                        i_Staff_Id   => i_Staff_Id,
                                                        i_Period     => i_Hiring_Date);
    
      v_Robot_Id := Hpd_Util.Get_Closest_Robot_Id(i_Company_Id => i_Company_Id,
                                                  i_Filial_Id  => i_Filial_Id,
                                                  i_Staff_Id   => i_Staff_Id,
                                                  i_Period     => i_Hiring_Date);
    
      if v_Schedule_Id is not null then
        Plan_Time(i_Begin_Date  => i_Begin_Date,
                  i_End_Date    => i_Hiring_Date - 1,
                  i_Schedule_Id => v_Schedule_Id,
                  i_Robot_Id    => v_Robot_Id);
      end if;
    end if;
  
    if i_Dismissal_Date < i_End_Date then
      Plan_Time(i_Begin_Date  => i_Dismissal_Date + 1,
                i_End_Date    => i_End_Date,
                i_Schedule_Id => i_Schedule_Id,
                i_Robot_Id    => i_Robot_Id);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Report_Time_Kind_Ids
  (
    i_Company_Id       number,
    o_Turnout_Id       out number,
    o_Lack_Id          out number,
    o_Late_Id          out number,
    o_Early_Id         out number,
    o_Overtime_Id      out number,
    o_Free_Id          out number,
    o_Beforework_Id    out number,
    o_Afterwork_Id     out number,
    o_Lunchtime_Id     out number,
    o_Leave_Ids        out Array_Number,
    o_Unaggregated_Ids out Array_Number
  ) is
  begin
    o_Turnout_Id    := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Turnout);
    o_Lack_Id       := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lack);
    o_Late_Id       := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
    o_Early_Id      := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Early);
    o_Overtime_Id   := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Overtime);
    o_Free_Id       := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
    o_Beforework_Id := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work);
    o_Afterwork_Id  := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work);
    o_Lunchtime_Id  := Htt_Util.Time_Kind_Id(i_Company_Id => i_Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime);
  
    o_Unaggregated_Ids := Array_Number(o_Beforework_Id, o_Afterwork_Id, o_Lunchtime_Id);
  
    select Tk.Time_Kind_Id
      bulk collect
      into o_Leave_Ids
      from Htt_Time_Kinds Tk
     where Tk.Company_Id = i_Company_Id
       and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) in
           (select q.Time_Kind_Id
              from Htt_Time_Kinds q
             where q.Company_Id = i_Company_Id
               and q.Pcode in (Htt_Pref.c_Pcode_Time_Kind_Leave,
                               Htt_Pref.c_Pcode_Time_Kind_Leave_Full,
                               Htt_Pref.c_Pcode_Time_Kind_Sick,
                               Htt_Pref.c_Pcode_Time_Kind_Trip,
                               Htt_Pref.c_Pcode_Time_Kind_Vacation));
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
                       and Bp.Employee_Id = w.Person_Id))
       and Rownum <= 4;
  
    if v_Location_Names.Count = 4 then
      v_Location_Names(4) := '...';
    end if;
  
    return Fazo.Gather(v_Location_Names, ', ');
  
  exception
    when No_Data_Found then
      return '';
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Calc_Track_Schedule_Times
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timesheet_Id number
  ) return number is
    v_Track_Schedule_Time number := 0;
    v_Track_Type_Index    number := 1;
    v_Start_Time          date;
    v_Track_Type_Output   varchar2(1) := Htt_Pref.c_Track_Type_Output;
    v_Track_Type_Input    varchar2(1) := Htt_Pref.c_Track_Type_Input;
    v_Track_Type_Check    varchar2(1) := Htt_Pref.c_Track_Type_Check;
    v_Track_Type          varchar2(1) := v_Track_Type_Output;
    v_Track_Types         Array_Varchar2;
    v_Track_Times         Array_Date;
  begin
    -- Gathering all tracks and track times in the timesheet
    select q.Track_Type, q.Track_Datetime
      bulk collect
      into v_Track_Types, v_Track_Times
      from Htt_Timesheet_Tracks q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Timesheet_Id = i_Timesheet_Id
       and q.Track_Type <> v_Track_Type_Check
     order by q.Track_Datetime;
  
    -- Calculate all times of timesheet mark which is not done
    for r in (select q.*
                from Htt_Timesheet_Marks q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Timesheet_Id = i_Timesheet_Id
               order by q.Begin_Time)
    loop
      if r.Done = 'N' then
        v_Start_Time := r.Begin_Time;
      
        for x in v_Track_Type_Index .. v_Track_Types.Count
        loop
          if v_Start_Time > r.End_Time then
            -- All mark dates are sorted by begin date. 
            -- That is why should not begin from first index in every one.
            -- We should save last index of track which we use
            v_Track_Type_Index := Greatest(x - 2, 1);
            v_Track_Type       := v_Track_Type_Output;
            exit;
          end if;
        
          -- Track type in begin part of mark equal to track type of last track befor it 
          if v_Track_Times(x) <= r.Begin_Time then
            v_Track_Type := v_Track_Types(x);
          else
            if v_Track_Type <> v_Track_Types(x) then
              if v_Track_Type = v_Track_Type_Input then
                v_Track_Schedule_Time := v_Track_Schedule_Time +
                                         (Least(v_Track_Times(x), r.End_Time) - v_Start_Time) *
                                         86400;
                v_Track_Type          := v_Track_Types(x);
                v_Start_Time          := v_Track_Times(x);
              else
                v_Track_Type := v_Track_Types(x);
                v_Start_Time := v_Track_Times(x);
              end if;
            end if;
          end if;
        end loop;
      end if;
    end loop;
  
    return v_Track_Schedule_Time;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Color_Info return b_Table is
    v_Colspan_Text number := 8;
    Info           b_Table := b_Report.New_Table();
  begin
  
    -- Color infos
    Info.New_Row;
  
    Info.Current_Style('rest');
    Info.New_Row;
    Info.Data('', i_Colspan => 1);
    Info.Current_Style('');
    Info.Data(t('when day is rest day'), i_Colspan => v_Colspan_Text);
  
    Info.Current_Style('warning');
    Info.New_Row;
    Info.Data('', i_Colspan => 1);
    Info.Current_Style('');
    Info.Data(t('when daily hour time less than plan time OR when check track is ON and not exists check track OR when planned marks count more than done marks count'),
              i_Colspan => v_Colspan_Text);
  
    Info.Current_Style('warning');
    Info.New_Row;
    Info.Data('В', i_Colspan => 1);
    Info.Current_Style('');
    Info.Data(t('when in rest day have input time and output time'), i_Colspan => v_Colspan_Text);
  
    Info.Current_Style('danger');
    Info.New_Row;
    Info.Data('', i_Colspan => 1);
    Info.Current_Style('');
    Info.Data(t('when there is no input and output times for the previous day OR when done marks count equal zero'),
              i_Colspan => v_Colspan_Text);
  
    Info.Current_Style('success');
    Info.New_Row;
    Info.Data('', i_Colspan => 1);
    Info.Current_Style('');
    Info.Data(t('when done marks count more than planned marks count'),
              i_Colspan => v_Colspan_Text);
  
    Info.Current_Style('not_licensed');
    Info.New_Row;
    Info.Data('', i_Colspan => 1);
    Info.Current_Style('');
    Info.Data(t('when not license day'), i_Colspan => v_Colspan_Text);
  
    Info.Current_Style('dismissed');
    Info.New_Row;
    Info.Data('', i_Colspan => 1);
    Info.Current_Style('');
    Info.Data(t('when dismissed or not hired'), i_Colspan => v_Colspan_Text);
  
    return Info;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_All
  (
    i_Company_Id   number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Filial_Ids   Array_Number,
    i_Division_Ids Array_Number,
    i_Job_Ids      Array_Number,
    i_Location_Ids Array_Number,
    i_Staff_Ids    Array_Number
  ) is
    v_Settings Hashmap := Load_Preferences;
  
    v_Show_Staff_Number varchar2(1) := Nvl(v_Settings.o_Varchar2('staff_number'), 'N');
    v_Leave_By_Coef     varchar2(1) := Nvl(v_Settings.o_Varchar2('show_leave_by_coef'), 'N');
  
    v_Show_Filial                    boolean := Nvl(v_Settings.o_Varchar2('filial'), 'N') = 'Y';
    v_Show_Job                       boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Rank                      boolean := Nvl(v_Settings.o_Varchar2('rank'), 'N') = 'Y';
    v_Show_Division                  boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Location                  boolean := Nvl(v_Settings.o_Varchar2('location'), 'N') = 'Y';
    v_Show_Schedule                  boolean := Nvl(v_Settings.o_Varchar2('schedule'), 'N') = 'Y';
    v_Show_Manager                   boolean := Nvl(v_Settings.o_Varchar2('manager'), 'N') = 'Y';
    v_Show_Input_Output              boolean := Nvl(v_Settings.o_Varchar2('input_output'), 'N') = 'Y';
    v_Show_Overtime                  boolean := Nvl(v_Settings.o_Varchar2('overtime'), 'N') = 'Y';
    v_Show_Free_Time                 boolean := Nvl(v_Settings.o_Varchar2('free_time'), 'N') = 'Y';
    v_Show_Fact_Time                 boolean := Nvl(v_Settings.o_Varchar2('fact_time'), 'N') = 'Y';
    v_Show_Late_Time                 boolean := Nvl(v_Settings.o_Varchar2('late_time'), 'N') = 'Y';
    v_Show_Daily_Leave_Time          boolean := Nvl(v_Settings.o_Varchar2('daily_leave_time'), 'N') = 'Y';
    v_Show_Early_Output              boolean := Nvl(v_Settings.o_Varchar2('early_output'), 'N') = 'Y';
    v_Show_Worked_Coef               boolean := Nvl(v_Settings.o_Varchar2('worked_coef'), 'N') = 'Y';
    v_Show_Fact_Coef                 boolean := Nvl(v_Settings.o_Varchar2('fact_coef'), 'N') = 'Y';
    v_Show_Worked_Days               boolean := Nvl(v_Settings.o_Varchar2('worked_days'), 'N') = 'Y';
    v_Daily_Fact_Hours               boolean := Nvl(v_Settings.o_Varchar2('daily_hours'), 'N') = 'Y';
    v_Show_Minutes                   boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words             boolean := v_Show_Minutes and
                                                Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Show_Only_Minute               boolean := v_Show_Minutes and
                                                Nvl(v_Settings.o_Varchar2('only_minute'), 'N') = 'Y';
    v_Check_Track                    boolean := Nvl(v_Settings.o_Varchar2('check_track'), 'N') = 'Y';
    v_Check_Track_Schedule           boolean := Nvl(v_Settings.o_Varchar2('check_track_schedule'),
                                                    'N') = 'Y';
    v_Show_Dismissed_And_Not_Hired   boolean := Nvl(v_Settings.o_Varchar2('dismissed_and_not_hired'),
                                                    'N') = 'Y';
    v_Show_Penalty_Late_Time         boolean := Nvl(v_Settings.o_Varchar2('penalty_late_time'), 'N') = 'Y';
    v_Show_Penalty_Early_Time        boolean := Nvl(v_Settings.o_Varchar2('penalty_early_time'),
                                                    'N') = 'Y';
    v_Show_Penalty_Lack_Time         boolean := Nvl(v_Settings.o_Varchar2('penalty_lack_time'), 'N') = 'Y';
    v_Show_Period_Penalty_Time       boolean := Nvl(v_Settings.o_Varchar2('period_penalty_time'),
                                                    'N') = 'Y';
    v_Show_Penalty_Total             boolean := Nvl(v_Settings.o_Varchar2('penalty_total_time'),
                                                    'N') = 'Y' and
                                                (v_Show_Penalty_Late_Time or
                                                 v_Show_Penalty_Early_Time or
                                                 v_Show_Penalty_Lack_Time);
    v_Show_Origin_Penalty_Late_Time  boolean := Nvl(v_Settings.o_Varchar2('origin_penalty_late_time'),
                                                    'N') = 'Y';
    v_Show_Origin_Penalty_Early_Time boolean := Nvl(v_Settings.o_Varchar2('origin_penalty_early_time'),
                                                    'N') = 'Y';
    v_Show_Origin_Penalty_Lack_Time  boolean := Nvl(v_Settings.o_Varchar2('origin_penalty_lack_time'),
                                                    'N') = 'Y';
    v_Show_Origin_Penalty_Total      boolean := Nvl(v_Settings.o_Varchar2('origin_penalty_total_time'),
                                                    'N') = 'Y';
    v_Hide_Request_Letter_Code       boolean := Nvl(v_Settings.o_Varchar2('request_letter_code'),
                                                    'N') = 'Y';
    v_Show_Separate_Leave_Time       boolean := Nvl(v_Settings.o_Varchar2('separate_leave_time'),
                                                    'N') = 'Y';
    v_Show_Removed_Penalty_Time      boolean := Nvl(v_Settings.o_Varchar2('removed_penalty_time'),
                                                    'N') = 'Y' and
                                                (v_Show_Penalty_Late_Time or
                                                 v_Show_Penalty_Early_Time or
                                                 v_Show_Penalty_Lack_Time);
    v_Show_Rest_Free_Time            boolean := Nvl(v_Settings.o_Varchar2('rest_free_time'), 'N') = 'Y';
  
    v_Custom_Fact_Time          boolean := Nvl(v_Settings.o_Varchar2('custom_fact_time'), 'N') = 'Y';
    v_Include_Beforework        boolean := not v_Custom_Fact_Time or
                                           Nvl(v_Settings.o_Varchar2('before_work_time'), 'N') = 'Y';
    v_Include_Afterwork         boolean := not v_Custom_Fact_Time or
                                           Nvl(v_Settings.o_Varchar2('after_work_time'), 'N') = 'Y';
    v_Include_Lunchtime         boolean := not v_Custom_Fact_Time or
                                           Nvl(v_Settings.o_Varchar2('lunchtime'), 'N') = 'Y';
    v_Include_Rest_Free         boolean := not v_Custom_Fact_Time or
                                           Nvl(v_Settings.o_Varchar2('include_rest_free'), 'N') = 'Y';
    v_Check_Track_Schedule_Time boolean := v_Custom_Fact_Time and
                                           Nvl(v_Settings.o_Varchar2('track_schedule_time'), 'N') = 'Y';
    v_Show_Leave_By_Coef        boolean := v_Leave_By_Coef = 'Y';
  
    v_Rest_Free_Coef number := case
                                 when v_Show_Rest_Free_Time then
                                  Nvl(v_Settings.o_Number('rest_free_coef'), 1)
                                 else
                                  1
                               end;
    v_Division_Group_Id number := v_Settings.o_Number('division_group_id');
  
    v_Cache_Late_Time  Fazo.Varchar2_Code_Aat;
    v_Cache_Early_Time Fazo.Varchar2_Code_Aat;
    v_Cache_Lack_Time  Fazo.Varchar2_Code_Aat;
    v_Begin_Date       date := i_Begin_Date;
    v_Date_Format      varchar2(10);
  
    v_Penalties     Array_Number;
    v_Time_Kind_Ids Array_Number := Nvl(v_Settings.o_Array_Number('time_kind_ids'), Array_Number());
  
    v_Date_Colspan   number := 1;
    v_Sysdate        date := Trunc(sysdate);
    v_Division_Count number := i_Division_Ids.Count;
    v_Job_Count      number := i_Job_Ids.Count;
    v_Location_Count number := i_Location_Ids.Count;
    v_Staff_Count    number := i_Staff_Ids.Count;
  
    v_Filial_Names   Array_Varchar2;
    v_Division_Names Array_Varchar2;
    v_Job_Names      Array_Varchar2;
    v_Location_Names Array_Varchar2;
  
    r_Request      Htt_Requests%rowtype;
    r_Request_Kind Htt_Request_Kinds%rowtype;
  
    a          b_Table := b_Report.New_Table();
    c          b_Table := b_Report.New_Table();
    Color_Info b_Table := Get_Color_Info;
    Gen_Info   b_Table := b_Report.New_Table();
    Main       b_Table := b_Report.New_Table();
  
    v_Column_Count number := 0;
  
    v_Split_Horizontal number := 1;
    v_Split_Vertical   number := 5;
    v_Column           number := 1;
    v_Text             varchar2(100 char);
    v_Style            varchar2(100);
    v_Input_Time       varchar2(5);
    v_Output_Time      varchar2(5);
    v_No_Time          varchar2(5) := 'xx:xx';
  
    v_Calc  Calc := Calc();
    v_Param Hashmap := Hashmap();
  
    v_User_Id               number := Ui.User_Id;
    v_Access_All_Employees  varchar2(1);
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    v_Leave_Key varchar2(100) := 'leave_time_key';
  
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
    v_Beforework_Id    number;
    v_Afterwork_Id     number;
    v_Lunchtime_Id     number;
    v_Leave_Ids        Array_Number;
    v_Unaggregated_Ids Array_Number;
  
    v_Beforework number := 0;
    v_Afterwork  number := 0;
    v_Lunchtime  number := 0;
  
    v_Nls_Language varchar2(100) := Uit_Href.Get_Nls_Language;
  
    t_Not_Come     varchar2(50 char) := t('not come short');
    t_Rest_Day     varchar2(50 char) := t('rest day short');
    t_Not_Licensed varchar2(50 char) := t('not licensed short');
    t_Leave        varchar2(50 char) := t('leave');
    t_Dismissed    varchar2(50 char) := t('dismissed');
    t_Not_Hired    varchar2(50 char) := t('not hired');
  
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
    v_Filial_Id   number;
    v_Filial_Cnt  number := i_Filial_Ids.Count;
    v_Filial_Ids  Array_Number;
    v_Count       number := 1;
  
    --------------------------------------------------    
    Procedure Column_Count is
    begin
      v_Column_Count := 6 + i_End_Date - i_Begin_Date; -- Default Columns
    
      if v_Show_Staff_Number = 'Y' then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Filial and Ui.Is_Filial_Head then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Job then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Rank then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Division then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Location then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Schedule then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Manager then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Late_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Early_Output then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Fact_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Rest_Free_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Origin_Penalty_Late_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Penalty_Late_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Origin_Penalty_Early_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Penalty_Early_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Origin_Penalty_Lack_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Penalty_Lack_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Origin_Penalty_Total then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Penalty_Total then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Removed_Penalty_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Overtime then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Free_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Separate_Leave_Time then
        v_Column_Count := v_Column_Count + v_Time_Kind_Ids.Count + 2;
      else
        v_Column_Count := v_Column_Count + 2;
      end if;
    
      if v_Show_Worked_Coef then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Worked_Days then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Fact_Coef then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      v_Column_Count := v_Column_Count - 8; -- minus color info column count
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
    Procedure Put_Time(i_Seconds number) is
      v_Style varchar2(10);
    begin
      if i_Seconds < 0 then
        v_Style := 'danger';
      end if;
    
      if v_Show_Only_Minute then
        a.Data(Nullif(Round(i_Seconds / 60, 2), 0), v_Style);
      elsif v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Seconds_Text(i_Seconds, v_Show_Minutes, v_Show_Minutes_Words),
               v_Style);
      else
        a.Data(Nullif(Round(i_Seconds / 3600, 2), 0), v_Style);
      end if;
    end;
  
    --------------------------------------------------
    Procedure Add_Request
    (
      i_Company_Id     number,
      i_Filial_Id      number,
      i_Timesheet_Id   number,
      i_Timesheet_Date date,
      i_Calendar_Id    number,
      i_Day_Kind       varchar2
    ) is
      v_Aggregate_Id number;
      v_Time_Text    varchar2(100);
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
            if v_Show_Daily_Leave_Time then
              if r_Time_Kind.Time_Kind_Id member of v_Unaggregated_Ids then
                v_Aggregate_Id := r_Time_Kind.Time_Kind_Id;
              else
                v_Aggregate_Id := Nvl(r_Time_Kind.Parent_Id, r_Time_Kind.Time_Kind_Id);
              end if;
            
              v_Time_Text := case
                               when v_Show_Only_Minute then
                                to_char(v_Calc.Get_Value(i_Timesheet_Date, v_Aggregate_Id) / 60)
                               when v_Show_Minutes then
                                Htt_Util.To_Time_Seconds_Text(v_Calc.Get_Value(i_Timesheet_Date, v_Aggregate_Id),
                                                              v_Show_Minutes,
                                                              v_Show_Minutes_Words)
                               else
                                to_char(Nullif(Round(v_Calc.Get_Value(i_Timesheet_Date, v_Aggregate_Id) / 3600,
                                                     2),
                                               0))
                             end;
            end if;
          
            if r_Request.Request_Type = Htt_Pref.c_Request_Type_Part_Of_Day then
              if not v_Hide_Request_Letter_Code then
                v_Text := v_Text || ' / ' || r_Time_Kind.Letter_Code;
              
                if v_Show_Daily_Leave_Time and v_Time_Text is not null then
                  v_Text := v_Text || '(' || v_Time_Text || ')';
                end if;
              end if;
            else
              if not v_Hide_Request_Letter_Code then
                v_Text := r_Time_Kind.Letter_Code;
              
                if v_Show_Daily_Leave_Time and v_Time_Text is not null then
                  v_Text := v_Text || '(' || v_Time_Text || ')';
                end if;
              else
                v_Text := null;
              end if;
            
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
    Procedure Add_Timeoff
    (
      i_Timeoff_Tk_Id  number,
      i_Timesheet_Date date
    ) is
      v_Time_Text varchar2(100);
      r_Time_Kind Htt_Time_Kinds%rowtype;
    begin
      r_Time_Kind := z_Htt_Time_Kinds.Load(i_Company_Id   => i_Company_Id,
                                           i_Time_Kind_Id => i_Timeoff_Tk_Id);
    
      if not v_Hide_Request_Letter_Code then
        v_Text := r_Time_Kind.Letter_Code;
      
        if v_Show_Daily_Leave_Time then
          v_Time_Text := case
                           when v_Show_Only_Minute then
                            to_char(v_Calc.Get_Value(i_Timesheet_Date, r_Time_Kind.Time_Kind_Id) / 60)
                           when v_Show_Minutes then
                            Htt_Util.To_Time_Seconds_Text(v_Calc.Get_Value(i_Timesheet_Date,
                                                                           r_Time_Kind.Time_Kind_Id),
                                                          v_Show_Minutes,
                                                          v_Show_Minutes_Words)
                           else
                            to_char(Nullif(Round(v_Calc.Get_Value(i_Timesheet_Date, r_Time_Kind.Time_Kind_Id) / 3600,
                                                 2),
                                           0))
                         end;
          if v_Time_Text is not null then
            v_Text := v_Text || '(' || v_Time_Text || ')';
          end if;
        end if;
      else
        v_Text := null;
      end if;
    
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
      if not v_Hide_Request_Letter_Code then
        v_Text := r_Time_Kind.Letter_Code;
      else
        v_Text := null;
      end if;
    
      v_Style := Get_Time_Kind_Style(r_Time_Kind.Time_Kind_Id,
                                     r_Time_Kind.Bg_Color,
                                     r_Time_Kind.Color);
    end;
  
    --------------------------------------------------
    Procedure Set_Rest_Day
    (
      i_Company_Id     number,
      i_Filial_Id      number,
      i_Timesheet_Id   number,
      i_Timesheet_Date date,
      i_Calendar_Id    number,
      i_Day_Kind       varchar2,
      i_Timeoff_Exists varchar2,
      i_Timeoff_Tk_Id  number
    ) is
      v_Track_Exists boolean := false;
    begin
      if v_Show_Input_Output and (v_Input_Time is not null or v_Output_Time is not null) then
        v_Text := v_Text || --
                  ' (' || Nvl(v_Input_Time, v_No_Time) || ' - ' || Nvl(v_Output_Time, v_No_Time) || ')';
      
        v_Track_Exists := true;
      end if;
    
      if i_Timeoff_Exists = 'N' then
        Add_Request(i_Company_Id     => i_Company_Id,
                    i_Filial_Id      => i_Filial_Id,
                    i_Timesheet_Id   => i_Timesheet_Id,
                    i_Timesheet_Date => i_Timesheet_Date,
                    i_Calendar_Id    => i_Calendar_Id,
                    i_Day_Kind       => i_Day_Kind);
      else
        Add_Timeoff(i_Timeoff_Tk_Id, i_Timesheet_Date);
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
    Function Calc_Penalty
    (
      i_Company_Id  number,
      i_Filial_Id   number,
      i_Division_Id number
    ) return Array_Number is
      v_Penalty_Id           number;
      v_Penalty_Kinds        Array_Varchar2;
      v_From_Times           Array_Number;
      v_To_Times             Array_Number;
      v_Coef                 Array_Number;
      v_Penalty_Time         Array_Number;
      v_From_Days            Array_Number;
      v_To_Days              Array_Number;
      v_Penalty_Per_Times    Array_Number;
      v_Calc_After_From_Time Array_Varchar2;
      v_Late_Times           number := 0;
      v_Early_Times          number := 0;
      v_Lack_Times           number := 0;
      v_Original_Late_Times  number := 0;
      v_Original_Early_Times number := 0;
      v_Original_Lack_Times  number := 0;
      v_Original_Time        number := 0;
      v_Bf_Time              number := 0;
      v_Penal_Time           number := 0;
      v_Penalty_Times        number := 0;
      v_Late_Time            number;
      v_Early_Time           number;
      v_Lack_Time            number;
      v_Date                 date;
    
      v_Days_Cnt  number;
      v_Days_Calc Calc := Calc();
    begin
      if v_Show_Period_Penalty_Time then
        v_Late_Time  := v_Calc.Get_Value('late_time');
        v_Early_Time := v_Calc.Get_Value('early_output');
        v_Lack_Time  := v_Calc.Get_Value('lack_time');
      
        v_Penalty_Id := Get_Penalty_Id(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Date        => i_End_Date,
                                       i_Division_Id => i_Division_Id);
        select q.Penalty_Kind,
               q.From_Time,
               q.To_Time,
               q.Penalty_Coef,
               q.Penalty_Per_Time,
               q.Penalty_Time,
               q.From_Day,
               q.To_Day,
               q.Calc_After_From_Time
          bulk collect
          into v_Penalty_Kinds,
               v_From_Times,
               v_To_Times,
               v_Coef,
               v_Penalty_Per_Times,
               v_Penalty_Time,
               v_From_Days,
               v_To_Days,
               v_Calc_After_From_Time
          from Hpr_Penalty_Policies q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Penalty_Id = v_Penalty_Id
         order by q.Penalty_Kind;
      
        for j in 1 .. v_Penalty_Kinds.Count
        loop
          v_Bf_Time := 0;
        
          if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Late and
             v_Late_Time > v_From_Times(j) * 60 and
             v_Late_Time <= Nvl(v_To_Times(j) * 60, v_Late_Time) then
            v_Bf_Time := v_Late_Time;
          end if;
        
          if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Early and
             v_Early_Time > v_From_Times(j) * 60 and
             v_Early_Time <= Nvl(v_To_Times(j) * 60, v_Early_Time) then
            v_Bf_Time := v_Early_Time;
          end if;
        
          if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Lack and
             v_Lack_Time > v_From_Times(j) * 60 and
             v_Lack_Time <= Nvl(v_To_Times(j) * 60, v_Lack_Time) then
            v_Bf_Time := v_Lack_Time;
          end if;
        
          v_Original_Time := v_Bf_Time;
        
          if v_Coef(j) is not null then
            if v_Calc_After_From_Time(j) = 'Y' then
              v_Original_Time := v_Bf_Time - v_From_Times(j) * 60;
              v_Penal_Time    := v_Original_Time * v_Coef(j);
              v_Bf_Time       := v_Penal_Time;
            else
              v_Original_Time := v_Bf_Time;
              v_Penal_Time    := v_Original_Time * v_Coef(j);
              v_Bf_Time       := v_Penal_Time;
            end if;
          elsif v_Penalty_Per_Times(j) is not null then
            if v_Calc_After_From_Time(j) = 'Y' then
              v_Original_Time := v_Bf_Time - v_From_Times(j) * 60;
            else
              v_Original_Time := v_Bf_Time;
            end if;
          else
            v_Penal_Time    := Nvl(v_Penalty_Time(j) * 60, 0);
            v_Original_Time := v_Bf_Time;
          end if;
        
          continue when v_Bf_Time = 0;
        
          case v_Penalty_Kinds(j)
            when Hpr_Pref.c_Penalty_Kind_Late then
              v_Late_Times          := v_Late_Times + v_Penal_Time;
              v_Penalty_Times       := v_Penalty_Times - v_Late_Time;
              v_Original_Late_Times := v_Original_Late_Times + v_Original_Time;
            when Hpr_Pref.c_Penalty_Kind_Early then
              v_Early_Times          := v_Early_Times + v_Penal_Time;
              v_Penalty_Times        := v_Penalty_Times - v_Early_Time;
              v_Original_Early_Times := v_Original_Early_Times + v_Original_Time;
            when Hpr_Pref.c_Penalty_Kind_Lack then
              v_Lack_Times          := v_Lack_Times + v_Penal_Time;
              v_Penalty_Times       := v_Penalty_Times - v_Lack_Time;
              v_Original_Lack_Times := v_Original_Lack_Times + v_Original_Time;
          end case;
        
          v_Penalty_Times := v_Penalty_Times + v_Penal_Time;
        end loop;
      else
        for i in 0 ..(i_End_Date - i_Begin_Date)
        loop
          v_Date := i_Begin_Date + i;
        
          v_Penalty_Id := Get_Penalty_Id(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Date        => v_Date,
                                         i_Division_Id => i_Division_Id);
        
          if v_Penalty_Id is null then
            return Array_Number(0, 0, 0, 0, 0, 0, 0);
          end if;
        
          select q.Penalty_Kind,
                 q.From_Time,
                 q.To_Time,
                 q.Penalty_Coef,
                 q.Penalty_Per_Time,
                 q.Penalty_Time,
                 q.From_Day,
                 q.To_Day,
                 q.Calc_After_From_Time
            bulk collect
            into v_Penalty_Kinds,
                 v_From_Times,
                 v_To_Times,
                 v_Coef,
                 v_Penalty_Per_Times,
                 v_Penalty_Time,
                 v_From_Days,
                 v_To_Days,
                 v_Calc_After_From_Time
            from Hpr_Penalty_Policies q
           where q.Company_Id = i_Company_Id
             and q.Filial_Id = i_Filial_Id
             and q.Penalty_Id = v_Penalty_Id
           order by q.Penalty_Kind;
        
          for j in 1 .. v_Penalty_Kinds.Count
          loop
            v_Bf_Time := 0;
          
            begin
              v_Late_Time := v_Cache_Late_Time(v_Date);
            
              if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Late and
                 v_Late_Time > v_From_Times(j) * 60 and
                 v_Late_Time <= Nvl(v_To_Times(j) * 60, v_Late_Time) then
                v_Days_Calc.Plus(Hpr_Pref.c_Penalty_Kind_Late, v_From_Times(j), v_From_Days(j), 1);
              end if;
            exception
              when No_Data_Found then
                v_Late_Time := 0;
            end;
          
            begin
              v_Early_Time := v_Cache_Early_Time(v_Date);
            
              if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Early and
                 v_Early_Time > v_From_Times(j) * 60 and
                 v_Early_Time <= Nvl(v_To_Times(j) * 60, v_Early_Time) then
                v_Days_Calc.Plus(Hpr_Pref.c_Penalty_Kind_Early, v_From_Times(j), v_From_Days(j), 1);
              end if;
            exception
              when No_Data_Found then
                v_Early_Time := 0;
            end;
          
            begin
              v_Lack_Time := v_Cache_Lack_Time(v_Date);
            
              if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Lack and
                 v_Lack_Time > v_From_Times(j) * 60 and
                 v_Lack_Time <= Nvl(v_To_Times(j) * 60, v_Lack_Time) then
                v_Days_Calc.Plus(Hpr_Pref.c_Penalty_Kind_Lack, v_From_Times(j), v_From_Days(j), 1);
              end if;
            exception
              when No_Data_Found then
                v_Lack_Time := 0;
            end;
          
            -- check days
            v_Days_Cnt := v_Days_Calc.Get_Value(Hpr_Pref.c_Penalty_Kind_Late,
                                                v_From_Times(j),
                                                v_From_Days(j));
          
            if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Late and --
               v_From_Days(j) < v_Days_Cnt and v_Days_Cnt <= Nvl(v_To_Days(j), v_Days_Cnt) then
              begin
                v_Bf_Time := v_Cache_Late_Time(v_Date);
              exception
                when No_Data_Found then
                  v_Bf_Time := 0;
              end;
            end if;
          
            v_Days_Cnt := v_Days_Calc.Get_Value(Hpr_Pref.c_Penalty_Kind_Early,
                                                v_From_Times(j),
                                                v_From_Days(j));
          
            if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Early and --
               v_From_Days(j) < v_Days_Cnt and v_Days_Cnt <= Nvl(v_To_Days(j), v_Days_Cnt) then
              begin
                v_Bf_Time := v_Cache_Early_Time(v_Date);
              exception
                when No_Data_Found then
                  v_Bf_Time := 0;
              end;
            end if;
          
            v_Days_Cnt := v_Days_Calc.Get_Value(Hpr_Pref.c_Penalty_Kind_Lack,
                                                v_From_Times(j),
                                                v_From_Days(j));
          
            if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Lack and --
               v_From_Days(j) < v_Days_Cnt and v_Days_Cnt <= Nvl(v_To_Days(j), v_Days_Cnt) then
              begin
                v_Bf_Time := v_Cache_Lack_Time(v_Date);
              exception
                when No_Data_Found then
                  v_Bf_Time := 0;
              end;
            end if;
          
            continue when v_Bf_Time = 0;
          
            if v_Bf_Time > v_From_Times(j) * 60 and v_Bf_Time <= Nvl(v_To_Times(j) * 60, v_Bf_Time) then
              if v_Coef(j) is not null then
                if v_Calc_After_From_Time(j) = 'Y' then
                  v_Penal_Time    := (v_Bf_Time - v_From_Times(j) * 60) * v_Coef(j);
                  v_Original_Time := v_Bf_Time - v_From_Times(j) * 60;
                else
                  v_Penal_Time    := v_Bf_Time * v_Coef(j);
                  v_Original_Time := v_Bf_Time;
                end if;
              elsif v_Penalty_Per_Times(j) is not null then
                v_Penal_Time := 0;
              
                if v_Calc_After_From_Time(j) = 'Y' then
                  v_Original_Time := v_Bf_Time - v_From_Times(j) * 60;
                else
                  v_Original_Time := v_Bf_Time;
                end if;
              else
                v_Penal_Time    := Nvl(v_Penalty_Time(j) * 60, 0);
                v_Original_Time := v_Bf_Time;
              end if;
            
              case v_Penalty_Kinds(j)
                when Hpr_Pref.c_Penalty_Kind_Late then
                  v_Late_Times          := v_Late_Times + v_Penal_Time;
                  v_Penalty_Times       := v_Penalty_Times + v_Penal_Time - v_Late_Time;
                  v_Original_Late_Times := v_Original_Late_Times + v_Original_Time;
                when Hpr_Pref.c_Penalty_Kind_Early then
                  v_Early_Times          := v_Early_Times + v_Penal_Time;
                  v_Penalty_Times        := v_Penalty_Times + v_Penal_Time - v_Early_Time;
                  v_Original_Early_Times := v_Original_Early_Times + v_Original_Time;
                
                when Hpr_Pref.c_Penalty_Kind_Lack then
                  v_Lack_Times          := v_Lack_Times + v_Penal_Time;
                  v_Penalty_Times       := v_Penalty_Times + v_Penal_Time - v_Lack_Time;
                  v_Original_Lack_Times := v_Original_Lack_Times + v_Original_Time;
              end case;
            end if;
          end loop;
        end loop;
      end if;
    
      return Array_Number(v_Late_Times,
                          v_Early_Times,
                          v_Lack_Times,
                          v_Penalty_Times,
                          v_Original_Late_Times,
                          v_Original_Early_Times,
                          v_Original_Lack_Times);
    end;
  
    --------------------------------------------------
    Function Calc_Free_Time
    (
      i_Free_Time  number,
      i_Beforework number,
      i_Afterwork  number,
      i_Lunchtime  number,
      i_Day_Kind   varchar2
    ) return number is
      v_Free_Time number := i_Free_Time;
      result      number := 0;
    begin
      if i_Day_Kind <> Htt_Pref.c_Day_Kind_Work then
        v_Free_Time := v_Free_Time * v_Rest_Free_Coef;
      end if;
    
      if v_Include_Beforework then
        result := result + i_Beforework;
      end if;
    
      if v_Include_Afterwork then
        result := result + i_Afterwork;
      end if;
    
      if v_Include_Lunchtime then
        result := result + i_Lunchtime;
      end if;
    
      if v_Include_Rest_Free and i_Day_Kind <> Htt_Pref.c_Day_Kind_Work then
        result := result + v_Free_Time;
      end if;
    
      -- temporary fix to free time inside plan
      -- maybe add variable to enable/disable this value
      -- Free time in plan
      if i_Day_Kind = Htt_Pref.c_Day_Kind_Work then
        result := result + i_Free_Time;
      end if;
    
      return result;
    end;
  
    --------------------------------------------------
    Procedure Print_Info is
    begin
      Column_Count;
    
      c.Current_Style('root bold');
    
      c.New_Row;
    
      if i_Filial_Ids.Count > 0 and Ui.Is_Filial_Head then
        c.New_Row;
      
        select d.Name
          bulk collect
          into v_Filial_Names
          from Md_Filials d
         where d.Company_Id = i_Company_Id
           and d.Filial_Id member of i_Filial_Ids;
      
        c.Data(t('filials: $1', Fazo.Gather(v_Filial_Names, ', ')), i_Colspan => v_Column_Count);
        v_Split_Vertical := v_Split_Vertical + 1;
      end if;
    
      if i_Division_Ids.Count > 0 then
        c.New_Row;
      
        select d.Name
          bulk collect
          into v_Division_Names
          from Mhr_Divisions d
         where d.Company_Id = i_Company_Id
           and (v_Filial_Id is null or d.Filial_Id = v_Filial_Id)
           and d.Division_Id member of i_Division_Ids;
      
        c.Data(t('division: $1', Fazo.Gather(v_Division_Names, ', ')), i_Colspan => v_Column_Count);
        v_Split_Vertical := v_Split_Vertical + 1;
      end if;
    
      if i_Job_Ids.Count > 0 then
        c.New_Row;
      
        select d.Name
          bulk collect
          into v_Job_Names
          from Mhr_Jobs d
         where d.Company_Id = i_Company_Id
           and (v_Filial_Id is null or d.Filial_Id = v_Filial_Id)
           and d.Job_Id member of i_Job_Ids;
      
        c.Data(t('job: $1', Fazo.Gather(v_Job_Names, ', ')), i_Colspan => v_Column_Count);
        v_Split_Vertical := v_Split_Vertical + 1;
      end if;
    
      if i_Location_Ids.Count > 0 then
        c.New_Row;
      
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
                   and (v_Filial_Id is null or w.Filial_Id = v_Filial_Id)
                   and w.Location_Id = q.Location_Id);
      
        c.Data(t('location: $1', Fazo.Gather(v_Location_Names, ', ')), i_Colspan => v_Column_Count);
        v_Split_Vertical := v_Split_Vertical + 1;
      end if;
    
      c.New_Row;
      c.Data(t('period: $1 - $2',
               to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
               to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
             i_Colspan => v_Column_Count);
    
      Gen_Info.New_Row;
      Gen_Info.Data(c);
      Gen_Info.Data(Color_Info);
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
    begin
      a.Current_Style('header');
      a.New_Row;
      a.New_Row;
    
      Print_Header(t('order no'), 1, 2, 50);
    
      if v_Show_Staff_Number = 'Y' then
        Print_Header(t('staff number'), 1, 2, 100);
        v_Split_Horizontal := v_Split_Horizontal + 1;
      end if;
    
      Print_Header(t('name'), 1, 2, 200);
    
      if v_Show_Filial and Ui.Is_Filial_Head then
        Print_Header(t('filial'), 1, 2, 150);
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
    
      if Trunc(i_Begin_Date, 'mon') <> Trunc(i_End_Date, 'mon') then
        v_Date_Format := 'DD.mon';
      else
        v_Date_Format := 'DD';
      end if;
    
      for i in 0 .. i_End_Date - i_Begin_Date
      loop
        Print_Header(to_char(i_Begin_Date + i, v_Date_Format, v_Nls_Language),
                     v_Date_Colspan,
                     1,
                     75);
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
    
      if v_Show_Rest_Free_Time then
        Print_Header(t('rest free time'), 1, 2, 75);
      end if;
    
      Print_Header(t('intime'), 1, 2, 75);
    
      if v_Show_Origin_Penalty_Late_Time then
        Print_Header(t('origin penalty late time'), 1, 2, 75);
      end if;
    
      if v_Show_Penalty_Late_Time then
        Print_Header(t('penalty late time'), 1, 2, 75);
      end if;
    
      if v_Show_Origin_Penalty_Early_Time then
        Print_Header(t('origin penalty early time'), 1, 2, 75);
      end if;
    
      if v_Show_Penalty_Early_Time then
        Print_Header(t('penalty early time'), 1, 2, 75);
      end if;
    
      if v_Show_Origin_Penalty_Lack_Time then
        Print_Header(t('origin penalty lack time'), 1, 2, 75);
      end if;
    
      if v_Show_Penalty_Lack_Time then
        Print_Header(t('penalty lack time'), 1, 2, 75);
      end if;
    
      if v_Show_Origin_Penalty_Total then
        Print_Header(t('origin penalty total'), 1, 2, 75);
      end if;
    
      if v_Show_Penalty_Total then
        Print_Header(t('penalty total time'), 1, 2, 75);
      end if;
    
      if v_Show_Removed_Penalty_Time then
        Print_Header(t('fact time removed penalty time'), 1, 2, 75);
      end if;
    
      if v_Show_Overtime then
        Print_Header(t('overtime'), 1, 2, 75);
      end if;
    
      if v_Show_Free_Time then
        Print_Header(t('free time'), 1, 2, 75);
      end if;
    
      if v_Show_Separate_Leave_Time then
        Print_Header(t('leave and absence'), (v_Time_Kind_Ids.Count + 2), 1, 75);
      else
        Print_Header(t('leave and absence'), 2, 1, 75);
      end if;
    
      Print_Header(t('total time'), 1, 2, 75);
    
      if v_Show_Worked_Coef then
        Print_Header(t('worked coef'), 1, 2, 75);
      end if;
    
      if v_Show_Worked_Days then
        Print_Header(t('worked days'), 1, 2, 75);
      end if;
    
      if v_Show_Fact_Coef then
        Print_Header(t('fact coef'), 1, 2, 75);
      end if;
    
      a.New_Row;
      for i in 0 .. i_End_Date - i_Begin_Date
      loop
        Print_Header(to_char(i_Begin_Date + i, 'Dy', v_Nls_Language), v_Date_Colspan, 1, null);
      end loop;
    
      if v_Show_Separate_Leave_Time then
        for i in 1 .. v_Time_Kind_Ids.Count
        loop
          Print_Header(z_Htt_Time_Kinds.Load(i_Company_Id => i_Company_Id, i_Time_Kind_Id => v_Time_Kind_Ids(i)).Name,
                       1,
                       1,
                       null);
        end loop;
      end if;
    
      if v_Show_Leave_By_Coef then
        Print_Header(t('leave time by coef'), 1, 1, null);
      else
        Print_Header(t('leave time'), 1, 1, null);
      end if;
    
      Print_Header(t('absence time'), 1, 1, null);
    end;
  
    --------------------------------------------------
    Procedure Print_Body(i_Filial_Id number) is
    begin
      a.Current_Style('body_centralized');
    
      if v_Access_All_Employees = 'N' then
        v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                      i_Filial_Id          => i_Filial_Id,
                                                                      i_Direct             => true,
                                                                      i_Indirect           => true,
                                                                      i_Manual             => true,
                                                                      i_Gather_Chiefs      => false);
      end if;
    
      for r in (select q.*,
                       (select p.Name
                          from Md_Filials p
                         where p.Company_Id = q.Company_Id
                           and p.Filial_Id = q.Filial_Id) Filial_Name,
                       w.Name,
                       w.Gender
                  from Href_Staffs q
                  join Mr_Natural_Persons w
                    on w.Company_Id = q.Company_Id
                   and w.Person_Id = q.Employee_Id
                 where q.Company_Id = i_Company_Id
                   and q.Filial_Id = i_Filial_Id
                   and (v_Division_Count = 0 or q.Division_Id member of i_Division_Ids)
                   and (v_Job_Count = 0 or q.Job_Id member of i_Job_Ids)
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
        v_Calc := Calc();
      
        v_Param.Put('person_id', r.Employee_Id);
        v_Param.Put('filial_id', r.Filial_Id);
      
        -- staff data
        a.New_Row;
      
        a.Data(v_Count, 'body_centralized');
        v_Count := v_Count + 1;
      
        if v_Show_Staff_Number = 'Y' then
          a.Data(r.Staff_Number);
        end if;
      
        a.Data(r.Name, 'body middle', i_Param => Fazo.Zip_Map('staff_id', r.Staff_Id).Json());
      
        if v_Show_Filial and Ui.Is_Filial_Head then
          a.Data(r.Filial_Name);
        end if;
      
        if v_Show_Job then
          a.Data(z_Mhr_Jobs.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Job_Id => r.Job_Id).Name);
        end if;
      
        if v_Show_Rank then
          a.Data(z_Mhr_Ranks.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Rank_Id => r.Rank_Id).Name);
        end if;
      
        if v_Show_Division then
          a.Data(z_Mhr_Divisions.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Division_Id => r.Division_Id).Name);
        end if;
      
        if v_Show_Location then
          a.Data(Get_Location_Names(i_Company_Id  => r.Company_Id,
                                    i_Filial_Id   => r.Filial_Id,
                                    i_Employee_Id => r.Employee_Id));
        end if;
      
        if v_Show_Schedule then
          a.Data(z_Htt_Schedules.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Schedule_Id => r.Schedule_Id).Name);
        end if;
      
        if v_Show_Manager then
          a.Data(Uit_Hrm.Get_Manager_Name(i_Company_Id        => r.Company_Id,
                                          i_Filial_Id         => r.Filial_Id,
                                          i_Division_Id       => r.Division_Id,
                                          i_Division_Group_Id => v_Division_Group_Id));
        end if;
      
        Cache_Timesheet_Facts(i_Company_Id    => i_Company_Id,
                              i_Filial_Id     => i_Filial_Id,
                              i_Staff_Id      => r.Staff_Id,
                              i_Begin_Date    => i_Begin_Date,
                              i_End_Date      => i_End_Date,
                              i_Leave_Key     => v_Leave_Key,
                              i_Leave_Ids     => v_Leave_Ids,
                              i_Time_Kind_Ids => v_Unaggregated_Ids,
                              i_Leave_By_Coef => v_Leave_By_Coef,
                              p_Calc          => v_Calc);
      
        -- daily data
        for Tsht in (select q.*,
                            Td.Time_Kind_Id Timeoff_Tk_Id,
                            Nvl2(Td.Time_Kind_Id, 'Y', 'N') Timeoff_Exists,
                            Nvl((select 'N'
                                  from Hlic_Unlicensed_Employees Le
                                 where Le.Company_Id = r.Company_Id
                                   and Le.Employee_Id = r.Employee_Id
                                   and Le.Licensed_Date = Dates.Date_Value),
                                'Y') as Licensed,
                            Dates.Date_Value
                       from (select i_Begin_Date + (level - 1) Date_Value
                               from Dual
                             connect by level <= (i_End_Date - i_Begin_Date + 1)) Dates
                       left join Htt_Timesheets q
                         on q.Company_Id = r.Company_Id
                        and q.Filial_Id = r.Filial_Id
                        and q.Staff_Id = r.Staff_Id
                        and Dates.Date_Value = q.Timesheet_Date
                       left join Hpd_Timeoff_Days Td
                         on Td.Company_Id = q.Company_Id
                        and Td.Filial_Id = q.Filial_Id
                        and Td.Staff_Id = q.Staff_Id
                        and Td.Timeoff_Date = q.Timesheet_Date
                      order by Dates.Date_Value)
        loop
          if Trunc(v_Begin_Date, 'mon') <> Trunc(Tsht.Timesheet_Date, 'mon') then
            v_Begin_Date := Tsht.Timesheet_Date;
          end if;
        
          if Tsht.Company_Id is null then
            if v_Show_Dismissed_And_Not_Hired then
              if r.Dismissal_Date < Tsht.Date_Value then
                v_Text  := t_Dismissed;
                v_Style := 'dismissed';
                a.Data(v_Text, v_Style);
              elsif r.Hiring_Date > Tsht.Date_Value then
                v_Text  := t_Not_Hired;
                v_Style := 'not_hired';
                a.Data(v_Text, v_Style);
              else
                a.Add_Data(1);
              end if;
            else
              -- timesheet is not generated
              a.Add_Data(1);
            end if;
          
            continue;
          end if;
        
          if Tsht.Day_Kind in (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) then
            v_Calc.Plus('plan_time', Tsht.Plan_Time);
          end if;
        
          if Tsht.Licensed = 'N' then
            a.Data(t_Not_Licensed, 'not_licensed');
            continue;
          end if;
        
          v_Turnout_Time := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Turnout_Id);
        
          if v_Check_Track_Schedule_Time and Tsht.Planned_Marks > 0 then
            v_Turnout_Time := v_Turnout_Time -
                              Calc_Track_Schedule_Times(i_Company_Id   => Tsht.Company_Id,
                                                        i_Filial_Id    => Tsht.Filial_Id,
                                                        i_Timesheet_Id => Tsht.Timesheet_Id);
          end if;
        
          v_Free_Time    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Free_Id);
          v_Lack_Time    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Lack_Id);
          v_Late_Time    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Late_Id);
          v_Early_Output := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Early_Id);
          v_Beforework   := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Beforework_Id);
          v_Afterwork    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Afterwork_Id);
          v_Lunchtime    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Lunchtime_Id);
        
          v_Free_Time := Calc_Free_Time(i_Free_Time  => v_Free_Time,
                                        i_Beforework => v_Beforework,
                                        i_Afterwork  => v_Afterwork,
                                        i_Lunchtime  => v_Lunchtime,
                                        i_Day_Kind   => Tsht.Day_Kind);
        
          v_Fact_Time := v_Turnout_Time + v_Free_Time;
        
          -- cache penalties
          if v_Show_Penalty_Late_Time or v_Show_Origin_Penalty_Late_Time then
            v_Cache_Late_Time(Tsht.Timesheet_Date) := v_Late_Time;
          end if;
        
          if v_Show_Penalty_Early_Time or v_Show_Origin_Penalty_Early_Time then
            v_Cache_Early_Time(Tsht.Timesheet_Date) := v_Early_Output;
          end if;
        
          if v_Show_Penalty_Lack_Time or v_Show_Origin_Penalty_Lack_Time then
            v_Cache_Lack_Time(Tsht.Timesheet_Date) := v_Lack_Time;
          end if;
        
          if v_Daily_Fact_Hours then
            v_Daily_Hours_Time := v_Fact_Time;
          else
            v_Daily_Hours_Time := v_Turnout_Time;
          end if;
        
          v_Param.Put('track_date', Tsht.Timesheet_Date);
        
          v_Input_Time  := to_char(Tsht.Input_Time, Href_Pref.c_Time_Format_Minute);
          v_Output_Time := to_char(Tsht.Output_Time, Href_Pref.c_Time_Format_Minute);
          v_Text        := null;
          v_Style       := null;
        
          case Tsht.Day_Kind
            when Htt_Pref.c_Day_Kind_Work then
              if v_Daily_Hours_Time > 0 or v_Input_Time is not null or v_Output_Time is not null then
                if v_Show_Input_Output then
                  if v_Input_Time is not null and v_Output_Time is not null then
                    v_Text := v_Input_Time || ' - ' || v_Output_Time;
                  elsif v_Daily_Hours_Time = 0 and v_Input_Time is not null and
                        v_Output_Time is null then
                    v_Text := Nvl(v_Input_Time, v_No_Time) || ' - ' ||
                              Nvl(v_Output_Time, v_No_Time);
                  end if;
                end if;
              
                if v_Daily_Hours_Time > 0 then
                  if v_Show_Only_Minute then
                    if v_Text is null then
                      v_Text := v_Daily_Hours_Time / 60;
                    else
                      v_Text := v_Text || ' (' || v_Daily_Hours_Time / 60 || ')';
                    end if;
                  else
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
                end if;
              
                if v_Daily_Hours_Time < Tsht.Plan_Time or
                   v_Check_Track and
                   not Check_Track_Type_Exist(i_Company_Id => Tsht.Company_Id,
                                              i_Filial_Id  => Tsht.Filial_Id,
                                              i_Person_Id  => Tsht.Employee_Id,
                                              i_Begin_Time => Tsht.Shift_Begin_Time,
                                              i_End_Time   => Tsht.Shift_End_Time) then
                  v_Style := 'warning';
                end if;
              else
                if Tsht.Timesheet_Date <= v_Sysdate then
                  if not v_Hide_Request_Letter_Code then
                    v_Text := t_Not_Come;
                  else
                    v_Text := null;
                  end if;
                
                  v_Style := 'danger';
                end if;
              end if;
            
              if Tsht.Timeoff_Exists = 'N' then
                Add_Request(i_Company_Id     => i_Company_Id,
                            i_Filial_Id      => i_Filial_Id,
                            i_Timesheet_Id   => Tsht.Timesheet_Id,
                            i_Timesheet_Date => Tsht.Timesheet_Date,
                            i_Calendar_Id    => Tsht.Calendar_Id,
                            i_Day_Kind       => Tsht.Day_Kind);
              else
                Add_Timeoff(Tsht.Timeoff_Tk_Id, Tsht.Timesheet_Date);
              end if;
            
              if v_Check_Track_Schedule and Tsht.Planned_Marks > 0 then
                v_Style := null;
                v_Text  := t('$1/$2', Tsht.Done_Marks, Tsht.Planned_Marks);
                if Tsht.Timesheet_Date <= v_Sysdate then
                  if Tsht.Done_Marks = 0 then
                    v_Style := 'danger';
                  elsif Tsht.Done_Marks < Tsht.Planned_Marks then
                    v_Style := 'warning';
                  else
                    v_Style := 'success';
                  end if;
                end if;
              end if;
            
              a.Data(v_Text, v_Style, i_Param => v_Param.Json());
            
              v_Calc.Plus('intime', v_Turnout_Time);
            
              if v_Show_Separate_Leave_Time then
                for i in 1 .. v_Time_Kind_Ids.Count
                loop
                  v_Calc.Plus(v_Time_Kind_Ids(i),
                              v_Calc.Get_Value(Tsht.Timesheet_Date, v_Time_Kind_Ids(i)));
                end loop;
              end if;
            
              v_Calc.Plus('leave_time', v_Calc.Get_Value(Tsht.Timesheet_Date, v_Leave_Key));
              v_Calc.Plus('absence_time', v_Late_Time + v_Lack_Time + v_Early_Output);
              v_Calc.Plus('free_time', v_Free_Time);
            
              if v_Show_Late_Time or v_Show_Penalty_Late_Time then
                v_Calc.Plus('late_time', v_Late_Time);
              end if;
            
              if v_Show_Early_Output or v_Show_Penalty_Early_Time then
                v_Calc.Plus('early_output', v_Early_Output);
              end if;
            
              if v_Show_Penalty_Lack_Time then
                v_Calc.Plus('lack_time', v_Lack_Time);
              end if;
            
              if v_Show_Worked_Days and Nvl(Tsht.Input_Time, Tsht.Output_Time) is not null or
                 v_Turnout_Time > 0 then
                v_Calc.Plus('worked_days', 1);
              end if;
            when Htt_Pref.c_Day_Kind_Rest then
              if not v_Hide_Request_Letter_Code then
                v_Text := t_Rest_Day;
              else
                v_Text := null;
              end if;
            
              if v_Input_Time is not null and v_Output_Time is not null then
                v_Style := 'warning';
              else
                v_Style := 'rest';
              end if;
            
              Set_Rest_Day(i_Company_Id     => i_Company_Id,
                           i_Filial_Id      => i_Filial_Id,
                           i_Timesheet_Id   => Tsht.Timesheet_Id,
                           i_Timesheet_Date => Tsht.Timesheet_Date,
                           i_Calendar_Id    => Tsht.Calendar_Id,
                           i_Day_Kind       => Tsht.Day_Kind,
                           i_Timeoff_Exists => Tsht.Timeoff_Exists,
                           i_Timeoff_Tk_Id  => Tsht.Timeoff_Tk_Id);
            when Htt_Pref.c_Day_Kind_Nonworking then
              Get_Calendar_Day_Style(i_Company_Id => Tsht.Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Nonworking);
              Set_Rest_Day(i_Company_Id     => i_Company_Id,
                           i_Filial_Id      => i_Filial_Id,
                           i_Timesheet_Id   => Tsht.Timesheet_Id,
                           i_Timesheet_Date => Tsht.Timesheet_Date,
                           i_Calendar_Id    => Tsht.Calendar_Id,
                           i_Day_Kind       => Tsht.Day_Kind,
                           i_Timeoff_Exists => Tsht.Timeoff_Exists,
                           i_Timeoff_Tk_Id  => Tsht.Timeoff_Tk_Id);
            when Htt_Pref.c_Day_Kind_Holiday then
              Get_Calendar_Day_Style(i_Company_Id => Tsht.Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Holiday);
              Set_Rest_Day(i_Company_Id     => i_Company_Id,
                           i_Filial_Id      => i_Filial_Id,
                           i_Timesheet_Id   => Tsht.Timesheet_Id,
                           i_Timesheet_Date => Tsht.Timesheet_Date,
                           i_Calendar_Id    => Tsht.Calendar_Id,
                           i_Day_Kind       => Tsht.Day_Kind,
                           i_Timeoff_Exists => Tsht.Timeoff_Exists,
                           i_Timeoff_Tk_Id  => Tsht.Timeoff_Tk_Id);
            when Htt_Pref.c_Day_Kind_Additional_Rest then
              Get_Calendar_Day_Style(i_Company_Id => Tsht.Company_Id,
                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Additional_Rest);
              Set_Rest_Day(i_Company_Id     => i_Company_Id,
                           i_Filial_Id      => i_Filial_Id,
                           i_Timesheet_Id   => Tsht.Timesheet_Id,
                           i_Timesheet_Date => Tsht.Timesheet_Date,
                           i_Calendar_Id    => Tsht.Calendar_Id,
                           i_Day_Kind       => Tsht.Day_Kind,
                           i_Timeoff_Exists => Tsht.Timeoff_Exists,
                           i_Timeoff_Tk_Id  => Tsht.Timeoff_Tk_Id);
            else
              a.Data;
          end case;
        
          if v_Show_Overtime then
            v_Calc.Plus('overtime', v_Calc.Get_Value(Tsht.Timesheet_Date, v_Overtime_Id));
          end if;
        
          if Tsht.Day_Kind <> Htt_Pref.c_Day_Kind_Work then
            v_Calc.Plus('rest_free_time', v_Free_Time);
          end if;
        end loop;
      
        if v_Show_Dismissed_And_Not_Hired then
          v_Calc.Plus('plan_time',
                      Get_Plan_Time(i_Company_Id     => i_Company_Id,
                                    i_Filial_Id      => i_Filial_Id,
                                    i_Staff_Id       => r.Staff_Id,
                                    i_Hiring_Date    => r.Hiring_Date,
                                    i_Dismissal_Date => r.Dismissal_Date,
                                    i_Robot_Id       => r.Robot_Id,
                                    i_Schedule_Id    => r.Schedule_Id,
                                    i_Begin_Date     => i_Begin_Date,
                                    i_End_Date       => i_End_Date));
        end if;
      
        Put_Time(v_Calc.Get_Value('plan_time'));
      
        if v_Show_Late_Time then
          Put_Time(v_Calc.Get_Value('late_time'));
        end if;
      
        if v_Show_Early_Output then
          Put_Time(v_Calc.Get_Value('early_output'));
        end if;
      
        if v_Show_Fact_Time then
          Put_Time(v_Calc.Get_Value('intime') + v_Calc.Get_Value('free_time'));
        end if;
      
        if v_Show_Rest_Free_Time then
          Put_Time(v_Calc.Get_Value('rest_free_time'));
        end if;
      
        Put_Time(v_Calc.Get_Value('intime'));
      
        -- penalties
        if v_Show_Penalty_Late_Time or --
           v_Show_Penalty_Early_Time or --
           v_Show_Penalty_Lack_Time or -- 
           v_Show_Origin_Penalty_Late_Time or --
           v_Show_Origin_Penalty_Early_Time or --
           v_Show_Origin_Penalty_Lack_Time then
          v_Penalties := Calc_Penalty(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Division_Id => r.Division_Id);
        
          if v_Show_Origin_Penalty_Late_Time then
            Put_Time(v_Penalties(5));
          end if;
        
          if v_Show_Penalty_Late_Time then
            Put_Time(v_Penalties(1));
          end if;
        
          if v_Show_Origin_Penalty_Early_Time then
            Put_Time(v_Penalties(6));
          end if;
        
          if v_Show_Penalty_Early_Time then
            Put_Time(v_Penalties(2));
          end if;
        
          if v_Show_Origin_Penalty_Lack_Time then
            Put_Time(v_Penalties(7));
          end if;
        
          if v_Show_Penalty_Lack_Time then
            Put_Time(v_Penalties(3));
          end if;
        
          if v_Show_Origin_Penalty_Total then
            Put_Time(v_Penalties(5) + v_Penalties(6) + v_Penalties(7));
          end if;
        
          if v_Show_Penalty_Total then
            Put_Time(v_Penalties(1) + v_Penalties(2) + v_Penalties(3));
          end if;
        
          if v_Show_Removed_Penalty_Time then
            Put_Time(v_Calc.Get_Value('intime') - v_Penalties(4));
          end if;
        end if;
      
        if v_Show_Overtime then
          Put_Time(v_Calc.Get_Value('overtime'));
        end if;
      
        if v_Show_Free_Time then
          Put_Time(v_Calc.Get_Value('free_time'));
        end if;
      
        if v_Show_Separate_Leave_Time then
          for i in 1 .. v_Time_Kind_Ids.Count
          loop
            Put_Time(v_Calc.Get_Value(v_Time_Kind_Ids(i)));
          end loop;
        end if;
      
        Put_Time(v_Calc.Get_Value('leave_time'));
        Put_Time(v_Calc.Get_Value('absence_time'));
        Put_Time(v_Calc.Get_Value('intime') + v_Calc.Get_Value('leave_time') +
                 v_Calc.Get_Value('overtime'));
      
        if v_Show_Worked_Coef then
          if v_Calc.Get_Value('plan_time') > 0 then
            a.Data(Nullif(Round((v_Calc.Get_Value('intime') + v_Calc.Get_Value('leave_time') +
                                v_Calc.Get_Value('overtime')) / v_Calc.Get_Value('plan_time'),
                                4) * 100,
                          0));
          else
            a.Data;
          end if;
        end if;
      
        if v_Show_Worked_Days then
          a.Data(Nullif(v_Calc.Get_Value('worked_days'), 0));
        end if;
      
        if v_Show_Fact_Coef then
          if v_Calc.Get_Value('plan_time') > 0 then
            a.Data(Nullif(Round((v_Calc.Get_Value('intime') + v_Calc.Get_Value('free_time')) /
                                v_Calc.Get_Value('plan_time'),
                                4) * 100,
                          0));
          else
            a.Data;
          end if;
        end if;
      end loop;
    end;
  
  begin
    if v_Filial_Cnt = 1 then
      v_Filial_Id := i_Filial_Ids(1);
    end if;
  
    select q.Filial_Id
      bulk collect
      into v_Filial_Ids
      from Md_Filials q
     where q.Company_Id = i_Company_Id
       and (v_Filial_Cnt = 0 or q.Filial_Id member of i_Filial_Ids)
       and q.Filial_Id <> v_Filial_Head
       and q.State = 'A'
     order by q.Order_No, q.Name;
  
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
  
    Load_Report_Time_Kind_Ids(i_Company_Id       => i_Company_Id,
                              o_Turnout_Id       => v_Turnout_Id,
                              o_Lack_Id          => v_Lack_Id,
                              o_Late_Id          => v_Late_Id,
                              o_Early_Id         => v_Early_Id,
                              o_Overtime_Id      => v_Overtime_Id,
                              o_Free_Id          => v_Free_Id,
                              o_Beforework_Id    => v_Beforework_Id,
                              o_Afterwork_Id     => v_Afterwork_Id,
                              o_Lunchtime_Id     => v_Lunchtime_Id,
                              o_Leave_Ids        => v_Leave_Ids,
                              o_Unaggregated_Ids => v_Unaggregated_Ids);
  
    v_Unaggregated_Ids := case
                            when v_Show_Separate_Leave_Time then
                             v_Unaggregated_Ids multiset union v_Time_Kind_Ids
                            else
                             v_Unaggregated_Ids
                          end;
  
    -- info
    Print_Info;
  
    -- header
    Print_Header;
  
    -- body
    for i in 1 .. v_Filial_Ids.Count
    loop
      Print_Body(v_Filial_Ids(i));
    end loop;
  
    Main.New_Row;
    Main.Data(Gen_Info);
    Main.New_Row;
    Main.Data(a);
  
    b_Report.Add_Sheet(i_Name             => Ui.Current_Form_Name,
                       p_Table            => Main,
                       i_Param            => Fazo.Zip_Map('begin_date', i_Begin_Date,'end_date', i_End_Date).Json,
                       i_Split_Horizontal => v_Split_Horizontal,
                       i_Split_Vertical   => v_Split_Vertical);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run_Staff
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Begin_Date date,
    i_End_Date   date
  ) is
    v_Settings      Hashmap := Load_Preferences;
    v_Leave_By_Coef varchar2(1) := Nvl(v_Settings.o_Varchar2('show_leave_by_coef'), 'N');
  
    v_Show_Staff_Number boolean := Nvl(v_Settings.o_Varchar2('staff_number'), 'N') = 'Y';
    v_Show_Filial       boolean := Nvl(v_Settings.o_Varchar2('filial'), 'N') = 'Y';
    v_Show_Job          boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Rank         boolean := Nvl(v_Settings.o_Varchar2('rank'), 'N') = 'Y';
    v_Show_Division     boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Location     boolean := Nvl(v_Settings.o_Varchar2('location'), 'N') = 'Y';
    v_Show_Schedule     boolean := Nvl(v_Settings.o_Varchar2('schedule'), 'N') = 'Y';
    v_Show_Manager      boolean := Nvl(v_Settings.o_Varchar2('manager'), 'N') = 'Y';
    --
    v_Show_Late_Time                 boolean := Nvl(v_Settings.o_Varchar2('late_time'), 'N') = 'Y';
    v_Show_Early_Output              boolean := Nvl(v_Settings.o_Varchar2('early_output'), 'N') = 'Y';
    v_Show_Overtime                  boolean := Nvl(v_Settings.o_Varchar2('overtime'), 'N') = 'Y';
    v_Show_Free_Time                 boolean := Nvl(v_Settings.o_Varchar2('free_time'), 'N') = 'Y';
    v_Show_Worked_Coef               boolean := Nvl(v_Settings.o_Varchar2('worked_coef'), 'N') = 'Y';
    v_Show_Fact_Coef                 boolean := Nvl(v_Settings.o_Varchar2('fact_coef'), 'N') = 'Y';
    v_Show_Minutes                   boolean := Nvl(v_Settings.o_Varchar2('minutes'), 'N') = 'Y';
    v_Show_Minutes_Words             boolean := v_Show_Minutes and
                                                Nvl(v_Settings.o_Varchar2('minute_words'), 'N') = 'Y';
    v_Show_Only_Minute               boolean := v_Show_Minutes and
                                                Nvl(v_Settings.o_Varchar2('only_minute'), 'N') = 'Y';
    v_Check_Track                    boolean := Nvl(v_Settings.o_Varchar2('check_track'), 'N') = 'Y';
    v_Check_Track_Schedule           boolean := Nvl(v_Settings.o_Varchar2('check_track_schedule'),
                                                    'N') = 'Y';
    v_Show_Dismissed_And_Not_Hired   boolean := Nvl(v_Settings.o_Varchar2('dismissed_and_not_hired'),
                                                    'N') = 'Y';
    v_Show_Penalty_Late_Time         boolean := Nvl(v_Settings.o_Varchar2('penalty_late_time'), 'N') = 'Y';
    v_Show_Penalty_Early_Time        boolean := Nvl(v_Settings.o_Varchar2('penalty_early_time'),
                                                    'N') = 'Y';
    v_Show_Penalty_Lack_Time         boolean := Nvl(v_Settings.o_Varchar2('penalty_lack_time'), 'N') = 'Y';
    v_Show_Penalty_Total             boolean := Nvl(v_Settings.o_Varchar2('penalty_total_time'),
                                                    'N') = 'Y' and
                                                (v_Show_Penalty_Late_Time or
                                                 v_Show_Penalty_Early_Time or
                                                 v_Show_Penalty_Lack_Time);
    v_Show_Origin_Penalty_Late_Time  boolean := Nvl(v_Settings.o_Varchar2('origin_penalty_late_time'),
                                                    'N') = 'Y';
    v_Show_Origin_Penalty_Early_Time boolean := Nvl(v_Settings.o_Varchar2('origin_penalty_early_time'),
                                                    'N') = 'Y';
    v_Show_Origin_Penalty_Lack_Time  boolean := Nvl(v_Settings.o_Varchar2('origin_penalty_lack_time'),
                                                    'N') = 'Y';
    v_Show_Origin_Penalty_Total      boolean := Nvl(v_Settings.o_Varchar2('origin_penalty_total_time'),
                                                    'N') = 'Y';
    v_Show_Separate_Leave_Time       boolean := Nvl(v_Settings.o_Varchar2('separate_leave_time'),
                                                    'N') = 'Y';
    v_Show_Removed_Penalty_Time      boolean := Nvl(v_Settings.o_Varchar2('removed_penalty_time'),
                                                    'N') = 'Y' and
                                                (v_Show_Penalty_Late_Time or
                                                 v_Show_Penalty_Early_Time or
                                                 v_Show_Penalty_Lack_Time);
    v_Show_Rest_Free_Time            boolean := Nvl(v_Settings.o_Varchar2('rest_free_time'), 'N') = 'Y';
  
    v_Custom_Fact_Time          boolean := Nvl(v_Settings.o_Varchar2('custom_fact_time'), 'N') = 'Y';
    v_Include_Beforework        boolean := not v_Custom_Fact_Time or
                                           Nvl(v_Settings.o_Varchar2('before_work_time'), 'N') = 'Y';
    v_Include_Afterwork         boolean := not v_Custom_Fact_Time or
                                           Nvl(v_Settings.o_Varchar2('after_work_time'), 'N') = 'Y';
    v_Include_Lunchtime         boolean := not v_Custom_Fact_Time or
                                           Nvl(v_Settings.o_Varchar2('lunchtime'), 'N') = 'Y';
    v_Include_Rest_Free         boolean := not v_Custom_Fact_Time or
                                           Nvl(v_Settings.o_Varchar2('include_rest_free'), 'N') = 'Y';
    v_Check_Track_Schedule_Time boolean := v_Custom_Fact_Time and
                                           Nvl(v_Settings.o_Varchar2('track_schedule_time'), 'N') = 'Y';
    v_Show_Leave_By_Coef        boolean := v_Leave_By_Coef = 'Y';
  
    v_Rest_Free_Coef number := case
                                 when v_Show_Rest_Free_Time then
                                  Nvl(v_Settings.o_Number('rest_free_coef'), 1)
                                 else
                                  1
                               end;
    v_Division_Group_Id number := v_Settings.o_Number('division_group_id');
  
    v_Begin_Date date := i_Begin_Date;
    v_Days_Calc  Calc := Calc();
  
    v_Penalties     Array_Number;
    v_Time_Kind_Ids Array_Number := Nvl(v_Settings.o_Array_Number('time_kind_ids'), Array_Number());
  
    r_Person Mr_Natural_Persons%rowtype;
    r_Staff  Href_Staffs%rowtype;
  
    a          b_Table := b_Report.New_Table();
    c          b_Table := b_Report.New_Table();
    Color_Info b_Table := Get_Color_Info;
    Gen_Info   b_Table := b_Report.New_Table();
    Main       b_Table := b_Report.New_Table();
  
    v_Column_Count   number := 0;
    v_Split_Vertical number := 6;
    v_Column         number := 1;
    v_Fact_Colspan   number;
    v_Value          number;
    v_Input_Time     varchar2(5);
    v_Output_Time    varchar2(5);
    v_No_Time        varchar2(5) := 'xx:xx';
    v_Style          varchar2(100);
    v_Sysdate        date := Trunc(sysdate);
    v_Calc           Calc := Calc();
    v_Param          Hashmap;
  
    v_Leave_Key varchar2(100) := 'leave_time_key';
  
    v_Late_Time        number;
    v_Early_Output     number;
    v_Lack_Time        number;
    v_Overtime         number;
    v_Free_Time        number;
    v_Fact_Time        number;
    v_Leave_Time       number;
    v_Turnout_Time     number;
    v_Turnout_Id       number;
    v_Overtime_Id      number;
    v_Free_Id          number;
    v_Lack_Id          number;
    v_Late_Id          number;
    v_Early_Id         number;
    v_Beforework_Id    number;
    v_Afterwork_Id     number;
    v_Lunchtime_Id     number;
    v_Leave_Ids        Array_Number;
    v_Unaggregated_Ids Array_Number;
    v_Nls_Language     varchar2(100) := Uit_Href.Get_Nls_Language;
  
    v_Beforework number := 0;
    v_Afterwork  number := 0;
    v_Lunchtime  number := 0;
  
    t_Not_Come_Male    varchar2(50 char) := t('not come male');
    t_Not_Come_Female  varchar2(50 char) := t('not come female');
    t_Rest_Day         varchar2(50 char) := t('rest day');
    t_Not_Licensed_Day varchar2(50 char) := t('not licensed day');
    t_Leave            varchar2(50 char) := t('leave');
  
    --------------------------------------------------        
    Procedure Column_Count is
    begin
      v_Column_Count := 7;
    
      if v_Check_Track_Schedule then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Late_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Early_Output then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Origin_Penalty_Late_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Penalty_Late_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Origin_Penalty_Early_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Penalty_Early_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Origin_Penalty_Lack_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Penalty_Lack_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Origin_Penalty_Total then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Penalty_Total then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Removed_Penalty_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Overtime then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Free_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Rest_Free_Time then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Separate_Leave_Time then
        v_Column_Count := v_Column_Count + v_Time_Kind_Ids.Count + 2;
      else
        v_Column_Count := v_Column_Count + 2;
      end if;
    
      if v_Show_Worked_Coef then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      if v_Show_Fact_Coef then
        v_Column_Count := v_Column_Count + 1;
      end if;
    
      v_Column_Count := v_Column_Count - 5; -- minus color info 
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
        a.Column_Width(i_Column_Index => v_Column, i_Width => i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Put_Time(i_Seconds number) is
      v_Style varchar2(10);
    begin
      if i_Seconds < 0 then
        v_Style := 'danger';
      end if;
    
      if v_Show_Only_Minute then
        a.Data(Nullif(Round(i_Seconds / 60, 2), 0), v_Style);
      elsif v_Show_Minutes then
        a.Data(Htt_Util.To_Time_Seconds_Text(i_Seconds, v_Show_Minutes, v_Show_Minutes_Words),
               v_Style);
      else
        a.Data(Nullif(Round(i_Seconds / 3600, 2), 0), v_Style);
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
    Function Calc_Penalty
    (
      i_Division_Id number,
      i_Date        date,
      i_Late_Time   number,
      i_Early_Time  number,
      i_Lack_Time   number
    ) return Array_Number is
      v_Penalty_Id              number;
      v_Penalty_Kinds           Array_Varchar2;
      v_From_Times              Array_Number;
      v_To_Times                Array_Number;
      v_Coef                    Array_Number;
      v_Penalty_Time            Array_Number;
      v_From_Day                Array_Number;
      v_To_Day                  Array_Number;
      v_Calc_After_From_Time    Array_Varchar2;
      v_Original_Late_Time      number := 0;
      v_Original_Early_Time     number := 0;
      v_Original_Lack_Time      number := 0;
      v_Late_Times              number := 0;
      v_Early_Times             number := 0;
      v_Lack_Times              number := 0;
      v_Bf_Time                 number := 0;
      v_Penal_Time              number := 0;
      v_Penal_Times             number := 0;
      v_Days_Cnt                number;
      v_Is_Calc_After_From_Time boolean;
    begin
      v_Penalty_Id := Get_Penalty_Id(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => i_Filial_Id,
                                     i_Date        => i_Date,
                                     i_Division_Id => i_Division_Id);
    
      if v_Penalty_Id is null then
        return Array_Number(0, 0, 0, 0, 0, 0, 0);
      end if;
    
      select q.Penalty_Kind,
             q.From_Time,
             q.To_Time,
             q.Penalty_Coef,
             q.Penalty_Time,
             q.From_Day,
             q.To_Day,
             q.Calc_After_From_Time
        bulk collect
        into v_Penalty_Kinds,
             v_From_Times,
             v_To_Times,
             v_Coef,
             v_Penalty_Time,
             v_From_Day,
             v_To_Day,
             v_Calc_After_From_Time
        from Hpr_Penalty_Policies q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Penalty_Id = v_Penalty_Id;
    
      for j in 1 .. v_Penalty_Kinds.Count
      loop
        v_Bf_Time                 := 0;
        v_Is_Calc_After_From_Time := v_Calc_After_From_Time(j) = 'Y';
      
        -- check time
        if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Late and --
           i_Late_Time > v_From_Times(j) * 60 and --
           i_Late_Time <= Nvl(v_To_Times(j) * 60, i_Late_Time) then
        
          v_Days_Calc.Plus(Hpr_Pref.c_Penalty_Kind_Late, v_From_Times(j), v_From_Day(j), 1);
        end if;
      
        if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Early and --
           i_Early_Time > v_From_Times(j) * 60 and --
           i_Early_Time <= Nvl(v_To_Times(j) * 60, i_Early_Time) then
        
          v_Days_Calc.Plus(Hpr_Pref.c_Penalty_Kind_Early, v_From_Times(j), v_From_Day(j), 1);
        end if;
      
        if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Lack and --
           i_Lack_Time > v_From_Times(j) * 60 and --
           i_Lack_Time <= Nvl(v_To_Times(j) * 60, i_Lack_Time) then
        
          v_Days_Calc.Plus(Hpr_Pref.c_Penalty_Kind_Lack, v_From_Times(j), v_From_Day(j), 1);
        end if;
      
        -- check day
        v_Days_Cnt := v_Days_Calc.Get_Value(Hpr_Pref.c_Penalty_Kind_Late,
                                            v_From_Times(j),
                                            v_From_Day(j));
      
        if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Late and --
           v_Days_Cnt <= Nvl(v_To_Day(j), v_Days_Cnt) and --
           v_Days_Cnt > v_From_Day(j) then
          v_Bf_Time := i_Late_Time;
        end if;
      
        v_Days_Cnt := v_Days_Calc.Get_Value(Hpr_Pref.c_Penalty_Kind_Early,
                                            v_From_Times(j),
                                            v_From_Day(j));
      
        if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Early and --
           v_Days_Cnt <= Nvl(v_To_Day(j), v_Days_Cnt) and --
           v_Days_Cnt > v_From_Day(j) then
          v_Bf_Time := i_Early_Time;
        end if;
      
        v_Days_Cnt := v_Days_Calc.Get_Value(Hpr_Pref.c_Penalty_Kind_Lack,
                                            v_From_Times(j),
                                            v_From_Day(j));
      
        if v_Penalty_Kinds(j) = Hpr_Pref.c_Penalty_Kind_Lack and --
           v_Days_Cnt <= Nvl(v_To_Day(j), v_Days_Cnt) and --
           v_Days_Cnt > v_From_Day(j) then
          v_Bf_Time := i_Lack_Time;
        end if;
      
        continue when v_Bf_Time = 0;
      
        if v_Bf_Time > v_From_Times(j) * 60 and v_Bf_Time <= Nvl(v_To_Times(j) * 60, v_Bf_Time) then
          if v_Coef(j) is not null then
            if v_Is_Calc_After_From_Time then
              v_Penal_Time := (v_Bf_Time - v_From_Times(j) * 60) * v_Coef(j);
            else
              v_Penal_Time := v_Bf_Time * v_Coef(j);
            end if;
          else
            v_Penal_Time := Nvl(v_Penalty_Time(j) * 60, 0);
          end if;
        
          case v_Penalty_Kinds(j)
            when Hpr_Pref.c_Penalty_Kind_Late then
              v_Late_Times := v_Late_Times + v_Penal_Time;
            
              if v_Is_Calc_After_From_Time then
                v_Penal_Times        := v_Penal_Times + v_Penal_Time - i_Late_Time +
                                        v_From_Times(j) * 60;
                v_Original_Late_Time := v_Original_Late_Time + i_Late_Time - v_From_Times(j) * 60;
              else
                v_Penal_Times        := v_Penal_Times + v_Penal_Time - i_Late_Time;
                v_Original_Late_Time := v_Original_Late_Time + i_Late_Time;
              end if;
            when Hpr_Pref.c_Penalty_Kind_Early then
              v_Early_Times := v_Early_Times + v_Penal_Time;
            
              if v_Is_Calc_After_From_Time then
                v_Penal_Times         := v_Penal_Times + v_Penal_Time - i_Early_Time +
                                         v_From_Times(j) * 60;
                v_Original_Early_Time := v_Original_Early_Time + i_Early_Time -
                                         v_From_Times(j) * 60;
              else
                v_Penal_Times         := v_Penal_Times + v_Penal_Time - i_Early_Time;
                v_Original_Early_Time := v_Original_Early_Time + i_Early_Time;
              end if;
            when Hpr_Pref.c_Penalty_Kind_Lack then
              v_Lack_Times := v_Lack_Times + v_Penal_Time;
            
              if v_Is_Calc_After_From_Time then
                v_Penal_Times        := v_Penal_Times + v_Penal_Time - i_Lack_Time +
                                        v_From_Times(j) * 60;
                v_Original_Lack_Time := v_Original_Lack_Time + i_Lack_Time - v_From_Times(j) * 60;
              else
                v_Penal_Times        := v_Penal_Times + v_Penal_Time - i_Lack_Time;
                v_Original_Lack_Time := v_Original_Lack_Time + i_Lack_Time;
              end if;
          end case;
        end if;
      end loop;
    
      return Array_Number(v_Late_Times,
                          v_Early_Times,
                          v_Lack_Times,
                          v_Penal_Times,
                          v_Original_Late_Time,
                          v_Original_Early_Time,
                          v_Original_Lack_Time);
    end;
  
    --------------------------------------------------
    Function Calc_Free_Time
    (
      i_Free_Time  number,
      i_Beforework number,
      i_Afterwork  number,
      i_Lunchtime  number,
      i_Day_Kind   varchar2
    ) return number is
      v_Free_Time number := i_Free_Time;
      result      number := 0;
    begin
      if i_Day_Kind <> Htt_Pref.c_Day_Kind_Work then
        v_Free_Time := v_Free_Time * v_Rest_Free_Coef;
      end if;
    
      if v_Include_Beforework then
        result := result + i_Beforework;
      end if;
    
      if v_Include_Afterwork then
        result := result + i_Afterwork;
      end if;
    
      if v_Include_Lunchtime then
        result := result + i_Lunchtime;
      end if;
    
      if v_Include_Rest_Free and i_Day_Kind <> Htt_Pref.c_Day_Kind_Work then
        result := result + v_Free_Time;
      end if;
    
      -- temporary fix to free time inside plan
      -- maybe add variable to enable/disable this value
      -- Free time in plan    
      if i_Day_Kind = Htt_Pref.c_Day_Kind_Work then
        result := result + i_Free_Time;
      end if;
    
      return result;
    end;
  
  begin
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id, i_Filial_Id => i_Filial_Id);
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id,
                                          i_Person_Id  => r_Staff.Employee_Id);
  
    v_Param := Fazo.Zip_Map('person_id', r_Staff.Employee_Id, 'filial_id', i_Filial_Id);
  
    Column_Count;
  
    --info
    c.Current_Style('root bold');
    c.New_Row;
  
    if v_Show_Staff_Number then
      c.New_Row;
      c.Data(t('staff number: $1', r_Staff.Staff_Number), i_Colspan => v_Column_Count);
      v_Split_Vertical := v_Split_Vertical + 1;
    end if;
  
    c.New_Row;
    c.Data(t('employee: $1', r_Person.Name), i_Colspan => v_Column_Count);
  
    c.New_Row;
    c.Data(t('period: $1 - $2',
             to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
             to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
           i_Colspan => v_Column_Count);
  
    if v_Show_Filial and Ui.Is_Filial_Head then
      c.New_Row;
      c.Data(t('filial: $1',
               z_Md_Filials.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id).Name),
             i_Colspan => v_Column_Count);
    end if;
  
    if v_Show_Job then
      c.New_Row;
      c.Data(t('job: $1',
               z_Mhr_Jobs.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Job_Id => r_Staff.Job_Id).Name),
             i_Colspan => v_Column_Count);
    end if;
  
    if v_Show_Rank then
      c.New_Row;
      c.Data(t('rank: $1',
               z_Mhr_Ranks.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Rank_Id => r_Staff.Rank_Id).Name),
             i_Colspan => v_Column_Count);
    end if;
  
    if v_Show_Division then
      c.New_Row;
      c.Data(t('division: $1',
               z_Mhr_Divisions.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Division_Id => r_Staff.Division_Id).Name),
             i_Colspan => v_Column_Count);
    end if;
  
    if v_Show_Location then
      c.New_Row;
      c.Data(t('location: $1',
               Get_Location_Names(i_Company_Id  => r_Staff.Company_Id,
                                  i_Filial_Id   => r_Staff.Filial_Id,
                                  i_Employee_Id => r_Staff.Employee_Id)),
             i_Colspan => v_Column_Count);
    end if;
  
    if v_Show_Schedule then
      c.New_Row;
      c.Data(t('schedule: $1',
               z_Htt_Schedules.Take(i_Company_Id => r_Staff.Company_Id, i_Filial_Id => r_Staff.Filial_Id, i_Schedule_Id => r_Staff.Schedule_Id).Name),
             i_Colspan => v_Column_Count);
    end if;
  
    if v_Show_Manager then
      c.New_Row;
      c.Data(t('manager: $1',
               Uit_Hrm.Get_Manager_Name(i_Company_Id        => r_Staff.Company_Id,
                                        i_Filial_Id         => r_Staff.Filial_Id,
                                        i_Division_Id       => r_Staff.Division_Id,
                                        i_Division_Group_Id => v_Division_Group_Id)),
             i_Colspan => v_Column_Count);
    end if;
  
    Gen_Info.New_Row;
    Gen_Info.Data(c);
    Gen_Info.Data(Color_Info);
  
    -- Header
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
  
    if v_Show_Origin_Penalty_Late_Time then
      Print_Header(t('original penalty late time'), 1, 2, 75);
    end if;
  
    if v_Show_Penalty_Late_Time then
      Print_Header(t('penalty late time'), 1, 2, 75);
    end if;
  
    if v_Show_Origin_Penalty_Early_Time then
      Print_Header(t('original penalty early time'), 1, 2, 75);
    end if;
  
    if v_Show_Penalty_Early_Time then
      Print_Header(t('penalty early time'), 1, 2, 75);
    end if;
  
    if v_Show_Origin_Penalty_Lack_Time then
      Print_Header(t('original penalty lack time'), 1, 2, 75);
    end if;
  
    if v_Show_Penalty_Lack_Time then
      Print_Header(t('penalty lack time'), 1, 2, 75);
    end if;
  
    if v_Show_Origin_Penalty_Total then
      Print_Header(t('original penalty total time'), 1, 2, 75);
    end if;
  
    if v_Show_Penalty_Total then
      Print_Header(t('penalty total time'), 1, 2, 75);
    end if;
  
    if v_Show_Removed_Penalty_Time then
      Print_Header(t('fact time removed penalty time'), 1, 2, 75);
    end if;
  
    Print_Header(t('intime'), 1, 2, 75);
  
    if v_Show_Overtime then
      Print_Header(t('overtime'), 1, 2, 75);
    end if;
  
    if v_Show_Free_Time then
      Print_Header(t('free time'), 1, 2, 75);
    end if;
  
    if v_Show_Rest_Free_Time then
      Print_Header(t('rest free time'), 1, 2, 75);
    end if;
  
    if v_Show_Separate_Leave_Time then
      Print_Header(t('leave and absence'), (v_Time_Kind_Ids.Count + 2), 1, 75);
    else
      Print_Header(t('leave and absence'), 2, 1, 75);
    end if;
  
    Print_Header(t('total'), 1, 2, 75);
  
    if v_Show_Worked_Coef then
      Print_Header(t('worked coef'), 1, 2, 75);
    end if;
  
    if v_Show_Fact_Coef then
      Print_Header(t('fact coef'), 1, 2, 75);
    end if;
  
    a.New_Row;
  
    a.Data(t('input'));
    a.Data(t('output'));
    a.Data(t('plan_time'));
    --
    a.Data(t('input'));
    a.Data(t('output'));
    a.Data(t('fact time'));
    --
    if v_Show_Separate_Leave_Time then
      for i in 1 .. v_Time_Kind_Ids.Count
      loop
        Print_Header(z_Htt_Time_Kinds.Load(i_Company_Id => i_Company_Id, i_Time_Kind_Id => v_Time_Kind_Ids(i)).Name,
                     1,
                     1,
                     null);
      end loop;
    end if;
  
    if v_Show_Leave_By_Coef then
      Print_Header(t('leave time by coef'), 1, 1, null);
    else
      Print_Header(t('leave time'), 1, 1, null);
    end if;
  
    a.Data(t('absence time'));
  
    -- body
    a.Current_Style('body_centralized');
  
    Load_Report_Time_Kind_Ids(i_Company_Id       => i_Company_Id,
                              o_Turnout_Id       => v_Turnout_Id,
                              o_Lack_Id          => v_Lack_Id,
                              o_Late_Id          => v_Late_Id,
                              o_Early_Id         => v_Early_Id,
                              o_Overtime_Id      => v_Overtime_Id,
                              o_Free_Id          => v_Free_Id,
                              o_Beforework_Id    => v_Beforework_Id,
                              o_Afterwork_Id     => v_Afterwork_Id,
                              o_Lunchtime_Id     => v_Lunchtime_Id,
                              o_Leave_Ids        => v_Leave_Ids,
                              o_Unaggregated_Ids => v_Unaggregated_Ids);
  
    v_Unaggregated_Ids := case
                            when v_Show_Separate_Leave_Time then
                             v_Unaggregated_Ids multiset union v_Time_Kind_Ids
                            else
                             v_Unaggregated_Ids
                          end;
  
    Cache_Timesheet_Facts(i_Company_Id    => i_Company_Id,
                          i_Filial_Id     => i_Filial_Id,
                          i_Staff_Id      => i_Staff_Id,
                          i_Begin_Date    => i_Begin_Date,
                          i_End_Date      => i_End_Date,
                          i_Leave_Key     => v_Leave_Key,
                          i_Leave_Ids     => v_Leave_Ids,
                          i_Time_Kind_Ids => v_Unaggregated_Ids,
                          i_Leave_By_Coef => v_Leave_By_Coef,
                          p_Calc          => v_Calc);
  
    v_Fact_Colspan := v_Column - 6;
  
    for Tsht in (select q.*,
                        Td.Time_Kind_Id Timeoff_Tk_Id,
                        Nvl2(Td.Time_Kind_Id, 'Y', 'N') Timeoff_Exists,
                        Nvl((select 'N'
                              from Hlic_Unlicensed_Employees Le
                             where Le.Company_Id = r_Staff.Company_Id
                               and Le.Employee_Id = r_Staff.Employee_Id
                               and Le.Licensed_Date = Dates.Date_Value),
                            'Y') as Licensed
                   from (select i_Begin_Date + (level - 1) Date_Value
                           from Dual
                         connect by level <= (i_End_Date - i_Begin_Date + 1)) Dates
                   left join Htt_Timesheets q
                     on q.Company_Id = i_Company_Id
                    and q.Filial_Id = i_Filial_Id
                    and q.Staff_Id = i_Staff_Id
                    and Dates.Date_Value = q.Timesheet_Date
                   left join Hpd_Timeoff_Days Td
                     on Td.Company_Id = q.Company_Id
                    and Td.Filial_Id = q.Filial_Id
                    and Td.Staff_Id = q.Staff_Id
                    and Td.Timeoff_Date = q.Timesheet_Date
                  order by Dates.Date_Value)
    loop
      if Tsht.Company_Id is null then
        continue;
      end if;
    
      if Trunc(v_Begin_Date, 'mon') <> Trunc(Tsht.Timesheet_Date, 'mon') then
        v_Begin_Date := Tsht.Timesheet_Date;
      end if;
    
      v_Style := null;
    
      v_Param.Put('track_date', Tsht.Timesheet_Date);
    
      v_Input_Time  := to_char(Tsht.Input_Time, Href_Pref.c_Time_Format_Minute);
      v_Output_Time := to_char(Tsht.Output_Time, Href_Pref.c_Time_Format_Minute);
    
      a.New_Row;
    
      if Tsht.Licensed = 'Y' and (v_Input_Time is not null or v_Output_Time is not null) then
        a.Data(to_char(Tsht.Timesheet_Date, 'dd/mm/yyyy'), i_Param => v_Param.Json());
      else
        a.Data(to_char(Tsht.Timesheet_Date, 'dd/mm/yyyy'));
      end if;
    
      a.Data(to_char(Tsht.Timesheet_Date, 'Dy', v_Nls_Language));
    
      -- plan
      case Tsht.Day_Kind
        when Htt_Pref.c_Day_Kind_Work then
          a.Data(to_char(Tsht.Begin_Time, Href_Pref.c_Time_Format_Minute));
          a.Data(to_char(Tsht.End_Time, Href_Pref.c_Time_Format_Minute));
          Put_Time(Tsht.Plan_Time);
        
          v_Calc.Plus('plan_time', Tsht.Plan_Time);
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
                           Htt_Util.To_Time_Text(Round(Tsht.Plan_Time / 60, 2), v_Show_Minutes));
        
          v_Calc.Plus('plan_time', Tsht.Plan_Time);
        else
          a.Add_Data(3);
      end case;
    
      -- fact
      if Tsht.Licensed = 'N' then
        a.Data(t_Not_Licensed_Day, 'not_licensed', i_Colspan => v_Fact_Colspan);
        continue;
      end if;
    
      v_Turnout_Time := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Turnout_Id);
    
      if v_Check_Track_Schedule_Time and Tsht.Planned_Marks > 0 then
        v_Turnout_Time := v_Turnout_Time -
                          Calc_Track_Schedule_Times(i_Company_Id   => Tsht.Company_Id,
                                                    i_Filial_Id    => Tsht.Filial_Id,
                                                    i_Timesheet_Id => Tsht.Timesheet_Id);
      end if;
    
      v_Overtime     := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Overtime_Id);
      v_Free_Time    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Free_Id);
      v_Lack_Time    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Lack_Id);
      v_Late_Time    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Late_Id);
      v_Early_Output := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Early_Id);
      v_Beforework   := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Beforework_Id);
      v_Afterwork    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Afterwork_Id);
      v_Lunchtime    := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Lunchtime_Id);
      v_Leave_Time   := v_Calc.Get_Value(Tsht.Timesheet_Date, v_Leave_Key);
    
      v_Free_Time := Calc_Free_Time(i_Free_Time  => v_Free_Time,
                                    i_Beforework => v_Beforework,
                                    i_Afterwork  => v_Afterwork,
                                    i_Lunchtime  => v_Lunchtime,
                                    i_Day_Kind   => Tsht.Day_Kind);
    
      v_Style     := null;
      v_Fact_Time := v_Turnout_Time + v_Free_Time;
    
      if v_Input_Time is not null or v_Output_Time is not null then
        if Tsht.Day_Kind = Htt_Pref.c_Day_Kind_Work and
           (v_Turnout_Time < Tsht.Plan_Time or
           v_Check_Track and
           not Check_Track_Type_Exist(i_Company_Id => Tsht.Company_Id,
                                       i_Filial_Id  => Tsht.Filial_Id,
                                       i_Person_Id  => Tsht.Employee_Id,
                                       i_Begin_Time => Tsht.Shift_Begin_Time,
                                       i_End_Time   => Tsht.Shift_End_Time)) then
          v_Style := 'warning';
        end if;
      
        a.Data(Nvl(v_Input_Time, v_No_Time), v_Style);
        a.Data(Nvl(v_Output_Time, v_No_Time), v_Style);
        Put_Time(v_Fact_Time);
      elsif Tsht.Day_Kind = Htt_Pref.c_Day_Kind_Work and Tsht.Timesheet_Date <= v_Sysdate then
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
        if Tsht.Timesheet_Date <= v_Sysdate then
          if Tsht.Done_Marks = 0 then
            v_Style := 'danger';
          elsif Tsht.Done_Marks < Tsht.Planned_Marks then
            v_Style := 'warning';
          else
            v_Style := 'success';
          end if;
        end if;
        if Tsht.Planned_Marks > 0 then
          a.Data(t('$1/$2', Tsht.Done_Marks, Tsht.Planned_Marks), v_Style);
        else
          a.Data;
        end if;
      end if;
    
      if Tsht.Timeoff_Exists = 'N' then
        Add_Request(i_Timesheet_Id   => Tsht.Timesheet_Id,
                    i_Timesheet_Date => Tsht.Timesheet_Date,
                    i_Calendar_Id    => Tsht.Calendar_Id,
                    i_Day_Kind       => Tsht.Day_Kind);
      else
        Add_Timeoff(Tsht.Timeoff_Tk_Id);
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
    
      -- penalties
      if v_Show_Penalty_Late_Time or --
         v_Show_Penalty_Early_Time or --
         v_Show_Penalty_Lack_Time or --
         v_Show_Origin_Penalty_Late_Time or --
         v_Show_Origin_Penalty_Early_Time or --
         v_Show_Origin_Penalty_Lack_Time then
        v_Penalties := Calc_Penalty(r_Staff.Division_Id,
                                    Tsht.Timesheet_Date,
                                    v_Late_Time,
                                    v_Early_Output,
                                    v_Lack_Time);
      
        if v_Show_Origin_Penalty_Late_Time then
          Put_Time(v_Penalties(5));
          v_Calc.Plus('original_late_time', v_Penalties(5));
        end if;
      
        if v_Show_Penalty_Late_Time then
          Put_Time(v_Penalties(1));
          v_Calc.Plus('penalty_late_time', v_Penalties(1));
        end if;
      
        if v_Show_Origin_Penalty_Early_Time then
          Put_Time(v_Penalties(6));
          v_Calc.Plus('original_early_time', v_Penalties(6));
        end if;
      
        if v_Show_Penalty_Early_Time then
          Put_Time(v_Penalties(2));
          v_Calc.Plus('penalty_early_time', v_Penalties(2));
        end if;
      
        if v_Show_Origin_Penalty_Lack_Time then
          Put_Time(v_Penalties(7));
          v_Calc.Plus('original_lack_time', v_Penalties(7));
        end if;
      
        if v_Show_Penalty_Lack_Time then
          Put_Time(v_Penalties(3));
          v_Calc.Plus('penalty_lack_time', v_Penalties(3));
        end if;
      
        if v_Show_Origin_Penalty_Total then
          Put_Time(v_Penalties(5) + v_Penalties(6) + v_Penalties(7));
          v_Calc.Plus('original_total_time', v_Penalties(5) + v_Penalties(6) + v_Penalties(7));
        end if;
      
        if v_Show_Penalty_Total then
          Put_Time(v_Penalties(1) + v_Penalties(2) + v_Penalties(3));
          v_Calc.Plus('penalty_total_time', v_Penalties(1) + v_Penalties(2) + v_Penalties(3));
        end if;
      
        if v_Show_Removed_Penalty_Time then
          Put_Time(v_Turnout_Time - v_Penalties(4));
          v_Calc.Plus('removed_penalty_time', v_Turnout_Time - v_Penalties(4));
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
    
      if v_Show_Rest_Free_Time then
        if Tsht.Day_Kind <> Htt_Pref.c_Day_Kind_Work and v_Free_Time > 0 then
          Put_Time(v_Free_Time);
        else
          a.Data;
        end if;
      end if;
    
      if v_Show_Separate_Leave_Time then
        for i in 1 .. v_Time_Kind_Ids.Count
        loop
          Put_Time(v_Calc.Get_Value(Tsht.Timesheet_Date, v_Time_Kind_Ids(i)));
          v_Calc.Plus(v_Time_Kind_Ids(i),
                      v_Calc.Get_Value(Tsht.Timesheet_Date, v_Time_Kind_Ids(i)));
        end loop;
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
    
      Put_Time(v_Turnout_Time + v_Leave_Time + v_Overtime);
    
      if v_Show_Worked_Coef then
        if Tsht.Plan_Time > 0 then
          v_Value := Round((v_Turnout_Time + v_Leave_Time + v_Overtime) / Tsht.Plan_Time, 4) * 100;
          a.Data(Nullif(v_Value, 0));
        else
          a.Data;
        end if;
      end if;
    
      if v_Show_Fact_Coef then
        if Tsht.Plan_Time > 0 then
          v_Value := Round((v_Turnout_Time + v_Free_Time) / Tsht.Plan_Time, 4) * 100;
          a.Data(Nullif(v_Value, 0));
        else
          a.Data;
        end if;
      end if;
    
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
    
      if v_Show_Rest_Free_Time then
        if Tsht.Day_Kind <> Htt_Pref.c_Day_Kind_Work then
          v_Calc.Plus('rest_free_time', v_Free_Time);
        end if;
      end if;
    
      v_Calc.Plus('leave_time', v_Leave_Time);
      v_Calc.Plus('absence_time', v_Late_Time + v_Lack_Time + v_Early_Output);
      v_Calc.Plus('total', v_Turnout_Time + v_Leave_Time + v_Overtime);
    end loop;
  
    if v_Show_Dismissed_And_Not_Hired then
      v_Calc.Plus('plan_time',
                  Get_Plan_Time(i_Company_Id     => i_Company_Id,
                                i_Filial_Id      => i_Filial_Id,
                                i_Staff_Id       => r_Staff.Staff_Id,
                                i_Hiring_Date    => r_Staff.Hiring_Date,
                                i_Dismissal_Date => r_Staff.Dismissal_Date,
                                i_Robot_Id       => r_Staff.Robot_Id,
                                i_Schedule_Id    => r_Staff.Schedule_Id,
                                i_Begin_Date     => i_Begin_Date,
                                i_End_Date       => i_End_Date));
    end if;
  
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
  
    if v_Show_Origin_Penalty_Late_Time then
      Put_Time(v_Calc.Get_Value('original_late_time'));
    end if;
  
    if v_Show_Penalty_Late_Time then
      Put_Time(v_Calc.Get_Value('penalty_late_time'));
    end if;
  
    if v_Show_Origin_Penalty_Early_Time then
      Put_Time(v_Calc.Get_Value('original_early_time'));
    end if;
  
    if v_Show_Penalty_Early_Time then
      Put_Time(v_Calc.Get_Value('penalty_early_time'));
    end if;
  
    if v_Show_Origin_Penalty_Lack_Time then
      Put_Time(v_Calc.Get_Value('original_lack_time'));
    end if;
  
    if v_Show_Penalty_Lack_Time then
      Put_Time(v_Calc.Get_Value('penalty_lack_time'));
    end if;
  
    if v_Show_Origin_Penalty_Total then
      Put_Time(v_Calc.Get_Value('original_total_time'));
    end if;
  
    if v_Show_Penalty_Total then
      Put_Time(v_Calc.Get_Value('penalty_total_time'));
    end if;
  
    if v_Show_Removed_Penalty_Time then
      Put_Time(v_Calc.Get_Value('removed_penalty_time'));
    end if;
  
    Put_Time(v_Calc.Get_Value('intime'));
  
    if v_Show_Overtime then
      Put_Time(v_Calc.Get_Value('overtime'));
    end if;
  
    if v_Show_Free_Time then
      Put_Time(v_Calc.Get_Value('free_time'));
    end if;
  
    if v_Show_Rest_Free_Time then
      Put_Time(v_Calc.Get_Value('rest_free_time'));
    end if;
  
    if v_Show_Separate_Leave_Time then
      for i in 1 .. v_Time_Kind_Ids.Count
      loop
        Put_Time(v_Calc.Get_Value(v_Time_Kind_Ids(i)));
      end loop;
    end if;
  
    Put_Time(v_Calc.Get_Value('leave_time'));
    Put_Time(v_Calc.Get_Value('absence_time'));
    Put_Time(v_Calc.Get_Value('total'));
  
    if v_Show_Worked_Coef then
      if v_Calc.Get_Value('plan_time') > 0 then
        v_Value := Round((v_Calc.Get_Value('intime') + v_Calc.Get_Value('leave_time') +
                         v_Calc.Get_Value('overtime')) / v_Calc.Get_Value('plan_time'),
                         4) * 100;
        a.Data(Nullif(v_Value, 0));
      else
        a.Data;
      end if;
    end if;
  
    if v_Show_Fact_Coef then
      if v_Calc.Get_Value('plan_time') > 0 then
        a.Data(Nullif(Round((v_Calc.Get_Value('intime') + v_Calc.Get_Value('free_time')) /
                            v_Calc.Get_Value('plan_time'),
                            4) * 100,
                      0));
      else
        a.Data;
      end if;
    end if;
  
    Main.New_Row;
    Main.Data(Gen_Info);
    Main.New_Row;
    Main.Data(a);
  
    b_Report.Add_Sheet(i_Name           => Ui.Current_Form_Name,
                       p_Table          => Main,
                       i_Split_Vertical => v_Split_Vertical);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
    v_Company_Id    number := Ui.Company_Id;
    v_Filial_Id     number := Ui.Filial_Id;
    v_Filial_Ids    Array_Number := Nvl(p.o_Array_Number('filial_ids'), Array_Number());
    v_Staff_Ids     Array_Number;
    v_Employee_Name Md_Persons.Name%type;
    v_Param         Hashmap;
  
    --------------------------------------------------
    Function Get_Filial_Id
    (
      i_Company_Id number,
      i_Staff_Id   number
    ) return number is
      result number;
    begin
      select q.Filial_Id
        into result
        from Href_Staffs q
       where q.Company_Id = i_Company_Id
         and q.Staff_Id = i_Staff_Id;
    
      return result;
    end;
  begin
    v_Staff_Ids := Nvl(p.o_Array_Number('staff_ids'), Array_Number());
  
    if not Ui.Is_Filial_Head then
      v_Filial_Ids := Array_Number(v_Filial_Id);
    end if;
  
    if b_Report.Is_Redirect(p) then
      v_Param := Fazo.Parse_Map(p.r_Varchar2('cell_param'));
      if v_Param.Has('staff_id') then
        v_Param := Fazo.Zip_Map('staff_ids', v_Param.r_Number('staff_id'));
        v_Param.Put_All(Fazo.Parse_Map(p.r_Varchar2('table_param')));
        b_Report.Redirect_To_Report('/vhr/rep/htt/timesheet:run', v_Param);
      else
        b_Report.Redirect_To_Form('/vhr/htt/track_list',
                                  v_Param,
                                  i_Filial_Id => v_Param.o_Number('filial_id'));
      end if;
    else
      if v_Staff_Ids.Count = 1 then
        if Ui.Is_Filial_Head then
          v_Filial_Id := Get_Filial_Id(i_Company_Id => v_Company_Id, --
                                       i_Staff_Id   => v_Staff_Ids(1));
        end if;
      
        v_Employee_Name := ' (' || Href_Util.Staff_Name(i_Company_Id => v_Company_Id,
                                                        i_Filial_Id  => v_Filial_Id,
                                                        i_Staff_Id   => v_Staff_Ids(1)) || ')';
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
    
      if v_Staff_Ids.Count = 1 then
        Run_Staff(i_Company_Id => v_Company_Id,
                  i_Filial_Id  => v_Filial_Id,
                  i_Staff_Id   => v_Staff_Ids(1),
                  i_Begin_Date => Nvl(p.o_Date('begin_date'), Trunc(sysdate, 'mon')),
                  i_End_Date   => Nvl(p.o_Date('end_date'), Trunc(Last_Day(sysdate))));
      else
        Run_All(i_Company_Id   => v_Company_Id,
                i_Filial_Ids   => v_Filial_Ids,
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
  Procedure Run_Telegram(p Hashmap) is
    Data Hashmap := p;
  begin
    Data.Put('rt', Biruni_Report.Rt_Xlsx);
  
    Run(Data);
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
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
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
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           name         = null,
           Requestable  = null,
           State        = null;
  end;

end Ui_Vhr101;
/
