create or replace package Ui_Vhr334 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Overtime(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Overtimes(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Overtime_Day(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr334;
/
create or replace package body Ui_Vhr334 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Employee_Id number := p.o_Number('employee_id');
    q             Fazo_Query;
    v_Query       varchar2(32000);
    v_Params      Hashmap;
  begin
    v_Query := 'select q.journal_id,
                       w.journal_date,
                       q.overtime_id,
                       q.employee_id,
                       trunc(q.begin_date) as month,
                       w.created_on,
                       w.created_by,
                       w.modified_on,
                       w.modified_by,
                       hpd_util.get_closest_org_unit_id(i_company_Id => :company_Id,
                                                        i_filial_Id  => :filial_Id,
                                                        i_staff_Id   => q.staff_Id,
                                                        i_period     => q.end_date) org_unit_id 
                  from hpd_journal_overtimes q
                  join hpd_journals w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.journal_id = q.journal_id
                   and w.posted = ''Y''
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'employee_id',
                             v_Employee_Id);
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('journal_id', 'overtime_id', 'employee_id', 'created_by', 'modified_by');
    q.Date_Field('journal_date', 'month', 'created_on', 'modified_on');
  
    q.Refer_Field('employee_name',
                  'employee_id',
                  'md_persons',
                  'person_id',
                  'name',
                  'select *
                     from md_persons q
                    where q.company_id = :company_id
                      and (:employee_id is null or q.person_id = :employee_id)');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
  
    q.Map_Field('day_count',
                'select count(*)
                   from hpd_overtime_days q
                  where q.company_id = :company_id
                    and q.filial_id = :filial_id
                    and q.overtime_id = $overtime_id');
    q.Map_Field('total_time',
                'select round(sum(q.overtime_seconds) / 60, 2)
                   from hpd_overtime_days q
                  where q.company_id = :company_id
                    and q.filial_id = :filial_id
                    and q.overtime_id = $overtime_id');
    q.Map_Field('period_date',
                'select to_char(min(q.overtime_date) || '' - '' || max(q.overtime_date)) as period
                   from hpd_overtime_days q
                  where q.company_id = :company_id
                    and q.filial_id = :filial_id
                    and q.overtime_id = $overtime_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
    v_Hashmap Hashmap := Hashmap();
    v_Query   varchar2(32000);
    q         Fazo_Query;
  begin
    v_Hashmap.Put_All(Fazo.Zip_Map('company_id',
                                   Ui.Company_Id,
                                   'filial_id',
                                   Ui.Filial_Id,
                                   'free_id',
                                   Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                         i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free),
                                   'month_begin',
                                   p.r_Date('month_begin'),
                                   'month_end',
                                   p.r_Date('month_end')));
  
    v_Hashmap.Put('min_free_time', Greatest(Nvl(p.o_Number('min_free_time'), 60), 60));
    v_Hashmap.Put('max_free_time', Nvl(p.o_Number('max_free_time'), 86400));
  
    v_Query := 'select q.*
                  from href_staffs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.state = ''A''
                   and exists (select 1
                          from htt_timesheets t
                         where t.company_id = q.company_id
                           and t.filial_id = q.filial_id
                           and t.staff_id = q.staff_id
                           and t.timesheet_date between :month_begin and :month_end
                           and nvl((select sum(tf.fact_value)
                                      from htt_timesheet_facts tf
                                     where tf.company_id = t.company_id
                                       and tf.filial_id = t.filial_id
                                       and tf.timesheet_id = t.timesheet_id
                                       and tf.time_kind_id in
                                           (select tk.time_kind_id
                                              from htt_time_kinds tk
                                             where tk.company_id = :company_id
                                               and nvl(tk.parent_id, tk.time_kind_id) = :free_id)),
                                   0) between :min_free_time and :max_free_time
                           and not exists (select *
                                  from hpd_overtime_days d
                                  join hpd_journal_overtimes jo
                                    on jo.company_id = d.company_id
                                   and jo.filial_id = d.filial_id
                                   and jo.overtime_id = d.overtime_id
                                  join hpd_journals j
                                    on j.company_id = jo.company_id
                                   and j.filial_id = jo.filial_id
                                   and j.journal_id = jo.journal_id
                                 where t.company_id = d.company_id
                                   and t.filial_id = d.filial_id
                                   and t.staff_id = d.staff_id
                                   and t.timesheet_date = d.overtime_date
                                   and j.posted = ''Y''))';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query);
  
    q := Fazo_Query(v_Query, v_Hashmap);
  
    q.Number_Field('staff_id', 'employee_id');
    q.Varchar2_Field('staff_number', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('staff_ids',
               Uit_Hpd.Load_Overtime_Blocked_Staffs(i_Month_Begin   => p.r_Date('month_begin'),
                                                    i_Month_End     => p.r_Date('month_end'),
                                                    i_Min_Free_Time => Greatest(Nvl(p.o_Number('min_free_time'),
                                                                                    60),
                                                                                60),
                                                    i_Max_Free_Time => Nvl(p.o_Number('max_free_time'),
                                                                           86400)));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('et_contractor', Hpd_Pref.c_Employment_Type_Contractor);
    Result.Put('day_kinds',
               Fazo.Zip_Matrix(Array_Varchar2(Htt_Pref.c_Day_Kind_Work,
                                              Htt_Pref.c_Day_Kind_Rest,
                                              Htt_Pref.c_Day_Kind_Holiday,
                                              Htt_Pref.c_Day_Kind_Additional_Rest,
                                              Htt_Pref.c_Day_Kind_Nonworking),
                               Array_Varchar2(Htt_Util.t_Day_Kind(Htt_Pref.c_Day_Kind_Work),
                                              Htt_Util.t_Day_Kind(Htt_Pref.c_Day_Kind_Rest),
                                              Htt_Util.t_Day_Kind(Htt_Pref.c_Day_Kind_Holiday),
                                              Htt_Util.t_Day_Kind(Htt_Pref.c_Day_Kind_Additional_Rest),
                                              Htt_Util.t_Day_Kind(Htt_Pref.c_Day_Kind_Nonworking))));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Overtime(p Hashmap) return Hashmap is
    r_Journal        Hpd_Journals%rowtype;
    r_Overtime       Hpd_Journal_Overtimes%rowtype;
    v_Matrix         Matrix_Varchar2;
    v_Free_Id        number;
    v_Lunchtime_Id   number;
    v_Before_Work_Id number;
    v_After_Work_Id  number;
    result           Hashmap;
  begin
    r_Overtime := z_Hpd_Journal_Overtimes.Load(i_Company_Id  => Ui.Company_Id,
                                               i_Filial_Id   => Ui.Filial_Id,
                                               i_Overtime_Id => p.r_Number('overtime_id'));
  
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Overtime.Employee_Id, i_Self => false);
  
    v_Free_Id        := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
    v_Lunchtime_Id   := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime);
    v_Before_Work_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work);
    v_After_Work_Id  := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work);
  
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    result := z_Hpd_Journal_Overtimes.To_Map(r_Overtime,
                                             z.Overtime_Id,
                                             z.Journal_Id,
                                             z.Employee_Id,
                                             z.Staff_Id,
                                             z.Begin_Date,
                                             z.End_Date);
  
    Result.Put('journal_date', r_Journal.Journal_Date);
    Result.Put('journal_name', r_Journal.Journal_Name);
    Result.Put('month', to_char(r_Overtime.Begin_Date, Href_Pref.c_Date_Format_Month));
    Result.Put('staff_name',
               z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => r_Overtime.Employee_Id).Name);
  
    select Array_Varchar2(q.Overtime_Date,
                          max(t.Day_Kind),
                          Round(sum(Tf.Fact_Value) / 60, 2),
                          Round(sum(Decode(Tf.Time_Kind_Id, v_Lunchtime_Id, Tf.Fact_Value, 0)) / 60,
                                2),
                          Round(sum(Decode(Tf.Time_Kind_Id, v_Before_Work_Id, Tf.Fact_Value, 0)) / 60,
                                2),
                          Round(sum(Decode(Tf.Time_Kind_Id, v_After_Work_Id, Tf.Fact_Value, 0)) / 60,
                                2),
                          Round(max(q.Overtime_Seconds) / 60, 2))
      bulk collect
      into v_Matrix
      from Hpd_Overtime_Days q
      join Htt_Timesheets t
        on t.Company_Id = q.Company_Id
       and t.Filial_Id = q.Filial_Id
       and t.Staff_Id = q.Staff_Id
       and t.Timesheet_Date = q.Overtime_Date
      join Htt_Timesheet_Facts Tf
        on Tf.Company_Id = t.Company_Id
       and Tf.Filial_Id = t.Filial_Id
       and Tf.Timesheet_Id = t.Timesheet_Id
       and Tf.Time_Kind_Id in
           (select Tk.Time_Kind_Id
              from Htt_Time_Kinds Tk
             where Tk.Company_Id = Ui.Company_Id
               and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) = v_Free_Id)
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Overtime_Id = r_Overtime.Overtime_Id
     group by q.Staff_Id, q.Overtime_Date
     order by q.Staff_Id, q.Overtime_Date;
  
    Result.Put('overtime_days', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Overtimes(p Hashmap) return Arraylist is
    v_Matrix               Matrix_Varchar2;
    v_Free_Id              number;
    v_Lunchtime_Id         number;
    v_Before_Work_Id       number;
    v_After_Work_Id        number;
    v_Excluded_Tk_Id       number := -1;
    v_Exc_After_Work_Id    number := -1;
    v_Exc_Before_Work_Id   number := -1;
    v_Min_Free_Time        number := Greatest(Nvl(p.o_Number('min_free_time'), 0) * 60, 1);
    v_Max_Free_Time        number := Nvl(p.o_Number('max_free_time'), 1440) * 60;
    v_Max_Before_Work_Time number := Nvl(p.o_Number('max_before_work_time'), 1440) * 60;
    v_Min_Before_Work_Time number := Nvl(p.o_Number('min_before_work_time'), 0) * 60;
    v_Max_After_Work_Time  number := Nvl(p.o_Number('max_after_work_time'), 1440) * 60;
    v_Min_After_Work_Time  number := Nvl(p.o_Number('min_after_work_time'), 0) * 60;
    v_Calc_Lunchtime       varchar2(1) := Nvl(p.o_Varchar2('calc_lunchtime'), 'N');
    v_Calc_After_Work      varchar2(1) := Nvl(p.o_Varchar2('calc_after_work'), 'N');
    v_Calc_Before_Work     varchar2(1) := Nvl(p.o_Varchar2('calc_before_work'), 'N');
    v_Staff_Id             number := p.r_Number('staff_id');
    v_Month_Begin          date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Month_End            date := Last_Day(v_Month_Begin);
  begin
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
  
    v_Free_Id       := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
    v_Lunchtime_Id  := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime);
    v_After_Work_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work);
  
    v_Before_Work_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work);
  
    if v_Calc_Lunchtime = 'N' then
      v_Excluded_Tk_Id := v_Lunchtime_Id;
    end if;
  
    if v_Calc_After_Work = 'N' then
      v_Exc_After_Work_Id := v_After_Work_Id;
    end if;
  
    if v_Calc_Before_Work = 'N' then
      v_Exc_Before_Work_Id := v_Before_Work_Id;
    end if;
  
    select Array_Varchar2(t.Timesheet_Date,
                          max(t.Day_Kind),
                          Round(sum(q.Fact_Value) / 60, 2),
                          Round(sum(Decode(q.Time_Kind_Id, v_Lunchtime_Id, q.Fact_Value, 0)) / 60, 2),
                          Round(sum(Decode(q.Time_Kind_Id, v_Before_Work_Id, q.Fact_Value, 0)) / 60,
                                2),
                          Round(sum(Decode(q.Time_Kind_Id, v_After_Work_Id, q.Fact_Value, 0)) / 60,
                                2))
      bulk collect
      into v_Matrix
      from Htt_Timesheets t
      join Htt_Timesheet_Facts q
        on q.Company_Id = t.Company_Id
       and q.Filial_Id = t.Filial_Id
       and q.Timesheet_Id = t.Timesheet_Id
       and q.Time_Kind_Id in
           (select Tk.Time_Kind_Id
              from Htt_Time_Kinds Tk
             where Tk.Company_Id = Ui.Company_Id
               and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) = v_Free_Id)
     where t.Company_Id = Ui.Company_Id
       and t.Filial_Id = Ui.Filial_Id
       and t.Staff_Id = v_Staff_Id
       and t.Timesheet_Date between v_Month_Begin and v_Month_End
       and not exists (select *
              from Hpd_Overtime_Days d
             where t.Company_Id = d.Company_Id
               and t.Filial_Id = d.Filial_Id
               and t.Staff_Id = d.Staff_Id
               and t.Timesheet_Date = d.Overtime_Date)
     group by t.Timesheet_Date
    having Nvl(sum(Decode(q.Time_Kind_Id, v_After_Work_Id, q.Fact_Value, 0)), 0) between v_Min_After_Work_Time and v_Max_After_Work_Time --
    and Nvl(sum(Decode(q.Time_Kind_Id, v_Before_Work_Id, q.Fact_Value, 0)), 0) between v_Min_Before_Work_Time and v_Max_Before_Work_Time --
    and sum(q.Fact_Value) --
    -Nvl(sum(Decode(q.Time_Kind_Id, v_Excluded_Tk_Id, q.Fact_Value, 0)), 0) --
    -Nvl(sum(Decode(q.Time_Kind_Id, v_Exc_After_Work_Id, q.Fact_Value, 0)), 0) --
    -Nvl(sum(Decode(q.Time_Kind_Id, v_Exc_Before_Work_Id, q.Fact_Value, 0)), 0) -- 
    between v_Min_Free_Time and v_Max_Free_Time
     order by t.Timesheet_Date;
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Overtime_Day(p Hashmap) return Hashmap is
    r_Timesheet        Htt_Timesheets%rowtype;
    r_Overtime         Hpd_Overtime_Days%rowtype;
    v_Overtime_Id      number := Nvl(p.o_Number('overtime_id'), -1);
    v_Free_Id          number;
    v_Lunchtime_Id     number;
    v_After_Work_Id    number;
    v_Before_Work_Id   number;
    v_Free_Time        number;
    v_Lunchtime        number;
    v_After_Work_Time  number;
    v_Before_Work_Time number;
    v_Staff_Id         number := p.r_Number('staff_id');
  begin
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
  
    v_Free_Id       := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
    v_Lunchtime_Id  := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime);
    v_After_Work_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work);
  
    v_Before_Work_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work);
  
    r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Staff_Id       => v_Staff_Id,
                                      i_Timesheet_Date => p.r_Date('overtime_date'));
  
    if not z_Hpd_Overtime_Days.Exist(i_Company_Id    => r_Timesheet.Company_Id,
                                     i_Filial_Id     => r_Timesheet.Filial_Id,
                                     i_Staff_Id      => r_Timesheet.Staff_Id,
                                     i_Overtime_Date => r_Timesheet.Timesheet_Date,
                                     o_Row           => r_Overtime) or
       r_Overtime.Overtime_Id = v_Overtime_Id then
      v_Free_Time := Htt_Util.Get_Fact_Value(i_Company_Id     => r_Timesheet.Company_Id,
                                             i_Filial_Id      => r_Timesheet.Filial_Id,
                                             i_Staff_Id       => r_Timesheet.Staff_Id,
                                             i_Timesheet_Date => r_Timesheet.Timesheet_Date,
                                             i_Time_Kind_Id   => v_Free_Id);
    
      v_Lunchtime       := Htt_Util.Get_Fact_Value(i_Company_Id   => r_Timesheet.Company_Id,
                                                   i_Filial_Id    => r_Timesheet.Filial_Id,
                                                   i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                                   i_Time_Kind_Id => v_Lunchtime_Id);
      v_After_Work_Time := Htt_Util.Get_Fact_Value(i_Company_Id   => r_Timesheet.Company_Id,
                                                   i_Filial_Id    => r_Timesheet.Filial_Id,
                                                   i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                                   i_Time_Kind_Id => v_After_Work_Id);
    
      v_Before_Work_Time := Htt_Util.Get_Fact_Value(i_Company_Id   => r_Timesheet.Company_Id,
                                                    i_Filial_Id    => r_Timesheet.Filial_Id,
                                                    i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                                    i_Time_Kind_Id => v_Before_Work_Id);
    end if;
  
    return Fazo.Zip_Map('day_kind',
                        r_Timesheet.Day_Kind,
                        'free_time',
                        Round(Nvl(v_Free_Time, 0) / 60, 2),
                        'lunchtime',
                        Round(Nvl(v_Lunchtime, 0) / 60, 2),
                        'after_work_time',
                        Round(Nvl(v_After_Work_Time, 0) / 60, 2),
                        'before_work_time',
                        Round(Nvl(v_Before_Work_Time, 0) / 60, 2));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    v_Journal       Hpd_Pref.Overtime_Journal_Rt;
    v_Overtime      Hpd_Pref.Overtime_Nt;
    v_Overtime_List Arraylist;
    v_Overtime_Cell Hashmap;
    v_Journal_Id    number := p.o_Number('journal_id');
    v_Overtime_Id   number := p.o_Number('overtime_id');
    r_Journal       Hpd_Journals%rowtype;
    v_Staff_Id      number := p.r_Number('staff_id');
  begin
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
  
    if z_Hpd_Journals.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Journal_Id => v_Journal_Id,
                                 o_Row        => r_Journal) then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id);
    else
      v_Journal_Id := Hpd_Next.Journal_Id;
    end if;
  
    if v_Overtime_Id is null then
      v_Overtime_Id := Hpd_Next.Overtime_Id;
    end if;
  
    Hpd_Util.Overtime_Journal_New(o_Overtime_Journal => v_Journal,
                                  i_Company_Id       => Ui.Company_Id,
                                  i_Filial_Id        => Ui.Filial_Id,
                                  i_Journal_Id       => v_Journal_Id,
                                  i_Journal_Number   => r_Journal.Journal_Number,
                                  i_Journal_Date     => Trunc(sysdate),
                                  i_Journal_Name     => r_Journal.Journal_Name);
  
    v_Overtime_List := p.r_Arraylist('overtime_days');
    v_Overtime      := Hpd_Pref.Overtime_Nt();
  
    for j in 1 .. v_Overtime_List.Count
    loop
      v_Overtime_Cell := Treat(v_Overtime_List.r_Hashmap(j) as Hashmap);
    
      Hpd_Util.Overtime_Add(p_Overtimes        => v_Overtime,
                            i_Overtime_Date    => v_Overtime_Cell.r_Date('overtime_date'),
                            i_Overtime_Seconds => v_Overtime_Cell.r_Number('overtime_hours') * 60);
    end loop;
  
    Hpd_Util.Journal_Add_Overtime(p_Journal     => v_Journal,
                                  i_Staff_Id    => v_Staff_Id,
                                  i_Month       => p.r_Date('month', Href_Pref.c_Date_Format_Month),
                                  i_Overtime_Id => v_Overtime_Id,
                                  i_Overtimes   => v_Overtime);
  
    Hpd_Api.Overtime_Journal_Save(v_Journal);
  
    Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                         i_Filial_Id  => v_Journal.Filial_Id,
                         i_Journal_Id => v_Journal.Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Journal_Ids Array_Number := Fazo.Sort(p.r_Array_Number('journal_id'));
  begin
    for i in 1 .. v_Journal_Ids.Count
    loop
      Hpd_Api.Journal_Unpost(i_Company_Id => Ui.Company_Id,
                             i_Filial_Id  => Ui.Filial_Id,
                             i_Journal_Id => v_Journal_Ids(i));
    
      Hpd_Api.Journal_Delete(i_Company_Id => Ui.Company_Id,
                             i_Filial_Id  => Ui.Filial_Id,
                             i_Journal_Id => v_Journal_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpd_Journals
       set Company_Id  = null,
           Filial_Id   = null,
           Journal_Id  = null,
           Posted      = null,
           Created_By  = null,
           Created_On  = null,
           Modified_By = null,
           Modified_On = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Hpd_Journal_Overtimes
       set Company_Id  = null,
           Filial_Id   = null,
           Overtime_Id = null,
           Journal_Id  = null,
           Employee_Id = null,
           Staff_Id    = null,
           Begin_Date  = null,
           End_Date    = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Hpd_Overtime_Days
       set Company_Id       = null,
           Filial_Id        = null,
           Overtime_Id      = null,
           Overtime_Seconds = null;
    update Href_Staffs
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Staff_Number    = null,
           Employee_Id     = null,
           Hiring_Date     = null,
           Employment_Type = null,
           Dismissal_Date  = null,
           State           = null;
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
           Time_Kind_Id = null,
           Fact_Value   = null;
    Uie.x(Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => null,
                                           i_Filial_Id  => null,
                                           i_Staff_Id   => null,
                                           i_Period     => null));
  end;

end Ui_Vhr334;
/
