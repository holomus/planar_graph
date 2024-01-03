create or replace package Ui_Vhr267 is
  -------------------------------------------------------------------------------------------------- 
  Function List_Timebooks(p Hashmap) return Json_Object_t;
  -------------------------------------------------------------------------------------------------- 
  Function List_Timebook_Details(p Hashmap) return Json_Object_t;
end Ui_Vhr267;
/
create or replace package body Ui_Vhr267 is
  ----------------------------------------------------------------------------------------------------
  -- timebook keys
  ----------------------------------------------------------------------------------------------------
  c_Key_Timebook_Id           constant varchar2(50) := 'timebook_id';
  c_Key_Timebook_Created_On   constant varchar2(50) := 'created_on';
  c_Key_Timebook_Modified_On  constant varchar2(50) := 'modified_on';
  c_Key_Timebook_Number       constant varchar2(50) := 'timebook_number';
  c_Key_Timebook_Date         constant varchar2(50) := 'timebook_date';
  c_Key_Timebook_Month        constant varchar2(50) := 'timebook_month';
  c_Key_Timebook_Period_Begin constant varchar2(50) := 'timebook_period_begin';
  c_Key_Timebook_Period_End   constant varchar2(50) := 'timebook_period_end';
  c_Key_Timebook_Division_Id  constant varchar2(50) := 'division_id';
  c_Key_Timebook_Posted       constant varchar2(50) := 'posted';

  ----------------------------------------------------------------------------------------------------
  -- timebook staff keys
  ----------------------------------------------------------------------------------------------------
  c_Key_Staffs           constant varchar2(50) := 'staffs';
  c_Key_Staff_Id         constant varchar2(50) := 'staff_id';
  c_Key_Employee_Id      constant varchar2(50) := 'employee_id';
  c_Key_Division_Id      constant varchar2(50) := 'division_id';
  c_Key_Job_Id           constant varchar2(50) := 'job_id';
  c_Key_Schedule_Id      constant varchar2(50) := 'schedule_id';
  c_Key_Staff_Plan_Days  constant varchar2(50) := 'plan_days';
  c_Key_Staff_Plan_Hours constant varchar2(50) := 'plan_hours';
  c_Key_Staff_Fact_Days  constant varchar2(50) := 'fact_days';
  c_Key_Staff_Fact_Hours constant varchar2(50) := 'fact_hours';

  ----------------------------------------------------------------------------------------------------
  -- timesheet keys
  ----------------------------------------------------------------------------------------------------
  c_Key_Days               constant varchar2(50) := 'days';
  c_Key_Timesheet_Date     constant varchar2(50) := 'date';
  c_Key_Timesheet_Day_Kind constant varchar2(50) := 'day_kind';

  ----------------------------------------------------------------------------------------------------
  -- timebook fact keys
  ----------------------------------------------------------------------------------------------------
  c_Key_Facts        constant varchar2(50) := 'facts';
  c_Key_Fact_Hours   constant varchar2(50) := 'fact_hours';
  c_Key_Fact_Minutes constant varchar2(50) := 'fact_minutes';
  c_Key_Time_Kind_Id constant varchar2(50) := 'time_kind_id';

  ----------------------------------------------------------------------------------------------------
  Procedure Put_Staff_Data
  (
    p_Staff        in out nocopy Gmap,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Timebook_Id  number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date,
    i_With_Details boolean := false
  ) is
    v_Fact  Gmap;
    v_Facts Glist := Glist();
  
    v_Day  Gmap;
    v_Days Glist := Glist();
  
    v_Fact_Day  Gmap;
    v_Fact_Days Glist;
  begin
    for Tf in (select f.Fact_Hours, f.Time_Kind_Id
                 from Hpr_Timebook_Facts f
                where f.Company_Id = i_Company_Id
                  and f.Filial_Id = i_Filial_Id
                  and f.Timebook_Id = i_Timebook_Id
                  and f.Staff_Id = i_Staff_Id)
    loop
      v_Fact := Gmap();
    
      v_Fact.Put(c_Key_Time_Kind_Id, Tf.Time_Kind_Id);
      v_Fact.Put(c_Key_Fact_Hours, Tf.Fact_Hours);
    
      v_Facts.Push(v_Fact.Val);
    end loop;
  
    p_Staff.Put(c_Key_Facts, v_Facts);
  
    if i_With_Details then
      for Tf in (select q.Timesheet_Id, q.Timesheet_Date, q.Day_Kind
                   from Htt_Timesheets q
                  where q.Company_Id = i_Company_Id
                    and q.Filial_Id = i_Filial_Id
                    and q.Staff_Id = i_Staff_Id
                    and q.Timesheet_Date >= i_Period_Begin
                    and q.Timesheet_Date <= i_Period_End
                  order by q.Timesheet_Date)
      loop
        v_Day := Gmap();
      
        v_Day.Put(c_Key_Timesheet_Date, Tf.Timesheet_Date);
        v_Day.Put(c_Key_Timesheet_Day_Kind, Tf.Day_Kind);
      
        v_Fact_Days := Glist();
      
        for Fs in (select Nvl(Tk.Parent_Id, Tk.Time_Kind_Id) as Time_Kind_Id,
                          Round(sum(Tfc.Fact_Value) / 60, 2) as Fact_Hours
                     from Htt_Timesheet_Facts Tfc
                     join Htt_Time_Kinds Tk
                       on Tk.Company_Id = Tfc.Company_Id
                      and Tk.Time_Kind_Id = Tfc.Time_Kind_Id
                    where Tfc.Company_Id = i_Company_Id
                      and Tfc.Filial_Id = i_Filial_Id
                      and Tfc.Timesheet_Id = Tf.Timesheet_Id
                      and Tfc.Fact_Value > 0
                    group by Nvl(Tk.Parent_Id, Tk.Time_Kind_Id))
        loop
          v_Fact_Day := Gmap();
        
          v_Fact_Day.Put(c_Key_Time_Kind_Id, Fs.Time_Kind_Id);
          v_Fact_Day.Put(c_Key_Fact_Minutes, Fs.Fact_Hours);
        
          v_Fact_Days.Push(v_Fact_Day.Val);
        end loop;
      
        v_Day.Put(c_Key_Facts, v_Fact_Days);
      
        v_Days.Push(v_Day.Val);
      end loop;
    
      p_Staff.Put(c_Key_Days, v_Days);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Export_Data(i_Data Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Timebook_Ids Array_Number := Nvl(i_Data.o_Array_Number('timebook_ids'), Array_Number());
    v_Count        number := v_Timebook_Ids.Count;
    v_Division_Id  number := i_Data.o_Number('division_id');
  
    v_Staffs    Glist;
    v_Timebook  Gmap;
    v_Timebooks Glist := Glist();
  
    v_Staff Gmap;
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    for Tb in (select *
                 from (select q.Company_Id,
                              q.Filial_Id,
                              q.Timebook_Id,
                              q.Created_On,
                              q.Modified_On,
                              q.Modified_Id,
                              q.Timebook_Number,
                              q.Timebook_Date,
                              q.Month,
                              q.Period_Begin,
                              q.Period_End,
                              q.Division_Id,
                              q.Posted
                         from Hpr_Timebooks q
                        where q.Company_Id = v_Company_Id
                          and q.Filial_Id = v_Filial_Id
                          and (v_Count = 0 or --                 
                              q.Timebook_Id member of v_Timebook_Ids)
                          and (v_Division_Id is null or q.Division_Id = v_Division_Id)) Qr
                where Qr.Company_Id = v_Company_Id
                  and Qr.Filial_Id = v_Filial_Id
                  and Qr.Modified_Id > v_Start_Id
                order by Qr.Modified_Id
                fetch first v_Limit Rows only)
    loop
      v_Timebook := Gmap();
      v_Staffs   := Glist();
    
      v_Timebook.Put(c_Key_Timebook_Id, Tb.Timebook_Id);
      v_Timebook.Put(c_Key_Timebook_Created_On, Tb.Created_On);
      v_Timebook.Put(c_Key_Timebook_Modified_On, Tb.Modified_On);
      v_Timebook.Put(c_Key_Timebook_Number, Tb.Timebook_Number);
      v_Timebook.Put(c_Key_Timebook_Date, Tb.Timebook_Date);
      v_Timebook.Put(c_Key_Timebook_Month, Tb.Month);
      v_Timebook.Put(c_Key_Timebook_Period_Begin, Tb.Period_Begin);
      v_Timebook.Put(c_Key_Timebook_Period_End, Tb.Period_End);
      v_Timebook.Put(c_Key_Timebook_Division_Id, Tb.Division_Id);
      v_Timebook.Put(c_Key_Timebook_Posted, Tb.Posted);
    
      for Ts in (select t.Company_Id,
                        t.Filial_Id,
                        t.Timebook_Id,
                        t.Staff_Id,
                        (select St.Employee_Id
                           from Href_Staffs St
                          where St.Company_Id = t.Company_Id
                            and St.Filial_Id = t.Filial_Id
                            and St.Staff_Id = t.Staff_Id) Employee_Id,
                        t.Division_Id,
                        t.Job_Id,
                        t.Schedule_Id,
                        t.Plan_Days,
                        t.Plan_Hours,
                        t.Fact_Days,
                        t.Fact_Hours
                   from Hpr_Timebook_Staffs t
                  where t.Company_Id = Tb.Company_Id
                    and t.Filial_Id = Tb.Filial_Id
                    and t.Timebook_Id = Tb.Timebook_Id)
      loop
        v_Staff := Gmap;
      
        v_Staff.Put(c_Key_Staff_Id, Ts.Staff_Id);
        v_Staff.Put(c_Key_Employee_Id, Ts.Employee_Id);
        v_Staff.Put(c_Key_Division_Id, Ts.Division_Id);
        v_Staff.Put(c_Key_Job_Id, Ts.Job_Id);
        v_Staff.Put(c_Key_Schedule_Id, Ts.Schedule_Id);
        v_Staff.Put(c_Key_Staff_Plan_Days, Ts.Plan_Days);
        v_Staff.Put(c_Key_Staff_Plan_Hours, Ts.Plan_Hours);
        v_Staff.Put(c_Key_Staff_Fact_Days, Ts.Fact_Days);
        v_Staff.Put(c_Key_Staff_Fact_Hours, Ts.Fact_Hours);
      
        Put_Staff_Data(p_Staff        => v_Staff,
                       i_Company_Id   => Ts.Company_Id,
                       i_Filial_Id    => Ts.Filial_Id,
                       i_Timebook_Id  => Ts.Timebook_Id,
                       i_Staff_Id     => Ts.Staff_Id,
                       i_Period_Begin => Tb.Period_Begin,
                       i_Period_End   => Tb.Period_End);
      
        v_Staffs.Push(v_Staff.Val);
      end loop;
    
      v_Timebook.Put(c_Key_Staffs, v_Staffs);
    
      v_Last_Id := Tb.Modified_Id;
    
      v_Timebooks.Push(v_Timebook.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Timebooks, --
                                       i_Modified_Id => v_Last_Id);
  end;

  -------------------------------------------------------------------------------------------------- 
  Function List_Timebooks(p Hashmap) return Json_Object_t is
  begin
    return Export_Data(p);
  end;

  -------------------------------------------------------------------------------------------------- 
  Function List_Timebook_Details(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Timebook_Id number := p.r_Number('timebook_id');
  
    r_Timebook Hpr_Timebooks%rowtype;
  
    v_Staff  Gmap;
    v_Staffs Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => v_Company_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Timebook_Id => v_Timebook_Id);
  
    for Ts in (select *
                 from (select t.Company_Id,
                              t.Filial_Id,
                              t.Timebook_Id,
                              t.Staff_Id,
                              (select St.Employee_Id
                                 from Href_Staffs St
                                where St.Company_Id = t.Company_Id
                                  and St.Filial_Id = t.Filial_Id
                                  and St.Staff_Id = t.Staff_Id) Employee_Id,
                              t.Division_Id,
                              t.Job_Id,
                              t.Schedule_Id,
                              t.Plan_Days,
                              t.Plan_Hours,
                              t.Fact_Days,
                              t.Fact_Hours
                         from Hpr_Timebook_Staffs t
                        where t.Company_Id = v_Company_Id
                          and t.Filial_Id = v_Filial_Id
                          and t.Timebook_Id = v_Timebook_Id) Qr
                where Qr.Company_Id = v_Company_Id
                  and Qr.Filial_Id = v_Filial_Id
                  and Qr.Staff_Id > v_Start_Id
                order by Qr.Staff_Id
                fetch first v_Limit Rows only)
    loop
      v_Staff := Gmap;
    
      v_Staff.Put(c_Key_Staff_Id, Ts.Staff_Id);
      v_Staff.Put(c_Key_Employee_Id, Ts.Employee_Id);
      v_Staff.Put(c_Key_Division_Id, Ts.Division_Id);
      v_Staff.Put(c_Key_Job_Id, Ts.Job_Id);
      v_Staff.Put(c_Key_Schedule_Id, Ts.Schedule_Id);
      v_Staff.Put(c_Key_Staff_Plan_Days, Ts.Plan_Days);
      v_Staff.Put(c_Key_Staff_Plan_Hours, Ts.Plan_Hours);
      v_Staff.Put(c_Key_Staff_Fact_Days, Ts.Fact_Days);
      v_Staff.Put(c_Key_Staff_Fact_Hours, Ts.Fact_Hours);
    
      Put_Staff_Data(p_Staff        => v_Staff,
                     i_Company_Id   => Ts.Company_Id,
                     i_Filial_Id    => Ts.Filial_Id,
                     i_Timebook_Id  => Ts.Timebook_Id,
                     i_Staff_Id     => Ts.Staff_Id,
                     i_Period_Begin => r_Timebook.Period_Begin,
                     i_Period_End   => r_Timebook.Period_End,
                     i_With_Details => true);
    
      v_Last_Id := Ts.Staff_Id;
    
      v_Staffs.Push(v_Staff.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Staffs, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr267;
/
