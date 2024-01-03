create or replace package Ui_Vhr332 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Unchecked(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Checked(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Kinds(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Accruals(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Limits(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Function Get_Request_Info(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Cancel(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Delete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Reset(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap);
end Ui_Vhr332;
/
create or replace package body Ui_Vhr332 is
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
                       q.created_on request_date
                  from htt_requests q
                  join href_staffs w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.staff_id = q.staff_id
                   and w.state = ''A''
                   and w.staff_kind = :staff_kind_primary
                 where w.company_id = :company_id
                   and w.filial_id = :filial_id
                   and w.employee_id = :employee_id';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'employee_id',
                             v_Employee_Id,
                             'staff_kind_primary',
                             Href_Pref.c_Staff_Kind_Primary);
  
    if i_Unchecked then
      v_Query := v_Query || ' 
      and (q.status = ''N'' or q.status = ''A'')';
    else
      v_Query := v_Query || ' 
      and (q.status = ''D'' or q.status = ''C'')';
    end if;
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('request_id',
                   'request_kind_id',
                   'staff_id',
                   'approved_by',
                   'completed_by',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('request_type',
                     'manager_note',
                     'note',
                     'status',
                     'barcode',
                     'access_level',
                     'accrual_kind');
    q.Date_Field('begin_time', 'end_time', 'created_on', 'modified_on', 'request_date');
  
    q.Refer_Field('request_kind_name',
                  'request_kind_id',
                  'htt_request_kinds',
                  'request_kind_id',
                  'name',
                  'select *
                     from htt_request_kinds
                    where company_id = :company_id');
  
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
  
    v_Matrix := Htt_Util.Request_Types;
    q.Option_Field('request_type_name', 'request_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Request_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.User_Acces_Levels;
    q.Option_Field('access_level_name', 'access_level', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Accrual_Kinds;
    q.Option_Field('accrual_kind_name', 'accrual_kind', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('request_time',
                'htt_util.request_time(i_request_type => $request_type,
                                       i_begin_time   => $begin_time,
                                       i_end_time     => $end_time)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Unchecked(p Hashmap) return Fazo_Query is
  begin
    return Query(p, true);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Checked(p Hashmap) return Fazo_Query is
  begin
    return Query(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Kinds(p Hashmap) return Fazo_Query is
    v_Staff_Id number := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Employee_Id => p.r_Number('employee_id'));
  
    q Fazo_Query;
  begin
    q := Fazo_Query('select p.*
                       from htt_request_kinds p
                      where p.company_id = :company_id
                        and p.state = :state
                        and (p.request_kind_id in 
                            (select rk.request_kind_id
                               from htt_staff_request_kinds rk
                              where rk.company_id = :company_id
                                and rk.filial_id = :filial_id
                                and rk.staff_id = :staff_id) 
                            or not exists 
                           (select 1
                              from htt_staff_request_kinds k
                             where k.company_id = p.company_id
                               and k.request_kind_id = p.request_kind_id
                               and exists
                           (select 1
                              from href_staffs q
                             where q.company_id = k.company_id
                               and q.filial_id = k.filial_id
                               and q.staff_id = k.staff_id
                               and q.state = ''A''
                               and q.hiring_date <= :curr_date
                               and (q.dismissal_date is null 
                                or q.dismissal_date >= :curr_date))))',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'staff_id',
                                 v_Staff_Id,
                                 'curr_date',
                                 Trunc(sysdate),
                                 'state',
                                 'A'));
  
    q.Number_Field('request_kind_id', 'time_kind_id');
    q.Varchar2_Field('name', 'user_permitted', 'annually_limited');
  
    q.Refer_Field('plan_load',
                  'time_kind_id',
                  'htt_time_kinds',
                  'time_kind_id',
                  'plan_load',
                  'select *
                     from htt_time_kinds s
                    where s.company_id = :company_id');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query_Accruals(p Hashmap) return Fazo_Query is
    v_Employee_Id number := p.r_Number('employee_id');
    v_Staff_Id    number := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                           i_Filial_Id   => Ui.Filial_Id,
                                                           i_Employee_Id => v_Employee_Id);
  
    v_Count_Condition varchar2(32767);
    v_Days_Query      varchar2(32767);
    v_Query           varchar2(32767);
    v_Matrix          Matrix_Varchar2;
    v_Params          Hashmap;
    q                 Fazo_Query;
  begin
    v_Days_Query := 'select rh.interval_date
                       from htt_requests rq
                       join htt_request_helpers rh
                         on rh.company_id = rq.company_id
                        and rh.filial_id = rq.filial_id
                        and rh.staff_id = rq.staff_id
                        and rh.interval_date between trunc(q.period, ''yyyy'') and q.period
                        and rh.request_id = rq.request_id
                      where rq.company_id = q.company_id
                        and rq.filial_id = q.filial_id
                        and rq.staff_id = q.staff_id
                        and rq.request_kind_id = q.request_kind_id
                        and rq.accrual_kind = q.accrual_kind
                        and rq.status = :status_completed';
  
    -- when day count type is calendar days
    v_Count_Condition := ' p.day_count_type = :count_type_calendar ';
  
    -- when day count type is work days
    v_Count_Condition := v_Count_Condition ||
                         ' or p.day_count_type = :count_type_working 
                          and exists
                             (select 1
                                from htt_timesheets k
                               where k.company_id = rh.company_id
                                 and k.filial_id = rh.filial_id
                                 and k.staff_id = rh.staff_id
                                 and k.timesheet_date = rh.interval_date
                                 and k.day_kind = :day_kind_work) ';
  
    -- when day count type is production days                     
    v_Count_Condition := v_Count_Condition ||
                         ' or p.day_count_type = :count_type_production 
                          and exists
                             (select 1
                                from htt_timesheets k
                               where k.company_id = rh.company_id
                                 and k.filial_id = rh.filial_id
                                 and k.staff_id = rh.staff_id
                                 and k.timesheet_date = rh.interval_date
                                 and k.day_kind in (:day_kind_work,
                                                    :day_kind_rest,
                                                    :day_kind_nonworking)
                                 and not exists
                             (select 1
                                from htt_calendar_rest_days rd
                               where rd.company_id = k.company_id
                                 and rd.filial_id = k.filial_id
                                 and rd.calendar_id = nvl(k.calendar_id, :calendar_id)
                                 and rd.week_day_no =
                                     (trunc(k.timesheet_date) - trunc(k.timesheet_date, ''iw'') + 1))) ';
  
    -- adding days count condition
    v_Days_Query := v_Days_Query || ' and ( ' || v_Count_Condition || ' ) ';
  
    -- leaving only unique request days
    v_Days_Query := v_Days_Query || ' group by rh.interval_date ';
  
    -- counting days
    v_Days_Query := ' select count(*) from ( ' || v_Days_Query || ' ) ';
  
    v_Query := 'select q.request_kind_id,
                       p.name request_kind_name,
                       trunc(q.period, ''yyyy'') period_begin,
                       q.period period_end,
                       q.accrual_kind,
                       q.accrued_days, ( ' --
               || v_Days_Query || ' ) used_days
                  from htt_request_kind_accruals q
                  join htt_request_kinds p
                    on p.company_id = q.company_id
                   and p.request_kind_id = q.request_kind_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.staff_id = :staff_id
                   and p.state = ''A''';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'staff_id',
                             v_Staff_Id,
                             'calendar_id',
                             Htt_Util.Default_Calendar_Id(i_Company_Id => Ui.Company_Id,
                                                          i_Filial_Id  => Ui.Filial_Id),
                             'status_completed',
                             Htt_Pref.c_Request_Status_Completed);
  
    v_Params.Put('day_kind_work', Htt_Pref.c_Day_Kind_Work);
    v_Params.Put('day_kind_rest', Htt_Pref.c_Day_Kind_Rest);
    v_Params.Put('day_kind_nonworking', Htt_Pref.c_Day_Kind_Nonworking);
  
    v_Params.Put('count_type_calendar', Htt_Pref.c_Day_Count_Type_Calendar_Days);
    v_Params.Put('count_type_working', Htt_Pref.c_Day_Count_Type_Work_Days);
    v_Params.Put('count_type_production', Htt_Pref.c_Day_Count_Type_Production_Days);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Varchar2_Field('request_kind_name', 'accrual_kind');
    q.Number_Field('request_kind_id', 'accrued_days', 'used_days');
    q.Date_Field('period_begin', 'period_end');
  
    v_Matrix := Htt_Util.Accrual_Kinds;
    q.Option_Field('accrual_kind_name', 'accrual_kind', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('left_days', '$accrued_days - $used_days');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Limits(p Hashmap) return Arraylist is
    v_Staff_Id number := Coalesce(p.o_Number('staff_id'),
                                  Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                                 i_Filial_Id   => Ui.Filial_Id,
                                                                 i_Employee_Id => p.r_Number('employee_id')));
  begin
    return Uit_Htt.Load_Request_Limits(i_Staff_Id        => v_Staff_Id,
                                       i_Request_Kind_Id => p.r_Number('request_kind_id'),
                                       i_Period_Begin    => p.r_Date('begin_date'),
                                       i_Period_End      => p.r_Date('end_date'),
                                       i_Request_Id      => p.o_Number('request_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Request_Info(p Hashmap) return Hashmap is
    v_Request_Kind_Id number := p.r_Number('request_kind_id');
    r_Request_Kind    Htt_Request_Kinds%rowtype;
    result            Hashmap := Hashmap();
  begin
    r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => Ui.Company_Id,
                                               i_Request_Kind_Id => v_Request_Kind_Id);
  
    Result.Put('plan_load',
               z_Htt_Time_Kinds.Load(i_Company_Id => Ui.Company_Id, i_Time_Kind_Id => r_Request_Kind.Time_Kind_Id).Plan_Load);
    Result.Put('annually_limited', r_Request_Kind.Annually_Limited);
    Result.Put('accruals',
               Uit_Htt.Load_Request_Limits(i_Staff_Id        => p.r_Number('staff_id'),
                                           i_Request_Kind_Id => v_Request_Kind_Id,
                                           i_Period_Begin    => p.r_Date('begin_time'),
                                           i_Period_End      => p.r_Date('end_time'),
                                           i_Request_Id      => p.r_Number('request_id')));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Request
  (
    i_Request_Id number,
    p            Hashmap
  ) is
    v_Begin_Time  date;
    v_End_Time    date;
    r_Request     Htt_Requests%rowtype;
    v_Employee_Id number := p.r_Number('employee_id');
  begin
    Uit_Href.Assert_Access_To_Employee(v_Employee_Id);
  
    case p.r_Varchar2('request_type')
      when Htt_Pref.c_Request_Type_Part_Of_Day then
        v_Begin_Time := to_date(p.r_Varchar2('begin_date') || ' ' || p.r_Varchar2('begin_time'),
                                Href_Pref.c_Date_Format_Minute);
        v_End_Time   := to_date(p.r_Varchar2('begin_date') || ' ' || p.r_Varchar2('end_time'),
                                Href_Pref.c_Date_Format_Minute);
      
        if v_End_Time < v_Begin_Time then
          v_End_Time := v_End_Time + 1;
        end if;
      when Htt_Pref.c_Request_Type_Full_Day then
        v_Begin_Time := p.r_Date('begin_date');
        v_End_Time   := v_Begin_Time;
      else
        v_Begin_Time := p.r_Date('begin_date');
        v_End_Time   := p.r_Date('end_date');
    end case;
  
    r_Request := z_Htt_Requests.To_Row(p, z.Request_Kind_Id, z.Request_Type, z.Note, z.Accrual_Kind);
  
    r_Request.Company_Id := Ui.Company_Id;
    r_Request.Filial_Id  := Ui.Filial_Id;
    r_Request.Request_Id := i_Request_Id;
    r_Request.Begin_Time := v_Begin_Time;
    r_Request.End_Time   := v_End_Time;
    r_Request.Staff_Id   := Href_Util.Get_Primary_Staff_Id(i_Company_Id   => Ui.Company_Id,
                                                           i_Filial_Id    => Ui.Filial_Id,
                                                           i_Employee_Id  => v_Employee_Id,
                                                           i_Period_Begin => Trunc(v_Begin_Time),
                                                           i_Period_End   => Trunc(v_End_Time));
  
    Htt_Api.Request_Save(r_Request);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    Save_Request(Htt_Next.Request_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Request_Id => p.r_Number('request_id'));
  
    Save_Request(r_Request.Request_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Note_Is_Required varchar2(1) := Href_Util.Request_Note_Is_Required(Ui.Company_Id);
    result             Hashmap := Hashmap();
  begin
    result := Fazo.Zip_Map('request_type_part_of_day',
                           Htt_Pref.c_Request_Type_Part_Of_Day,
                           'request_type_full_day',
                           Htt_Pref.c_Request_Type_Full_Day,
                           'request_type_multiple_days',
                           Htt_Pref.c_Request_Type_Multiple_Days);
    Result.Put('plan_load_part', Htt_Pref.c_Plan_Load_Part);
    Result.Put('plan_load_full', Htt_Pref.c_Plan_Load_Full);
    Result.Put('plan_load_extra', Htt_Pref.c_Plan_Load_Extra);
    Result.Put('request_types', Fazo.Zip_Matrix_Transposed(Htt_Util.Request_Types));
    Result.Put('accrual_kind_plan', Htt_Pref.c_Accrual_Kind_Plan);
    Result.Put('accrual_kind_carryover', Htt_Pref.c_Accrual_Kind_Carryover);
    Result.Put_All(Fazo.Zip_Map('ual_personal',
                                Href_Pref.c_User_Access_Level_Personal,
                                'ual_direct_employee',
                                Href_Pref.c_User_Access_Level_Direct_Employee,
                                'access_all_employee',
                                Uit_Href.User_Access_All_Employees,
                                'note_is_required',
                                v_Note_Is_Required));
  
    if v_Note_Is_Required = 'Y' then
      Result.Put('note_limit', Href_Util.Load_Request_Note_Limit(Ui.Company_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Employee_Id number := p.r_Number('employee_id');
    result        Hashmap := Hashmap();
  begin
    Uit_Href.Assert_Access_To_Employee(p.r_Number('employee_id'));
  
    Result.Put('employee_id', v_Employee_Id);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve(p Hashmap) is
    r_Request      Htt_Requests%rowtype;
    v_Request_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('request_id'));
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Approve(i_Company_Id   => r_Request.Company_Id,
                              i_Filial_Id    => r_Request.Filial_Id,
                              i_Request_Id   => r_Request.Request_Id,
                              i_Manager_Note => v_Manager_Note,
                              i_User_Id      => Ui.User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny(p Hashmap) is
    r_Request      Htt_Requests%rowtype;
    v_Request_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('request_id'));
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Deny(i_Company_Id   => r_Request.Company_Id,
                           i_Filial_Id    => r_Request.Filial_Id,
                           i_Request_Id   => r_Request.Request_Id,
                           i_Manager_Note => v_Manager_Note);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete(p Hashmap) is
    r_Request     Htt_Requests%rowtype;
    v_Request_Ids Array_Number := Fazo.Sort(p.r_Array_Number('request_id'));
  begin
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Complete(i_Company_Id => r_Request.Company_Id,
                               i_Filial_Id  => r_Request.Filial_Id,
                               i_Request_Id => r_Request.Request_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Cancel(p Hashmap) is
    r_Request     Htt_Requests%rowtype;
    v_Request_Ids Array_Number := Fazo.Sort(p.r_Array_Number('request_id'));
  begin
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Deny(i_Company_Id => r_Request.Company_Id,
                           i_Filial_Id  => r_Request.Filial_Id,
                           i_Request_Id => r_Request.Request_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Delete(p Hashmap) is
    r_Request     Htt_Requests%rowtype;
    v_Request_Ids Array_Number := Fazo.Sort(p.r_Array_Number('request_id'));
  begin
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id, i_Undirect => false);
    
      Htt_Api.Request_Delete(i_Company_Id => r_Request.Company_Id,
                             i_Filial_Id  => r_Request.Filial_Id,
                             i_Request_Id => r_Request.Request_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Request_Reset(p Hashmap) is
    r_Request     Htt_Requests%rowtype;
    v_Request_Ids Array_Number := Fazo.Sort(p.r_Array_Number('request_id'));
  begin
    for i in 1 .. v_Request_Ids.Count
    loop
      r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                            i_Filial_Id  => Ui.Filial_Id,
                                            i_Request_Id => v_Request_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                      i_Self     => false,
                                      i_Undirect => false);
    
      Htt_Api.Request_Reset(i_Company_Id => r_Request.Company_Id,
                            i_Filial_Id  => r_Request.Filial_Id,
                            i_Request_Id => r_Request.Request_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Run(p Hashmap) is
  begin
    Ui_Vhr122.Run(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Division_Id    = null,
           Org_Unit_Id    = null,
           Employee_Id    = null,
           Staff_Kind     = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Htt_Requests
       set Company_Id      = null,
           Filial_Id       = null,
           Request_Id      = null,
           Request_Kind_Id = null,
           Staff_Id        = null,
           Begin_Time      = null,
           End_Time        = null,
           Request_Type    = null,
           Manager_Note    = null,
           Note            = null,
           Status          = null,
           Accrual_Kind    = null,
           Barcode         = null,
           Approved_By     = null,
           Completed_By    = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null,
           Created_By = null;
    update Htt_Request_Kinds
       set Company_Id      = null,
           Request_Kind_Id = null,
           name            = null,
           State           = null;
    update Htt_Staff_Request_Kinds
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Request_Kind_Id = null;
    update Htt_Request_Kind_Accruals
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Request_Kind_Id = null,
           Period          = null,
           Accrual_Kind    = null,
           Accrued_Days    = null;
    update Htt_Request_Helpers
       set Company_Id    = null,
           Filial_Id     = null,
           Staff_Id      = null,
           Interval_Date = null,
           Request_Id    = null;
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           Plan_Load    = null;
    update Htt_Timesheets
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Timesheet_Date = null,
           Calendar_Id    = null,
           Day_Kind       = null;
    update Htt_Calendar_Rest_Days
       set Company_Id  = null,
           Filial_Id   = null,
           Calendar_Id = null,
           Week_Day_No = null;
  
    Uie.x(Htt_Util.Request_Time(i_Request_Type => null, i_Begin_Time => null, i_End_Time => null));
  end;

end Ui_Vhr332;
/
