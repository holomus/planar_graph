create or replace package Ui_Vhr456 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Changes(p Hashmap) return Json_Object_t;
  ----------------------------------------------------------------------------------------------------
  Function Create_Change(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------       
  Procedure Update_Change(p Hashmap);
  ----------------------------------------------------------------------------------------------------       
  Procedure Delete_Change(p Hashmap);
end Ui_Vhr456;
/
create or replace package body Ui_Vhr456 is
  ----------------------------------------------------------------------------------------------------  
  Function List_Changes(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Change_Ids  Array_Number := Nvl(p.o_Array_Number('change_ids'), Array_Number());
    v_Count       number := v_Change_Ids.Count;
    v_Change_Days Glist;
    v_Change_Day  Gmap;
    v_Change      Gmap;
    v_Changes     Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Htt_Plan_Changes q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Change_Id member of v_Change_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Change := Gmap();
    
      v_Change.Put('change_id', r.Change_Id);
      v_Change.Put('staff_id', r.Staff_Id);
      v_Change.Put('change_kind', r.Change_Kind);
      v_Change.Put('manager_note', r.Manager_Note);
      v_Change.Put('note', r.Note);
      v_Change.Put('status', r.Status);
      v_Change.Put('created_on', r.Created_On);
    
      v_Change_Days := Glist();
    
      for d in (select *
                  from Htt_Change_Days c
                 where c.Company_Id = r.Company_Id
                   and c.Filial_Id = r.Filial_Id
                   and c.Change_Id = r.Change_Id)
      loop
        v_Change_Day := Gmap();
      
        v_Change_Day.Put('change_date', d.Change_Date);
        v_Change_Day.Put('swapped_date', d.Swapped_Date);
        v_Change_Day.Put('day_kind', d.Day_Kind);
        v_Change_Day.Put('begin_time', d.Begin_Time);
        v_Change_Day.Put('end_time', d.End_Time);
        v_Change_Day.Put('break_enabled', d.Break_Enabled);
        v_Change_Day.Put('break_begin_time', d.Break_Begin_Time);
        v_Change_Day.Put('break_end_time', d.Break_End_Time);
        v_Change_Day.Put('plan_time', Round(d.Plan_Time / 60));
      
        v_Change_Days.Push(v_Change_Day.Val);
      end loop;
    
      v_Change.Put('change_days', v_Change_Days);
    
      v_Last_Id := r.Modified_Id;
    
      v_Changes.Push(v_Change.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Changes, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p           Hashmap,
    i_Change_Id number
  ) is
    v_Item        Hashmap;
    v_Items       Arraylist := p.r_Arraylist('change_dates');
    v_Change      Htt_Pref.Change_Rt;
    v_Changed_Day Htt_Pref.Change_Day_Rt;
  
    --------------------------------------------------
    Procedure Swap_Days
    (
      p_Change       in out nocopy Htt_Pref.Change_Rt,
      i_Changed_Date date,
      i_Swapped_Date date
    ) is
      v_Days Htt_Pref.Change_Day_Nt;
    
      v_Day           Htt_Pref.Change_Day_Rt;
      v_Changed_Day   Htt_Pref.Change_Day_Rt := Htt_Pref.Change_Day_Rt();
      v_Swapped_Day   Htt_Pref.Change_Day_Rt := Htt_Pref.Change_Day_Rt();
      v_Swap_Distance number;
    begin
      select t.Timesheet_Date,
             null,
             t.Day_Kind,
             t.Begin_Time,
             t.End_Time,
             t.Break_Enabled,
             t.Break_Begin_Time,
             t.Break_End_Time,
             t.Plan_Time
        bulk collect
        into v_Days
        from Htt_Timesheets t
       where t.Company_Id = p_Change.Company_Id
         and t.Filial_Id = p_Change.Filial_Id
         and t.Staff_Id = p_Change.Staff_Id
         and t.Timesheet_Date in (i_Changed_Date, i_Swapped_Date);
    
      if v_Days.Count = 2 then
        v_Changed_Day := v_Days(1);
        v_Swapped_Day := v_Days(2);
      else
        v_Changed_Day.Change_Date := i_Changed_Date;
        v_Swapped_Day.Change_Date := i_Swapped_Date;
      
        if v_Days.Count = 1 then
          if v_Changed_Day.Change_Date = v_Days(1).Change_Date then
            v_Changed_Day := v_Days(1);
          else
            v_Swapped_Day := v_Days(1);
          end if;
        end if;
      end if;
    
      v_Swap_Distance := v_Swapped_Day.Change_Date - v_Changed_Day.Change_Date;
    
      v_Day := v_Swapped_Day;
    
      v_Swapped_Day                  := v_Changed_Day;
      v_Swapped_Day.Change_Date      := v_Day.Change_Date;
      v_Swapped_Day.Swapped_Date     := v_Changed_Day.Change_Date;
      v_Swapped_Day.Begin_Time       := v_Swapped_Day.Begin_Time + v_Swap_Distance;
      v_Swapped_Day.End_Time         := v_Swapped_Day.End_Time + v_Swap_Distance;
      v_Swapped_Day.Break_Begin_Time := v_Swapped_Day.Break_Begin_Time + v_Swap_Distance;
      v_Swapped_Day.Break_End_Time   := v_Swapped_Day.Break_End_Time + v_Swap_Distance;
    
      v_Changed_Day                  := v_Day;
      v_Changed_Day.Change_Date      := v_Swapped_Day.Swapped_Date;
      v_Changed_Day.Swapped_Date     := v_Swapped_Day.Change_Date;
      v_Changed_Day.Begin_Time       := v_Changed_Day.Begin_Time - v_Swap_Distance;
      v_Changed_Day.End_Time         := v_Changed_Day.End_Time - v_Swap_Distance;
      v_Changed_Day.Break_Begin_Time := v_Changed_Day.Break_Begin_Time - v_Swap_Distance;
      v_Changed_Day.Break_End_Time   := v_Changed_Day.Break_End_Time - v_Swap_Distance;
    
      p_Change.Change_Days := Htt_Pref.Change_Day_Nt(v_Changed_Day, v_Swapped_Day);
    end;
  begin
    Htt_Util.Change_New(o_Change      => v_Change,
                        i_Company_Id  => Ui.Company_Id,
                        i_Filial_Id   => Ui.Filial_Id,
                        i_Change_Id   => i_Change_Id,
                        i_Staff_Id    => p.r_Number('staff_id'),
                        i_Change_Kind => p.r_Varchar2('change_kind'),
                        i_Note        => p.o_Varchar2('note'));
  
    for i in 1 .. v_Items.Count
    loop
      v_Item := Treat(v_Items.r_Hashmap(i) as Hashmap);
    
      v_Changed_Day.Day_Kind         := v_Item.o_Varchar2('day_kind');
      v_Changed_Day.Begin_Time       := v_Item.o_Date('begin_time');
      v_Changed_Day.End_Time         := v_Item.o_Date('end_time');
      v_Changed_Day.Break_Enabled    := v_Item.o_Varchar2('break_enabled');
      v_Changed_Day.Break_Begin_Time := v_Item.o_Date('break_begin_time');
      v_Changed_Day.Break_End_Time   := v_Item.o_Date('break_end_time');
      v_Changed_Day.Plan_Time        := v_Item.o_Number('plan_time');
    
      Htt_Util.Change_Day_Add(o_Change           => v_Change,
                              i_Change_Date      => v_Item.r_Date('change_date'),
                              i_Swapped_Date     => v_Item.o_Date('swapped_date'),
                              i_Begin_Time       => v_Changed_Day.Begin_Time,
                              i_End_Time         => v_Changed_Day.End_Time,
                              i_Day_Kind         => v_Changed_Day.Day_Kind,
                              i_Break_Enabled    => v_Changed_Day.Break_Enabled,
                              i_Break_Begin_Time => v_Changed_Day.Break_Begin_Time,
                              i_Break_End_Time   => v_Changed_Day.Break_End_Time,
                              i_Plan_Time        => v_Changed_Day.Plan_Time * 60);
    end loop;
  
    if v_Change.Change_Kind = Htt_Pref.c_Change_Kind_Swap then
      Swap_Days(v_Change, --
                v_Change.Change_Days(1).Change_Date,
                v_Change.Change_Days(2).Change_Date);
    end if;
  
    Htt_Api.Change_Save(v_Change);
  
    -- maybe status should be based on input 
    Htt_Api.Change_Complete(i_Company_Id => Ui.Company_Id,
                            i_Filial_Id  => Ui.Filial_Id,
                            i_Change_Id  => i_Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Change(p Hashmap) return Hashmap is
    v_Change_Id number := Htt_Next.Change_Id;
  begin
    save(p, v_Change_Id);
  
    return Fazo.Zip_Map('change_id', v_Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Update_Change(p Hashmap) is
    r_Plan_Change Htt_Plan_Changes%rowtype;
  begin
    r_Plan_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                  i_Filial_Id  => Ui.Filial_Id,
                                                  i_Change_Id  => p.r_Number('change_id'));
  
    if r_Plan_Change.Status <> Htt_Pref.c_Change_Status_New then
      Htt_Api.Change_Reset(i_Company_Id => r_Plan_Change.Company_Id,
                           i_Filial_Id  => r_Plan_Change.Filial_Id,
                           i_Change_Id  => r_Plan_Change.Change_Id);
    end if;
  
    save(p, r_Plan_Change.Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Delete_Change(p Hashmap) is
    r_Plan_Change Htt_Plan_Changes%rowtype;
  begin
    r_Plan_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                                  i_Filial_Id  => Ui.Filial_Id,
                                                  i_Change_Id  => p.r_Number('change_id'));
  
    if r_Plan_Change.Status <> Htt_Pref.c_Change_Status_New then
      Htt_Api.Change_Reset(i_Company_Id => r_Plan_Change.Company_Id,
                           i_Filial_Id  => r_Plan_Change.Filial_Id,
                           i_Change_Id  => r_Plan_Change.Change_Id);
    end if;
  
    Htt_Api.Change_Delete(i_Company_Id => r_Plan_Change.Company_Id,
                          i_Filial_Id  => r_Plan_Change.Filial_Id,
                          i_Change_Id  => r_Plan_Change.Change_Id);
  end;

end Ui_Vhr456;
/
