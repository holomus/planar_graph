create or replace package Ui_Vhr461 is
  ----------------------------------------------------------------------------------------------------
  Function List_Calendar(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Calendar(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Calendar(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Calendar(p Hashmap);
end Ui_Vhr461;
/
create or replace package body Ui_Vhr461 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Calendar(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Calendar_Ids Array_Number := Nvl(p.o_Array_Number('calendar_ids'), Array_Number());
    v_Year         number := p.o_Number('year');
    v_Count        number := v_Calendar_Ids.Count;
    v_Rest_Days    Array_Number;
    v_Day          Gmap;
    v_Days         Glist;
    v_Calendar     Gmap;
    v_Calendars    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Htt_Calendars q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Calendar_Id member of v_Calendar_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Calendar := Gmap();
      v_Days     := Glist();
    
      v_Calendar.Put('calendar_id', r.Calendar_Id);
      v_Calendar.Put('name', r.Name);
      v_Calendar.Put('code', r.Code);
    
      for j in (select *
                  from Htt_Calendar_Days w
                 where w.Company_Id = r.Company_Id
                   and w.Filial_Id = r.Filial_Id
                   and w.Calendar_Id = r.Calendar_Id
                   and (v_Year is null or v_Year = Extract(year from w.Calendar_Date)))
      loop
        v_Day := Gmap();
      
        v_Day.Put('calendar_date', j.Calendar_Date);
        v_Day.Put('name', j.Name);
        v_Day.Put('day_kind', j.Day_Kind);
        v_Day.Put('swapped_date', j.Swapped_Date);
      
        v_Days.Push(v_Day.Val);
      end loop;
    
      v_Calendar.Put('calendar_days', v_Days);
    
      select d.Week_Day_No
        bulk collect
        into v_Rest_Days
        from Htt_Calendar_Rest_Days d
       where d.Company_Id = r.Company_Id
         and d.Filial_Id = r.Filial_Id
         and d.Calendar_Id = r.Calendar_Id;
    
      v_Calendar.Put('rest_days', v_Rest_Days);
    
      v_Last_Id := r.Modified_Id;
    
      v_Calendars.Push(v_Calendar.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Calendars, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure save
  (
    p          Hashmap,
    i_Calendar Htt_Calendars%rowtype
  ) is
    v_Calendar_Days Arraylist := Nvl(p.o_Arraylist('calendar_days'), Arraylist());
    v_Calendar_Day  Hashmap;
    p_Calendar      Htt_Pref.Calendar_Rt;
  begin
    Htt_Util.Calendar_New(o_Calendar      => p_Calendar,
                          i_Company_Id    => i_Calendar.Company_Id,
                          i_Filial_Id     => i_Calendar.Filial_Id,
                          i_Calendar_Id   => i_Calendar.Calendar_Id,
                          i_Name          => p.r_Varchar2('name'),
                          i_Code          => p.o_Varchar2('code'),
                          i_Year          => p.r_Number('year'),
                          i_Monthly_Limit => Nvl(i_Calendar.Monthly_Limit, 'N'),
                          i_Daily_Limit   => Nvl(i_Calendar.Daily_Limit, 'N'),
                          i_Rest_Day      => p.o_Array_Number('week_day_numbers'));
  
    for i in 1 .. v_Calendar_Days.Count
    loop
      v_Calendar_Day := Treat(v_Calendar_Days.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Calendar_Add_Day(o_Calendar      => p_Calendar,
                                i_Calendar_Date => v_Calendar_Day.r_Date('calendar_date'),
                                i_Name          => v_Calendar_Day.r_Varchar2('name'),
                                i_Day_Kind      => v_Calendar_Day.r_Varchar2('day_kind'),
                                i_Swapped_Date  => v_Calendar_Day.o_Date('swapped_date'));
    end loop;
  
    Htt_Api.Calendar_Save(p_Calendar);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Calendar(p Hashmap) return Hashmap is
    v_Calendar_Id number := Htt_Next.Calendar_Id;
    r_Calendar    Htt_Calendars%rowtype;
  begin
    r_Calendar.Company_Id  := Ui.Company_Id;
    r_Calendar.Filial_Id   := Ui.Filial_Id;
    r_Calendar.Calendar_Id := v_Calendar_Id;
  
    save(p, r_Calendar);
  
    return Fazo.Zip_Map('calendar_id', v_Calendar_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Update_Calendar(p Hashmap) is
    r_Calendar Htt_Calendars%rowtype;
  begin
    r_Calendar := z_Htt_Calendars.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                            i_Filial_Id   => Ui.Filial_Id,
                                            i_Calendar_Id => p.r_Number('calendar_id'));
  
    save(p, r_Calendar);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Delete_Calendar(p Hashmap) is
  begin
    Htt_Api.Calendar_Delete(i_Company_Id  => Ui.Company_Id,
                            i_Filial_Id   => Ui.Filial_Id,
                            i_Calendar_Id => p.r_Number('calendar_id'));
  end;

end Ui_Vhr461;
/
