create or replace package Ui_Vhr335 is
  ----------------------------------------------------------------------------------------------------
  Function Query
  (
    p           Hashmap,
    i_Unchecked boolean := false
  ) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Unchecked(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Checked(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Monthly_Limits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Reset(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Approve(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Deny(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Cancel(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Delete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Load_Timesheet(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Change(p Hashmap) return Arraylist;
end Ui_Vhr335;
/
create or replace package body Ui_Vhr335 is
  ----------------------------------------------------------------------------------------------------
  Function Query
  (
    p           Hashmap,
    i_Unchecked boolean := false
  ) return Fazo_Query is
    v_Query       varchar2(32767);
    v_Params      Hashmap;
    v_Matrix      Matrix_Varchar2;
    v_Employee_Id number := p.r_Number('employee_id');
    q             Fazo_Query;
  begin
    v_Query := 'select q.*,
                       w.employee_id,
                       w.division_id,
                       w.org_unit_id,
                       q.created_on change_date,
                       case
                          when q.change_kind = :chk_swap then
                           ''N''
                          else
                           nvl ((select ''Y''
                                   from htt_change_days d
                                   join htt_timesheets t
                                     on t.company_id = d.company_id
                                    and t.filial_id = d.filial_id
                                    and t.staff_id = d.staff_id
                                    and t.timesheet_date = d.change_date
                                   join htt_schedules sch
                                     on sch.company_id = t.company_id
                                    and sch.filial_id = t.filial_id
                                    and sch.schedule_id = t.schedule_id
                                  where d.company_id = q.company_id
                                    and d.filial_id = q.filial_id
                                    and d.staff_id = q.staff_id
                                    and d.change_id = q.change_id
                                    and d.day_kind = :dk_work
                                    and sch.use_weights = ''Y''
                                    and not exists (select 1
                                           from htt_change_day_weights dw
                                          where dw.company_id = d.company_id
                                            and dw.filial_id = d.filial_id
                                            and dw.staff_id = d.staff_id
                                            and dw.change_date = d.change_date
                                            and dw.change_id = d.change_id)
                                    and rownum = 1), ''N'')
                        end need_weight
                  from htt_plan_changes q
                  join href_staffs w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.staff_id = q.staff_id
                   and w.state = ''A''
                 where w.company_id = :company_id
                   and w.filial_id = :filial_id
                   and w.employee_id = :employee_id';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'employee_id',
                             v_Employee_Id,
                             'nls_language',
                             Htt_Util.Get_Nls_Language,
                             'dk_work',
                             Htt_Pref.c_Day_Kind_Work,
                             'chk_swap',
                             Htt_Pref.c_Change_Kind_Swap);
    if i_Unchecked then
      v_Params.Put('status_new', Htt_Pref.c_Change_Status_New);
      v_Params.Put('status_approved', Htt_Pref.c_Change_Status_Approved);
    
      v_Query := v_Query || ' and (q.status = :status_new or q.status = :status_approved)';
    else
      v_Params.Put('status_completed', Htt_Pref.c_Change_Status_Completed);
      v_Params.Put('status_denied', Htt_Pref.c_Change_Status_Denied);
    
      v_Query := v_Query || ' and (q.status = :status_completed or q.status = :status_denied)';
    end if;
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('change_id',
                   'staff_id',
                   'approved_by',
                   'completed_by',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('change_kind',
                     'manager_note',
                     'note',
                     'status',
                     'access_level',
                     'need_weight');
    q.Date_Field('created_on', 'change_date', 'modified_on');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('approved_by_name',
                  'approved_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
    q.Refer_Field('completed_by_name',
                  'completed_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users
                    where company_id = :company_id');
  
    v_Matrix := Htt_Util.Change_Kinds;
    q.Option_Field('change_kind_name', 'change_kind', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Change_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.User_Acces_Levels;
    q.Option_Field('access_level_name', 'access_level', v_Matrix(1), v_Matrix(2));
    q.Option_Field('need_weight_name',
                   'need_weight',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Map_Field('change_dates',
                'select listagg(case
                                   when q.swapped_date is null then
                                    to_char(q.change_date, ''fmdd mon. yyyy'')
                                   else
                                    to_char(q.change_date, ''fmdd mon. yyyy'') || '' - '' ||
                                    to_char(q.swapped_date, ''fmdd mon. yyyy'')
                                 end, '', '') ' || --
                '       within group(order by q.change_date) ' || -- 
                '  from htt_change_days q ' || --
                ' where q.company_id = $company_id ' || --
                '   and q.filial_id = $filial_id ' || --
                '   and q.change_id = $change_id' || --
                '   and (q.swapped_date is null or q.swapped_date > q.change_date)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Checked(p Hashmap) return Fazo_Query is
  begin
    return Query(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Unchecked(p Hashmap) return Fazo_Query is
  begin
    return Query(p, true);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Monthly_Limits(p Hashmap) return Fazo_Query is
    v_Employee_Id number := p.r_Number('employee_id');
    v_Staff_Id    number;
    q             Fazo_Query;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => v_Employee_Id);
  
    q := Fazo_Query('select w.change_month,
                            to_char(w.change_month, ''Month yyyy'') change_month_name,
                            count(1) total_count
                       from (select t.*, q.change_date, trunc(q.change_date, ''mon'') change_month
                               from htt_plan_changes t
                               join htt_change_days q
                                 on q.company_id = t.company_id
                                and q.filial_id = t.filial_id
                                and q.change_id = t.change_id
                              where t.company_id = :company_id
                                and t.filial_id = :filial_id
                                and t.staff_id = :staff_id
                                and t.status = :status_completed
                                and (t.change_kind = :change_kind_change_plan or q.change_date < q.swapped_date)) w
                      group by w.change_month',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'staff_id',
                                 v_Staff_Id,
                                 'status_completed',
                                 Htt_Pref.c_Change_Status_Completed,
                                 'change_kind_change_plan',
                                 Htt_Pref.c_Change_Kind_Change_Plan));
  
    q.Number_Field('total_count');
    q.Varchar2_Field('change_month_name');
    q.Date_Field('change_month');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function References(i_Employee_Id number) return Hashmap is
    v_Note_Is_Required varchar2(1) := Href_Util.Plan_Change_Note_Is_Required(Ui.Company_Id);
    v_Change_Day_Limit Hes_Pref.Change_Day_Limit_Rt;
    result             Hashmap := Hashmap();
  begin
    Result.Put_All(Fazo.Zip_Map('ual_personal',
                                Href_Pref.c_User_Access_Level_Personal,
                                'ual_direct_employee',
                                Href_Pref.c_User_Access_Level_Direct_Employee,
                                'access_all_employee',
                                Uit_Href.User_Access_All_Employees));
    Result.Put('change_kind_swap', 'S');
    Result.Put('change_kind_change', 'C');
    Result.Put('note_is_required', v_Note_Is_Required);
  
    if v_Note_Is_Required = 'Y' then
      Result.Put('note_limit', Href_Util.Load_Plan_Change_Note_Limit(Ui.Company_Id));
    end if;
  
    v_Change_Day_Limit := Hes_Util.Staff_Change_Day_Limit_Settings(i_Company_Id => Ui.Company_Id,
                                                                   i_Filial_Id  => Ui.Filial_Id,
                                                                   i_User_Id    => i_Employee_Id);
  
    Result.Put('change_with_monthly_limit', v_Change_Day_Limit.Change_With_Monthly_Limit);
    Result.Put('change_monthly_limit', v_Change_Day_Limit.Change_Monthly_Limit);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Employee_Id number := p.r_Number('employee_id');
    v_Staff_Id    number;
    result        Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(v_Employee_Id);
  
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => v_Employee_Id);
  
    Result.Put('employee_id', v_Employee_Id);
    Result.Put('staff_id', v_Staff_Id);
    Result.Put('references', References(v_Employee_Id));
    Result.Put('personal_mode', case when Ui.User_Id = v_Employee_Id then 'Y' else 'N' end);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Change
  (
    i_Change_Id number,
    p           Hashmap
  ) is
    v_Change           Htt_Pref.Change_Rt;
    v_Staff_Id         number;
    v_Break_Enabled    varchar2(1);
    v_Day_Kind         varchar2(1);
    v_Begin_Time       date;
    v_End_Time         date;
    v_Break_Begin_Time date;
    v_Break_End_Time   date;
    v_Plan_Time        number;
    v_Change_Date      date;
    v_Item             Hashmap;
    v_Items            Arraylist := p.r_Arraylist('change_dates');
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => p.r_Number('employee_id'));
  
    Htt_Util.Change_New(o_Change      => v_Change,
                        i_Company_Id  => Ui.Company_Id,
                        i_Filial_Id   => Ui.Filial_Id,
                        i_Change_Id   => i_Change_Id,
                        i_Staff_Id    => v_Staff_Id,
                        i_Change_Kind => p.r_Varchar2('change_kind'),
                        i_Note        => p.o_Varchar2('note'));
  
    for i in 1 .. v_Items.Count
    loop
      v_Item             := Treat(v_Items.r_Hashmap(i) as Hashmap);
      v_Change_Date      := v_Item.r_Varchar2('change_date');
      v_Day_Kind         := v_Item.r_Varchar2('day_kind');
      v_Begin_Time       := to_date(v_Change_Date || ' ' || v_Item.r_Varchar2('begin_time'),
                                    Href_Pref.c_Date_Format_Minute);
      v_End_Time         := to_date(v_Change_Date || ' ' || v_Item.r_Varchar2('end_time'),
                                    Href_Pref.c_Date_Format_Minute);
      v_Break_Enabled    := v_Item.o_Varchar2('break_enabled');
      v_Break_Begin_Time := to_date(v_Change_Date || ' ' || v_Item.r_Varchar2('break_begin_time'),
                                    Href_Pref.c_Date_Format_Minute);
      v_Break_End_Time   := to_date(v_Change_Date || ' ' || v_Item.r_Varchar2('break_end_time'),
                                    Href_Pref.c_Date_Format_Minute);
      v_Plan_Time        := v_Item.r_Number('plan_time') * 60;
    
      if v_Day_Kind in (Htt_Pref.c_Day_Kind_Rest,
                        Htt_Pref.c_Day_Kind_Holiday,
                        Htt_Pref.c_Day_Kind_Additional_Rest) or v_Day_Kind is null then
        v_Begin_Time       := null;
        v_End_Time         := null;
        v_Break_Enabled    := null;
        v_Break_Begin_Time := null;
        v_Break_End_Time   := null;
        v_Plan_Time        := null;
      
        if v_Day_Kind is not null then
          v_Plan_Time := 0;
        end if;
      else
        v_Break_Enabled := Nvl(v_Break_Enabled, 'N');
      
        if v_End_Time <= v_Begin_Time then
          v_End_Time := v_End_Time + 1;
        end if;
      
        if v_Break_Enabled = 'Y' then
          if v_Break_Begin_Time <= v_Begin_Time then
            v_Break_Begin_Time := v_Break_Begin_Time + 1;
          end if;
        
          if v_Break_End_Time <= v_Break_Begin_Time then
            v_Break_End_Time := v_Break_End_Time + 1;
          end if;
        
        else
          v_Break_Begin_Time := null;
          v_Break_End_Time   := null;
        end if;
      end if;
    
      Htt_Util.Change_Day_Add(o_Change           => v_Change,
                              i_Change_Date      => v_Item.r_Date('change_date'),
                              i_Swapped_Date     => v_Item.o_Date('swapped_date'),
                              i_Day_Kind         => v_Day_Kind,
                              i_Begin_Time       => v_Begin_Time,
                              i_End_Time         => v_End_Time,
                              i_Break_Enabled    => v_Break_Enabled,
                              i_Break_Begin_Time => v_Break_Begin_Time,
                              i_Break_End_Time   => v_Break_End_Time,
                              i_Plan_Time        => v_Plan_Time);
    end loop;
  
    Htt_Api.Change_Save(v_Change);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    Save_Change(Htt_Next.Change_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
  begin
    Save_Change(p.r_Number('change_id'), p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Reset(p Hashmap) is
    r_Change     Htt_Plan_Changes%rowtype;
    v_Change_Ids Array_Number := Fazo.Sort(p.r_Array_Number('change_id'));
  begin
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Reset(i_Company_Id => r_Change.Company_Id,
                           i_Filial_Id  => r_Change.Filial_Id,
                           i_Change_Id  => r_Change.Change_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Approve(p Hashmap) is
    r_Change       Htt_Plan_Changes%rowtype;
    v_Change_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('change_id'));
    v_Manager_Note Htt_Plan_Changes.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Approve(i_Company_Id   => r_Change.Company_Id,
                             i_Filial_Id    => r_Change.Filial_Id,
                             i_Change_Id    => r_Change.Change_Id,
                             i_Manager_Note => v_Manager_Note,
                             i_User_Id      => Ui.User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Deny(p Hashmap) is
    r_Change       Htt_Plan_Changes%rowtype;
    v_Change_Ids   Array_Number := Fazo.Sort(p.r_Array_Number('change_id'));
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Deny(i_Company_Id   => r_Change.Company_Id,
                          i_Filial_Id    => r_Change.Filial_Id,
                          i_Change_Id    => r_Change.Change_Id,
                          i_Manager_Note => v_Manager_Note);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Complete(p Hashmap) is
    r_Change     Htt_Plan_Changes%rowtype;
    v_Change_Ids Array_Number := Fazo.Sort(p.r_Array_Number('change_id'));
  begin
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Complete(i_Company_Id => r_Change.Company_Id,
                              i_Filial_Id  => r_Change.Filial_Id,
                              i_Change_Id  => r_Change.Change_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Cancel(p Hashmap) is
    r_Change     Htt_Plan_Changes%rowtype;
    v_Change_Ids Array_Number := Fazo.Sort(p.r_Array_Number('change_id'));
  begin
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Change_Deny(i_Company_Id => r_Change.Company_Id,
                          i_Filial_Id  => r_Change.Filial_Id,
                          i_Change_Id  => r_Change.Change_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Delete(p Hashmap) is
    r_Change     Htt_Plan_Changes%rowtype;
    v_Change_Ids Array_Number := Fazo.Sort(p.r_Array_Number('change_id'));
  begin
    for i in 1 .. v_Change_Ids.Count
    loop
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_Change_Id  => v_Change_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id, i_Undirect => false);
    
      Htt_Api.Change_Delete(i_Company_Id => r_Change.Company_Id,
                            i_Filial_Id  => r_Change.Filial_Id,
                            i_Change_Id  => r_Change.Change_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Timesheet(p Hashmap) return Hashmap is
    r_Timesheet Htt_Timesheets%rowtype;
    result      Hashmap;
  begin
    r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Staff_Id       => p.r_Number('staff_id'),
                                      i_Timesheet_Date => p.r_Date('timesheet_date'));
  
    result := z_Htt_Timesheets.To_Map(r_Timesheet,
                                      z.Timesheet_Date,
                                      z.Timesheet_Date,
                                      z.Day_Kind,
                                      z.Break_Enabled,
                                      z.Plan_Time);
  
    Result.Put('begin_time', to_char(r_Timesheet.Begin_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('end_time', to_char(r_Timesheet.End_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('break_begin_time',
               to_char(r_Timesheet.Break_Begin_Time, Href_Pref.c_Time_Format_Minute));
    Result.Put('break_end_time',
               to_char(r_Timesheet.Break_End_Time, Href_Pref.c_Time_Format_Minute));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Change(p Hashmap) return Arraylist is
    result        Matrix_Varchar2;
    v_Change_Date varchar2(10);
  begin
    select Array_Varchar2(q.Change_Date,
                          q.Day_Kind,
                          to_char(q.Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(q.End_Time, Href_Pref.c_Time_Format_Minute),
                          q.Break_Enabled,
                          to_char(q.Break_Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(q.Break_End_Time, Href_Pref.c_Time_Format_Minute),
                          q.Plan_Time,
                          q.Full_Time)
      bulk collect
      into result
      from Htt_Change_Days q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Change_Id = p.r_Number('change_id');
  
    if p.r_Varchar2('change_kind') = Htt_Pref.c_Change_Kind_Swap then
      v_Change_Date := result(1) (1);
      result(1)(1) := result(2) (1);
      result(2)(1) := v_Change_Date;
    end if;
  
    return Fazo.Zip_Matrix(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Plan_Changes
       set Company_Id   = null,
           Filial_Id    = null,
           Change_Id    = null,
           Staff_Id     = null,
           Change_Kind  = null,
           Manager_Note = null,
           Note         = null,
           Status       = null,
           Approved_By  = null,
           Completed_By = null,
           Created_By   = null,
           Created_On   = null,
           Modified_By  = null,
           Modified_On  = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Employee_Id = null,
           Division_Id = null,
           Org_Unit_Id = null,
           State       = null;
    update Md_Users
       set Company_Id  = null,
           User_Id     = null,
           name        = null,
           Created_By  = null,
           Modified_By = null;
    update Htt_Change_Days
       set Company_Id       = null,
           Filial_Id        = null,
           Change_Id        = null,
           Change_Date      = null,
           Day_Kind         = null,
           Begin_Time       = null,
           End_Time         = null,
           Break_Enabled    = null,
           Break_Begin_Time = null,
           Break_End_Time   = null,
           Plan_Time        = null,
           Full_Time        = null;
    update Htt_Change_Days
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Change_Date = null,
           Change_Id   = null,
           Day_Kind    = null;
    update Htt_Timesheets
       set Company_Id     = null,
           Filial_Id      = null,
           Timesheet_Date = null,
           Staff_Id       = null,
           Schedule_Id    = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           Use_Weights = null;
    update Htt_Change_Day_Weights
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Change_Id   = null,
           Change_Date = null;
  end;

end Ui_Vhr335;
/
