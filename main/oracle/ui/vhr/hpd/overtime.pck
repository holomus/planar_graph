create or replace package Ui_Vhr280 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Blocked_Staffs(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Overtimes_All(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Get_Overtimes(p Hashmap) return Arraylist;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Overtime_Day(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr280;
/
create or replace package body Ui_Vhr280 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(3000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select * 
                  from href_staffs s
                 where s.company_id = :company_id
                   and s.filial_id = :filial_id
                   and s.state = ''A''';
  
    if Uit_Href.User_Access_All_Employees <> 'Y' then
      v_Params.Put('user_id', Ui.User_Id);
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    
      v_Query := v_Query || ' and s.org_unit_id in (select column_value from table(:division_ids))
                              and s.employee_id <> :user_id';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id', 'employee_id', 'division_id');
    q.Varchar2_Field('staff_number', 'staff_kind', 'employment_type');
    q.Date_Field('hiring_date', 'dismissal_date');
  
    q.Map_Field('name',
                'select q.name
                   from mr_natural_persons q
                  where q.company_id = :company_id
                    and q.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
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
  Function Get_Overtimes_All(p Hashmap) return Arraylist is
    v_Matrix               Matrix_Varchar2;
    v_Free_Id              number;
    v_Lunchtime_Id         number;
    v_Before_Work_Id       number;
    v_After_Work_Id        number;
    v_Excluded_Tk_Id       number := -1;
    v_Exc_After_Work_Id    number := -1;
    v_Exc_Before_Work_Id   number := -1;
    v_Min_Free_Time        number := Greatest(Nvl(p.o_Number('min_free_time'), 0) * 60, 60);
    v_Max_Free_Time        number := Nvl(p.o_Number('max_free_time'), 1440) * 60;
    v_Max_Before_Work_Time number := Nvl(p.o_Number('max_before_work_time'), 1440) * 60;
    v_Min_Before_Work_Time number := Nvl(p.o_Number('min_before_work_time'), 0) * 60;
    v_Max_After_Work_Time  number := Nvl(p.o_Number('max_after_work_time'), 1440) * 60;
    v_Min_After_Work_Time  number := Nvl(p.o_Number('min_after_work_time'), 0) * 60;
    v_Staff_Ids            Array_Number := p.r_Array_Number('staff_ids');
    v_Calc_Lunchtime       varchar2(1) := Nvl(p.o_Varchar2('calc_lunchtime'), 'N');
    v_Calc_After_Work      varchar2(1) := Nvl(p.o_Varchar2('calc_after_work'), 'N');
    v_Calc_Before_Work     varchar2(1) := Nvl(p.o_Varchar2('calc_before_work'), 'N');
    v_Month_Begin          date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Month_End            date := Last_Day(v_Month_Begin);
  begin
    v_Free_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    v_Lunchtime_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
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
  
    select Array_Varchar2(t.Staff_Id,
                          t.Timesheet_Date,
                          max(t.Day_Kind),
                          Round(sum(q.Fact_Value) / 60, 2),
                          Round(sum(Decode(q.Time_Kind_Id, v_Lunchtime_Id, q.Fact_Value, 0)) / 60, 2),
                          Round(sum(Decode(q.Time_Kind_Id, v_After_Work_Id, q.Fact_Value, 0)) / 60,
                                2),
                          Round(sum(Decode(q.Time_Kind_Id, v_Before_Work_Id, q.Fact_Value, 0)) / 60,
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
       and t.Staff_Id in (select Column_Value
                            from table(v_Staff_Ids))
       and t.Timesheet_Date between v_Month_Begin and v_Month_End
       and not exists (select *
              from Hpd_Overtime_Days d
             where t.Company_Id = d.Company_Id
               and t.Filial_Id = d.Filial_Id
               and t.Staff_Id = d.Staff_Id
               and t.Timesheet_Date = d.Overtime_Date)
     group by t.Staff_Id, t.Timesheet_Date
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
  Function Get_Overtimes(p Hashmap) return Arraylist is
    v_Matrix               Matrix_Varchar2;
    v_Free_Id              number;
    v_Lunchtime_Id         number;
    v_Before_Work_Id       number;
    v_After_Work_Id        number;
    v_Excluded_Tk_Id       number := -1;
    v_Exc_After_Work_Id    number := -1;
    v_Exc_Before_Work_Id   number := -1;
    v_Min_Free_Time        number := Greatest(Nvl(p.o_Number('min_free_time'), 0) * 60, 60);
    v_Max_Free_Time        number := Nvl(p.o_Number('max_free_time'), 1440) * 60;
    v_Max_Before_Work_Time number := Nvl(p.o_Number('max_before_work_time'), 1440) * 60;
    v_Min_Before_Work_Time number := Nvl(p.o_Number('min_before_work_time'), 0) * 60;
    v_Max_After_Work_Time  number := Nvl(p.o_Number('max_after_work_time'), 1440) * 60;
    v_Min_After_Work_Time  number := Nvl(p.o_Number('min_after_work_time'), 0) * 60;
    v_Staff_Id             number := p.r_Number('staff_id');
    v_Calc_Lunchtime       varchar2(1) := Nvl(p.o_Varchar2('calc_lunchtime'), 'N');
    v_Calc_After_Work      varchar2(1) := Nvl(p.o_Varchar2('calc_after_work'), 'N');
    v_Calc_Before_Work     varchar2(1) := Nvl(p.o_Varchar2('calc_before_work'), 'N');
    v_Month_Begin          date := p.r_Date('month', Href_Pref.c_Date_Format_Month);
    v_Month_End            date := Last_Day(v_Month_Begin);
  begin
    v_Free_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
  
    v_Lunchtime_Id := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
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
                          Round(sum(Decode(q.Time_Kind_Id, v_After_Work_Id, q.Fact_Value, 0)) / 60,
                                2),
                          Round(sum(Decode(q.Time_Kind_Id, v_Before_Work_Id, q.Fact_Value, 0)) / 60,
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
    v_Free_Time        number;
    v_Lunchtime        number;
    v_After_Work_Time  number;
    v_Before_Work_Time number;
    v_Staff_Id         number := p.r_Number('staff_id');
  begin
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
  
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
                                             i_Time_Kind_Id   => Htt_Util.Time_Kind_Id(i_Company_Id => r_Timesheet.Company_Id,
                                                                                       i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free));
    
      v_Lunchtime := Htt_Util.Get_Fact_Value(i_Company_Id   => r_Timesheet.Company_Id,
                                             i_Filial_Id    => r_Timesheet.Filial_Id,
                                             i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                             i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                                                     i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime));
    
      v_After_Work_Time := Htt_Util.Get_Fact_Value(i_Company_Id   => r_Timesheet.Company_Id,
                                                   i_Filial_Id    => r_Timesheet.Filial_Id,
                                                   i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                                   i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => r_Timesheet.Company_Id,
                                                                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work));
    
      v_Before_Work_Time := Htt_Util.Get_Fact_Value(i_Company_Id   => r_Timesheet.Company_Id,
                                                    i_Filial_Id    => r_Timesheet.Filial_Id,
                                                    i_Timesheet_Id => r_Timesheet.Timesheet_Id,
                                                    i_Time_Kind_Id => Htt_Util.Time_Kind_Id(i_Company_Id => r_Timesheet.Company_Id,
                                                                                            i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work));
    end if;
  
    return Fazo.Zip_Map('day_kind',
                        r_Timesheet.Day_Kind,
                        'free_time',
                        Round(Nullif(v_Free_Time, 0) / 60, 2),
                        'lunchtime',
                        Round(Nullif(v_Lunchtime, 0) / 60, 2),
                        'after_work_time',
                        Round(Nullif(v_After_Work_Time, 0) / 60, 2),
                        'before_work_time',
                        Round(Nullif(v_Before_Work_Time, 0) / 60, 2));
  end;

  ----------------------------------------------------------------------------------------------------    
  Function References return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('et_contractor', Hpd_Pref.c_Employment_Type_Contractor);
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
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
  Function Add_Model(p Hashmap) return Hashmap is
    v_Journal_Type_Id   number := p.r_Number('journal_type_id');
    v_Has_Sign_Template varchar2(1) := 'N';
    result              Hashmap;
  begin
    if not Hpd_Util.Is_Overtime_Journal(i_Company_Id      => Ui.Company_Id,
                                        i_Journal_Type_Id => v_Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    result := Fazo.Zip_Map('journal_date',
                           Trunc(sysdate),
                           'month',
                           to_char(Trunc(sysdate), Href_Pref.c_Date_Format_Month));
  
    if Hpd_Util.Has_Journal_Type_Sign_Template(i_Company_Id      => Ui.Company_Id,
                                               i_Filial_Id       => Ui.Filial_Id,
                                               i_Journal_Type_Id => v_Journal_Type_Id) then
      v_Has_Sign_Template := 'Y';
    end if;
  
    Result.Put('has_sign_template', v_Has_Sign_Template);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Journal              Hpd_Journals%rowtype;
    result                 Hashmap;
    v_Matrix               Matrix_Varchar2;
    v_Overtime_Ids         Array_Number;
    v_Sign_Document_Status varchar2(1);
    v_Has_Sign_Document    varchar2(1) := 'N';
    v_Free_Id              number := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Free);
    v_Lunchtime_Id         number := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Lunchtime);
    v_After_Work_Time_Id   number := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_After_Work);
    v_Before_Work_Time_Id  number := Htt_Util.Time_Kind_Id(i_Company_Id => Ui.Company_Id,
                                                           i_Pcode      => Htt_Pref.c_Pcode_Time_Kind_Before_Work);
  
  begin
    r_Journal := z_Hpd_Journals.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Journal_Id => p.r_Number('journal_id'));
  
    if not Hpd_Util.Is_Overtime_Journal(i_Company_Id      => Ui.Company_Id,
                                        i_Journal_Type_Id => r_Journal.Journal_Type_Id) then
      b.Raise_Not_Implemented;
    end if;
  
    v_Sign_Document_Status := Hpd_Util.Load_Sign_Document_Status(i_Company_Id  => r_Journal.Company_Id,
                                                                 i_Document_Id => r_Journal.Sign_Document_Id);
  
    if v_Sign_Document_Status is not null then
      Uit_Hpd.Check_Access_To_Edit_Journal(i_Document_Status => v_Sign_Document_Status,
                                           i_Posted          => r_Journal.Posted,
                                           i_Journal_Number  => r_Journal.Journal_Number);
      v_Has_Sign_Document := 'Y';
    end if;
  
    for r in (select s.Staff_Id
                from Hpd_Journal_Staffs s
               where s.Company_Id = r_Journal.Company_Id
                 and s.Filial_Id = r_Journal.Filial_Id
                 and s.Journal_Id = r_Journal.Journal_Id)
    loop
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r.Staff_Id, i_Self => false);
    end loop;
  
    result := z_Hpd_Journals.To_Map(r_Journal,
                                    z.Journal_Id,
                                    z.Journal_Number,
                                    z.Journal_Date,
                                    z.Journal_Name);
  
    select Array_Varchar2(q.Overtime_Id,
                          q.Staff_Id,
                          (select w.Name
                             from Mr_Natural_Persons w
                            where q.Company_Id = w.Company_Id
                              and q.Employee_Id = w.Person_Id),
                          to_char(q.Begin_Date, Href_Pref.c_Date_Format_Month),
                          (select Round(sum(w.Overtime_Seconds) / 60, 2)
                             from Hpd_Overtime_Days w
                            where q.Company_Id = w.Company_Id
                              and q.Filial_Id = w.Filial_Id
                              and q.Overtime_Id = w.Overtime_Id),
                          (select Listagg(w.Overtime_Date, ', ')
                             from Hpd_Overtime_Days w
                            where q.Company_Id = w.Company_Id
                              and q.Filial_Id = w.Filial_Id
                              and q.Overtime_Id = w.Overtime_Id),
                          (select Round(min(w.Overtime_Seconds) / 60, 2)
                             from Hpd_Overtime_Days w
                            where q.Company_Id = w.Company_Id
                              and q.Filial_Id = w.Filial_Id
                              and q.Overtime_Id = w.Overtime_Id),
                          (select Round(max(w.Overtime_Seconds) / 60, 2)
                             from Hpd_Overtime_Days w
                            where q.Company_Id = w.Company_Id
                              and q.Filial_Id = w.Filial_Id
                              and q.Overtime_Id = w.Overtime_Id)),
           q.Overtime_Id
      bulk collect
      into v_Matrix, v_Overtime_Ids
      from Hpd_Journal_Overtimes q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Journal_Id = r_Journal.Journal_Id;
  
    Result.Put('overtime_staffs', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(max(q.Overtime_Id),
                          q.Overtime_Date,
                          max(t.Day_Kind),
                          Round(sum(Tf.Fact_Value) / 60, 2),
                          Round(sum(Decode(Tf.Time_Kind_Id, v_Lunchtime_Id, Tf.Fact_Value, 0)) / 60,
                                2),
                          Round(sum(Decode(Tf.Time_Kind_Id, v_After_Work_Time_Id, Tf.Fact_Value, 0)) / 60,
                                2),
                          Round(sum(Decode(Tf.Time_Kind_Id, v_Before_Work_Time_Id, Tf.Fact_Value, 0)) / 60,
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
       and q.Overtime_Id member of v_Overtime_Ids
     group by q.Staff_Id, q.Overtime_Date
     order by q.Staff_Id, q.Overtime_Date;
  
    Result.Put('overtime_days', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('month', to_char(sysdate, Href_Pref.c_Date_Format_Month));
    Result.Put('division_id',
               z_Hpd_Overtime_Journal_Divisions.Take(i_Company_Id => r_Journal.Company_Id, i_Filial_Id => r_Journal.Filial_Id, i_Journal_Id => r_Journal.Journal_Id).Division_Id);
    Result.Put('has_sign_document', v_Has_Sign_Document);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Journal_Id number,
    p            Hashmap
  ) is
    v_Journal         Hpd_Pref.Overtime_Journal_Rt;
    v_Overtime        Hpd_Pref.Overtime_Nt;
    v_Overtime_Staffs Arraylist := p.r_Arraylist('overtime_staffs');
    v_Overtime_Map    Hashmap;
    v_Overtime_Id     number;
    v_Staff_Id        number;
    v_Overtime_List   Arraylist;
    v_Overtime_Cell   Hashmap;
  begin
    Hpd_Util.Overtime_Journal_New(o_Overtime_Journal => v_Journal,
                                  i_Company_Id       => Ui.Company_Id,
                                  i_Filial_Id        => Ui.Filial_Id,
                                  i_Journal_Id       => i_Journal_Id,
                                  i_Journal_Number   => p.o_Varchar2('journal_number'),
                                  i_Journal_Date     => p.r_Date('journal_date'),
                                  i_Journal_Name     => p.o_Varchar2('journal_name'),
                                  i_Division_Id      => p.o_Number('division_id'),
                                  i_Lang_Code        => Ui_Context.Lang_Code);
  
    for i in 1 .. v_Overtime_Staffs.Count
    loop
      v_Overtime_Map := Treat(v_Overtime_Staffs.r_Hashmap(i) as Hashmap);
    
      v_Staff_Id := v_Overtime_Map.r_Number('staff_id');
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => v_Staff_Id, i_Self => false);
    
      v_Overtime_Id := v_Overtime_Map.o_Number('overtime_id');
    
      if v_Overtime_Id is null then
        v_Overtime_Id := Hpd_Next.Overtime_Id;
      end if;
    
      v_Overtime_List := v_Overtime_Map.r_Arraylist('overtime_days');
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
                                    i_Month       => v_Overtime_Map.r_Date('month',
                                                                           Href_Pref.c_Date_Format_Month),
                                    i_Overtime_Id => v_Overtime_Id,
                                    i_Overtimes   => v_Overtime);
    
    end loop;
  
    Hpd_Api.Overtime_Journal_Save(v_Journal);
  
    if p.r_Varchar2('posted') = 'Y' then
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(Hpd_Next.Journal_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Journal Hpd_Journals%rowtype;
  begin
    r_Journal := z_Hpd_Journals.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Journal_Id => p.r_Number('journal_id'));
  
    if r_Journal.Posted = 'Y' then
      Hpd_Api.Journal_Unpost(i_Company_Id => r_Journal.Company_Id,
                             i_Filial_Id  => r_Journal.Filial_Id,
                             i_Journal_Id => r_Journal.Journal_Id);
    end if;
  
    save(r_Journal.Journal_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Employee_Id     = null,
           Hiring_Date     = null,
           Org_Unit_Id     = null,
           Employment_Type = null,
           Dismissal_Date  = null,
           Division_Id     = null,
           Staff_Kind      = null,
           State           = null;
  end;

end Ui_Vhr280;
/
