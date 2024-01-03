create or replace package Ui_Vhr339 is
  ---------------------------------------------------------------------------------------------------- 
  Function List_Schedules(p Hashmap) return Json_Object_t;
  ---------------------------------------------------------------------------------------------------- 
  Function Create_Schedule(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Schedule(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Schedule(p Hashmap);
end Ui_Vhr339;
/
create or replace package body Ui_Vhr339 is
  ---------------------------------------------------------------------------------------------------- 
  Function List_Schedules(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Schedule_Ids Array_Number := Nvl(p.o_Array_Number('schedule_ids'), Array_Number());
    v_Count        number := v_Schedule_Ids.Count;
    v_Schedule     Gmap;
    v_Schedules    Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id => v_Start_Id, --
                                o_Limit    => v_Limit);
  
    for r in (select *
                from (select *
                        from Htt_Schedules q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Count = 0 or --
                             q.Schedule_Id member of v_Schedule_Ids)) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Schedule := Gmap();
    
      v_Schedule.Put('name', r.Name);
      v_Schedule.Put('schedule_id', r.Schedule_Id);
      v_Schedule.Put('code', r.Code);
      v_Schedule.Put('state', r.State);
    
      v_Last_Id := r.Modified_Id;
    
      v_Schedules.Push(v_Schedule.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Schedules, --
                                       i_Modified_Id => v_Last_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    p          Hashmap,
    i_Schedule Htt_Schedules%rowtype
  ) is
    v_Schedule Htt_Pref.Schedule_Rt;
    v_Day      Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Day_Kind varchar2(1) := 'W';
    r_Schedule Htt_Schedules%rowtype := i_Schedule;
  begin
    Htt_Util.Schedule_New(o_Schedule                  => v_Schedule,
                          i_Company_Id                => r_Schedule.Company_Id,
                          i_Filial_Id                 => r_Schedule.Filial_Id,
                          i_Schedule_Id               => r_Schedule.Schedule_Id,
                          i_Name                      => p.r_Varchar2('name'),
                          i_Shift                     => r_Schedule.Shift,
                          i_Input_Acceptance          => r_Schedule.Input_Acceptance,
                          i_Output_Acceptance         => r_Schedule.Output_Acceptance,
                          i_Count_Late                => Nvl(r_Schedule.Count_Late, 'Y'),
                          i_Count_Early               => Nvl(r_Schedule.Count_Early, 'Y'),
                          i_Count_Lack                => Nvl(r_Schedule.Count_Lack, 'Y'),
                          i_Count_Free                => Nvl(r_Schedule.Count_Free, 'Y'),
                          i_Gps_Turnout_Enabled       => Nvl(r_Schedule.Gps_Turnout_Enabled, 'N'),
                          i_Gps_Use_Location          => Nvl(r_Schedule.Gps_Use_Location, 'N'),
                          i_Gps_Max_Interval          => r_Schedule.Gps_Max_Interval,
                          i_Track_Duration            => r_Schedule.Track_Duration,
                          i_Calendar_Id               => r_Schedule.Calendar_Id,
                          i_Take_Holidays             => Nvl(r_Schedule.Take_Holidays, 'Y'),
                          i_Take_Nonworking           => Nvl(r_Schedule.Take_Nonworking, 'Y'),
                          i_Take_Additional_Rest_Days => Nvl(r_Schedule.Take_Additional_Rest_Days,
                                                             'Y'),
                          i_Allowed_Late_Time         => Nvl(r_Schedule.Allowed_Late_Time, 0),
                          i_Allowed_Early_Time        => Nvl(r_Schedule.Allowed_Early_Time, 0),
                          i_Begin_Late_Time           => Nvl(r_Schedule.Begin_Late_Time, 0),
                          i_End_Early_Time            => Nvl(r_Schedule.End_Early_Time, 0),
                          i_Use_Weights               => Nvl(r_Schedule.Use_Weights, 'N'),
                          i_State                     => Nvl(r_Schedule.State, 'A'),
                          i_Code                      => p.o_Varchar2('code'),
                          i_Year                      => Extract(year from sysdate));
  
    Htt_Util.Schedule_Pattern_New(o_Pattern        => v_Schedule.Pattern,
                                  i_Pattern_Kind   => Htt_Pref.c_Pattern_Kind_Weekly,
                                  i_All_Days_Equal => 'Y',
                                  i_Count_Days     => 7,
                                  i_Begin_Date     => null,
                                  i_End_Date       => null);
    for i in 1 .. 7
    loop
      if i > 5 then
        v_Day_Kind := 'R';
      end if;
    
      Htt_Util.Schedule_Pattern_Day_New(o_Pattern_Day      => v_Day,
                                        i_Day_No           => i,
                                        i_Day_Kind         => v_Day_Kind,
                                        i_Begin_Time       => 540,
                                        i_End_Time         => 1080,
                                        i_Break_Enabled    => 'Y',
                                        i_Break_Begin_Time => 780,
                                        i_Break_End_Time   => 840,
                                        i_Plan_Time        => 480);
    
      Htt_Util.Schedule_Pattern_Day_Add(o_Schedule_Pattern => v_Schedule.Pattern, i_Day => v_Day);
    end loop;
  
    Htt_Api.Schedule_Save(v_Schedule);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Create_Schedule(p Hashmap) return Hashmap is
    r_Schedule Htt_Schedules%rowtype;
  begin
    r_Schedule.Company_Id  := Ui.Company_Id;
    r_Schedule.Filial_Id   := Ui.Filial_Id;
    r_Schedule.Schedule_Id := Htt_Next.Schedule_Id;
  
    save(p, r_Schedule);
  
    return Fazo.Zip_Map('schedule_id', r_Schedule.Schedule_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Schedule(p Hashmap) is
    r_Schedule Htt_Schedules%rowtype;
  begin
    r_Schedule := z_Htt_Schedules.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                            i_Filial_Id   => Ui.Filial_Id,
                                            i_Schedule_Id => p.r_Number('schedule_id'));
  
    save(p, r_Schedule);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Delete_Schedule(p Hashmap) is
  begin
    Htt_Api.Schedule_Delete(i_Company_Id  => Ui.Company_Id,
                            i_Filial_Id   => Ui.Filial_Id,
                            i_Schedule_Id => p.r_Number('schedule_id'));
  end;

end Ui_Vhr339;
/
