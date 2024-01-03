create or replace package Ui_Vhr31 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Calendars return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Calendar_Days(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Check_By_Calendar_Limit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Get_Schedule_Year(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr31;
/
create or replace package body Ui_Vhr31 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Calendars return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_calendars',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('calendar_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Marks
  (
    i_Schedule_Id number,
    i_Year        number
  ) return Arraylist is
    result Matrix_Varchar2;
  begin
    select Array_Varchar2(Dm.Schedule_Date, mod(Dm.Begin_Time, 1440), mod(Dm.End_Time, 1440))
      bulk collect
      into result
      from Htt_Schedule_Origin_Day_Marks Dm
     where Dm.Company_Id = Ui.Company_Id
       and Dm.Filial_Id = Ui.Filial_Id
       and Dm.Schedule_Id = i_Schedule_Id
       and Extract(year from Dm.Schedule_Date) = i_Year;
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Weights
  (
    i_Schedule_Id number,
    i_Year        number
  ) return Arraylist is
    v_Year_Begin date := to_date('01.01.' || i_Year, 'dd.mm.yyyy');
    v_Year_End   date := Htt_Util.Year_Last_Day(v_Year_Begin);
    result       Matrix_Varchar2;
  begin
    select Array_Varchar2(Dm.Schedule_Date,
                          mod(Dm.Begin_Time, 1440),
                          mod(Dm.End_Time, 1440),
                          Dm.Weight)
      bulk collect
      into result
      from Htt_Schedule_Origin_Day_Weights Dm
     where Dm.Company_Id = Ui.Company_Id
       and Dm.Filial_Id = Ui.Filial_Id
       and Dm.Schedule_Id = i_Schedule_Id
       and Dm.Schedule_Date between v_Year_Begin and v_Year_End;
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Days
  (
    i_Schedule_Id number,
    i_Year        number
  ) return Arraylist is
    result       Matrix_Varchar2;
    v_Year_Begin date := Trunc(to_date(i_Year, Href_Pref.c_Date_Format_Year), 'y');
    v_Year_End   date := Last_Day(Add_Months(v_Year_Begin, 11));
  begin
    select Array_Varchar2(v.Date_Value,
                          to_char(t.End_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(t.Begin_Time, Href_Pref.c_Time_Format_Minute),
                          Nvl(t.Break_Enabled, 'N'),
                          Nvl(t.Day_Kind, Htt_Pref.c_Day_Kind_Rest),
                          to_char(t.Break_Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(t.Break_End_Time, Href_Pref.c_Time_Format_Minute),
                          Nvl(t.Plan_Time, 0))
      bulk collect
      into result
      from (select *
              from Htt_Schedule_Origin_Days d
             where d.Company_Id = Ui.Company_Id
               and d.Filial_Id = Ui.Filial_Id
               and d.Schedule_Id = i_Schedule_Id
               and Extract(year from d.Schedule_Date) = i_Year) t
     right join (select v_Year_Begin + (level - 1) Date_Value
                   from Dual
                 connect by level <= (v_Year_End - v_Year_Begin + 1)) v
        on v.Date_Value = t.Schedule_Date
     order by v.Date_Value;
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Calendar_Days(p Hashmap) return Hashmap is
    v_Calendar_Id number := p.r_Number('calendar_id');
    v_Schedule_Id number := p.o_Number('schedule_id');
    v_Year        number := p.r_Number('year');
    v_Matrix      Matrix_Varchar2;
    v_Dates       Array_Date;
    result        Hashmap := Hashmap();
  begin
    select Array_Varchar2(s.Calendar_Date, s.Name, s.Day_Kind, s.Swapped_Date)
      bulk collect
      into v_Matrix
      from Htt_Calendar_Days s
     where s.Company_Id = Ui.Company_Id
       and s.Filial_Id = Ui.Filial_Id
       and s.Calendar_Id = v_Calendar_Id
       and (Extract(year from s.Calendar_Date) = v_Year or
           Extract(year from s.Swapped_Date) = v_Year);
  
    Result.Put('calendar_days', Fazo.Zip_Matrix(v_Matrix));
  
    -- taking calendar date      in this year and swapped date not in this year
    -- or      calendar date not in this year and swapped date     in this year
    select Decode(Extract(year from q.Calendar_Date), v_Year, q.Swapped_Date, q.Calendar_Date)
      bulk collect
      into v_Dates
      from Htt_Calendar_Days q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Calendar_Id = v_Calendar_Id
       and q.Day_Kind = Htt_Pref.c_Day_Kind_Swapped
       and (Extract(year from q.Calendar_Date) = v_Year and
           Extract(year from q.Swapped_Date) <> v_Year or
           Extract(year from q.Calendar_Date) <> v_Year and
           Extract(year from q.Swapped_Date) = v_Year);
  
    select Array_Varchar2(q.Schedule_Date,
                          to_char(w.End_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(w.Begin_Time, Href_Pref.c_Time_Format_Minute),
                          Nvl(w.Break_Enabled, 'N'),
                          Nvl(w.Day_Kind, Htt_Pref.c_Day_Kind_Rest),
                          to_char(w.Break_Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(w.Break_End_Time, Href_Pref.c_Time_Format_Minute),
                          Nvl(w.Plan_Time, 0))
      bulk collect
      into v_Matrix
      from (select Column_Value Schedule_Date
              from table(v_Dates)) q
      left join Htt_Schedule_Origin_Days w
        on w.Company_Id = Ui.Company_Id
       and w.Schedule_Id = v_Schedule_Id
       and w.Schedule_Date = q.Schedule_Date;
  
    Result.Put('swapped_days', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Schedule_Year(p Hashmap) return Hashmap is
    result        Hashmap := Hashmap();
    v_Schedule_Id number := p.r_Number('schedule_id');
    v_Year        number := p.r_Number('year');
  begin
    Result.Put('days', Get_Days(v_Schedule_Id, v_Year));
    Result.Put('marks', Get_Marks(v_Schedule_Id, v_Year));
    Result.Put('weights', Get_Weights(v_Schedule_Id, v_Year));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Template_Data(i_Template_Id number) return Hashmap is
    r_Template      Htt_Schedule_Templates%rowtype;
    v_Days          Arraylist := Arraylist();
    v_Day           Hashmap;
    v_Pattern_Marks Matrix_Varchar2;
    v_Marks_Used    varchar2(1) := 'N';
    result          Hashmap;
  
    -------------------------------------------------- 
    Function Advanced_Settings
    (
      i_Template   Htt_Schedule_Templates%rowtype,
      i_Marks_Used varchar2
    ) return varchar2 is
    begin
      if i_Template.Shift = 0 and i_Template.Input_Acceptance = 0 and
         i_Template.Output_Acceptance = 0 and i_Template.Track_Duration = 1440 and
         i_Template.Count_Late = 'Y' and i_Template.Count_Early = 'Y' and
         i_Template.Count_Lack = 'Y' and i_Marks_Used = 'N' then
        return 'N';
      else
        return 'Y';
      end if;
    end;
  begin
    r_Template := z_Htt_Schedule_Templates.Load(i_Template_Id);
  
    result := z_Htt_Schedule_Templates.To_Map(r_Template,
                                              z.All_Days_Equal,
                                              z.Schedule_Kind,
                                              z.Count_Days,
                                              z.Shift,
                                              z.Input_Acceptance,
                                              z.Output_Acceptance,
                                              z.Track_Duration,
                                              z.Count_Late,
                                              z.Count_Early,
                                              z.Count_Lack,
                                              z.Take_Holidays,
                                              z.Take_Nonworking);
  
    for r in (select *
                from Htt_Schedule_Template_Days q
               where q.Template_Id = r_Template.Template_Id
               order by q.Day_No)
    loop
      v_Day := z_Htt_Schedule_Template_Days.To_Map(r,
                                                   z.Day_No,
                                                   z.Day_Kind,
                                                   z.Begin_Time,
                                                   z.End_Time,
                                                   z.Break_Enabled,
                                                   z.Break_Begin_Time,
                                                   z.Break_End_Time,
                                                   z.Plan_Time);
    
      select Array_Varchar2(mod(Pm.Begin_Time, 1440), mod(Pm.End_Time, 1440))
        bulk collect
        into v_Pattern_Marks
        from Htt_Schedule_Template_Marks Pm
       where Pm.Template_Id = r.Template_Id
         and Pm.Day_No = r.Day_No;
    
      if v_Marks_Used = 'N' and v_Pattern_Marks.Count > 0 then
        v_Marks_Used := 'Y';
      end if;
    
      v_Day.Put('marks', Fazo.Zip_Matrix(v_Pattern_Marks));
    
      v_Days.Push(v_Day);
    end loop;
  
    Result.Put('year', Extract(year from sysdate));
    Result.Put('schedule_days', v_Days);
    Result.Put('schedule_kind', r_Template.Schedule_Kind);
    Result.Put('all_days_equal', r_Template.All_Days_Equal);
    Result.Put('use_calendar', 'N');
    Result.Put('advanced_settings',
               Advanced_Settings(i_Template => r_Template, i_Marks_Used => v_Marks_Used));
    Result.Put('use_marks', v_Marks_Used);
    Result.Put('state', 'A');
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
  begin
    return Fazo.Zip_Map('sk_custom',
                        Htt_Pref.c_Schedule_Kind_Custom,
                        'sk_hourly',
                        Htt_Pref.c_Schedule_Kind_Hourly,
                        'sk_flexible',
                        Htt_Pref.c_Schedule_Kind_Flexible,
                        'additional_time_type_allowed',
                        Htt_Pref.c_Additional_Time_Type_Allowed,
                        'additional_time_type_extra',
                        Htt_Pref.c_Additional_Time_Type_Extra);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model(p Hashmap) return Hashmap is
    v_Template_Id   number := p.o_Number('template_id');
    v_Schedule_Kind varchar2(1) := p.r_Varchar2('schedule_kind');
    result          Hashmap;
  begin
    Uit_Htt.Assert_Access_To_Schedule_Kind(i_Schedule_Kind => v_Schedule_Kind,
                                           i_Form          => Htt_Pref.c_Schedule_List_Form);
  
    if v_Template_Id is null then
      result := Fazo.Zip_Map('pattern_kind',
                             Htt_Pref.c_Pattern_Kind_Weekly,
                             'year',
                             Extract(year from sysdate),
                             'advanced_settings',
                             'N',
                             'use_calendar',
                             'N',
                             'all_days_equal',
                             'Y',
                             'state',
                             'A');
    
      Result.Put('schedule_kind', v_Schedule_Kind);
      Result.Put('take_holidays', 'Y');
      Result.Put('take_nonworking', 'Y');
      Result.Put('take_additional_rest_days', 'Y');
      Result.Put('count_late', 'Y');
      Result.Put('count_early', 'Y');
      Result.Put('count_lack', 'Y');
      Result.Put('count_free', 'Y');
      Result.Put('gps_turnout_enabled', 'N');
      Result.Put('gps_use_location', 'N');
      Result.Put('use_marks', 'N');
      Result.Put('use_weights', 'N');
      Result.Put('advanced_setting', 'N');
      Result.Put('additional_time_type', Htt_Pref.c_Additional_Time_Type_Allowed);
    else
      b.Raise_Not_Implemented;
    
      result := Get_Template_Data(v_Template_Id);
    end if;
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Schedule             Htt_Schedules%rowtype;
    r_Schedule_Pattern     Htt_Schedule_Patterns%rowtype;
    v_Days                 Arraylist := Arraylist();
    v_Day                  Hashmap;
    v_Pattern_Marks        Matrix_Varchar2;
    v_Pattern_Weights      Matrix_Varchar2;
    v_Marks                Arraylist;
    v_Weights              Arraylist;
    v_Schedule_Year        number := Extract(year from sysdate);
    v_Dummy                number;
    v_Attached             varchar2(1);
    v_Marks_Used           varchar2(1) := 'N';
    v_Additional_Time_Type varchar2(1) := Htt_Pref.c_Additional_Time_Type_Allowed;
    v_Advanced_Setting     varchar2(1) := 'N';
    result                 Hashmap;
  
    -------------------------------------------------- 
    Function Advanced_Settings
    (
      i_Schedule     Htt_Schedules%rowtype,
      i_Marks_Used   varchar2,
      i_Weights_Used varchar2
    ) return varchar2 is
      v_Shift_Changed boolean := i_Schedule.Shift = 0 and i_Schedule.Input_Acceptance = 0 and
                                 i_Schedule.Output_Acceptance = 0 and
                                 i_Schedule.Track_Duration = 1440;
    begin
      if i_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Hourly then
        return 'N';
      elsif (i_Schedule.Schedule_Kind = Htt_Pref.c_Schedule_Kind_Flexible or v_Shift_Changed) and
            i_Schedule.Count_Late = 'Y' and i_Schedule.Count_Early = 'Y' and
            i_Schedule.Count_Lack = 'Y' and i_Schedule.Count_Free = 'Y' and i_Marks_Used = 'N' and
            i_Weights_Used = 'N' then
        return 'N';
      else
        return 'Y';
      end if;
    end;
  begin
    r_Schedule := z_Htt_Schedules.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Schedule_Id => p.r_Number('schedule_id'));
  
    Uit_Htt.Assert_Access_To_Schedule_Kind(i_Schedule_Kind => r_Schedule.Schedule_Kind,
                                           i_Form          => Htt_Pref.c_Schedule_List_Form);
  
    if r_Schedule.Pcode is not null then
      b.Raise_Not_Implemented;
    end if;
  
    r_Schedule_Pattern := z_Htt_Schedule_Patterns.Load(i_Company_Id  => r_Schedule.Company_Id,
                                                       i_Filial_Id   => r_Schedule.Filial_Id,
                                                       i_Schedule_Id => r_Schedule.Schedule_Id);
  
    result := z_Htt_Schedules.To_Map(r_Schedule,
                                     z.Schedule_Id,
                                     z.Name,
                                     z.Shift,
                                     z.Schedule_Kind,
                                     z.Input_Acceptance,
                                     z.Output_Acceptance,
                                     z.Track_Duration,
                                     z.Count_Late,
                                     z.Count_Early,
                                     z.Count_Lack,
                                     z.Count_Free,
                                     z.Use_Weights,
                                     z.Gps_Turnout_Enabled,
                                     z.Gps_Use_Location,
                                     z.Gps_Max_Interval,
                                     z.Allowed_Late_Time,
                                     z.Allowed_Early_Time,
                                     z.Begin_Late_Time,
                                     z.End_Early_Time,
                                     z.Calendar_Id,
                                     z.Take_Holidays,
                                     z.Take_Nonworking,
                                     z.Take_Additional_Rest_Days,
                                     z.State,
                                     z.Code);
  
    if r_Schedule.Begin_Late_Time <> 0 or r_Schedule.End_Early_Time <> 0 then
      v_Additional_Time_Type := Htt_Pref.c_Additional_Time_Type_Extra;
    end if;
  
    if r_Schedule.Allowed_Late_Time <> 0 or r_Schedule.Allowed_Early_Time <> 0 or
       v_Additional_Time_Type = Htt_Pref.c_Additional_Time_Type_Extra then
      v_Advanced_Setting := 'Y';
    end if;
  
    Result.Put('additional_time_type', v_Additional_Time_Type);
    Result.Put('advanced_setting', v_Advanced_Setting);
  
    for r in (select *
                from Htt_Schedule_Pattern_Days q
               where q.Company_Id = r_Schedule.Company_Id
                 and q.Filial_Id = r_Schedule.Filial_Id
                 and q.Schedule_Id = r_Schedule.Schedule_Id
               order by q.Day_No)
    loop
      v_Day := z_Htt_Schedule_Pattern_Days.To_Map(r,
                                                  z.Day_No,
                                                  z.Day_Kind,
                                                  z.Begin_Time,
                                                  z.End_Time,
                                                  z.Break_Enabled,
                                                  z.Break_Begin_Time,
                                                  z.Break_End_Time,
                                                  z.Plan_Time);
    
      select Array_Varchar2(mod(Pm.Begin_Time, 1440), mod(Pm.End_Time, 1440))
        bulk collect
        into v_Pattern_Marks
        from Htt_Schedule_Pattern_Marks Pm
       where Pm.Company_Id = r.Company_Id
         and Pm.Filial_Id = r.Filial_Id
         and Pm.Schedule_Id = r.Schedule_Id
         and Pm.Day_No = r.Day_No;
    
      if v_Marks_Used = 'N' and v_Pattern_Marks.Count > 0 then
        v_Marks_Used := 'Y';
      end if;
    
      select Array_Varchar2(mod(Pm.Begin_Time, 1440), mod(Pm.End_Time, 1440), Pm.Weight)
        bulk collect
        into v_Pattern_Weights
        from Htt_Schedule_Pattern_Weights Pm
       where Pm.Company_Id = r.Company_Id
         and Pm.Filial_Id = r.Filial_Id
         and Pm.Schedule_Id = r.Schedule_Id
         and Pm.Day_No = r.Day_No;
    
      v_Day.Put('marks', Fazo.Zip_Matrix(v_Pattern_Marks));
      v_Day.Put('weights', Fazo.Zip_Matrix(v_Pattern_Weights));
    
      v_Days.Push(v_Day);
    end loop;
  
    begin
      select 1
        into v_Dummy
        from Htt_Schedule_Origin_Days d
       where d.Company_Id = r_Schedule.Company_Id
         and d.Filial_Id = r_Schedule.Filial_Id
         and d.Schedule_Id = r_Schedule.Schedule_Id
         and Extract(year from d.Schedule_Date) = v_Schedule_Year
       fetch first 1 row only;
    exception
      when No_Data_Found then
        select Extract(year from max(d.Schedule_Date))
          into v_Schedule_Year
          from Htt_Schedule_Origin_Days d
         where d.Company_Id = r_Schedule.Company_Id
           and d.Filial_Id = r_Schedule.Filial_Id
           and d.Schedule_Id = r_Schedule.Schedule_Id;
      
        v_Schedule_Year := Nvl(v_Schedule_Year, Extract(year from sysdate));
    end;
  
    begin
      select 'Y'
        into v_Attached
        from Htt_Timesheets t
       where t.Company_Id = r_Schedule.Company_Id
         and t.Filial_Id = r_Schedule.Filial_Id
         and t.Schedule_Id = r_Schedule.Schedule_Id
         and Rownum = 1;
    exception
      when No_Data_Found then
        v_Attached := 'N';
    end;
  
    v_Marks := Get_Marks(r_Schedule.Schedule_Id, v_Schedule_Year);
  
    if v_Marks_Used = 'N' and v_Marks.Count > 0 then
      v_Marks_Used := 'Y';
    end if;
  
    v_Weights := Get_Weights(r_Schedule.Schedule_Id, v_Schedule_Year);
  
    Result.Put('year', v_Schedule_Year);
    Result.Put('schedule_days', v_Days);
    Result.Put('pattern_kind', r_Schedule_Pattern.Schedule_Kind);
    Result.Put('all_days_equal', r_Schedule_Pattern.All_Days_Equal);
    Result.Put('begin_date',
               case when v_Schedule_Year = Extract(year from r_Schedule_Pattern.Begin_Date) then
               r_Schedule_Pattern.Begin_Date else null end);
    Result.Put('end_date',
               case when v_Schedule_Year = Extract(year from r_Schedule_Pattern.End_Date) then
               r_Schedule_Pattern.End_Date else null end);
    Result.Put('use_calendar', case when r_Schedule.Calendar_Id is null then 'N' else 'Y' end);
    Result.Put('is_attached', v_Attached);
    Result.Put('calendar_name',
               z_Htt_Calendars.Take(i_Company_Id => Ui.Company_Id, --
               i_Filial_Id => Ui.Filial_Id, --
               i_Calendar_Id => r_Schedule.Calendar_Id).Name);
    Result.Put('days', Get_Days(r_Schedule.Schedule_Id, v_Schedule_Year));
    Result.Put('marks', v_Marks);
    Result.Put('weights', v_Weights);
    Result.Put('advanced_settings',
               Advanced_Settings(r_Schedule,
                                 i_Marks_Used   => v_Marks_Used,
                                 i_Weights_Used => r_Schedule.Use_Weights));
    Result.Put('use_marks', v_Marks_Used);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fill_Patterns
  (
    o_Pattern in out nocopy Htt_Pref.Schedule_Pattern_Rt,
    i_Pattern Hashmap
  ) is
    v_Days    Arraylist := i_Pattern.r_Arraylist('days');
    v_Day     Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Marks   Arraylist;
    v_Mark    Hashmap;
    v_Weights Arraylist;
    v_Weight  Hashmap;
    v_Item    Hashmap;
  begin
    Htt_Util.Schedule_Pattern_New(o_Pattern        => o_Pattern,
                                  i_Pattern_Kind   => i_Pattern.r_Varchar2('pattern_kind'),
                                  i_All_Days_Equal => i_Pattern.r_Varchar2('all_days_equal'),
                                  i_Count_Days     => i_Pattern.r_Number('count_days'),
                                  i_Begin_Date     => i_Pattern.r_Date('begin_date'),
                                  i_End_Date       => i_Pattern.r_Date('end_date'));
  
    for i in 1 .. v_Days.Count
    loop
      v_Item := Treat(v_Days.r_Hashmap(i) as Hashmap);
    
      v_Marks   := v_Item.r_Arraylist('marks');
      v_Weights := v_Item.r_Arraylist('weights');
    
      Htt_Util.Schedule_Pattern_Day_New(o_Pattern_Day      => v_Day,
                                        i_Day_No           => v_Item.r_Number('day_no'),
                                        i_Day_Kind         => v_Item.r_Varchar2('day_kind'),
                                        i_Begin_Time       => v_Item.r_Number('begin_time'),
                                        i_End_Time         => v_Item.r_Number('end_time'),
                                        i_Break_Enabled    => v_Item.r_Varchar2('break_enabled'),
                                        i_Break_Begin_Time => v_Item.r_Number('break_begin_time'),
                                        i_Break_End_Time   => v_Item.r_Number('break_end_time'),
                                        i_Plan_Time        => v_Item.r_Number('plan_time'));
    
      for j in 1 .. v_Marks.Count
      loop
        v_Mark := Treat(v_Marks.r_Hashmap(j) as Hashmap);
      
        Htt_Util.Schedule_Marks_Add(o_Marks      => v_Day.Pattern_Marks,
                                    i_Begin_Time => v_Mark.r_Number('begin_time'),
                                    i_End_Time   => v_Mark.r_Number('end_time'));
      end loop;
    
      for j in 1 .. v_Weights.Count
      loop
        v_Weight := Treat(v_Weights.r_Hashmap(j) as Hashmap);
      
        Htt_Util.Schedule_Weights_Add(o_Weights    => v_Day.Pattern_Weights,
                                      i_Begin_Time => v_Weight.r_Number('begin_time'),
                                      i_End_Time   => v_Weight.r_Number('end_time'),
                                      i_Weight     => v_Weight.r_Number('weight'));
      end loop;
    
      Htt_Util.Schedule_Pattern_Day_Add(o_Schedule_Pattern => o_Pattern, i_Day => v_Day);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fill_Days
  (
    p_Schedule in out nocopy Htt_Pref.Schedule_Rt,
    i_Days     Arraylist
  ) is
    v_Day  Htt_Pref.Schedule_Day_Rt;
    v_Item Hashmap;
  begin
    for i in 1 .. i_Days.Count
    loop
      v_Item := Treat(i_Days.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Schedule_Day_New(o_Day              => v_Day,
                                i_Schedule_Date    => v_Item.r_Date('schedule_date'),
                                i_Day_Kind         => v_Item.r_Varchar2('day_kind'),
                                i_Begin_Time       => v_Item.r_Number('begin_time'),
                                i_End_Time         => v_Item.r_Number('end_time'),
                                i_Break_Enabled    => v_Item.r_Varchar2('break_enabled'),
                                i_Break_Begin_Time => v_Item.r_Number('break_begin_time'),
                                i_Break_End_Time   => v_Item.r_Number('break_end_time'),
                                i_Plan_Time        => v_Item.r_Number('plan_time'));
    
      Htt_Util.Schedule_Day_Add(o_Schedule => p_Schedule, i_Day => v_Day);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fill_Marks
  (
    p_Schedule  in out nocopy Htt_Pref.Schedule_Rt,
    i_Day_Marks Arraylist,
    i_Days      Arraylist
  ) is
    v_Day_Marks    Htt_Pref.Schedule_Day_Marks_Rt;
    v_Day          Hashmap;
    v_Schedule_Day Hashmap;
    v_Marks        Arraylist;
    v_Mark         Hashmap;
  begin
    for i in 1 .. i_Day_Marks.Count
    loop
      v_Day          := Treat(i_Day_Marks.r_Hashmap(i) as Hashmap);
      v_Schedule_Day := Treat(i_Days.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Schedule_Day_Marks_New(o_Schedule_Day_Marks => v_Day_Marks,
                                      i_Schedule_Date      => v_Day.r_Date('schedule_date'),
                                      i_Begin_Date         => v_Schedule_Day.r_Number('begin_time'),
                                      i_End_Date           => v_Schedule_Day.r_Number('end_time'));
    
      v_Marks := v_Day.r_Arraylist('marks');
    
      for j in 1 .. v_Marks.Count
      loop
        v_Mark := Treat(v_Marks.r_Hashmap(j) as Hashmap);
      
        Htt_Util.Schedule_Marks_Add(o_Marks      => v_Day_Marks.Marks,
                                    i_Begin_Time => v_Mark.r_Number('begin_time'),
                                    i_End_Time   => v_Mark.r_Number('end_time'));
      end loop;
    
      Htt_Util.Schedule_Day_Marks_Add(o_Schedule => p_Schedule, i_Day_Marks => v_Day_Marks);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fill_Weights
  (
    p_Schedule    in out nocopy Htt_Pref.Schedule_Rt,
    i_Day_Weights Arraylist,
    i_Days        Arraylist
  ) is
    v_Day_Weights  Htt_Pref.Schedule_Day_Weights_Rt;
    v_Day          Hashmap;
    v_Schedule_Day Hashmap;
    v_Weights      Arraylist;
    v_Weight       Hashmap;
  begin
    for i in 1 .. i_Day_Weights.Count
    loop
      v_Day          := Treat(i_Day_Weights.r_Hashmap(i) as Hashmap);
      v_Schedule_Day := Treat(i_Days.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Schedule_Day_Weights_New(o_Schedule_Day_Weights => v_Day_Weights,
                                        i_Schedule_Date        => v_Day.r_Date('schedule_date'),
                                        i_Begin_Date           => v_Schedule_Day.r_Number('begin_time'),
                                        i_End_Date             => v_Schedule_Day.r_Number('end_time'));
    
      v_Weights := v_Day.r_Arraylist('weights');
    
      for j in 1 .. v_Weights.Count
      loop
        v_Weight := Treat(v_Weights.r_Hashmap(j) as Hashmap);
      
        Htt_Util.Schedule_Weights_Add(o_Weights    => v_Day_Weights.Weights,
                                      i_Begin_Time => v_Weight.r_Number('begin_time'),
                                      i_End_Time   => v_Weight.r_Number('end_time'),
                                      i_Weight     => v_Weight.r_Number('weight'));
      end loop;
    
      Htt_Util.Schedule_Day_Weights_Add(o_Schedule => p_Schedule, i_Day_Weights => v_Day_Weights);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_By_Calendar_Limit(p Hashmap) return Hashmap is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Exceeded_Months Matrix_Varchar2 := Matrix_Varchar2();
    v_Exceeded_Days   Matrix_Varchar2 := Matrix_Varchar2();
    v_Nls_Language    varchar2(100) := Uit_Href.Get_Nls_Language;
  
    v_Plan_Time_Limit            number;
    v_Month_Order                number;
    v_Plan_Time                  number;
    v_Tomorrow_Day_Kind          varchar2(1);
    v_Tomorrow_Calendar_Day_Kind varchar2(1);
    v_Date                       date;
    v_Year_Begin                 date := p.r_Date('year_begin');
    v_Calendar_Id                number := p.o_Number('calendar_id');
    v_Days                       Arraylist := p.r_Arraylist('days');
    v_Day                        Hashmap;
    v_Monthly_Limits             Array_Number;
    v_Monthly_Working_Day        Array_Number := Array_Number(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    r_Calendar                   Htt_Calendars%rowtype;
    r_Week_Day                   Htt_Calendar_Week_Days%rowtype;
    result                       Hashmap := Hashmap();
  begin
    r_Calendar := z_Htt_Calendars.Take(i_Company_Id  => v_Company_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Calendar_Id => v_Calendar_Id);
  
    for i in 1 .. v_Days.Count
    loop
      v_Day                        := Treat(v_Days.r_Hashmap(i) as Hashmap);
      v_Date                       := v_Day.r_Date('schedule_date');
      v_Plan_Time                  := v_Day.r_Number('plan_time');
      v_Tomorrow_Day_Kind          := v_Day.o_Varchar2('tomorrow_day_kind');
      v_Tomorrow_Calendar_Day_Kind := v_Day.o_Varchar2('tomorrow_calendar_day_kind');
    
      if Nvl(v_Day.o_Varchar2('calendar_day_kind'), v_Day.r_Varchar2('day_kind')) in
         (Htt_Pref.c_Day_Kind_Work, Htt_Pref.c_Day_Kind_Nonworking) and v_Plan_Time > 0 then
        v_Month_Order := to_char(v_Date, 'mm');
      
        v_Monthly_Working_Day(v_Month_Order) := v_Monthly_Working_Day(v_Month_Order) + 1;
      
        if r_Calendar.Daily_Limit = 'Y' then
          r_Week_Day := z_Htt_Calendar_Week_Days.Take(i_Company_Id  => r_Calendar.Company_Id,
                                                      i_Filial_Id   => r_Calendar.Filial_Id,
                                                      i_Calendar_Id => r_Calendar.Calendar_Id,
                                                      i_Order_No    => Htt_Util.Iso_Week_Day_No(v_Date));
        
          v_Plan_Time_Limit := r_Week_Day.Plan_Time;
        
          if Htt_Pref.c_Day_Kind_Holiday in (v_Tomorrow_Day_Kind, v_Tomorrow_Calendar_Day_Kind) then
            v_Plan_Time_Limit := Greatest(0, v_Plan_Time_Limit - r_Week_Day.Preholiday_Time);
          end if;
        
          if Htt_Pref.c_Day_Kind_Rest in (v_Tomorrow_Day_Kind, v_Tomorrow_Calendar_Day_Kind) or --
             Htt_Pref.c_Day_Kind_Additional_Rest in
             (v_Tomorrow_Day_Kind, v_Tomorrow_Calendar_Day_Kind) then
            v_Plan_Time_Limit := Greatest(0, v_Plan_Time_Limit - r_Week_Day.Preweekend_Time);
          end if;
        
          if v_Plan_Time > v_Plan_Time_Limit then
            Fazo.Push(v_Exceeded_Days, Array_Varchar2(v_Date, v_Plan_Time, v_Plan_Time_Limit));
          end if;
        end if;
      end if;
    end loop;
  
    Result.Put('exceeded_days', Fazo.Zip_Matrix(v_Exceeded_Days));
  
    v_Monthly_Limits := Htt_Util.Calendar_Monthly_Limit(i_Company_Id  => v_Company_Id,
                                                        i_Filial_Id   => v_Filial_Id,
                                                        i_Calendar_Id => v_Calendar_Id,
                                                        i_Year_Begin  => v_Year_Begin);
  
    if r_Calendar.Monthly_Limit = 'Y' then
      for i in 1 .. 12
      loop
        v_Date := Add_Months(v_Year_Begin, i - 1);
      
        if v_Monthly_Working_Day(i) <> v_Monthly_Limits(i) then
          Fazo.Push(v_Exceeded_Months,
                    Array_Varchar2(to_char(v_Date, 'Month', v_Nls_Language),
                                   v_Monthly_Working_Day(i),
                                   v_Monthly_Limits(i)));
        end if;
      end loop;
    end if;
  
    Result.Put('exceeded_months', Fazo.Zip_Matrix(v_Exceeded_Months));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Schedule_Id number,
    p             Hashmap
  ) return Hashmap is
    v_Schedule      Htt_Pref.Schedule_Rt;
    v_Pattern       Htt_Pref.Schedule_Pattern_Rt;
    v_Days          Arraylist := p.r_Arraylist('days');
    v_Schedule_Kind varchar2(1) := p.r_Varchar2('schedule_kind');
  begin
    Htt_Util.Schedule_New(o_Schedule                  => v_Schedule,
                          i_Company_Id                => Ui.Company_Id,
                          i_Filial_Id                 => Ui.Filial_Id,
                          i_Schedule_Id               => i_Schedule_Id,
                          i_Name                      => p.r_Varchar2('name'),
                          i_Shift                     => p.o_Number('shift'),
                          i_Schedule_Kind             => v_Schedule_Kind,
                          i_Input_Acceptance          => p.o_Number('input_acceptance'),
                          i_Output_Acceptance         => p.o_Number('output_acceptance'),
                          i_Count_Late                => Nvl(p.o_Varchar2('count_late'), 'Y'),
                          i_Count_Early               => Nvl(p.o_Varchar2('count_early'), 'Y'),
                          i_Count_Lack                => Nvl(p.o_Varchar2('count_lack'), 'Y'),
                          i_Count_Free                => Nvl(p.o_Varchar2('count_free'), 'Y'),
                          i_Use_Weights               => Nvl(p.o_Varchar2('use_weights'), 'N'),
                          i_Gps_Turnout_Enabled       => Nvl(p.o_Varchar2('gps_turnout_enabled'),
                                                             'N'),
                          i_Gps_Use_Location          => Nvl(p.o_Varchar2('gps_use_location'), 'N'),
                          i_Gps_Max_Interval          => p.o_Number('gps_max_interval'),
                          i_Allowed_Late_Time         => Nvl(p.o_Number('allowed_late_time'), 0),
                          i_Allowed_Early_Time        => Nvl(p.o_Number('allowed_early_time'), 0),
                          i_Begin_Late_Time           => Nvl(p.o_Number('begin_late_time'), 0),
                          i_End_Early_Time            => Nvl(p.o_Number('end_early_time'), 0),
                          i_Track_Duration            => p.o_Number('track_duration'),
                          i_Calendar_Id               => p.o_Number('calendar_id'),
                          i_Take_Holidays             => p.o_Varchar2('take_holidays'),
                          i_Take_Nonworking           => p.o_Varchar2('take_nonworking'),
                          i_Take_Additional_Rest_Days => p.r_Varchar2('take_additional_rest_days'),
                          i_State                     => p.r_Varchar2('state'),
                          i_Code                      => p.o_Varchar2('code'),
                          i_Year                      => p.r_Number('year'));
  
    Fill_Days(v_Schedule, v_Days);
    Fill_Marks(v_Schedule, p.r_Arraylist('marks'), v_Days);
    Fill_Weights(v_Schedule, p.r_Arraylist('weights'), v_Days);
    Fill_Patterns(v_Pattern, p.r_Hashmap('pattern'));
  
    v_Schedule.Pattern := v_Pattern;
  
    Htt_Api.Schedule_Save(v_Schedule);
  
    return Fazo.Zip_Map('schedule_id', i_Schedule_Id, 'name', v_Schedule.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Htt_Next.Schedule_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Schedule Htt_Schedules%rowtype;
  begin
    r_Schedule := z_Htt_Schedules.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                            i_Filial_Id   => Ui.Filial_Id,
                                            i_Schedule_Id => p.r_Number('schedule_id'));
  
    return save(r_Schedule.Schedule_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Calendars
       set Company_Id  = null,
           Filial_Id   = null,
           Calendar_Id = null,
           name        = null;
  end;

end Ui_Vhr31;
/
