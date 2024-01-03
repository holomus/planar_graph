create or replace package Ui_Vhr166 is
  ----------------------------------------------------------------------------------------------------  
  Function Load_Dates(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Calculate_Monthly_Details(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr166;
/
create or replace package body Ui_Vhr166 is
  ----------------------------------------------------------------------------------------------------
  Function Get_Dates
  (
    i_Calendar_Id number,
    i_Year        number
  ) return Arraylist is
    result Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Calendar_Date,
                          q.Name,
                          q.Day_Kind,
                          Htt_Util.t_Day_Kind(q.Day_Kind),
                          q.Swapped_Date)
      bulk collect
      into result
      from Htt_Calendar_Days q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Calendar_Id = i_Calendar_Id
       and i_Year = Extract(year from q.Calendar_Date);
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Dates(p Hashmap) return Arraylist is
  begin
    return Get_Dates(i_Calendar_Id => p.r_Number('calendar_id'), --
                     i_Year        => p.r_Number('year'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('dt_swapped', Htt_Pref.c_Day_Kind_Swapped);
  
    Result.Put('day_kinds', Fazo.Zip_Matrix_Transposed(Htt_Util.Calendar_Day_Kinds));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('year',
                            Extract(year from sysdate),
                            'monthly_limit',
                            'N',
                            'daily_limit',
                            'N'));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Calculate_Monthly_Details(p Hashmap) return Hashmap is
    v_Calendar_Day        Hashmap;
    v_Calendar_Date       date;
    v_Date                date;
    v_Date_No             number;
    v_Month               date;
    v_Preholiday_Time     number := Nvl(p.o_Number('preholiday_hour'), 0);
    v_Preweekend_Time     number := Nvl(p.o_Number('preweekend_hour'), 0);
    v_Plan_Time           number := Nvl(p.o_Number('plan_time'), 0);
    v_Daily_Plan_Time     number;
    v_Holiday_Dates       Array_Date := Array_Date();
    v_Nonworking_Dates    Array_Date := Array_Date();
    v_Additional_Rest_Day Array_Date := Array_Date();
    v_End_Date            date := p.r_Date('end_date');
    v_Begin_Date          date := p.r_Date('begin_date');
    v_Calendar_Days       Arraylist := p.r_Arraylist('calendar_days');
    v_Rest_Week_Day_No    Array_Number := p.r_Array_Number('rest_week_day_no');
    v_Day_Kind            varchar2(1);
    v_Calc                Calc := Calc();
    v_Matrix              Matrix_Varchar2 := Matrix_Varchar2();
    result                Hashmap := Hashmap();
  begin
    for i in 1 .. v_Calendar_Days.Count
    loop
      v_Calendar_Day  := Treat(v_Calendar_Days.r_Hashmap(i) as Hashmap);
      v_Day_Kind      := v_Calendar_Day.r_Varchar2('day_kind');
      v_Calendar_Date := v_Calendar_Day.r_Date('calendar_date');
    
      if v_Day_Kind = Htt_Pref.c_Day_Kind_Holiday then
        v_Holiday_Dates.Extend();
        v_Holiday_Dates(v_Holiday_Dates.Count) := v_Calendar_Date;
      elsif v_Day_Kind = Htt_Pref.c_Day_Kind_Nonworking then
        v_Nonworking_Dates.Extend();
        v_Nonworking_Dates(v_Nonworking_Dates.Count) := v_Calendar_Date;
      elsif v_Day_Kind = Htt_Pref.c_Day_Kind_Additional_Rest then
        v_Additional_Rest_Day.Extend();
        v_Additional_Rest_Day(v_Additional_Rest_Day.Count) := v_Calendar_Date;
      end if;
    end loop;
  
    for i in 1 .. v_End_Date - v_Begin_Date + 1
    loop
      v_Date    := v_Begin_Date + i - 1;
      v_Date_No := Htt_Util.Iso_Week_Day_No(v_Date);
      v_Month   := Trunc(v_Date, 'mon');
    
      v_Daily_Plan_Time := v_Plan_Time;
    
      if v_Date_No member of v_Rest_Week_Day_No or v_Date member of v_Holiday_Dates or v_Date
       member of v_Nonworking_Dates or v_Date member of v_Additional_Rest_Day then
        v_Daily_Plan_Time := 0;
      end if;
    
      if v_Date + 1 member of v_Holiday_Dates then
        v_Daily_Plan_Time := Greatest(0, v_Daily_Plan_Time - v_Preholiday_Time);
      end if;
    
      if Htt_Util.Iso_Week_Day_No(v_Date + 1) member of v_Rest_Week_Day_No or --
         (v_Date + 1) member of v_Additional_Rest_Day then
        v_Daily_Plan_Time := Greatest(0, v_Daily_Plan_Time - v_Preweekend_Time);
      end if;
    
      v_Calc.Plus(v_Month, 'plan_time', v_Daily_Plan_Time);
    
      if v_Daily_Plan_Time > 0 then
        v_Calc.Plus(v_Month, 'day', 1);
      end if;
    end loop;
  
    for i in 0 .. 11
    loop
      v_Date := Add_Months(v_Begin_Date, i);
      v_Matrix.Extend();
      v_Matrix(v_Matrix.Count) := Array_Varchar2(v_Date,
                                                 v_Calc.Get_Value(v_Date, 'day'),
                                                 Round(v_Calc.Get_Value(v_Date, 'plan_time') / 60, 1));
    end loop;
  
    Result.Put('monthly_details', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Calendar Htt_Calendars%rowtype;
    r_Week_Day Htt_Calendar_Week_Days%rowtype;
    v_Array    Array_Number;
    v_Year     number := Nvl(p.o_Number('year'), Extract(year from sysdate));
    v_Data     Hashmap;
    result     Hashmap := Hashmap();
  
    --------------------------------------------------
    Function Get_First_Order_Of_Weekday return number is
      v_First_Order_Number number;
      v_Rest_Days          Array_Number;
    begin
      v_Rest_Days := Htt_Util.Calendar_Rest_Days(i_Company_Id  => r_Calendar.Company_Id,
                                                 i_Filial_Id   => r_Calendar.Filial_Id,
                                                 i_Calendar_Id => r_Calendar.Calendar_Id);
    
      select q.Order_No
        into v_First_Order_Number
        from Htt_Calendar_Week_Days q
       where q.Company_Id = r_Calendar.Company_Id
         and q.Filial_Id = r_Calendar.Filial_Id
         and q.Calendar_Id = r_Calendar.Calendar_Id
         and q.Order_No not member of v_Rest_Days
         and Rownum = 1;
    
      return v_First_Order_Number;
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    r_Calendar := z_Htt_Calendars.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Calendar_Id => p.r_Number('calendar_id'));
  
    v_Data := z_Htt_Calendars.To_Map(r_Calendar,
                                     z.Calendar_Id,
                                     z.Name,
                                     z.Code,
                                     z.Monthly_Limit,
                                     z.Daily_Limit);
  
    r_Week_Day := z_Htt_Calendar_Week_Days.Take(i_Company_Id  => r_Calendar.Company_Id,
                                                i_Filial_Id   => r_Calendar.Filial_Id,
                                                i_Calendar_Id => r_Calendar.Calendar_Id,
                                                i_Order_No    => Get_First_Order_Of_Weekday);
  
    v_Data.Put('preholiday_hour', r_Week_Day.Preholiday_Time);
    v_Data.Put('preweekend_hour', r_Week_Day.Preweekend_Time);
    v_Data.Put('plan_time', r_Week_Day.Plan_Time);
  
    select q.Week_Day_No
      bulk collect
      into v_Array
      from Htt_Calendar_Rest_Days q
     where q.Company_Id = r_Calendar.Company_Id
       and q.Filial_Id = r_Calendar.Filial_Id
       and q.Calendar_Id = r_Calendar.Calendar_Id
     order by q.Week_Day_No;
  
    v_Data.Put('year', v_Year);
    v_Data.Put('rest_days', v_Array);
    v_Data.Put('days',
               Get_Dates(i_Calendar_Id => r_Calendar.Calendar_Id, --
                         i_Year        => v_Year));
  
    Result.Put('data', v_Data);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Calendar_Id number,
    p             Hashmap
  ) return Hashmap is
    v_Calendar        Htt_Pref.Calendar_Rt;
    v_Days            Arraylist;
    v_Day             Hashmap;
    v_Preholiday_Hour number := Nvl(p.o_Number('preholiday_hour'), 0);
    v_Preweekend_Hour number := Nvl(p.o_Number('preweekend_hour'), 0);
    v_Plan_Time       number := Nvl(p.o_Number('plan_time'), 0);
  begin
    Htt_Util.Calendar_New(o_Calendar      => v_Calendar,
                          i_Company_Id    => Ui.Company_Id,
                          i_Filial_Id     => Ui.Filial_Id,
                          i_Calendar_Id   => i_Calendar_Id,
                          i_Name          => p.r_Varchar2('name'),
                          i_Code          => p.o_Varchar2('code'),
                          i_Year          => p.r_Number('year'),
                          i_Monthly_Limit => p.r_Varchar2('monthly_limit'),
                          i_Daily_Limit   => p.r_Varchar2('daily_limit'),
                          i_Rest_Day      => p.r_Array_Number('rest_days'));
  
    v_Days := p.r_Arraylist('days');
  
    for i in 1 .. v_Days.Count
    loop
      v_Day := Treat(v_Days.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Calendar_Add_Day(o_Calendar      => v_Calendar,
                                i_Calendar_Date => v_Day.r_Date('calendar_date'),
                                i_Name          => v_Day.r_Varchar2('name'),
                                i_Day_Kind      => v_Day.r_Varchar2('day_kind'),
                                i_Swapped_Date  => v_Day.o_Date('swapped_date'));
    end loop;
  
    for i in 1 .. 7
    loop
      Htt_Util.Calendar_Add_Week_Day(o_Calendar        => v_Calendar,
                                     i_Order_No        => i,
                                     i_Plan_Time       => v_Plan_Time,
                                     i_Preholiday_Hour => v_Preholiday_Hour,
                                     i_Preweekend_Hour => v_Preweekend_Hour);
    end loop;
  
    Htt_Api.Calendar_Save(v_Calendar);
  
    return Fazo.Zip_Map('calendar_id', v_Calendar.Calendar_Id, 'name', v_Calendar.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Htt_Next.Calendar_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Calendar_Id number := p.r_Number('calendar_id');
  begin
    z_Htt_Calendars.Lock_Only(i_Company_Id  => Ui.Company_Id,
                              i_Filial_Id   => Ui.Filial_Id,
                              i_Calendar_Id => v_Calendar_Id);
  
    return save(v_Calendar_Id, p);
  end;

end Ui_Vhr166;
/
