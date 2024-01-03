create or replace package Ui_Vhr297 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Filials return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Employees(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Ftes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Day_Stats_Piechart(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Day_Stats_Xychart(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Birthdays return Arraylist;
end Ui_Vhr297;
/
create or replace package body Ui_Vhr297 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'ui_vhr297:settings';
  c_Employee_Filter_All         constant varchar2(1) := 'A';
  c_Employee_Filter_Managers    constant varchar2(1) := 'M';
  c_Employee_Filter_Subordinate constant varchar2(1) := 'S';

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
  Function Get_Filial_Managers return Array_Number is
    v_Manager_Ids Array_Number := Array_Number();
  begin
    select t.Manager_Id
      bulk collect
      into v_Manager_Ids
      from Mrf_Division_Managers t
     where t.Company_Id = Ui.Company_Id
       and exists (select 1
              from Mhr_Divisions q
             where q.Company_Id = t.Company_Id
               and q.Filial_Id = t.Filial_Id
               and q.Division_Id = t.Division_Id
               and q.Parent_Id is null
               and q.State = 'A');
  
    return v_Manager_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_User_Divisions return Array_Number is
    v_Division_Ids Array_Number := Array_Number();
  begin
    with User_Division_Ids as
     (select Rd.Division_Id
        from Hrm_Robot_Divisions Rd
       where Rd.Company_Id = Ui.Company_Id
         and exists (select 1
                from Mrf_Robots r
               where r.Company_Id = Rd.Company_Id
                 and r.Filial_Id = Rd.Filial_Id
                 and r.Robot_Id = Rd.Robot_Id
                 and r.Person_Id = Ui.User_Id
                 and r.State = 'A'))
    select d.Division_Id
      bulk collect
      into v_Division_Ids
      from Mhr_Divisions d
     where d.Company_Id = Ui.Company_Id
       and d.State = 'A'
       and (exists (select 1
                      from User_Division_Ids Ud
                     where Ud.Division_Id = d.Division_Id) --
            or exists (select 1
                         from Mhr_Parent_Divisions Pd
                        where Pd.Company_Id = d.Company_Id
                          and Pd.Filial_Id = d.Filial_Id
                          and Pd.Division_Id = d.Division_Id
                          and Pd.Parent_Id in (select *
                                                 from User_Division_Ids)));
    return v_Division_Ids;
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
  Function Query_Employees(p Hashmap) return Fazo_Query is
    v_Filial_Ids        Array_Number := Nvl(p.o_Array_Number('filial_id'), Array_Number());
    v_Fte_Ids           Array_Number := Nvl(p.o_Array_Number('fte_id'), Array_Number());
    v_Timesheet_Date    date := p.r_Date('date');
    v_Filial_Managers   Array_Number := Array_Number();
    v_User_Divisions    Array_Number := Array_Number();
    v_Employee_Filter   varchar2(1) := Nvl(Nvl(p.o_Varchar2('employee_filter'),
                                               Load_Preferences().o_Varchar2('employee_filter')),
                                           c_Employee_Filter_All);
    v_Current_Time      date := Htt_Util.Get_Current_Date(i_Company_Id => Ui.Company_Id,
                                                          i_Filial_Id  => Ui.Filial_Id);
    v_Query             varchar2(32767);
    v_Work_Status_Query varchar2(32767);
    v_Divs_Query        varchar2(4000);
    v_Params            Hashmap := Hashmap();
    v_Matrix            Matrix_Varchar2;
    q                   Fazo_Query;
  begin
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('filial_ids', v_Filial_Ids);
    v_Params.Put('fte_ids', v_Fte_Ids);
    v_Params.Put('timesheet_date', v_Timesheet_Date);
    v_Params.Put('format', Href_Pref.c_Time_Format_Minute);
    v_Params.Put('turnout_ids',
                 Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => Ui.Company_Id,
                                                   i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout)));
    v_Params.Put('late_id',
                 Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late));
    v_Params.Put('absence_ids',
                 Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => Ui.Company_Id,
                                                   i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Leave,
                                                                                  Htt_Pref.c_Pcode_Time_Kind_Leave_Full,
                                                                                  Htt_Pref.c_Pcode_Time_Kind_Sick,
                                                                                  Htt_Pref.c_Pcode_Time_Kind_Trip,
                                                                                  Htt_Pref.c_Pcode_Time_Kind_Vacation)));
    v_Params.Put('curr_date', v_Current_Time);
    v_Params.Put('worktime_not_started', Htt_Pref.c_Dashboard_Worktime_Not_Started);
    v_Params.Put('leave_exists', Htt_Pref.c_Dashboard_Leave_Exists);
    v_Params.Put('staff_late', Htt_Pref.c_Dashboard_Staff_Late);
    v_Params.Put('staff_intime', Htt_Pref.c_Dashboard_Staff_Intime);
    v_Params.Put('staff_not_come', Htt_Pref.c_Dashboard_Staff_Not_Come);
    v_Params.Put('rest_day', Htt_Pref.c_Dashboard_Rest_Day);
    v_Params.Put('holiday', Htt_Pref.c_Dashboard_Holiday);
    v_Params.Put('additional_rest_day', Htt_Pref.c_Dashboard_Additional_Rest_Day);
    v_Params.Put('nonworking_day', Htt_Pref.c_Dashboard_Nonworking_Day);
    v_Params.Put('not_licensed_day', Htt_Pref.c_Dashboard_Not_Licensed_Day);
    v_Params.Put('no_timesheet', Htt_Pref.c_Dashboard_No_Timesheet);
    v_Params.Put('day_kind_work', Htt_Pref.c_Day_Kind_Work);
    v_Params.Put('day_kind_rest', Htt_Pref.c_Day_Kind_Rest);
    v_Params.Put('day_kind_holiday', Htt_Pref.c_Day_Kind_Holiday);
    v_Params.Put('day_kind_additional_rest_day', Htt_Pref.c_Day_Kind_Additional_Rest);
    v_Params.Put('day_kind_nonworking', Htt_Pref.c_Day_Kind_Nonworking);
    v_Params.Put('sk_primary', Href_Pref.c_Staff_Kind_Primary);
  
    v_Params.Put('ws_in', Htt_Pref.c_Work_Status_In);
    v_Params.Put('ws_out', Htt_Pref.c_Work_Status_Out);
    v_Params.Put('ws_returned', Htt_Pref.c_Work_Status_Returned);
    v_Params.Put('tt_input', Htt_Pref.c_Track_Type_Input);
    v_Params.Put('tt_output', Htt_Pref.c_Track_Type_Output);
    v_Params.Put('tt_merger', Htt_Pref.c_Track_Type_Merger);
  
    v_Query := 'select w.*, 
                       f.tin,
                       f.cea,
                       f.main_phone,
                       g.email,
                       g.photo_sha,
                       m.iapa,
                       m.npin,
                       q.filial_id,
                       q.staff_id,
                       q.hiring_date,
                       q.staff_number,
                       q.division_id,
                       q.job_id,
                       q.rank_id,
                       q.schedule_id,
                       q.fte_id,
                       k.timesheet_id,
                       (select round(gt.total_distance / 1000, 3)
                          from htt_gps_tracks gt
                         where gt.company_id = :company_id
                           and gt.filial_id = q.filial_id
                           and gt.person_id = q.employee_id
                           and gt.track_date = :timesheet_date) as total_distance,
                       k.begin_time,
                       to_char(k.input_time, :format) input_time,
                       to_char(k.output_time, :format) output_time,
                       k.input_time input_time_dt,
                       k.output_time output_time_dt,
                       (select round(t.fact_value / 60)
                          from htt_timesheet_facts t 
                         where t.company_id = :company_id
                           and t.filial_id = k.filial_id
                           and t.timesheet_id = k.timesheet_id
                           and t.time_kind_id = :late_id) late_time,
                       (case
                          when k.staff_id is null then
                           :no_timesheet
                          when k.licensed = ''N'' then
                           :not_licensed_day
                          when k.day_kind = :day_kind_work then
                           case
                             when :curr_date < k.begin_time and k.input_time is null then
                              :worktime_not_started
                             when nvl((select sum(t.fact_value)
                                         from htt_timesheet_facts t
                                        where t.company_id = :company_id
                                          and t.filial_id = k.filial_id
                                          and t.timesheet_id = k.timesheet_id
                                          and t.time_kind_id member of :absence_ids),
                                       -1) >= k.plan_time then
                              :leave_exists
                             when nvl((select t.fact_value
                                         from htt_timesheet_facts t
                                        where t.company_id = :company_id
                                          and t.filial_id = k.filial_id
                                          and t.timesheet_id = k.timesheet_id
                                          and t.time_kind_id = :late_id),
                                       -1) > 0 then
                              :staff_late
                             when k.input_time is not null and k.input_time < k.end_time
                                  or nvl((select sum(t.fact_value)
                                            from htt_timesheet_facts t
                                           where t.company_id = :company_id
                                             and t.filial_id = k.filial_id
                                             and t.timesheet_id = k.timesheet_id
                                             and t.time_kind_id member of :turnout_ids),
                                          -1) > 0 then
                              :staff_intime
                             when k.count_lack = ''N'' and :curr_date <= k.end_time then
                              :worktime_not_started
                             else
                              :staff_not_come
                           end
                          when k.day_kind = :day_kind_rest then
                           :rest_day
                          when k.day_kind = :day_kind_holiday then
                           :holiday
                          when k.day_kind = :day_kind_additional_rest_day then
                           :additional_rest_day
                          when k.day_kind = :day_kind_nonworking then
                           :nonworking_day
                          else
                           :no_timesheet
                        end) kind                           
                  from href_staffs q
                  left join (select k.filial_id,
                                    nvl2(le.employee_id, null, k.timesheet_id) as timesheet_id,
                                    k.staff_id,
                                    k.day_kind,
                                    k.count_lack,
                                    k.begin_time,
                                    k.end_time,
                                    nvl2(le.employee_id, null, k.input_time) as input_time,
                                    nvl2(le.employee_id, null, k.output_time) as output_time,
                                    k.plan_time,
                                    nvl2(le.employee_id, ''N'', ''Y'') as licensed
                               from htt_timesheets k
                               left join hlic_unlicensed_employees le
                                 on le.company_id = :company_id
                                and le.employee_id = k.employee_id
                                and le.licensed_date = :timesheet_date
                              where k.company_id = :company_id
                                and k.timesheet_date = :timesheet_date) k
                    on k.filial_id = q.filial_id
                   and k.staff_id = q.staff_id
                  join md_persons g
                    on g.company_id = :company_id
                   and g.person_id  = q.employee_id
                  join mr_natural_persons w
                    on w.company_id = :company_id
                   and w.person_id = q.employee_id
                  left join mr_person_details f 
                    on f.company_id = :company_id
                   and f.person_id = q.employee_id
                  left join href_person_details m
                    on m.company_id = :company_id
                   and m.person_id = q.employee_id
                 where q.company_id = :company_id
                   and q.hiring_date <= trunc(:timesheet_date)
                   and (q.dismissal_date is null or q.dismissal_date >= trunc(:timesheet_date))
                   and q.staff_kind = :sk_primary
                   and q.state = ''A''
                   and exists (select 1
                          from mhr_employees e
                         where e.company_id = :company_id
                           and e.filial_id = q.filial_id
                           and e.employee_id = q.employee_id
                           and e.state = ''A'')';
  
    if v_Filial_Ids.Count > 0 then
      v_Query := v_Query || --
                 ' and q.filial_id in (select * from table(:filial_ids))';
    end if;
  
    if v_Fte_Ids.Count > 0 then
      v_Query := v_Query || --
                 ' and q.fte_id member of :fte_ids';
    end if;
  
    case v_Employee_Filter
      when c_Employee_Filter_All then
        null;
      
    --------------------------------------------------
      when c_Employee_Filter_Managers then
        v_Filial_Managers := Get_Filial_Managers();
        v_Params.Put('filial_managers', v_Filial_Managers);
      
        v_Query := v_Query || ' and q.robot_id member of (:filial_managers)';
      
    --------------------------------------------------
      when c_Employee_Filter_Subordinate then
        v_User_Divisions := Get_User_Divisions();
      
        v_Params.Put('user_id', Ui.User_Id);
        v_Params.Put('user_divisions', v_User_Divisions);
      
        v_Query := v_Query ||
                   ' and q.employee_id <> :user_id and q.division_id member of (:user_divisions)';
    end case;
  
    if Trunc(v_Current_Time) = v_Timesheet_Date then
      v_Work_Status_Query := 'select case
                                       when tr.track_type = :tt_output then
                                        :ws_out
                                       when tr.track_type in (:tt_input, :tt_merger) and qr.output_time_dt < tr.track_datetime then
                                        :ws_returned
                                       when tr.track_type in (:tt_input, :tt_merger) then
                                        :ws_in
                                        else
                                         null
                                      end
                                from htt_timesheet_tracks tr
                               where tr.company_id = :company_id
                                 and tr.filial_id = qr.filial_id
                                 and tr.timesheet_id = qr.timesheet_id
                                 and tr.track_id = (select tt.track_id
                                                      from htt_timesheet_tracks tt
                                                     where tt.company_id = :company_id
                                                       and tt.filial_id = qr.filial_id
                                                       and tt.timesheet_id = qr.timesheet_id
                                                       and tt.track_type in (:tt_input, :tt_output, :tt_merger)
                                                       and tt.track_datetime <= :curr_date
                                                     order by tt.track_datetime desc
                                                     fetch first row only)';
    else
      v_Work_Status_Query := 'null';
    end if;
  
    v_Query := 'select qr.*, (' || v_Work_Status_Query || ') current_work_status from (' || v_Query ||
               ') qr';
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('filial_id',
                   'staff_id',
                   'division_id',
                   'job_id',
                   'rank_id',
                   'schedule_id',
                   'total_distance',
                   'fte_id');
    q.Varchar2_Field('name', 'gender', 'photo_sha', 'staff_number');
    q.Varchar2_Field('tin', 'cea', 'main_phone', 'email', 'iapa', 'npin', 'current_work_status');
    q.Date_Field('hiring_date', 'birthday');
  
    v_Matrix := Md_Util.Person_Genders;
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
  
    if v_Filial_Ids.Count > 0 then
      v_Query := ' and w.filial_id member of :filial_ids';
    else
      v_Query := '';
    end if;
  
    q.Refer_Field('filial_name',
                  'filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select * 
                     from md_filials w
                    where w.company_id = :company_id' || v_Query);
    q.Refer_Field('fte_name',
                  'fte_id',
                  'href_ftes',
                  'fte_id',
                  'name',
                  'select *
                     from href_ftes s 
                    where s.company_id = :company_id');
  
    -- extra info
    v_Divs_Query := Uit_Hrm.Departments_Query(i_Current_Filial => false);
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Departments_Query(i_Current_Filial => false),
                  'division_id',
                  'name',
                  v_Divs_Query || v_Query);
  
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select * 
                     from mhr_jobs w 
                    where w.company_id = :company_id' || v_Query);
  
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select * 
                     from mhr_ranks w 
                    where w.company_id = :company_id' || v_Query);
  
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select * 
                     from htt_schedules w 
                    where w.company_id = :company_id' || v_Query);
  
    -- timesheet
    q.Number_Field('begin_time', 'late_time');
    q.Varchar2_Field('kind', 'input_time', 'output_time');
  
    q.Map_Field('time_kind_name',
                'select tk.name
                   from htt_time_kinds tk
                  where tk.company_id = :company_id
                    and exists (select 1
                           from htt_timesheet_facts tf
                          where tf.company_id = :company_id
                            and tf.filial_id = $filial_id
                            and tf.timesheet_id = $timesheet_id
                            and tf.time_kind_id member of :absence_ids
                            and tf.time_kind_id = tk.time_kind_id)');
  
    v_Matrix := Htt_Util.Dashboard_Status_Kinds;
    q.Option_Field('kind_name', 'kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Work_Statuses;
    q.Option_Field('current_work_status_name', 'current_work_status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Ftes return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_ftes', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('fte_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Load_Preferences;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Day_Stats_Piechart(p Hashmap) return Hashmap is
    v_Timesheet_Date  date := Trunc(p.r_Date('date'));
    v_Employee_Filter varchar2(1) := Nvl(Nvl(p.o_Varchar2('employee_filter'),
                                             Load_Preferences().o_Varchar2('employee_filter')),
                                         c_Employee_Filter_All);
  
    v_Filial_Ids Array_Number := Nvl(p.o_Array_Number('filial_id'), Array_Number());
    v_Filial_Cnt number := v_Filial_Ids.Count;
    v_Fte_Ids    Array_Number := Nvl(p.o_Array_Number('fte_id'), Array_Number());
    v_Fte_Cnt    number := v_Fte_Ids.Count;
  
    v_Working_Time_Not_Begin number := 0;
    v_Leave                  number := 0;
    v_Late                   number := 0;
    v_Intime                 number := 0;
    v_Not_Come               number := 0;
    v_Rest                   number := 0;
    v_Holiday                number := 0;
    v_Additional_Rest_Day    number := 0;
    v_Non_Working            number := 0;
    v_Not_Licensed           number := 0;
    v_Not_Timetable          number := 0;
  
    v_Company_Id  number := Ui.Company_Id;
    v_Late_Id     number;
    v_Absence_Ids Array_Number;
    v_Turnout_Ids Array_Number;
  
    v_Filial_Managers Array_Number := Get_Filial_Managers();
    v_User_Divisions  Array_Number := Get_User_Divisions();
  
    result Hashmap := Hashmap();
  begin
    -- save settings
    Save_Preferences(Fazo.Zip_Map('employee_filter', v_Employee_Filter));
  
    v_Late_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
  
    v_Absence_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => v_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Leave,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Leave_Full,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Sick,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Trip,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Vacation));
    v_Turnout_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => v_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
  
    select sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Worktime_Not_Started, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Leave_Exists, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Staff_Late, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Staff_Intime, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Staff_Not_Come, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Rest_Day, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Holiday, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Additional_Rest_Day, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Nonworking_Day, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_Not_Licensed_Day, 1, 0)),
           sum(Decode(q.Kind, Htt_Pref.c_Dashboard_No_Timesheet, 1, 0))
      into v_Working_Time_Not_Begin,
           v_Leave,
           v_Late,
           v_Intime,
           v_Not_Come,
           v_Rest,
           v_Holiday,
           v_Additional_Rest_Day,
           v_Non_Working,
           v_Not_Licensed,
           v_Not_Timetable
      from (select q.Employee_Id,
                   case
                      when k.Staff_Id is null then --
                       Htt_Pref.c_Dashboard_No_Timesheet -- timetable is not set
                      when k.Licensed = 'N' then --
                       Htt_Pref.c_Dashboard_Not_Licensed_Day -- not licensed day
                      when k.Day_Kind = Htt_Pref.c_Day_Kind_Work then
                       case
                         when Current_Timestamp < k.Begin_Time and k.Input_Time is null then
                          Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                         when Nvl((select sum(t.Fact_Value)
                                    from Htt_Timesheet_Facts t
                                   where t.Company_Id = v_Company_Id
                                     and t.Filial_Id = k.Filial_Id
                                     and t.Timesheet_Id = k.Timesheet_Id
                                     and t.Time_Kind_Id member of v_Absence_Ids),
                                  -1) >= k.Plan_Time then
                          Htt_Pref.c_Dashboard_Leave_Exists -- leave time
                         when Nvl((select t.Fact_Value
                                    from Htt_Timesheet_Facts t
                                   where t.Company_Id = v_Company_Id
                                     and t.Filial_Id = k.Filial_Id
                                     and t.Timesheet_Id = k.Timesheet_Id
                                     and t.Time_Kind_Id = v_Late_Id),
                                  -1) > 0 then
                          Htt_Pref.c_Dashboard_Staff_Late -- late
                         when k.Input_Time is not null and k.Input_Time < k.End_Time --
                              or Nvl((select sum(t.Fact_Value)
                                       from Htt_Timesheet_Facts t
                                      where t.Company_Id = v_Company_Id
                                        and t.Filial_Id = k.Filial_Id
                                        and t.Timesheet_Id = k.Timesheet_Id
                                        and t.Time_Kind_Id member of v_Turnout_Ids),
                                     -1) > 0 then
                          Htt_Pref.c_Dashboard_Staff_Intime -- intime
                         when k.Count_Lack = 'N' and Current_Timestamp <= k.End_Time then
                          Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                         else
                          Htt_Pref.c_Dashboard_Staff_Not_Come -- not come
                       end
                      when k.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
                       Htt_Pref.c_Dashboard_Rest_Day -- rest day
                      when k.Day_Kind = Htt_Pref.c_Day_Kind_Holiday then
                       Htt_Pref.c_Dashboard_Holiday -- holiday
                      when k.Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest then
                       Htt_Pref.c_Dashboard_Additional_Rest_Day -- additional rest day 
                      when k.Day_Kind = Htt_Pref.c_Day_Kind_Nonworking then
                       Htt_Pref.c_Dashboard_Nonworking_Day -- nonworking day
                      else
                       Htt_Pref.c_Dashboard_No_Timesheet -- timetable is not set         
                    end Kind
              from Href_Staffs q
              left join (select k.Filial_Id,
                               Nvl2(Le.Employee_Id, null, k.Timesheet_Id) as Timesheet_Id,
                               k.Staff_Id,
                               k.Day_Kind,
                               k.Count_Lack,
                               k.Begin_Time,
                               k.End_Time,
                               Nvl2(Le.Employee_Id, null, k.Input_Time) as Input_Time,
                               Nvl2(Le.Employee_Id, null, k.Output_Time) as Output_Time,
                               k.Plan_Time,
                               Nvl2(Le.Employee_Id, 'N', 'Y') as Licensed
                          from Htt_Timesheets k
                          left join Hlic_Unlicensed_Employees Le
                            on Le.Company_Id = v_Company_Id
                           and Le.Employee_Id = k.Employee_Id
                           and Le.Licensed_Date = v_Timesheet_Date
                         where k.Company_Id = v_Company_Id
                           and k.Timesheet_Date = v_Timesheet_Date) k
                on k.Filial_Id = q.Filial_Id
               and k.Staff_Id = q.Staff_Id
             where q.Company_Id = v_Company_Id
               and q.Hiring_Date <= v_Timesheet_Date
               and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Timesheet_Date)
               and q.State = 'A'
               and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
               and exists (select 1
                      from Mhr_Employees e
                     where e.Company_Id = v_Company_Id
                       and e.Filial_Id = q.Filial_Id
                       and e.Employee_Id = q.Employee_Id
                       and e.State = 'A')
               and (v_Filial_Cnt = 0 or q.Filial_Id member of v_Filial_Ids)
               and (v_Fte_Cnt = 0 or q.Fte_Id member of v_Fte_Ids)
               and (v_Employee_Filter = c_Employee_Filter_All or
                   v_Employee_Filter = c_Employee_Filter_Managers and
                   q.Robot_Id in (select *
                                     from table(v_Filial_Managers)) or
                   v_Employee_Filter = c_Employee_Filter_Subordinate and
                   q.Employee_Id <> Ui.User_Id and
                   q.Division_Id in (select *
                                        from table(v_User_Divisions)))) q;
  
    Result.Put('working_time_not_begin_cnt', v_Working_Time_Not_Begin);
    Result.Put('leave_cnt', v_Leave);
    Result.Put('late_cnt', v_Late);
    Result.Put('intime_cnt', v_Intime);
    Result.Put('not_come_cnt', v_Not_Come);
    Result.Put('rest_day_cnt', v_Rest);
    Result.Put('holiday_cnt', v_Holiday);
    Result.Put('additional_rest_day_cnt', v_Additional_Rest_Day);
    Result.Put('non_working_cnt', v_Non_Working);
    Result.Put('not_licensed_cnt', v_Not_Licensed);
    Result.Put('not_timetable_cnt', v_Not_Timetable);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Day_Stats_Xychart(p Hashmap) return Arraylist is
    v_Begin_Date      date := p.r_Date('begin_date');
    v_End_Date        date := p.r_Date('end_date');
    v_Employee_Filter varchar2(1) := Nvl(Nvl(p.o_Varchar2('employee_filter'),
                                             Load_Preferences().o_Varchar2('employee_filter')),
                                         c_Employee_Filter_All);
  
    v_Filial_Ids Array_Number := Nvl(p.o_Array_Number('filial_id'), Array_Number());
    v_Filial_Cnt number := v_Filial_Ids.Count;
    v_Fte_Ids    Array_Number := Nvl(p.o_Array_Number('fte_id'), Array_Number());
    v_Fte_Cnt    number := v_Fte_Ids.Count;
  
    v_Company_Id  number := Ui.Company_Id;
    v_Late_Id     number;
    v_Absence_Ids Array_Number;
    v_Turnout_Ids Array_Number;
    v_Matrix      Matrix_Varchar2;
  
    v_Filial_Managers Array_Number := Get_Filial_Managers();
    v_User_Divisions  Array_Number := Get_User_Divisions();
  begin
    -- save settings
    Save_Preferences(Fazo.Zip_Map('employee_filter', v_Employee_Filter));
  
    v_End_Date    := Least(v_Begin_Date + 30, v_End_Date);
    v_Late_Id     := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late);
    v_Absence_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => v_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Leave,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Leave_Full,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Sick,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Trip,
                                                                                      Htt_Pref.c_Pcode_Time_Kind_Vacation));
    v_Turnout_Ids := Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => v_Company_Id,
                                                       i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout));
  
    select Array_Varchar2(q.Timesheet_Date, --
                          q.Total,
                          q.Intime_Cnt,
                          Round(q.Intime_Cnt / q.Total * 100, 2),
                          q.Leave_Cnt,
                          Round(q.Leave_Cnt / q.Total * 100, 2),
                          q.Late_Cnt,
                          Round(q.Late_Cnt / q.Total * 100, 2),
                          q.Not_Come_Cnt,
                          Round(q.Not_Come_Cnt / q.Total * 100, 2))
      bulk collect
      into v_Matrix
      from (select f.Timesheet_Date,
                   count(*) as Total,
                   count(Decode(f.Kind, Htt_Pref.c_Dashboard_Staff_Intime, 1, null)) as Intime_Cnt,
                   count(Decode(f.Kind, Htt_Pref.c_Dashboard_Leave_Exists, 1, null)) as Leave_Cnt,
                   count(Decode(f.Kind, Htt_Pref.c_Dashboard_Staff_Late, 1, null)) as Late_Cnt,
                   count(Decode(f.Kind, Htt_Pref.c_Dashboard_Staff_Not_Come, 1, null)) as Not_Come_Cnt
              from (select k.Timesheet_Date,
                           case
                              when k.Staff_Id is null then --
                               Htt_Pref.c_Dashboard_No_Timesheet -- timetable is not set
                              when k.Licensed = 'N' then --
                               Htt_Pref.c_Dashboard_Not_Licensed_Day -- not licensed day
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Work then --
                               case
                                 when Current_Timestamp < k.Begin_Time and k.Input_Time is null then
                                  Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                                 when Nvl((select sum(t.Fact_Value)
                                            from Htt_Timesheet_Facts t
                                           where t.Company_Id = v_Company_Id
                                             and t.Filial_Id = k.Filial_Id
                                             and t.Timesheet_Id = k.Timesheet_Id
                                             and t.Time_Kind_Id member of v_Absence_Ids),
                                          -1) >= k.Plan_Time then
                                  Htt_Pref.c_Dashboard_Leave_Exists -- leave
                                 when Nvl((select t.Fact_Value
                                            from Htt_Timesheet_Facts t
                                           where t.Company_Id = v_Company_Id
                                             and t.Filial_Id = k.Filial_Id
                                             and t.Timesheet_Id = k.Timesheet_Id
                                             and t.Time_Kind_Id = v_Late_Id),
                                          -1) > 0 then
                                  Htt_Pref.c_Dashboard_Staff_Late -- late
                                 when k.Input_Time is not null and k.Input_Time < k.End_Time or
                                      Nvl((select sum(t.Fact_Value)
                                            from Htt_Timesheet_Facts t
                                           where t.Company_Id = v_Company_Id
                                             and t.Filial_Id = k.Filial_Id
                                             and t.Timesheet_Id = k.Timesheet_Id
                                             and t.Time_Kind_Id member of v_Turnout_Ids),
                                          -1) > 0 then
                                  Htt_Pref.c_Dashboard_Staff_Intime -- intime
                                 when k.Count_Lack = 'N' and Current_Timestamp <= k.End_Time then
                                  Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                                 else
                                  Htt_Pref.c_Dashboard_Staff_Not_Come -- not come
                               end
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
                               Htt_Pref.c_Dashboard_Rest_Day -- rest day
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
                               Htt_Pref.c_Dashboard_Rest_Day -- rest day
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Holiday then
                               Htt_Pref.c_Dashboard_Holiday -- holiday
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest then
                               Htt_Pref.c_Dashboard_Additional_Rest_Day -- additional rest day
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Nonworking then
                               Htt_Pref.c_Dashboard_Nonworking_Day -- nonworking day   
                              else
                               Htt_Pref.c_Dashboard_No_Timesheet -- timetable is not set                   
                            end Kind
                      from Href_Staffs q
                      join (select k.Filial_Id,
                                  Nvl2(Le.Employee_Id, null, k.Timesheet_Id) as Timesheet_Id,
                                  k.Timesheet_Date,
                                  k.Staff_Id,
                                  k.Day_Kind,
                                  k.Count_Lack,
                                  k.Begin_Time,
                                  k.End_Time,
                                  Nvl2(Le.Employee_Id, null, k.Input_Time) as Input_Time,
                                  Nvl2(Le.Employee_Id, null, k.Output_Time) as Output_Time,
                                  k.Plan_Time,
                                  Nvl2(Le.Employee_Id, 'N', 'Y') as Licensed
                             from Htt_Timesheets k
                             left join Hlic_Unlicensed_Employees Le
                               on Le.Company_Id = v_Company_Id
                              and Le.Employee_Id = k.Employee_Id
                              and Le.Licensed_Date = k.Timesheet_Date
                            where k.Company_Id = v_Company_Id
                              and k.Timesheet_Date between v_Begin_Date and v_End_Date
                              and k.Day_Kind = Htt_Pref.c_Day_Kind_Work) k
                        on k.Filial_Id = q.Filial_Id
                       and k.Staff_Id = q.Staff_Id
                     where q.Company_Id = v_Company_Id
                       and q.Hiring_Date <= v_End_Date
                       and Nvl(q.Dismissal_Date, v_Begin_Date) >= v_Begin_Date
                       and q.State = 'A'
                       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                       and exists
                     (select 1
                              from Mhr_Employees e
                             where e.Company_Id = v_Company_Id
                               and e.Filial_Id = q.Filial_Id
                               and e.Employee_Id = q.Employee_Id
                               and e.State = 'A')
                       and (v_Filial_Cnt = 0 or q.Filial_Id member of v_Filial_Ids)
                       and (v_Fte_Cnt = 0 or q.Fte_Id member of v_Fte_Ids)
                       and (v_Employee_Filter = c_Employee_Filter_All or
                           v_Employee_Filter = c_Employee_Filter_Managers and
                           q.Robot_Id in (select *
                                             from table(v_Filial_Managers)) or
                           v_Employee_Filter = c_Employee_Filter_Subordinate and
                           q.Employee_Id <> Ui.User_Id and
                           q.Division_Id in (select *
                                                from table(v_User_Divisions)))) f
             group by f.Timesheet_Date
             order by f.Timesheet_Date) q;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Birthdays return Arraylist is
    v_Date           date := Trunc(sysdate);
    v_Date_Str       varchar2(8) := to_char(sysdate, 'yyyymmdd');
    v_Date_Add_Month varchar2(8) := to_char(Add_Months(sysdate, 1), 'yyyymmdd');
    v_Year           varchar2(4) := to_char(sysdate, Href_Pref.c_Date_Format_Year);
    v_Year_Inc       varchar2(4) := to_number(to_char(sysdate, Href_Pref.c_Date_Format_Year)) + 1;
    v_Company_Id     number := Ui.Company_Id;
    v_Val            Matrix_Varchar2;
  begin
    with Birthdays as
     (select t.Person_Id Employee_Id,
             t.Name,
             (select f.Name
                from Md_Filials f
               where f.Company_Id = v_Company_Id
                 and f.Filial_Id = (select d.Filial_Id
                                      from Href_Staffs d
                                     where d.Company_Id = v_Company_Id
                                       and d.Employee_Id = t.Person_Id
                                       and d.Hiring_Date <= v_Date
                                       and (d.Dismissal_Date is null or d.Dismissal_Date >= v_Date)
                                       and d.State = 'A'
                                       and Rownum = 1)) Filial_Name,
             (select f.Photo_Sha
                from Md_Persons f
               where f.Company_Id = v_Company_Id
                 and f.Person_Id = t.Person_Id) Photo_Sha,
             t.Gender,
             t.Birthday,
             case
                when v_Year || to_char(t.Birthday, 'mmdd') >= v_Date_Str then
                 v_Year || to_char(t.Birthday, 'mmdd')
                else
                 v_Year_Inc || to_char(t.Birthday, 'mmdd')
              end c_Birthday
        from (select *
                from Mr_Natural_Persons k
               where k.Company_Id = v_Company_Id
                 and k.Birthday is not null
                 and exists (select 1
                        from Mhr_Employees d
                       where d.Company_Id = v_Company_Id
                         and d.Employee_Id = k.Person_Id
                         and d.State = 'A'
                         and exists (select 1
                                from Href_Staffs St
                               where St.Company_Id = v_Company_Id
                                 and St.Filial_Id = d.Filial_Id
                                 and St.Employee_Id = d.Employee_Id
                                 and St.Hiring_Date <= v_Date
                                 and (St.Dismissal_Date is null or
                                     St.Dismissal_Date >= v_Date)
                                 and St.State = 'A'))) t),
    Employees as
     (select c.Employee_Id,
             c.Name,
             c.Filial_Name,
             c.Photo_Sha,
             c.Gender,
             c.Birthday,
             count(Decode(c.c_Birthday, v_Date_Str, 1, null)) Over() Cnt
        from Birthdays c
       where c.c_Birthday <= v_Date_Add_Month
       order by c.c_Birthday)
    select Array_Varchar2(h.Employee_Id, --
                          h.Name,
                          h.Filial_Name,
                          h.Birthday,
                          h.Photo_Sha,
                          h.Gender)
      bulk collect
      into v_Val
      from Employees h
     where Rownum <= Greatest(10, h.Cnt);
  
    return Fazo.Zip_Matrix(v_Val);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Mr_Natural_Persons
       set Company_Id      = null,
           Person_Id       = null,
           name            = null,
           Gender          = null,
           Birthday        = null,
           Legal_Person_Id = null,
           Created_On      = null,
           Created_By      = null,
           Modified_On     = null,
           Modified_By     = null;
    update Href_Staffs
       set Company_Id   = null,
           Filial_Id    = null,
           Staff_Id     = null,
           Staff_Kind   = null,
           Staff_Number = null,
           Hiring_Date  = null,
           Division_Id  = null,
           Job_Id       = null,
           Rank_Id      = null,
           Schedule_Id  = null,
           Parent_Id    = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
    update Htt_Timesheets
       set Company_Id     = null,
           Filial_Id      = null,
           Timesheet_Id   = null,
           Timesheet_Date = null,
           Staff_Id       = null,
           Day_Kind       = null,
           Begin_Time     = null,
           End_Time       = null,
           Plan_Time      = null,
           Full_Time      = null,
           Input_Time     = null,
           Output_Time    = null;
    update Htt_Timesheet_Facts
       set Company_Id   = null,
           Filial_Id    = null,
           Timesheet_Id = null,
           Time_Kind_Id = null,
           Fact_Value   = null;
    update Href_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Iapa       = null,
           Npin       = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           Email      = null,
           Photo_Sha  = null;
    update Mr_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Tin        = null,
           Cea        = null,
           Main_Phone = null;
    update Htt_Gps_Tracks
       set Company_Id     = null,
           Filial_Id      = null,
           Person_Id      = null,
           Track_Date     = null,
           Total_Distance = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           name       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Rank_Id    = null,
           name       = null;
    update Htt_Schedules
       set Company_Id  = null,
           Schedule_Id = null,
           name        = null;
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           name         = null;
    update Htt_Timesheet_Tracks
       set Company_Id     = null,
           Filial_Id      = null,
           Timesheet_Id   = null,
           Track_Id       = null,
           Track_Datetime = null,
           Track_Type     = null;
    update Href_Ftes
       set Company_Id = null,
           Fte_Id     = null,
           name       = null;
  end;

end Ui_Vhr297;
/
