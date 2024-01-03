create or replace package Ui_Vhr216 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Personal_Changes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Changes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
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
end Ui_Vhr216;
/
create or replace package body Ui_Vhr216 is
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
    return b.Translate('UI-VHR216:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query(i_Personal boolean := false) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select q.*,
                       w.employee_id,
                       w.division_id,
                       w.org_unit_id,
                       w.job_id,
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
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'user_id',
                             Ui.User_Id,
                             'nls_language',
                             Htt_Util.Get_Nls_Language,
                             'dk_work',
                             Htt_Pref.c_Day_Kind_Work,
                             'chk_swap',
                             Htt_Pref.c_Change_Kind_Swap);
  
    if i_Personal then
      v_Query := v_Query || ' and w.employee_id = :user_id';
    
      v_Query := 'select qr.*, :access_level_personal access_level 
                    from (' || v_Query || ') qr';
    
      v_Params.Put('access_level_personal', Href_Pref.c_User_Access_Level_Personal);
    else
      v_Query := v_Query || ' and w.employee_id <> :user_id';
    
      v_Query := Uit_Href.Make_Subordinated_Query(i_Query            => v_Query,
                                                  i_Include_Undirect => false,
                                                  i_Include_Manual   => true);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('change_id',
                   'staff_id',
                   'division_id',
                   'job_id',
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
  
    if not i_Personal then
      v_Query := 'select q.staff_id,
                         (select p.name
                            from mr_natural_persons p
                           where p.company_id = :company_id
                             and p.person_id = q.employee_id) name,
                         q.employee_id,
                         q.division_id,
                         q.org_unit_id
                    from href_staffs q
                   where q.company_id = :company_id
                     and q.filial_id = :filial_id
                     and q.employee_id <> :user_id';
    
      q.Refer_Field('staff_name',
                    'staff_id',
                    'select q.staff_id,
                            (select p.name
                               from mr_natural_persons p
                              where p.company_id = :company_id
                                and p.person_id = q.employee_id) name
                       from href_staffs q',
                    'staff_id',
                    'name',
                    Uit_Href.Make_Subordinated_Query(i_Query            => v_Query,
                                                     i_Include_Undirect => false,
                                                     i_Include_Manual   => true));
      q.Refer_Field('division_name',
                    'division_id',
                    Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                    'division_id',
                    'name',
                    Uit_Hrm.Departments_Query);
      q.Refer_Field('job_name',
                    'job_id',
                    'mhr_jobs',
                    'job_id',
                    'name',
                    'select * 
                       from mhr_jobs d 
                      where d.company_id = :company_id 
                        and d.filial_id = :filial_id
                        and d.state = ''A''');
    end if;
  
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
  Function Query_Personal_Changes return Fazo_Query is
  begin
    return Query(true);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Changes return Fazo_Query is
  begin
    return Query;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Personal_Timesheet_Exists return varchar2 is
    v_Dummy    varchar2(1);
    v_Staff_Id number := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                        i_Filial_Id   => Ui.Filial_Id,
                                                        i_Employee_Id => Ui.User_Id);
  begin
    select 'x'
      into v_Dummy
      from Htt_Timesheets q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Staff_Id = v_Staff_Id
       and Rownum = 1;
  
    return 'Y';
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('ual_personal',
                        Href_Pref.c_User_Access_Level_Personal,
                        'ual_direct_employee',
                        Href_Pref.c_User_Access_Level_Direct_Employee,
                        'access_all_employee',
                        Uit_Href.User_Access_All_Employees,
                        'personal_timesheet_exists',
                        Personal_Timesheet_Exists);
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
           Org_Unit_Id = null,
           State       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null,
           Parent_Id   = null,
           State       = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
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

end Ui_Vhr216;
/
