create or replace package Ui_Vhr526 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Overtimes(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Overtime_Day(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
end Ui_Vhr526;
/
create or replace package body Ui_Vhr526 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs(p Hashmap) return Fazo_Query is
    v_Division_Ids Array_Number := p.r_Array_Number('division_ids');
    v_Div_Cnt      number := v_Division_Ids.Count;
    v_Param        Hashmap;
    q              Fazo_Query;
  begin
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'filial_id',
                            Ui.Filial_Id,
                            'div_cnt',
                            v_Div_Cnt);
  
    v_Param.Put('division_ids', v_Division_Ids);
  
    q := Fazo_Query('select *
                       from mhr_jobs q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.state = ''A''
                        and (:div_cnt = 0
                            or q.c_divisions_exist = ''N''
                            or exists (select 1
                                  from mhr_job_divisions w
                                 where w.company_id = q.company_id
                                   and w.filial_id = q.filial_id
                                   and w.job_id = q.job_id
                                   and w.division_id member of :division_ids))',
                    v_Param);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs(p Hashmap) return Fazo_Query is
  begin
    return Ui_Vhr334.Query_Staffs(p);
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
  Function Get_Overtimes(p Hashmap) return Arraylist is
    v_Company_Id           number := Ui.Company_Id;
    v_Filial_Id            number := Ui.Filial_Id;
    v_Matrix               Matrix_Varchar2;
    v_Division_Ids         Array_Number := p.r_Array_Number('division_ids');
    v_Sub_Division_Ids     Array_Number;
    v_Job_Ids              Array_Number := p.r_Array_Number('job_ids');
    v_Staff_Ids            Array_Number := p.r_Array_Number('staff_ids');
    v_Div_Cnt              number := v_Division_Ids.Count;
    v_Job_Cnt              number := v_Job_Ids.Count;
    v_Staff_Cnt            number := v_Staff_Ids.Count;
    v_Free_Id              number;
    v_Lunchtime_Id         number;
    v_Before_Work_Id       number;
    v_After_Work_Id        number;
    v_Excluded_Tk_Id       number := -1;
    v_Exc_After_Work_Id    number := -1;
    v_Exc_Before_Work_Id   number := -1;
    v_Month_Begin          date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Month_End            date := Last_Day(v_Month_Begin);
    v_Min_Free_Time        number := Greatest(Nvl(p.o_Number('min_free_time'), 0) * 60, 1);
    v_Max_Free_Time        number := Nvl(p.o_Number('max_free_time'), 1440) * 60;
    v_Max_Before_Work_Time number := Nvl(p.o_Number('max_before_work_time'), 1440) * 60;
    v_Min_Before_Work_Time number := Nvl(p.o_Number('min_before_work_time'), 0) * 60;
    v_Max_After_Work_Time  number := Nvl(p.o_Number('max_after_work_time'), 1440) * 60;
    v_Min_After_Work_Time  number := Nvl(p.o_Number('min_after_work_time'), 0) * 60;
    v_Calc_Lunchtime       varchar2(1) := Nvl(p.o_Varchar2('calc_lunchtime'), 'N');
    v_Calc_After_Work      varchar2(1) := Nvl(p.o_Varchar2('calc_after_work'), 'N');
    v_Calc_Before_Work     varchar2(1) := Nvl(p.o_Varchar2('calc_before_work'), 'N');
    v_Access_All_Employees varchar2(1) := Uit_Href.User_Access_All_Employees;
  begin
    if v_Access_All_Employees = 'N' then
      for i in 1 .. v_Staff_Cnt
      loop
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Ids(i), i_Self => false);
      end loop;
    
      v_Sub_Division_Ids := Uit_Href.Get_All_Subordinate_Divisions;
    end if;
  
    v_Free_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    v_Lunchtime_Id := Htt_Util.Time_Kind_Id(i_Company_Id => v_Company_Id,
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
  
    select Array_Varchar2(Ot.Staff_Name, --
                          Ot.Staff_Id,
                          Ot.Timesheet_Date,
                          Ot.Day_Kind,
                          Ot.Free_Time,
                          Ot.Lunchtime,
                          Ot.After_Work_Time,
                          Ot.Before_Work_Time)
      bulk collect
      into v_Matrix
      from (select (select w.Name
                      from Mr_Natural_Persons w
                     where w.Company_Id = v_Company_Id
                       and w.Person_Id = (select St.Employee_Id
                                            from Href_Staffs St
                                           where St.Company_Id = v_Company_Id
                                             and St.Filial_Id = v_Filial_Id
                                             and St.Staff_Id = t.Staff_Id)) Staff_Name,
                   t.Staff_Id,
                   t.Timesheet_Date,
                   max(t.Day_Kind) Day_Kind,
                   Round(sum(q.Fact_Value) / 60, 2) as Free_Time,
                   Round(sum(Decode(q.Time_Kind_Id, v_Lunchtime_Id, q.Fact_Value, 0)) / 60, 2) as Lunchtime,
                   Round(sum(Decode(q.Time_Kind_Id, v_After_Work_Id, q.Fact_Value, 0)) / 60, 2) as After_Work_Time,
                   Round(sum(Decode(q.Time_Kind_Id, v_Before_Work_Id, q.Fact_Value, 0)) / 60, 2) as Before_Work_Time,
                   case
                      when v_Div_Cnt = 0 and v_Access_All_Employees = 'Y' then
                       null
                      else
                       Hpd_Util.Get_Closest_Org_Unit_Id(i_Company_Id => v_Company_Id,
                                                        i_Filial_Id  => v_Filial_Id,
                                                        i_Staff_Id   => t.Staff_Id,
                                                        i_Period     => v_Month_End)
                    end Division_Id
              from Htt_Timesheets t
              join Htt_Timesheet_Facts q
                on q.Company_Id = t.Company_Id
               and q.Filial_Id = t.Filial_Id
               and q.Timesheet_Id = t.Timesheet_Id
               and q.Time_Kind_Id in
                   (select Tk.Time_Kind_Id
                      from Htt_Time_Kinds Tk
                     where Tk.Company_Id = v_Company_Id
                       and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) = v_Free_Id)
             where t.Company_Id = v_Company_Id
               and t.Filial_Id = v_Filial_Id
               and (v_Staff_Cnt = 0 or t.Staff_Id member of v_Staff_Ids)
               and t.Timesheet_Date between v_Month_Begin and v_Month_End
               and Ui.User_Id <> (select St.Employee_Id
                                    from Href_Staffs St
                                   where St.Company_Id = v_Company_Id
                                     and St.Filial_Id = v_Filial_Id
                                     and St.Staff_Id = t.Staff_Id)
               and (v_Job_Cnt = 0 or --
                   Hpd_Util.Get_Closest_Job_Id(i_Company_Id => v_Company_Id,
                                                i_Filial_Id  => v_Filial_Id,
                                                i_Staff_Id   => t.Staff_Id,
                                                i_Period     => v_Month_End) member of v_Job_Ids)
               and not exists (select *
                      from Hpd_Overtime_Days d
                     where d.Company_Id = t.Company_Id
                       and d.Filial_Id = t.Filial_Id
                       and d.Staff_Id = t.Staff_Id
                       and d.Overtime_Date = t.Timesheet_Date)
             group by t.Staff_Id, t.Timesheet_Date
            having Nvl(sum(Decode(q.Time_Kind_Id, v_After_Work_Id, q.Fact_Value, 0)), 0) between v_Min_After_Work_Time and v_Max_After_Work_Time --
            and Nvl(sum(Decode(q.Time_Kind_Id, v_Before_Work_Id, q.Fact_Value, 0)), 0) between v_Min_Before_Work_Time and v_Max_Before_Work_Time --
            and sum(q.Fact_Value) --
            -Nvl(sum(Decode(q.Time_Kind_Id, v_Excluded_Tk_Id, q.Fact_Value, 0)), 0) --
            -Nvl(sum(Decode(q.Time_Kind_Id, v_Exc_After_Work_Id, q.Fact_Value, 0)), 0) --
            -Nvl(sum(Decode(q.Time_Kind_Id, v_Exc_Before_Work_Id, q.Fact_Value, 0)), 0) -- 
            between v_Min_Free_Time and v_Max_Free_Time
             order by t.Staff_Id, t.Timesheet_Date) Ot
     where (v_Div_Cnt = 0 or --
           Ot.Division_Id member of v_Division_Ids)
       and (v_Access_All_Employees = 'Y' or --
           Ot.Division_Id member of v_Sub_Division_Ids);
  
    return Fazo.Zip_Matrix(v_Matrix);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Overtime_Day(p Hashmap) return Hashmap is
    r_Timesheet        Htt_Timesheets%rowtype;
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
  
    v_Free_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    v_Lunchtime_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime);
  
    v_After_Work_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                             i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work);
  
    v_Before_Work_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                              i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work);
  
    r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Staff_Id       => v_Staff_Id,
                                      i_Timesheet_Date => p.r_Date('overtime_date'));
  
    v_Free_Time := Htt_Util.Get_Fact_Value(i_Company_Id     => r_Timesheet.Company_Id,
                                           i_Filial_Id      => r_Timesheet.Filial_Id,
                                           i_Staff_Id       => r_Timesheet.Staff_Id,
                                           i_Timesheet_Date => r_Timesheet.Timesheet_Date,
                                           i_Time_Kind_Id   => v_Free_Id);
  
    v_Lunchtime := Htt_Util.Get_Fact_Value(i_Company_Id   => r_Timesheet.Company_Id,
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
    v_Company_Id     number := Ui.Company_Id;
    v_Filial_Id      number := Ui.Filial_Id;
    v_Journal        Hpd_Pref.Overtime_Journal_Rt;
    v_Overtime       Hpd_Pref.Overtime_Nt;
    v_Overtime_List  Arraylist;
    v_Overtime_Cell  Hashmap;
    v_Month          date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Overtimes      Arraylist := p.r_Arraylist('overtimes');
    v_Staff_Overtime Hashmap;
    v_Staff_Id       number;
  begin
    for x in 1 .. v_Overtimes.Count
    loop
      v_Staff_Overtime := Treat(v_Overtimes.r_Hashmap(x) as Hashmap);
    
      v_Staff_Id := v_Staff_Overtime.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      Hpd_Util.Overtime_Journal_New(o_Overtime_Journal => v_Journal,
                                    i_Company_Id       => v_Company_Id,
                                    i_Filial_Id        => v_Filial_Id,
                                    i_Journal_Id       => Hpd_Next.Journal_Id,
                                    i_Journal_Number   => null,
                                    i_Journal_Date     => Trunc(sysdate),
                                    i_Journal_Name     => null);
    
      v_Overtime_List := v_Staff_Overtime.r_Arraylist('overtime_days');
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
                                    i_Month       => v_Month,
                                    i_Overtime_Id => Hpd_Next.Overtime_Id,
                                    i_Overtimes   => v_Overtime);
    
      Hpd_Api.Overtime_Journal_Save(v_Journal);
    
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('month', to_char(sysdate, Href_Pref.c_Date_Format_Month));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
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
  Procedure Validation is
  begin
    update Mhr_Job_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Job_Id      = null,
           Division_Id = null;
    update Mhr_Jobs
       set Company_Id        = null,
           Job_Id            = null,
           name              = null,
           Filial_Id         = null,
           State             = null,
           c_Divisions_Exist = null;
  end;

end Ui_Vhr526;
/
