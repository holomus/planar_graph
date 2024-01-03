create or replace package Ui_Vhr100 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Ftes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Day_Stats_Piechart(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Day_Stats_Xychart(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Load_Birthdays return Arraylist;
end Ui_Vhr100;
/
create or replace package body Ui_Vhr100 is
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
    return b.Translate('UI-VHR100:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Ranks return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_ranks',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('rank_id');
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
  Function Query_Ftes return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_ftes', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('fte_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query is
    v_Division_Ids      Array_Number := Nvl(p.o_Array_Number('division_id'), Array_Number());
    v_Job_Ids           Array_Number := Nvl(p.o_Array_Number('job_id'), Array_Number());
    v_Schedule_Ids      Array_Number := Nvl(p.o_Array_Number('schedule_id'), Array_Number());
    v_Rank_Ids          Array_Number := Nvl(p.o_Array_Number('rank_id'), Array_Number());
    v_Location_Ids      Array_Number := Nvl(p.o_Array_Number('location_id'), Array_Number());
    v_Fte_Ids           Array_Number := Nvl(p.o_Array_Number('fte_id'), Array_Number());
    v_Timesheet_Date    date := p.r_Date('date');
    v_Current_Time      date := Htt_Util.Get_Current_Date(i_Company_Id => Ui.Company_Id,
                                                          i_Filial_Id  => Ui.Filial_Id);
    v_Query             varchar2(32767);
    v_Work_Status_Query varchar2(32767);
    v_Params            Hashmap := Hashmap();
    v_Matrix            Matrix_Varchar2;
    q                   Fazo_Query;
  begin
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('filial_id', Ui.Filial_Id);
    v_Params.Put('user_id', Ui.User_Id);
    v_Params.Put('timesheet_date', v_Timesheet_Date);
    v_Params.Put('format', Href_Pref.c_Time_Format_Minute);
    v_Params.Put('division_ids', v_Division_Ids);
    v_Params.Put('job_ids', v_Job_Ids);
    v_Params.Put('schedule_ids', v_Schedule_Ids);
    v_Params.Put('rank_ids', v_Rank_Ids);
    v_Params.Put('location_ids', v_Location_Ids);
    v_Params.Put('fte_ids', v_Fte_Ids);
    v_Params.Put('rs_completed', Htt_Pref.c_Request_Status_Completed);
    v_Params.Put('turnout_ids',
                 Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => Ui.Company_Id,
                                                   i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Turnout)));
    v_Params.Put('late_id',
                 Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Late));
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
    v_Params.Put('absence_ids',
                 Htt_Util.Time_Kind_With_Child_Ids(i_Company_Id => Ui.Company_Id,
                                                   i_Pcodes     => Array_Varchar2(Htt_Pref.c_Pcode_Time_Kind_Leave,
                                                                                  Htt_Pref.c_Pcode_Time_Kind_Leave_Full,
                                                                                  Htt_Pref.c_Pcode_Time_Kind_Sick,
                                                                                  Htt_Pref.c_Pcode_Time_Kind_Trip,
                                                                                  Htt_Pref.c_Pcode_Time_Kind_Vacation)));
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
                       f.web,
                       f.fax,
                       f.telegram,
                       f.post_address,
                       f.address,
                       f.legal_address,
                       f.region_id,
                       g.email,
                       g.photo_sha,
                       m.iapa,
                       m.npin,
                       q.staff_id,
                       q.employee_id,
                       q.hiring_date,
                       q.staff_number,
                       q.staff_kind,
                       q.division_id,
                       q.org_unit_id,
                       q.job_id,
                       q.rank_id,
                       q.schedule_id,
                       q.fte_id,
                       k.timesheet_id,
                       (select r.person_id
                          from mrf_robots r
                         where r.company_id = :company_id
                           and r.filial_id = :filial_id
                           and r.robot_id = (select case
                                                     when dm.manager_id <> q.robot_id then
                                                       dm.manager_id
                                                     else
                                                       (select md.manager_id
                                                          from mhr_parent_divisions pd
                                                          join mrf_division_managers md
                                                            on md.company_id = pd.company_id
                                                           and md.filial_id = pd.filial_id
                                                           and md.division_id = pd.parent_id
                                                         where pd.company_id = dm.company_id
                                                           and pd.filial_id = dm.filial_id
                                                           and pd.division_id = dm.division_id
                                                           and pd.lvl = 1)
                                                    end
                                               from mrf_division_managers dm
                                              where dm.company_id = :company_id
                                                and dm.filial_id = :filial_id
                                                and dm.division_id = q.org_unit_id)) manager_id,
                       (select s.name
                          from mkcs_bank_accounts s
                         where s.company_id = :company_id
                           and s.person_id = q.employee_id
                           and s.is_main = ''Y'') bank_account_name,
                       (select s.login
                          from md_users s
                         where s.company_id = :company_id
                           and s.user_id = q.employee_id) login,
                       nvl((select ''Y''
                              from hzk_person_fprints v
                             where v.company_id = :company_id
                               and v.person_id = q.employee_id
                               and rownum = 1), ''N'') fprints,
                       (select round(gt.total_distance / 1000, 3)
                          from htt_gps_tracks gt
                         where gt.company_id = :company_id
                           and gt.filial_id = :filial_id
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
                           and t.filial_id = :filial_id
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
                                         and t.filial_id = :filial_id
                                         and t.timesheet_id = k.timesheet_id
                                         and t.time_kind_id member of :absence_ids),
                                      -1) >= k.plan_time then
                              :leave_exists
                             when nvl((select t.fact_value
                                        from htt_timesheet_facts t
                                       where t.company_id = :company_id
                                         and t.filial_id = :filial_id
                                         and t.timesheet_id = k.timesheet_id
                                         and t.time_kind_id = :late_id),
                                      -1) > 0 then
                              :staff_late
                             when k.input_time is not null and k.input_time < k.end_time
                                  or nvl((select sum(t.fact_value)
                                           from htt_timesheet_facts t
                                          where t.company_id = :company_id
                                            and t.filial_id = :filial_id
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
                  left join (select nvl2(le.employee_id, null, k.timesheet_id) as timesheet_id,
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
                                and k.filial_id = :filial_id
                                and k.timesheet_date = :timesheet_date) k
                    on k.staff_id = q.staff_id
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
                   and q.filial_id = :filial_id
                   and q.hiring_date <= trunc(:timesheet_date)
                   and (q.dismissal_date is null or q.dismissal_date >= trunc(:timesheet_date))
                   and q.staff_kind = :sk_primary
                   and q.state = ''A''
                   and exists (select 1
                          from mhr_employees e
                         where e.company_id = :company_id
                           and e.filial_id = :filial_id
                           and e.employee_id = q.employee_id
                           and e.state = ''A'')';
  
    if v_Division_Ids.Count > 0 then
      v_Query := v_Query || --
                 ' and q.division_id in (select * from table(:division_ids))';
    end if;
  
    if v_Job_Ids.Count > 0 then
      v_Query := v_Query || --
                 ' and q.job_id in (select * from table(:job_ids))';
    end if;
  
    if v_Schedule_Ids.Count > 0 then
      v_Query := v_Query || --
                 ' and q.schedule_id in (select * from table(:schedule_ids))';
    end if;
  
    if v_Rank_Ids.Count > 0 then
      v_Query := v_Query || --
                 ' and q.rank_id in (select * from table(:rank_ids))';
    end if;
  
    if v_Location_Ids.Count > 0 then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_persons lp
                         where lp.company_id = q.company_id
                           and lp.filial_id = q.filial_id
                           and lp.location_id in (select * from table(:location_ids))
                           and lp.person_id = q.employee_id
                           and not exists (select 1
                                      from htt_blocked_person_tracking bp
                                     where bp.company_id = lp.company_id
                                       and bp.filial_id = lp.filial_id
                                       and bp.employee_id = lp.person_id))';
    end if;
  
    if v_Fte_Ids.Count > 0 then
      v_Query := v_Query || --
                 ' and q.fte_id in (select * from table(:fte_ids))';
    end if;
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query          => v_Query,
                                                i_Include_Manual => true,
                                                i_Filter_Key     => 'person_id');
  
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
                                 and tr.filial_id = :filial_id
                                 and tr.timesheet_id = qr.timesheet_id
                                 and tr.track_id = (select tt.track_id
                                                      from htt_timesheet_tracks tt
                                                     where tt.company_id = :company_id
                                                       and tt.filial_id = :filial_id
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
  
    q.Number_Field('staff_id',
                   'employee_id',
                   'manager_id',
                   'region_id',
                   'division_id',
                   'job_id',
                   'rank_id',
                   'schedule_id',
                   'total_distance',
                   'fte_id');
    q.Varchar2_Field('name',
                     'first_name',
                     'last_name',
                     'middle_name',
                     'gender',
                     'photo_sha',
                     'address',
                     'staff_number');
    q.Varchar2_Field('tin',
                     'cea',
                     'main_phone',
                     'email',
                     'web',
                     'fax',
                     'telegram',
                     'post_address',
                     'login',
                     'bank_account_name');
    q.Varchar2_Field('iapa',
                     'npin',
                     'fprints',
                     'code',
                     'access_level',
                     'staff_kind',
                     'current_work_status');
    q.Date_Field('hiring_date', 'birthday');
  
    v_Matrix := Md_Util.Person_Genders;
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    q.Option_Field('fprints_name',
                   'fprints',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Matrix := Href_Util.User_Acces_Levels;
    q.Option_Field('access_level_name', 'access_level', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('manager_name',
                  'manager_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  Uit_Href.Person_Refer_Field_Filter_Query(i_Include_Manual => true));
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions
                    where company_id = :company_id');
    q.Refer_Field('fte_name',
                  'fte_id',
                  'href_ftes',
                  'fte_id',
                  'name',
                  'select *
                     from href_ftes s 
                    where s.company_id = :company_id');
  
    -- extra info
    q.Map_Field('division_name',
                'select div.name
                   from mhr_divisions div
                  where div.company_id = :company_id
                    and div.filial_id = :filial_id
                    and div.division_id = $division_id');
  
    q.Map_Field('job_name',
                'select jb.name
                   from mhr_jobs jb
                  where jb.company_id = :company_id
                    and jb.filial_id = :filial_id
                    and jb.job_id = $job_id');
  
    q.Map_Field('rank_name',
                'select rnk.name
                   from mhr_ranks rnk
                  where rnk.company_id = :company_id
                    and rnk.filial_id = :filial_id
                    and rnk.rank_id = $rank_id');
  
    q.Map_Field('schedule_name',
                'select sch.name
                   from htt_schedules sch
                  where sch.company_id = :company_id
                    and sch.filial_id = :filial_id
                    and sch.schedule_id = $schedule_id');
  
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
                            and tf.filial_id = :filial_id
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
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Check_Access => false)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Day_Stats_Piechart(p Hashmap) return Hashmap is
    v_Timesheet_Date date := Trunc(p.r_Date('date'));
  
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_id'), Array_Number());
    v_Division_Cnt number := v_Division_Ids.Count;
    v_Job_Ids      Array_Number := Nvl(p.o_Array_Number('job_id'), Array_Number());
    v_Job_Cnt      number := v_Job_Ids.Count;
    v_Schedule_Ids Array_Number := Nvl(p.o_Array_Number('schedule_id'), Array_Number());
    v_Schedule_Cnt number := v_Schedule_Ids.Count;
    v_Rank_Ids     Array_Number := Nvl(p.o_Array_Number('rank_id'), Array_Number());
    v_Rank_Cnt     number := v_Rank_Ids.Count;
    v_Location_Ids Array_Number := Nvl(p.o_Array_Number('location_id'), Array_Number());
    v_Location_Cnt number := v_Location_Ids.Count;
    v_Fte_Ids      Array_Number := Nvl(p.o_Array_Number('fte_id'), Array_Number());
    v_Fte_Cnt      number := v_Fte_Ids.Count;
  
    v_Working_Time_Not_Begin number := 0;
    v_Leave                  number := 0;
    v_Late                   number := 0;
    v_Intime                 number := 0;
    v_Not_Come               number := 0;
    v_Rest                   number := 0;
    v_Holiday                number := 0;
    v_Additional_Rest_Days   number := 0;
    v_Non_Working            number := 0;
    v_Not_Licensed           number := 0;
    v_Not_Timetable          number := 0;
  
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Late_Id              number;
    v_Curr_Date            date;
    v_Access_All_Employees varchar2(1);
    v_Absence_Ids          Array_Number;
    v_Turnout_Ids          Array_Number;
  
    v_Allowed_Divisions  Array_Number;
    v_Subordinate_Chiefs Array_Number;
  
    result Hashmap := Hashmap();
  begin
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
  
    v_Curr_Date         := Htt_Util.Get_Current_Date(i_Company_Id => v_Company_Id,
                                                     i_Filial_Id  => v_Filial_Id);
    v_Allowed_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                              i_Direct             => true,
                                                              i_Indirect           => true,
                                                              i_Manual             => true);
  
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
           v_Additional_Rest_Days,
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
                         when v_Curr_Date < k.Begin_Time and k.Input_Time is null then
                          Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                         when Nvl((select sum(t.Fact_Value)
                                    from Htt_Timesheet_Facts t
                                   where t.Company_Id = v_Company_Id
                                     and t.Filial_Id = v_Filial_Id
                                     and t.Timesheet_Id = k.Timesheet_Id
                                     and t.Time_Kind_Id member of v_Absence_Ids),
                                  -1) >= k.Plan_Time then
                          Htt_Pref.c_Dashboard_Leave_Exists -- leave time
                         when Nvl((select t.Fact_Value
                                    from Htt_Timesheet_Facts t
                                   where t.Company_Id = v_Company_Id
                                     and t.Filial_Id = v_Filial_Id
                                     and t.Timesheet_Id = k.Timesheet_Id
                                     and t.Time_Kind_Id = v_Late_Id),
                                  -1) > 0 then
                          Htt_Pref.c_Dashboard_Staff_Late -- late
                         when k.Input_Time is not null and k.Input_Time < k.End_Time --
                              or Nvl((select sum(t.Fact_Value)
                                       from Htt_Timesheet_Facts t
                                      where t.Company_Id = v_Company_Id
                                        and t.Filial_Id = v_Filial_Id
                                        and t.Timesheet_Id = k.Timesheet_Id
                                        and t.Time_Kind_Id member of v_Turnout_Ids),
                                     -1) > 0 then
                          Htt_Pref.c_Dashboard_Staff_Intime -- intime
                         when k.Count_Lack = 'N' and v_Curr_Date <= k.End_Time then
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
              left join (select Nvl2(Le.Employee_Id, null, k.Timesheet_Id) as Timesheet_Id,
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
                           and k.Filial_Id = v_Filial_Id
                           and k.Timesheet_Date = v_Timesheet_Date) k
                on k.Staff_Id = q.Staff_Id
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id
               and q.Hiring_Date <= v_Timesheet_Date
               and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Timesheet_Date)
               and q.State = 'A'
               and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
               and exists (select 1
                      from Mhr_Employees e
                     where e.Company_Id = v_Company_Id
                       and e.Filial_Id = v_Filial_Id
                       and e.Employee_Id = q.Employee_Id
                       and e.State = 'A')
               and (v_Division_Cnt = 0 or q.Division_Id member of v_Division_Ids)
               and (v_Job_Cnt = 0 or q.Job_Id member of v_Job_Ids)
               and (v_Schedule_Cnt = 0 or q.Schedule_Id member of v_Schedule_Ids)
               and (v_Rank_Cnt = 0 or q.Rank_Id member of v_Rank_Ids)
               and (v_Location_Cnt = 0 or exists
                    (select 1
                       from Htt_Location_Persons Lp
                      where Lp.Company_Id = v_Company_Id
                        and Lp.Filial_Id = v_Filial_Id
                        and Lp.Location_Id member of v_Location_Ids
                        and Lp.Person_Id = q.Employee_Id
                        and not exists (select 1
                               from Htt_Blocked_Person_Tracking Bp
                              where Bp.Company_Id = Lp.Company_Id
                                and Bp.Filial_Id = Lp.Filial_Id
                                and Bp.Employee_Id = Lp.Person_Id)))
               and (v_Fte_Cnt = 0 or q.Fte_Id member of v_Fte_Ids)
               and (v_Access_All_Employees = 'Y' or q.Employee_Id = Ui.User_Id or
                   q.Org_Unit_Id member of v_Allowed_Divisions)) q;
  
    Result.Put('working_time_not_begin_cnt', v_Working_Time_Not_Begin);
    Result.Put('leave_cnt', v_Leave);
    Result.Put('late_cnt', v_Late);
    Result.Put('intime_cnt', v_Intime);
    Result.Put('not_come_cnt', v_Not_Come);
    Result.Put('rest_day_cnt', v_Rest);
    Result.Put('holiday_cnt', v_Holiday);
    Result.Put('additional_rest_days_cnt', v_Additional_Rest_Days);
    Result.Put('non_working_cnt', v_Non_Working);
    Result.Put('not_licensed_cnt', v_Not_Licensed);
    Result.Put('not_timetable_cnt', v_Not_Timetable);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Day_Stats_Xychart(p Hashmap) return Arraylist is
    v_Begin_Date date := p.r_Date('begin_date');
    v_End_Date   date := p.r_Date('end_date');
  
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_id'), Array_Number());
    v_Division_Cnt number := v_Division_Ids.Count;
    v_Job_Ids      Array_Number := Nvl(p.o_Array_Number('job_id'), Array_Number());
    v_Job_Cnt      number := v_Job_Ids.Count;
    v_Schedule_Ids Array_Number := Nvl(p.o_Array_Number('schedule_id'), Array_Number());
    v_Schedule_Cnt number := v_Schedule_Ids.Count;
    v_Rank_Ids     Array_Number := Nvl(p.o_Array_Number('rank_id'), Array_Number());
    v_Rank_Cnt     number := v_Rank_Ids.Count;
    v_Location_Ids Array_Number := Nvl(p.o_Array_Number('location_id'), Array_Number());
    v_Location_Cnt number := v_Location_Ids.Count;
    v_Fte_Ids      Array_Number := Nvl(p.o_Array_Number('fte_id'), Array_Number());
    v_Fte_Cnt      number := v_Fte_Ids.Count;
    v_Matrix       Matrix_Varchar2;
  
    v_Allowed_Divisions  Array_Number;
    v_Subordinate_Chiefs Array_Number;
  
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Late_Id              number;
    v_Curr_Date            date;
    v_Access_All_Employees varchar2(1);
    v_Absence_Ids          Array_Number;
    v_Turnout_Ids          Array_Number;
  begin
    v_End_Date             := Least(Last_Day(v_Begin_Date + 60), v_End_Date);
    v_Access_All_Employees := Uit_Href.User_Access_All_Employees;
  
    v_Curr_Date := Htt_Util.Get_Current_Date(i_Company_Id => v_Company_Id,
                                             i_Filial_Id  => v_Filial_Id);
  
    v_Allowed_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                              i_Direct             => true,
                                                              i_Indirect           => true,
                                                              i_Manual             => true);
  
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
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Work then
                               case
                                 when v_Curr_Date < k.Begin_Time and k.Input_Time is null then
                                  Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                                 when Nvl((select sum(t.Fact_Value)
                                            from Htt_Timesheet_Facts t
                                           where t.Company_Id = v_Company_Id
                                             and t.Filial_Id = v_Filial_Id
                                             and t.Timesheet_Id = k.Timesheet_Id
                                             and t.Time_Kind_Id member of v_Absence_Ids),
                                          -1) >= k.Plan_Time then
                                  Htt_Pref.c_Dashboard_Leave_Exists -- leave time
                                 when Nvl((select t.Fact_Value
                                            from Htt_Timesheet_Facts t
                                           where t.Company_Id = v_Company_Id
                                             and t.Filial_Id = v_Filial_Id
                                             and t.Timesheet_Id = k.Timesheet_Id
                                             and t.Time_Kind_Id = v_Late_Id),
                                          -1) > 0 then
                                  Htt_Pref.c_Dashboard_Staff_Late -- late
                                 when k.Input_Time is not null and k.Input_Time < k.End_Time --
                                      or Nvl((select sum(t.Fact_Value)
                                               from Htt_Timesheet_Facts t
                                              where t.Company_Id = v_Company_Id
                                                and t.Filial_Id = v_Filial_Id
                                                and t.Timesheet_Id = k.Timesheet_Id
                                                and t.Time_Kind_Id member of v_Turnout_Ids),
                                             -1) > 0 then
                                  Htt_Pref.c_Dashboard_Staff_Intime -- intime
                                 when k.Count_Lack = 'N' and v_Curr_Date <= k.End_Time then
                                  Htt_Pref.c_Dashboard_Worktime_Not_Started -- working time not begin
                                 else
                                  Htt_Pref.c_Dashboard_Staff_Not_Come -- not come
                               end
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Rest then
                               Htt_Pref.c_Dashboard_Rest_Day -- rest day
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Holiday then
                               Htt_Pref.c_Dashboard_Holiday -- holiday
                              when k.Day_Kind = Htt_Pref.c_Day_Kind_Nonworking then
                               Htt_Pref.c_Dashboard_Nonworking_Day -- nonworking day
                              else
                               Htt_Pref.c_Dashboard_No_Timesheet -- timetable is not set
                            end Kind
                      from Href_Staffs q
                      join (select Nvl2(Le.Employee_Id, null, k.Timesheet_Id) as Timesheet_Id,
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
                              and k.Filial_Id = v_Filial_Id
                              and k.Timesheet_Date between v_Begin_Date and v_End_Date
                              and k.Day_Kind = Htt_Pref.c_Day_Kind_Work) k
                        on k.Staff_Id = q.Staff_Id
                     where q.Company_Id = v_Company_Id
                       and q.Filial_Id = v_Filial_Id
                       and q.Hiring_Date <= v_End_Date
                       and Nvl(q.Dismissal_Date, v_Begin_Date) >= v_Begin_Date
                       and q.State = 'A'
                       and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                       and exists
                     (select 1
                              from Mhr_Employees e
                             where e.Company_Id = v_Company_Id
                               and e.Filial_Id = v_Filial_Id
                               and e.Employee_Id = q.Employee_Id
                               and e.State = 'A')
                       and (v_Division_Cnt = 0 or q.Division_Id member of v_Division_Ids)
                       and (v_Job_Cnt = 0 or q.Job_Id member of v_Job_Ids)
                       and (v_Schedule_Cnt = 0 or q.Schedule_Id member of v_Schedule_Ids)
                       and (v_Rank_Cnt = 0 or q.Rank_Id member of v_Rank_Ids)
                       and (v_Location_Cnt = 0 or exists
                            (select 1
                               from Htt_Location_Persons Lp
                              where Lp.Company_Id = q.Company_Id
                                and Lp.Filial_Id = q.Filial_Id
                                and Lp.Location_Id member of v_Location_Ids
                                and Lp.Person_Id = q.Employee_Id
                                and not exists (select 1
                                       from Htt_Blocked_Person_Tracking Bp
                                      where Bp.Company_Id = Lp.Company_Id
                                        and Bp.Filial_Id = Lp.Filial_Id
                                        and Bp.Employee_Id = Lp.Person_Id)))
                       and (v_Fte_Cnt = 0 or q.Fte_Id member of v_Fte_Ids)
                       and (v_Access_All_Employees = 'Y' or q.Employee_Id = Ui.User_Id or
                           q.Org_Unit_Id member of v_Allowed_Divisions)) f
             group by f.Timesheet_Date
             order by f.Timesheet_Date) q;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Birthdays return Arraylist is
    v_Date           varchar2(8) := to_char(sysdate, 'yyyymmdd');
    v_Date_Add_Month varchar2(8) := to_char(Add_Months(sysdate, 1), 'yyyymmdd');
    v_Year           varchar2(4) := to_char(sysdate, Href_Pref.c_Date_Format_Year);
    v_Year_Inc       varchar2(4) := to_number(to_char(sysdate, Href_Pref.c_Date_Format_Year)) + 1;
    v_Val            Matrix_Varchar2;
  begin
    with Birthdays as
     (select q.Employee_Id,
             w.Name,
             (select s.Name
                from Mhr_Jobs s
               where s.Company_Id = q.Company_Id
                 and s.Filial_Id = q.Filial_Id
                 and s.Job_Id = q.Job_Id) Job_Name,
             w.Birthday,
             case
                when v_Year || to_char(w.Birthday, 'mmdd') >= v_Date then
                 v_Year || to_char(w.Birthday, 'mmdd')
                else
                 v_Year_Inc || to_char(w.Birthday, 'mmdd')
              end c_Birthday,
             (select f.Photo_Sha
                from Md_Persons f
               where f.Company_Id = Ui.Company_Id
                 and f.Person_Id = q.Employee_Id
                 and f.Photo_Sha is not null) Photo_Sha,
             w.Gender
        from Mhr_Employees q
        join Mr_Natural_Persons w
          on w.Company_Id = q.Company_Id
         and w.Person_Id = q.Employee_Id
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.State = 'A'
         and w.Birthday is not null
         and exists (select 1
                from Href_Staffs d
               where d.Company_Id = q.Company_Id
                 and d.Filial_Id = q.Filial_Id
                 and d.Employee_Id = q.Employee_Id
                 and d.Hiring_Date <= Trunc(sysdate)
                 and (d.Dismissal_Date is null or d.Dismissal_Date >= Trunc(sysdate))
                 and d.State = 'A')),
    Employees as
     (select c.Employee_Id,
             c.Name,
             c.Job_Name,
             c.Photo_Sha,
             c.Gender,
             c.Birthday,
             count(Decode(c.c_Birthday, v_Date, 1, null)) Over() Cnt
        from Birthdays c
       where c.c_Birthday <= v_Date_Add_Month
       order by c.c_Birthday)
    select Array_Varchar2(h.Employee_Id, --
                           h.Name,
                           h.Job_Name,
                           h.Birthday,
                           h.Photo_Sha,
                           h.Gender,
                           case
                             when Uit_Href.Has_Access_To_Employee(h.Employee_Id) = 'Y' then
                              'Y'
                             else
                              'N'
                           end)
      bulk collect
      into v_Val
      from Employees h
     where Rownum <= Greatest(10, h.Cnt);
  
    return Fazo.Zip_Matrix(v_Val);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id      = null,
           Person_Id       = null,
           name            = null,
           First_Name      = null,
           Last_Name       = null,
           Middle_Name     = null,
           Gender          = null,
           Birthday        = null,
           Legal_Person_Id = null,
           Code            = null,
           Created_On      = null,
           Created_By      = null,
           Modified_On     = null,
           Modified_By     = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           State          = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Robot_Id       = null,
           Division_Id    = null,
           Org_Unit_Id    = null,
           Job_Id         = null,
           Rank_Id        = null,
           Schedule_Id    = null,
           Staff_Kind     = null,
           Parent_Id      = null;
    update Mr_Person_Details
       set Company_Id    = null,
           Person_Id     = null,
           Tin           = null,
           Cea           = null,
           Main_Phone    = null,
           Web           = null,
           Fax           = null,
           Telegram      = null,
           Post_Address  = null,
           Address       = null,
           Address_Guide = null,
           Legal_Address = null,
           Region_Id     = null;
    update Mrf_Division_Managers
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Manager_Id  = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Person_Id  = null;
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
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Mkcs_Bank_Accounts
       set Company_Id = null,
           Person_Id  = null,
           Is_Main    = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           Login      = null;
    update Hzk_Person_Fprints
       set Company_Id = null,
           Person_Id  = null;
    update Htt_Gps_Tracks
       set Company_Id     = null,
           Filial_Id      = null,
           Person_Id      = null,
           Track_Date     = null,
           Total_Distance = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           State       = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Location_Persons
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null,
           Person_Id   = null;
    update Htt_Blocked_Person_Tracking
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Hlic_Unlicensed_Employees
       set Company_Id    = null,
           Employee_Id   = null,
           Licensed_Date = null;
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

end Ui_Vhr100;
/
