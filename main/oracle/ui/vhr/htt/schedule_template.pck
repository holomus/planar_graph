create or replace package Ui_Vhr352 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr352;
/
create or replace package body Ui_Vhr352 is
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('schedule_kind',
                           Htt_Pref.c_Pattern_Kind_Weekly,
                           'use_calendar',
                           'N',
                           'all_days_equal',
                           'Y',
                           'state',
                           'A');
  
    Result.Put('take_holidays', 'Y');
    Result.Put('take_nonworking', 'Y');
    Result.Put('take_additional_rest_days', 'Y');
    Result.Put('count_late', 'Y');
    Result.Put('count_early', 'Y');
    Result.Put('count_lack', 'Y');
    Result.Put('use_marks', 'N');
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Schedule_Template Htt_Schedule_Templates%rowtype;
    v_Days              Arraylist := Arraylist();
    v_Day               Hashmap;
    v_Pattern_Marks     Matrix_Varchar2;
    v_Marks_Used        varchar2(1) := 'N';
    result              Hashmap;
  begin
    r_Schedule_Template := z_Htt_Schedule_Templates.Load(p.r_Number('template_id'));
  
    result := z_Htt_Schedule_Templates.To_Map(r_Schedule_Template,
                                              z.Template_Id,
                                              z.Name,
                                              z.Description,
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
                                              z.Take_Nonworking,
                                              z.Take_Additional_Rest_Days,
                                              z.Order_No,
                                              z.State,
                                              z.Code);
  
    for r in (select *
                from Htt_Schedule_Template_Days q
               where q.Template_Id = r_Schedule_Template.Template_Id
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
  
    Result.Put('schedule_days', v_Days);
    Result.Put('schedule_kind', r_Schedule_Template.Schedule_Kind);
    Result.Put('all_days_equal', r_Schedule_Template.All_Days_Equal);
    Result.Put('use_calendar',
               case --
               when r_Schedule_Template.Take_Holidays = 'N' and
               r_Schedule_Template.Take_Nonworking = 'N' and
               r_Schedule_Template.Take_Additional_Rest_Days = 'N' --
               then 'N' --
               else 'Y' --
               end);
    Result.Put('use_marks', v_Marks_Used);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fill_Patterns
  (
    o_Schedule_Template in out nocopy Htt_Pref.Schedule_Template_Rt,
    i_Pattern           Hashmap
  ) is
    v_Days        Arraylist := i_Pattern.r_Arraylist('days');
    v_Pattern_Day Htt_Pref.Schedule_Pattern_Day_Rt;
    v_Marks       Arraylist;
    v_Mark        Hashmap;
    v_Item        Hashmap;
  begin
    for i in 1 .. v_Days.Count
    loop
      v_Item := Treat(v_Days.r_Hashmap(i) as Hashmap);
    
      v_Marks := v_Item.r_Arraylist('marks');
    
      Htt_Util.Schedule_Pattern_Day_New(o_Pattern_Day      => v_Pattern_Day,
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
      
        Htt_Util.Schedule_Marks_Add(o_Marks      => v_Pattern_Day.Pattern_Marks,
                                    i_Begin_Time => v_Mark.r_Number('begin_time'),
                                    i_End_Time   => v_Mark.r_Number('end_time'));
      end loop;
    
      Htt_Util.Schedule_Template_Pattern_Add(o_Schedule_Template => o_Schedule_Template,
                                             i_Pattern_Day       => v_Pattern_Day);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    i_Template_Id number,
    p             Hashmap
  ) return Hashmap is
    v_Schedule_Template Htt_Pref.Schedule_Template_Rt;
    v_Pattern_Map       Hashmap := p.r_Hashmap('pattern');
  begin
    Htt_Util.Schedule_Template_New(o_Schedule_Template         => v_Schedule_Template,
                                   i_Template_Id               => i_Template_Id,
                                   i_Name                      => p.r_Varchar2('name'),
                                   i_Description               => p.o_Varchar2('description'),
                                   i_Schedule_Kind             => p.r_Varchar2('schedule_kind'),
                                   i_All_Days_Equal            => p.r_Varchar2('all_days_equal'),
                                   i_Count_Days                => p.r_Number('count_days'),
                                   i_Shift                     => p.o_Number('shift'),
                                   i_Input_Acceptance          => p.o_Number('input_acceptance'),
                                   i_Output_Acceptance         => p.o_Number('output_acceptance'),
                                   i_Count_Late                => Nvl(p.o_Varchar2('count_late'),
                                                                      'Y'),
                                   i_Count_Early               => Nvl(p.o_Varchar2('count_early'),
                                                                      'Y'),
                                   i_Count_Lack                => Nvl(p.o_Varchar2('count_lack'),
                                                                      'Y'),
                                   i_Track_Duration            => p.o_Number('track_duration'),
                                   i_Take_Holidays             => p.o_Varchar2('take_holidays'),
                                   i_Take_Nonworking           => p.o_Varchar2('take_nonworking'),
                                   i_Take_Additional_Rest_Days => p.o_Varchar2('take_additional_rest_days'),
                                   i_Order_No                  => p.o_Number('order_no'),
                                   i_State                     => p.r_Varchar2('state'),
                                   i_Code                      => p.o_Varchar2('code'));
  
    Fill_Patterns(v_Schedule_Template, v_Pattern_Map);
  
    Htt_Api.Schedule_Template_Save(v_Schedule_Template);
  
    return Fazo.Zip_Map('template_id', i_Template_Id, 'name', v_Schedule_Template.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(Htt_Next.Schedule_Template_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Schedule_Template Htt_Schedule_Templates%rowtype;
  begin
    r_Schedule_Template := z_Htt_Schedule_Templates.Lock_Load(p.r_Number('template_id'));
  
    return save(r_Schedule_Template.Template_Id, p);
  end;

end Ui_Vhr352;
/
