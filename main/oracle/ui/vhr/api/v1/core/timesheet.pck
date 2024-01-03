create or replace package Ui_Vhr283 is
  ----------------------------------------------------------------------------------------------------  
  Function Export(i_Data Hashmap) return Json_Object_t;
end Ui_Vhr283;
/
create or replace package body Ui_Vhr283 is
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
    return b.Translate('UI-VHR283:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Export(i_Data Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Staffs Glist;
    v_Staff  Gmap;
    v_Days   Glist;
    v_Day    Gmap;
    v_Facts  Glist;
  
    v_Period_Begin_Date date := i_Data.r_Date('period_begin_date');
    v_Period_End_Date   date := i_Data.r_Date('period_end_date');
    v_Division_Ids      Array_Number := i_Data.o_Array_Number('division_ids');
    v_Employee_Ids      Array_Number := i_Data.o_Array_Number('employee_ids');
    v_Divisions_Cnt     number := v_Division_Ids.Count;
    v_Emp_Cnt           number := v_Employee_Ids.Count;
  
    --------------------------------------------------
    Function To_Minute(i_Seconds number) return number is
    begin
      return Round(i_Seconds / 60, 2);
    end;
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 100);
  
    v_Staffs := Glist();
  
    for r in (select *
                from (select q.*
                        from Href_Staffs q
                       where q.Company_Id = v_Company_Id
                         and q.Filial_Id = v_Filial_Id
                         and (v_Divisions_Cnt = 0 or q.Division_Id member of v_Division_Ids)
                         and (v_Emp_Cnt = 0 or q.Employee_Id member of v_Employee_Ids)
                         and q.Hiring_Date <= v_Period_End_Date
                         and v_Period_Begin_Date <= Nvl(q.Dismissal_Date, v_Period_Begin_Date)
                         and q.State = 'A'
                         and exists (select 1
                                from Mhr_Employees p
                               where p.Company_Id = v_Company_Id
                                 and p.Filial_Id = v_Filial_Id
                                 and p.Employee_Id = q.Employee_Id
                                 and p.State = 'A')) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Staff_Id > v_Start_Id
               order by Qr.Staff_Id
               fetch first v_Limit Rows only)
    loop
      v_Staff := Gmap();
    
      v_Staff.Put('staff_id', r.Staff_Id);
      v_Staff.Put('employee_id', r.Employee_Id);
    
      v_Days := Glist();
    
      for Tsht in (select q.*,
                          (select Json_Arrayagg(Json_Object('time_kind_id' value
                                                            Nvl(Tk.Parent_Id, Tk.Time_Kind_Id),
                                                            'fact_value' value
                                                            Round(sum(Tf.Fact_Value) / 60, 2)))
                             from Htt_Timesheet_Facts Tf
                             join Htt_Time_Kinds Tk
                               on Tk.Company_Id = Tf.Company_Id
                              and Tk.Time_Kind_Id = Tf.Time_Kind_Id
                            where Tf.Company_Id = q.Company_Id
                              and Tf.Filial_Id = q.Filial_Id
                              and Tf.Timesheet_Id = q.Timesheet_Id
                            group by Nvl(Tk.Parent_Id, Tk.Time_Kind_Id)) Facts
                     from Htt_Timesheets q
                    where q.Company_Id = r.Company_Id
                      and q.Filial_Id = r.Filial_Id
                      and q.Staff_Id = r.Staff_Id
                      and q.Timesheet_Date between v_Period_Begin_Date and v_Period_End_Date
                      and not exists (select *
                             from Hlic_Unlicensed_Employees Lic
                            where Lic.Company_Id = q.Company_Id
                              and Lic.Employee_Id = q.Employee_Id
                              and Lic.Licensed_Date = q.Timesheet_Date)
                    order by q.Timesheet_Date)
      loop
        v_Day := Gmap();
      
        v_Day.Put('date', Tsht.Timesheet_Date);
        v_Day.Put('day_kind', Tsht.Day_Kind);
        v_Day.Put('plan_time', To_Minute(Tsht.Plan_Time));
        v_Day.Put('done_marks', Tsht.Done_Marks);
        v_Day.Put('planned_marks', Tsht.Planned_Marks);
        v_Day.Put('begin_time', Tsht.Begin_Time);
        v_Day.Put('end_time', Tsht.End_Time);
        v_Day.Put('break_begin_time', Tsht.Break_Begin_Time);
        v_Day.Put('break_end_time', Tsht.Break_End_Time);
        v_Day.Put('input_time', Tsht.Input_Time);
        v_Day.Put('output_time', Tsht.Output_Time);
      
        v_Facts := Glist(Json_Array_t(Tsht.Facts));
      
        v_Day.Put('facts', v_Facts);
      
        v_Days.Push(v_Day.Val);
      end loop;
    
      v_Staff.Put('days', v_Days);
    
      v_Last_Id := r.Staff_Id;
    
      v_Staffs.Push(v_Staff.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Staffs, --
                                       i_Modified_Id => v_Last_Id);
  end;
end Ui_Vhr283;
/
