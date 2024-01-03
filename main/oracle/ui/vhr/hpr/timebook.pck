create or replace package Ui_Vhr75 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Load_All_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Staff(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Blocked_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr75;
/
create or replace package body Ui_Vhr75 is
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
    return b.Translate('UI-VHR75:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    q              Fazo_Query;
    v_Matrix       Matrix_Varchar2;
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
    v_Query        varchar2(4000 char);
    v_Params       Hashmap;
  begin
    v_Query := 'select s.*
                       from href_staffs s
                      where s.company_id = :company_id
                        and s.filial_id = :filial_id
                        and s.state = ''A''
                        and (:division_id = hpd_util.get_closest_division_id(s.company_id, s.filial_id, s.staff_id, :period_end) or
                            :division_id is null)
                        and s.hiring_date <= :period_end
                        and (s.dismissal_date is null or s.dismissal_date >= :period_begin)
                        and hpr_util.is_staff_blocked(s.company_id, s.filial_id, s.staff_id, :period_begin, :period_end, :timebook_id) = ''N''
                        and exists (select 1
                               from htt_timesheets ht
                              where ht.company_id = :company_id
                                and ht.filial_id = :filial_id
                                and ht.staff_id = s.staff_id
                                and ht.timesheet_date between :period_begin and :period_end
                                and exists (select 1
                                       from htt_timesheet_facts tf
                                      where tf.company_id = :company_id
                                        and tf.filial_id = :filial_id
                                        and tf.timesheet_id = ht.timesheet_id
                                        and tf.fact_value > 0))
                        and not exists (select 1
                               from href_util.staff_licensed_period(:company_id, :filial_id, s.staff_id, :period_begin, :period_end) lp
                              where lp.licensed = ''N'')';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'division_id',
                             p.o_Number('division_id'),
                             'period_begin',
                             v_Period_Begin,
                             'period_end',
                             v_Period_End,
                             'timebook_id',
                             p.o_Number('timebook_id'));
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and s.org_unit_id in (select column_value from table(:division_ids))';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id', 'division_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('job_name',
                'select w.name
                   from mhr_jobs w
                  where w.company_id = :company_id
                    and w.filial_id = :filial_id
                    and w.job_id = hpd_util.get_closest_job_id(:company_id, :filial_id, $staff_id, :period_end)');
    q.Map_Field('name',
                'select r.name
                   from mr_natural_persons r
                  where r.company_id = :company_id
                    and r.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staffs
  (
    i_Division_Id  number,
    i_Period_Begin date,
    i_Period_End   date,
    i_Timebook_Id  number := null,
    i_Staff_Ids    Array_Number := null
  ) return Hashmap is
    v_Company_Id                number := Ui.Company_Id;
    v_Filial_Id                 number := Ui.Filial_Id;
    v_Staffs                    Matrix_Varchar2;
    v_Staff_Ids                 Array_Number;
    v_Division_Ids              Array_Number;
    v_User_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
    result                      Hashmap := Hashmap();
  begin
    if sysdate >= i_Period_Begin then
      v_Division_Ids := Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                           i_Indirect => true,
                                                           i_Manual   => true);
    
      select Array_Varchar2(q.Staff_Id,
                            q.Staff_Number,
                            (select Np.Name
                               from Mr_Natural_Persons Np
                              where Np.Company_Id = v_Company_Id
                                and Np.Person_Id = q.Employee_Id),
                            (select j.Name
                               from Mhr_Jobs j
                              where j.Company_Id = v_Company_Id
                                and j.Filial_Id = q.Filial_Id
                                and j.Job_Id =
                                    Hpd_Util.Get_Closest_Job_Id(i_Company_Id => v_Company_Id,
                                                                i_Filial_Id  => v_Filial_Id,
                                                                i_Staff_Id   => q.Staff_Id,
                                                                i_Period     => Least(i_Period_End,
                                                                                      Nvl(q.Dismissal_Date,
                                                                                          i_Period_End)))),
                            (select m.Name
                               from Mhr_Divisions m
                              where m.Company_Id = v_Company_Id
                                and m.Filial_Id = q.Filial_Id
                                and m.Division_Id =
                                    Hpd_Util.Get_Closest_Division_Id(i_Company_Id => v_Company_Id,
                                                                     i_Filial_Id  => v_Filial_Id,
                                                                     i_Staff_Id   => q.Staff_Id,
                                                                     i_Period     => Least(i_Period_End,
                                                                                           Nvl(q.Dismissal_Date,
                                                                                               i_Period_End)))),
                            (select s.Name
                               from Htt_Schedules s
                              where s.Company_Id = v_Company_Id
                                and s.Filial_Id = v_Filial_Id
                                and s.Schedule_Id =
                                    Hpd_Util.Get_Closest_Schedule_Id(i_Company_Id => v_Company_Id,
                                                                     i_Filial_Id  => v_Filial_Id,
                                                                     i_Staff_Id   => q.Staff_Id,
                                                                     i_Period     => Least(i_Period_End,
                                                                                           Nvl(q.Dismissal_Date,
                                                                                               i_Period_End)))),
                            Nvl((select 'N'
                                  from Href_Util.Staff_Licensed_Period(i_Company_Id   => v_Company_Id,
                                                                       i_Filial_Id    => v_Filial_Id,
                                                                       i_Staff_Id     => q.Staff_Id,
                                                                       i_Period_Begin => i_Period_Begin,
                                                                       i_Period_End   => i_Period_End) q
                                 where q.Licensed = 'N'
                                   and Rownum = 1),
                                'Y')),
             q.Staff_Id
        bulk collect
        into v_Staffs, v_Staff_Ids
        from Href_Staffs q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and q.State = 'A'
         and q.Hiring_Date <= i_Period_End
         and (q.Dismissal_Date is null or q.Dismissal_Date >= i_Period_Begin)
         and (i_Division_Id is null or
             i_Division_Id =
             Hpd_Util.Get_Closest_Division_Id(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Filial_Id,
                                               i_Staff_Id   => q.Staff_Id,
                                               i_Period     => Least(i_Period_End,
                                                                     Nvl(q.Dismissal_Date,
                                                                         i_Period_End))))
         and (v_User_Access_All_Employees = 'Y' or --
             q.Org_Unit_Id member of v_Division_Ids)
         and (i_Staff_Ids is null or
             q.Staff_Id in (select *
                               from table(i_Staff_Ids)))
         and exists (select 1
                from Htt_Timesheets Ht
               where Ht.Company_Id = v_Company_Id
                 and Ht.Filial_Id = v_Filial_Id
                 and Ht.Staff_Id = q.Staff_Id
                 and Ht.Timesheet_Date between i_Period_Begin and i_Period_End
                 and exists (select 1
                        from Htt_Timesheet_Facts Tf
                       where Tf.Company_Id = v_Company_Id
                         and Tf.Filial_Id = v_Filial_Id
                         and Tf.Timesheet_Id = Ht.Timesheet_Id
                         and Tf.Fact_Value > 0))
         and not exists
       (select *
                from Hpr_Timesheet_Locks Tl
               where Tl.Company_Id = v_Company_Id
                 and Tl.Filial_Id = v_Filial_Id
                 and Tl.Staff_Id = q.Staff_Id
                 and Tl.Timesheet_Date >= i_Period_Begin
                 and Tl.Timesheet_Date <= i_Period_End
                 and (i_Timebook_Id is null or Tl.Timebook_Id <> i_Timebook_Id));
    
      Result.Put('unlicensed_staffs',
                 Uit_Hpr.Get_Unlicensed_Staffs(p_Staff_Ids    => v_Staff_Ids,
                                               i_Period_Begin => i_Period_Begin,
                                               i_Period_End   => i_Period_End));
      Result.Put('staffs', Fazo.Zip_Matrix(v_Staffs));
      Result.Put('facts',
                 Uit_Hpr.Get_Staff_Facts(i_Staff_Ids    => v_Staff_Ids,
                                         i_Period_Begin => i_Period_Begin,
                                         i_Period_End   => i_Period_End));
      Result.Put('totals',
                 Uit_Hpr.Get_Staff_Totals(i_Staff_Ids    => v_Staff_Ids,
                                          i_Period_Begin => i_Period_Begin,
                                          i_Period_End   => i_Period_End));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------      
  Function Load_All_Staffs(p Hashmap) return Hashmap is
  begin
    return Load_Staffs(i_Division_Id  => p.o_Number('division_id'),
                       i_Period_Begin => p.r_Date('period_begin'),
                       i_Period_End   => p.r_Date('period_end'),
                       i_Timebook_Id  => p.o_Number('timebook_id'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Staffs(p Hashmap) return Hashmap is
  begin
    return Load_Staffs(i_Division_Id  => p.o_Number('division_id'),
                       i_Period_Begin => p.r_Date('period_begin'),
                       i_Period_End   => p.r_Date('period_end'),
                       i_Timebook_Id  => p.o_Number('timebook_id'),
                       i_Staff_Ids    => p.r_Array_Number('staff_ids'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Staff(p Hashmap) return Hashmap is
    v_Division_Id      number := p.o_Number('division_id');
    v_Staff_Id         number := p.r_Number('staff_id');
    v_Period_Begin     date := p.r_Date('period_begin');
    v_Period_End       date := p.r_Date('period_end');
    v_Desired_Date     date;
    r_Robot            Mrf_Robots%rowtype;
    r_Closest_Schedule Hpd_Trans_Schedules%rowtype;
    r_Staff            Href_Staffs%rowtype;
    v_Staff            Hashmap;
    result             Hashmap := Hashmap();
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Staff_Id   => v_Staff_Id);
  
    Uit_Href.Assert_Access_To_Staff(v_Staff_Id);
  
    v_Desired_Date := Least(v_Period_End, Nvl(r_Staff.Dismissal_Date, v_Period_End));
  
    v_Staff := Fazo.Zip_Map('staff_id',
                            r_Staff.Staff_Id,
                            'name',
                            Href_Util.Staff_Name(i_Company_Id => r_Staff.Company_Id,
                                                 i_Filial_Id  => r_Staff.Filial_Id,
                                                 i_Staff_Id   => r_Staff.Staff_Id),
                            'staff_number',
                            r_Staff.Staff_Number);
  
    r_Robot := Hpd_Util.Get_Closest_Robot(i_Company_Id => r_Staff.Company_Id,
                                          i_Filial_Id  => r_Staff.Filial_Id,
                                          i_Staff_Id   => r_Staff.Staff_Id,
                                          i_Period     => v_Desired_Date);
  
    if Href_Util.Staff_Licensed(i_Company_Id   => r_Staff.Company_Id,
                                i_Filial_Id    => r_Staff.Filial_Id,
                                i_Staff_Id     => r_Staff.Staff_Id,
                                i_Period_Begin => v_Period_Begin,
                                i_Period_End   => v_Period_End) = 'N' then
      v_Staff.Put('unlicensed', 'Y');
    elsif r_Staff.Hiring_Date <= v_Period_End and
          (r_Staff.Dismissal_Date is null or r_Staff.Dismissal_Date >= v_Period_Begin) and
          (v_Division_Id is null or v_Division_Id = r_Robot.Division_Id) and
          Hpr_Util.Is_Staff_Blocked(i_Company_Id   => Ui.Company_Id,
                                    i_Filial_Id    => Ui.Filial_Id,
                                    i_Staff_Id     => v_Staff_Id,
                                    i_Period_Begin => v_Period_Begin,
                                    i_Period_End   => v_Period_End,
                                    i_Timebook_Id  => p.o_Number('timebook_id')) = 'N' and
          sysdate >= v_Period_Begin then
    
      r_Closest_Schedule := Hpd_Util.Closest_Schedule(i_Company_Id => r_Staff.Company_Id,
                                                      i_Filial_Id  => r_Staff.Filial_Id,
                                                      i_Staff_Id   => r_Staff.Staff_Id,
                                                      i_Period     => v_Desired_Date);
    
      v_Staff.Put('job_name',
                  z_Mhr_Jobs.Take(i_Company_Id => r_Staff.Company_Id, --
                  i_Filial_Id => r_Staff.Filial_Id, --
                  i_Job_Id => r_Robot.Job_Id).Name);
      v_Staff.Put('division_name',
                  z_Mhr_Divisions.Take(i_Company_Id => r_Staff.Company_Id, --
                  i_Filial_Id => r_Staff.Filial_Id, --
                  i_Division_Id => r_Robot.Division_Id).Name);
      v_Staff.Put('schedule_name',
                  z_Htt_Schedules.Take(i_Company_Id => r_Staff.Company_Id, --
                  i_Filial_Id => r_Staff.Filial_Id, --
                  i_Schedule_Id => r_Closest_Schedule.Schedule_Id).Name);
      Result.Put('facts',
                 Uit_Hpr.Get_Staff_Facts(i_Staff_Ids    => Array_Number(v_Staff_Id),
                                         i_Period_Begin => v_Period_Begin,
                                         i_Period_End   => v_Period_End));
      Result.Put('totals',
                 Uit_Hpr.Get_Staff_Totals(i_Staff_Ids    => Array_Number(v_Staff_Id),
                                          i_Period_Begin => v_Period_Begin,
                                          i_Period_End   => v_Period_End));
    end if;
  
    Result.Put('staff', v_Staff);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Get_Blocked_Staffs(p Hashmap) return Hashmap is
    v_Period_Begin date := p.r_Date('period_begin');
    v_Period_End   date := p.r_Date('period_end');
    v_Timebook_Id  number := p.o_Number('timebook_id');
    v_Array        Array_Varchar2;
    result         Hashmap := Hashmap();
  begin
    select distinct q.Staff_Id
      bulk collect
      into v_Array
      from Hpr_Timesheet_Locks q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Timesheet_Date between v_Period_Begin and v_Period_End
       and (v_Timebook_Id is null or q.Timebook_Id <> v_Timebook_Id);
  
    Result.Put('staff_ids', v_Array);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References(i_Division_Id number := null) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Time_Kind_Id, t.Name)
      bulk collect
      into v_Matrix
      from Htt_Time_Kinds t
     where t.Company_Id = Ui.Company_Id
       and t.Pcode is not null
     order by t.Pcode;
  
    Result.Put('time_kinds', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions(i_Division_Id)));
    Result.Put('period_kinds', Fazo.Zip_Matrix_Transposed(Hpr_Util.Period_Kinds));
    Result.Put('period_kind_full_month', Hpr_Pref.c_Period_Full_Month);
    Result.Put('period_kind_first_half', Hpr_Pref.c_Period_Month_First_Half);
    Result.Put('period_kind_second_half', Hpr_Pref.c_Period_Month_Second_Half);
    Result.Put('period_kind_custom', Hpr_Pref.c_Period_Custom);
    Result.Put('settings',
               Hpr_Util.Load_Timebook_Fill_Settings(i_Company_Id => Ui.Company_Id,
                                                    i_Filial_Id  => Ui.Filial_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
    v_Period_Begin date := Add_Months(Trunc(sysdate, 'mon'), -1);
    v_Period_End   date := Last_Day(v_Period_Begin);
    result         Hashmap;
  begin
    result := Fazo.Zip_Map('timebook_date', --
                           Trunc(sysdate),
                           'period_kind',
                           Hpr_Pref.c_Period_Full_Month,
                           'month',
                           to_char(v_Period_Begin, Href_Pref.c_Date_Format_Month),
                           'period_begin',
                           to_char(v_Period_Begin, Href_Pref.c_Date_Format_Day),
                           'period_end',
                           to_char(v_Period_End, Href_Pref.c_Date_Format_Day));
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Timebook    Hpr_Timebooks%rowtype;
    v_Staff_Ids   Array_Number;
    v_Totals      Matrix_Varchar2;
    v_Fact_Totals Matrix_Varchar2;
    v_Staffs      Hashmap := Hashmap();
    result        Hashmap;
  begin
    r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Timebook_Id => p.r_Number('timebook_id'));
  
    for r in (select t.Staff_Id
                from Hpr_Timebook_Staffs t
               where t.Company_Id = r_Timebook.Company_Id
                 and t.Filial_Id = r_Timebook.Filial_Id
                 and t.Timebook_Id = r_Timebook.Timebook_Id)
    loop
      Uit_Href.Assert_Access_To_Staff(r.Staff_Id);
    end loop;
  
    result := z_Hpr_Timebooks.To_Map(r_Timebook,
                                     z.Timebook_Id,
                                     z.Timebook_Number,
                                     z.Timebook_Date,
                                     z.Division_Id,
                                     z.Period_Kind,
                                     z.Status,
                                     z.Note,
                                     z.Posted);
  
    Result.Put('month', to_char(r_Timebook.Month, Href_Pref.c_Date_Format_Month));
    Result.Put('period_begin', to_char(r_Timebook.Period_Begin, Href_Pref.c_Date_Format_Day));
    Result.Put('period_end', to_char(r_Timebook.Period_End, Href_Pref.c_Date_Format_Day));
  
    select Array_Varchar2(Ts.Staff_Id,
                          q.Staff_Number,
                          (select Np.Name
                             from Mr_Natural_Persons Np
                            where Np.Company_Id = q.Company_Id
                              and Np.Person_Id = q.Employee_Id),
                          (select j.Name
                             from Mhr_Jobs j
                            where j.Company_Id = Ts.Company_Id
                              and j.Filial_Id = Ts.Filial_Id
                              and j.Job_Id = Ts.Job_Id),
                          (select m.Name
                             from Mhr_Divisions m
                            where m.Company_Id = Ts.Company_Id
                              and m.Filial_Id = Ts.Filial_Id
                              and m.Division_Id = Ts.Division_Id),
                          (select s.Name
                             from Htt_Schedules s
                            where s.Company_Id = Ts.Company_Id
                              and s.Filial_Id = Ts.Filial_Id
                              and s.Schedule_Id = Ts.Schedule_Id),
                          Ts.Plan_Days,
                          Ts.Plan_Hours,
                          Ts.Fact_Days,
                          Ts.Fact_Hours),
           Ts.Staff_Id
      bulk collect
      into v_Totals, v_Staff_Ids
      from Hpr_Timebook_Staffs Ts
      join Href_Staffs q
        on q.Company_Id = Ts.Company_Id
       and q.Filial_Id = Ts.Filial_Id
       and q.Staff_Id = Ts.Staff_Id
     where Ts.Company_Id = r_Timebook.Company_Id
       and Ts.Filial_Id = r_Timebook.Filial_Id
       and Ts.Timebook_Id = r_Timebook.Timebook_Id;
  
    select Array_Varchar2(Tf.Staff_Id, Tf.Time_Kind_Id, Tf.Fact_Hours)
      bulk collect
      into v_Fact_Totals
      from Hpr_Timebook_Facts Tf
     where Tf.Company_Id = r_Timebook.Company_Id
       and Tf.Filial_Id = r_Timebook.Filial_Id
       and Tf.Timebook_Id = r_Timebook.Timebook_Id;
  
    v_Staffs.Put('totals', Fazo.Zip_Matrix(v_Totals));
    v_Staffs.Put('fact_totals', Fazo.Zip_Matrix(v_Fact_Totals));
    v_Staffs.Put('facts',
                 Uit_Hpr.Get_Staff_Facts(i_Staff_Ids    => v_Staff_Ids,
                                         i_Period_Begin => r_Timebook.Period_Begin,
                                         i_Period_End   => r_Timebook.Period_End));
  
    if r_Timebook.Division_Id is not null then
      Result.Put('division_name',
                 z_Mhr_Divisions.Load(i_Company_Id => r_Timebook.Company_Id, i_Filial_Id => r_Timebook.Filial_Id, i_Division_Id => r_Timebook.Division_Id).Name);
    end if;
  
    Result.Put('staffs', v_Staffs);
    Result.Put('references', References(r_Timebook.Division_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    i_Timebook_Id number,
    p             Hashmap,
    i_Repost      boolean := false,
    i_Exists      boolean := false
  ) return Hashmap is
    p_Timebook           Hpr_Pref.Timebook_Rt;
    v_Notification_Title varchar2(500);
    v_Posted             varchar2(1) := p.r_Varchar2('posted');
    v_User_Id            number := Ui.User_Id;
  begin
    Hpr_Util.Timebook_New(o_Timebook        => p_Timebook,
                          i_Company_Id      => Ui.Company_Id,
                          i_Filial_Id       => Ui.Filial_Id,
                          i_Timebook_Id     => i_Timebook_Id,
                          i_Timebook_Number => p.o_Varchar2('timebook_number'),
                          i_Timebook_Date   => p.r_Date('timebook_date'),
                          i_Period_Begin    => p.r_Date('period_begin'),
                          i_Period_End      => p.r_Date('period_end'),
                          i_Period_Kind     => p.r_Varchar2('period_kind'),
                          i_Division_Id     => p.o_Number('division_id'),
                          i_Note            => p.o_Varchar2('note'),
                          i_Staff_Ids       => p.r_Array_Number('staff_ids'));
  
    for i in 1 .. p_Timebook.Staff_Ids.Count
    loop
      Uit_Href.Assert_Access_To_Staff(p_Timebook.Staff_Ids(i));
    end loop;
  
    -- notification title should make before saving journal
    if i_Exists = false and v_Posted = 'N' then
      v_Notification_Title := Hpr_Util.t_Notification_Title_Timebook_Save(i_Company_Id      => p_Timebook.Company_Id,
                                                                          i_User_Id         => v_User_Id,
                                                                          i_Timebook_Number => p_Timebook.Timebook_Number,
                                                                          i_Month           => Trunc(p_Timebook.Period_Begin,
                                                                                                     'fmmon'));
    elsif i_Repost = false and v_Posted = 'Y' then
      v_Notification_Title := Hpr_Util.t_Notification_Title_Timebook_Post(i_Company_Id      => p_Timebook.Company_Id,
                                                                          i_User_Id         => v_User_Id,
                                                                          i_Timebook_Number => p_Timebook.Timebook_Number,
                                                                          i_Month           => Trunc(p_Timebook.Period_Begin,
                                                                                                     'fmmon'));
    else
      v_Notification_Title := Hpr_Util.t_Notification_Title_Timebook_Update(i_Company_Id      => p_Timebook.Company_Id,
                                                                            i_User_Id         => v_User_Id,
                                                                            i_Timebook_Number => p_Timebook.Timebook_Number,
                                                                            i_Month           => Trunc(p_Timebook.Period_Begin,
                                                                                                       'fmmon'));
    end if;
  
    Hpr_Api.Timebook_Save(p_Timebook);
  
    if v_Posted = 'Y' then
      Hpr_Api.Timebook_Post(i_Company_Id  => p_Timebook.Company_Id,
                            i_Filial_Id   => p_Timebook.Filial_Id,
                            i_Timebook_Id => p_Timebook.Timebook_Id);
    end if;
  
    -- notification send after saving journal
    Href_Core.Send_Notification(i_Company_Id    => p_Timebook.Company_Id,
                                i_Filial_Id     => p_Timebook.Filial_Id,
                                i_Title         => v_Notification_Title,
                                i_Uri           => Hpr_Pref.c_Form_Timebook_View,
                                i_Uri_Param     => Fazo.Zip_Map('timebook_id',
                                                                p_Timebook.Timebook_Id),
                                i_Check_Setting => true,
                                i_User_Id       => v_User_Id);
  
    return Fazo.Zip_Map('timebook_id',
                        p_Timebook.Timebook_Id,
                        'timebook_number',
                        p_Timebook.Timebook_Number);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Hpr_Next.Timebook_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    r_Timebook Hpr_Timebooks%rowtype;
  begin
    r_Timebook := z_Hpr_Timebooks.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                            i_Filial_Id   => Ui.Filial_Id,
                                            i_Timebook_Id => p.r_Number('timebook_id'));
  
    if r_Timebook.Posted = 'Y' then
      Hpr_Api.Timebook_Unpost(i_Company_Id  => r_Timebook.Company_Id,
                              i_Filial_Id   => r_Timebook.Filial_Id,
                              i_Timebook_Id => r_Timebook.Timebook_Id);
    end if;
  
    return save(r_Timebook.Timebook_Id,
                p,
                (r_Timebook.Posted = 'Y' and p.r_Varchar2('posted') = 'Y'),
                true);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
    v_Dummy varchar2(1);
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Employee_Id    = null,
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
           Staff_Kind     = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Htt_Timesheets
       set Company_Id     = null,
           Filial_Id      = null,
           Timesheet_Id   = null,
           Timesheet_Date = null,
           Staff_Id       = null;
    update Htt_Timesheet_Facts
       set Company_Id   = null,
           Filial_Id    = null,
           Timesheet_Id = null,
           Fact_Value   = null;
  
    Uie.x(Hpr_Util.Is_Staff_Blocked(null, null, null, null, null, null));
    Uie.x(Hpd_Util.Get_Closest_Division_Id(null, null, null, null));
    Uie.x(Hpd_Util.Get_Closest_Job_Id(null, null, null, null));
  
    select 'X'
      into v_Dummy
      from Href_Util.Staff_Licensed_Period(i_Company_Id   => null,
                                           i_Filial_Id    => null,
                                           i_Staff_Id     => null,
                                           i_Period_Begin => null,
                                           i_Period_End   => null);
  end;

end Ui_Vhr75;
/
