create or replace package Ui_Vhr164 is
  ----------------------------------------------------------------------------------------------------  
  Function Definitions return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr164;
/
create or replace package body Ui_Vhr164 is
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
    return b.Translate('UI-VHR164:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Definitions return Arraylist is
    v_Reason_List Arraylist := Arraylist;
    v_Staff_List  Arraylist := Arraylist;
    v_Date_No     number := 1;
    result        Arraylist := Arraylist;
  
    --------------------------------------------------
    Procedure Put
    (
      p_List       in out nocopy Arraylist,
      i_Key        varchar2,
      i_Definition varchar2,
      i_Items      Arraylist := null
    ) is
      v_Map Hashmap;
    begin
      v_Map := Fazo.Zip_Map('key', i_Key, 'definition', i_Definition);
    
      if i_Items is not null then
        v_Map.Put('items', i_Items);
      end if;
    
      p_List.Push(v_Map);
    end;
  begin
    Put(v_Reason_List, 'reason_code', t('reason code'));
    Put(v_Reason_List, 'reason_days', t('reason days'));
    Put(v_Reason_List, 'reason_hours', t('reason hours'));
  
    while v_Date_No <= 31
    loop
      Put(v_Staff_List, v_Date_No, t('$1 day value', v_Date_No));
    
      v_Date_No := v_Date_No + 1;
    end loop;
  
    Put(v_Staff_List, 'order_no', t('order no'));
    Put(v_Staff_List, 'name', t('name'));
    Put(v_Staff_List, 'job_name', t('job name'));
    Put(v_Staff_List, 'staff number', t('staff number'));
    Put(v_Staff_List, 'total_fact_days', t('fact days'));
    Put(v_Staff_List, 'fact_hours', t('fact hours'));
    Put(v_Staff_List, 'absence_days', t('absence days'));
    Put(v_Staff_List, 'absence_hours', t('absence hours'));
    Put(v_Staff_List, 'rest_days', t('rest days'));
    Put(v_Staff_List, 'reasons', t('reasons'), v_Reason_List);
  
    Put(result, 'filial_name', t('filial name'));
    Put(result, 'division_name', t('division name'));
    Put(result, 'timebook_number', t('timebook number'));
    Put(result, 'timebook_date', t('timebook date'));
    Put(result, 'begin_date', t('begin date'));
    Put(result, 'end_date', t('end date'));
    Put(result, 'staffs', t('staffs'), v_Staff_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Report(p Hashmap) return Gmap is
    r_Timebook         Hpr_Timebooks%rowtype;
    v_Reason_Map       Gmap;
    v_Reason_List      Glist;
    v_Staff_Map        Gmap;
    v_Staff_List       Glist := Glist();
    v_Turnout_Id       number;
    v_Rest_Id          number;
    v_Overtime_Id      number;
    v_Free_Id          number;
    v_Date_No          number;
    v_Order_No         number;
    v_Days_Count       number;
    v_Absense_Hours    number;
    v_Absense_Tk_Codes Fazo.Varchar2_Id_Aat;
    v_Reason_Days      Calc;
    result             Gmap := Gmap;
  
    --------------------------------------------------   
    Procedure Put
    (
      p_Map in out Gmap,
      i_Key varchar2,
      i_Val varchar2
    ) is
    begin
      p_Map.Put(i_Key, Nvl(i_Val, ''));
    end;
  begin
    r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Timebook_Id => p.r_Number('timebook_id'));
  
    if r_Timebook.Posted <> 'Y' then
      b.Raise_Not_Implemented;
    end if;
  
    v_Days_Count := Last_Day(r_Timebook.Month) - r_Timebook.Month + 1;
  
    -- cache time kinds
    for r in (select t.Time_Kind_Id, t.Letter_Code, t.Pcode
                from Htt_Time_Kinds t
               where t.Company_Id = r_Timebook.Company_Id
                 and t.Pcode is not null)
    loop
      if Htt_Pref.c_Pcode_Time_Kind_Turnout = r.Pcode then
        v_Turnout_Id := r.Time_Kind_Id;
      elsif Htt_Pref.c_Pcode_Time_Kind_Rest = r.Pcode then
        v_Rest_Id := r.Time_Kind_Id;
      elsif Htt_Pref.c_Pcode_Time_Kind_Overtime = r.Pcode then
        v_Overtime_Id := r.Time_Kind_Id;
      elsif Htt_Pref.c_Pcode_Time_Kind_Free = r.Pcode then
        v_Free_Id := r.Time_Kind_Id;
      end if;
      v_Absense_Tk_Codes(r.Time_Kind_Id) := r.Letter_Code;
    end loop;
  
    Put(result,
        'filial_name',
        z_Md_Filials.Load(i_Company_Id => r_Timebook.Company_Id, --
        i_Filial_Id => r_Timebook.Filial_Id).Name);
    Put(result,
        'division_name',
        z_Mhr_Divisions.Take(i_Company_Id => r_Timebook.Company_Id, --
        i_Filial_Id => r_Timebook.Filial_Id, --
        i_Division_Id => r_Timebook.Division_Id).Name);
    Put(result, 'timebook_number', r_Timebook.Timebook_Number);
    Put(result, 'timebook_date', r_Timebook.Timebook_Date);
    Put(result, 'begin_date', to_char(r_Timebook.Period_Begin, Href_Pref.c_Date_Format_Day));
    Put(result, 'end_date', to_char(r_Timebook.Period_End, Href_Pref.c_Date_Format_Day));
  
    v_Order_No := 1;
  
    for Stf in (select s.*,
                       q.Staff_Number,
                       Np.Name,
                       (select j.Name
                          from Mhr_Jobs j
                         where j.Company_Id = s.Company_Id
                           and j.Filial_Id = s.Filial_Id
                           and j.Job_Id = s.Job_Id) Job_Name
                  from Hpr_Timebook_Staffs s
                  join Href_Staffs q
                    on q.Company_Id = s.Company_Id
                   and q.Filial_Id = s.Filial_Id
                   and q.Staff_Id = s.Staff_Id
                  join Mr_Natural_Persons Np
                    on Np.Company_Id = q.Company_Id
                   and Np.Person_Id = q.Employee_Id
                 where s.Company_Id = r_Timebook.Company_Id
                   and s.Filial_Id = r_Timebook.Filial_Id
                   and s.Timebook_Id = r_Timebook.Timebook_Id
                 order by Np.Name)
    loop
      v_Staff_Map := Gmap();
    
      v_Date_No := 1;
    
      for Dt in (select t.Timesheet_Date - r_Timebook.Month + 1 Date_No,
                        Round(Tf.Fact_Value / 3600, 2) Turnout_Hours,
                        t.Timesheet_Date
                   from Htt_Timesheets t
                   join Htt_Timesheet_Facts Tf
                     on Tf.Company_Id = t.Company_Id
                    and Tf.Filial_Id = t.Filial_Id
                    and Tf.Timesheet_Id = t.Timesheet_Id
                    and Tf.Time_Kind_Id = v_Turnout_Id
                  where t.Company_Id = Stf.Company_Id
                    and t.Filial_Id = Stf.Filial_Id
                    and t.Staff_Id = Stf.Staff_Id
                    and t.Timesheet_Date between r_Timebook.Period_Begin and r_Timebook.Period_End
                  order by t.Timesheet_Date)
      loop
        while v_Date_No < Dt.Date_No
        loop
          Put(v_Staff_Map, v_Date_No, '');
        
          v_Date_No := v_Date_No + 1;
        end loop;
      
        Put(v_Staff_Map, v_Date_No, Nullif(Dt.Turnout_Hours, 0));
      
        v_Date_No := v_Date_No + 1;
      end loop;
    
      while v_Date_No <= 31
      loop
        if v_Date_No <= v_Days_Count then
          Put(v_Staff_Map, v_Date_No, '');
        else
          Put(v_Staff_Map, v_Date_No, 'x');
        end if;
      
        v_Date_No := v_Date_No + 1;
      end loop;
    
      v_Reason_Days := Calc();
    
      for Reason in (select Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) Time_Kind_Id, count(*) Days
                       from Htt_Timesheets t
                       join Htt_Timesheet_Facts Tf
                         on Tf.Company_Id = t.Company_Id
                        and Tf.Filial_Id = t.Filial_Id
                        and Tf.Timesheet_Id = t.Timesheet_Id
                        and Tf.Fact_Value >= t.Plan_Time
                       join Htt_Time_Kinds Tk
                         on Tk.Company_Id = Tf.Company_Id
                        and Tk.Time_Kind_Id = Tf.Time_Kind_Id
                      where t.Company_Id = Stf.Company_Id
                        and t.Filial_Id = Stf.Filial_Id
                        and t.Staff_Id = Stf.Staff_Id
                        and t.Timesheet_Date between r_Timebook.Period_Begin and
                            r_Timebook.Period_End
                      group by Nvl(Tk.Parent_Id, Tk.Time_Kind_Id))
      loop
        v_Reason_Days.Plus(Reason.Time_Kind_Id, Reason.Days);
      end loop;
    
      v_Reason_List   := Glist();
      v_Absense_Hours := 0;
    
      for Absense in (select Tf.Time_Kind_Id, Tf.Fact_Hours
                        from Hpr_Timebook_Facts Tf
                        join Htt_Time_Kinds Tk
                          on Tk.Company_Id = Tf.Company_Id
                         and Tk.Time_Kind_Id = Tf.Time_Kind_Id
                       where Tf.Company_Id = Stf.Company_Id
                         and Tf.Filial_Id = Stf.Filial_Id
                         and Tf.Timebook_Id = Stf.Timebook_Id
                         and Tf.Staff_Id = Stf.Staff_Id
                         and Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) not in
                             (v_Turnout_Id, v_Rest_Id, v_Overtime_Id, v_Free_Id)
                         and Tf.Fact_Hours > 0)
      loop
        v_Reason_Map := Gmap();
      
        Put(v_Reason_Map, 'reason_code', v_Absense_Tk_Codes(Absense.Time_Kind_Id));
        Put(v_Reason_Map, 'reason_days', v_Reason_Days.Get_Value(Absense.Time_Kind_Id));
        Put(v_Reason_Map, 'reason_hours', Absense.Fact_Hours);
      
        v_Absense_Hours := v_Absense_Hours + Absense.Fact_Hours;
      
        v_Reason_List.Push(v_Reason_Map.Val);
      end loop;
    
      Put(v_Staff_Map, 'order_no', v_Order_No);
      Put(v_Staff_Map, 'name', Stf.Name);
      Put(v_Staff_Map, 'staff_number', Stf.Staff_Number);
      Put(v_Staff_Map, 'job_name', Stf.Job_Name);
      Put(v_Staff_Map, 'fact_days', Stf.Fact_Days);
      Put(v_Staff_Map, 'fact_hours', Stf.Fact_Hours);
      Put(v_Staff_Map, 'absence_days', Stf.Plan_Days - Stf.Fact_Days);
      Put(v_Staff_Map, 'absence_hours', v_Absense_Hours);
      Put(v_Staff_Map,
          'rest_days',
          (r_Timebook.Period_End - r_Timebook.Period_Begin + 1) - Stf.Plan_Days);
    
      v_Staff_Map.Put('reasons', v_Reason_List);
    
      v_Staff_List.Push(v_Staff_Map.Val);
    
      v_Order_No := v_Order_No + 1;
    end loop;
  
    Result.Put('staffs', v_Staff_List);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
  begin
    Uit_Ker.Run_Report(i_Template_Id => p.r_Number('template_id'), --
                       i_Data        => Report(p));
  end;

end Ui_Vhr164;
/
