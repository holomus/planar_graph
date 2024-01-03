create or replace package Ui_Vhr74 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Time_Kinds return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Settings(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr74;
/
create or replace package body Ui_Vhr74 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Current_Filial boolean := false;
    v_Query          varchar2(32767);
    v_Params         Hashmap;
    v_Month          date := p.o_Date('month', Href_Pref.c_Date_Format_Month);
    q                Fazo_Query;
  
    v_User_Access_All_Employees varchar(1 char) := Uit_Href.User_Access_All_Employees;
  begin
    v_Query := 'select w.*,
                       nvl((select s.facts_changed
                              from hpr_timesheet_locks q
                              join htt_timesheet_locks s
                                on s.company_id = q.company_id
                               and s.filial_id = q.filial_id
                               and s.staff_id = q.staff_id
                               and s.timesheet_date = q.timesheet_date
                               and s.facts_changed = ''Y''
                             where q.company_id = w.company_id
                               and q.filial_id = w.filial_id
                               and q.timebook_id = w.timebook_id
                               and rownum = 1), ''N'') facts_changed 
                  from hpr_timebooks w 
                 where w.company_id = :company_id
                   and (:month is null or w.month = :month)';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'month',
                             v_Month,
                             'user_access_all_employees',
                             v_User_Access_All_Employees);
  
    if not Ui.Is_Filial_Head then
      v_Current_Filial := true;
      v_Query          := v_Query || ' and w.filial_id = :filial_id';
    
      v_Params.Put('filial_id', Ui.Filial_Id);
    end if;
  
    if v_User_Access_All_Employees = 'N' then
      v_Query := v_Query ||
                 '   and exists (select 1
                                   from hpr_timebook_staffs ts
                                   join href_staffs sf 
                                     on sf.company_id = ts.company_id
                                    and sf.filial_id = ts.filial_id
                                    and sf.staff_id = ts.staff_id
                                   join hpd_agreements_cache ac
                                     on ac.company_id = sf.company_Id
                                    and ac.filial_id = sf.filial_id
                                    and ac.staff_id = sf.staff_id
                                    and least(w.period_end, nvl(sf.dismissal_date, w.period_end)) 
                                        between ac.begin_date and ac.end_date
                                   join hrm_robots rb
                                     on rb.company_id = ac.company_id
                                    and rb.filial_id = ac.filial_id
                                    and rb.robot_id = ac.robot_id
                                  where ts.company_id = w.company_id
                                    and ts.filial_id = w.filial_id
                                    and ts.timebook_id = w.timebook_id
                                    and rb.org_unit_id member of :division_ids) ';
    
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    else
      v_Params.Put('division_ids', Array_Number());
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('filial_id', 'timebook_id', 'division_id', 'created_by', 'modified_by');
    q.Varchar2_Field('timebook_number', 'posted', 'note', 'barcode', 'facts_changed');
    q.Date_Field('timebook_date',
                 'month',
                 'period_begin',
                 'period_end',
                 'created_on',
                 'modified_on');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id');
  
    v_Query := Uit_Hrm.Departments_Query(i_Current_Filial => v_Current_Filial);
  
    if v_User_Access_All_Employees = 'N' then
      v_Query := 'select qr.* from (' || v_Query ||
                 ') qr where qr.division_id member of :division_ids ';
    end if;
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Current_Filial   => v_Current_Filial,
                                          i_Only_Departments => false),
                  'division_id',
                  'name',
                  v_Query);
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('facts_changed_name',
                   'facts_changed',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    if Ui.Is_Filial_Head then
      q.Refer_Field('filial_name',
                    'filial_id',
                    'md_filials',
                    'filial_id',
                    'name',
                    'select *
                       from md_filials t
                      where t.company_id = :company_id');
    else
      q.Map_Field('filial_name', 'null');
      q.Grid_Column_Label('filial_name', '');
    end if;
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Time_Kinds return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select * 
                       from htt_time_kinds q 
                      where q.company_id = :company_id 
                        and q.pcode is not null 
                        and q.parent_id is null 
                        and q.state = ''A''',
                    Fazo.Zip_Map('company_id', Ui.Company_Id));
  
    q.Number_Field('time_kind_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Settings(p Hashmap) is
  begin
    Hpr_Api.Timebook_Fill_Setting_Save(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Settings   => p.r_Varchar2('settings'));
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Easy_Report_Forms return Matrix_Varchar2 is
    v_Forms     Array_Varchar2 := Array_Varchar2(Hpr_Pref.c_Easy_Report_Form_Timebook);
    v_Templates Matrix_Varchar2;
    result      Matrix_Varchar2 := Matrix_Varchar2();
  begin
    for i in 1 .. v_Forms.Count
    loop
      continue when not Md_Util.Grant_Has_Form(i_Company_Id   => Ui.Company_Id,
                                               i_Project_Code => Ui.Project_Code,
                                               i_Filial_Id    => Ui.Filial_Id,
                                               i_User_Id      => Ui.User_Id,
                                               i_Form         => v_Forms(i));
    
      v_Templates := Uit_Ker.Templates(i_Form => v_Forms(i));
    
      for j in 1 .. v_Templates.Count
      loop
        Result.Extend();
        result(Result.Count) := v_Templates(j);
      end loop;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Settings return Hashmap is
    v_Company_Id    number := Ui.Company_Id;
    v_Time_Kind_Ids Array_Number;
    v_Time_Kinds    Arraylist := Arraylist();
    v_Time_Kind     Hashmap;
    r_Time_Kind     Htt_Time_Kinds%rowtype;
    result          Hashmap;
  begin
    result := Hpr_Util.Load_Timebook_Fill_Settings(i_Company_Id => v_Company_Id,
                                                   i_Filial_Id  => Ui.Filial_Id);
  
    v_Time_Kind_Ids := Nvl(Result.o_Array_Number('time_kind_ids'), Array_Number());
  
    for i in 1 .. v_Time_Kind_Ids.Count
    loop
      v_Time_Kind := Hashmap();
    
      if z_Htt_Time_Kinds.Exist(i_Company_Id   => v_Company_Id,
                                i_Time_Kind_Id => v_Time_Kind_Ids(i),
                                o_Row          => r_Time_Kind) then
        v_Time_Kind.Put('time_kind_id', r_Time_Kind.Time_Kind_Id);
        v_Time_Kind.Put('name', r_Time_Kind.Name);
      
        v_Time_Kinds.Push(v_Time_Kind);
      end if;
    end loop;
  
    Result.Put('time_kinds', v_Time_Kinds);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('reports', Fazo.Zip_Matrix(Easy_Report_Forms));
    Result.Put_All(Load_Settings);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_User_Id      number := Ui.User_Id;
    r_Timebook     Hpr_Timebooks%rowtype;
    v_Timebook_Ids Array_Number := Fazo.Sort(p.r_Array_Number('timebook_id'));
  begin
    for i in 1 .. v_Timebook_Ids.Count
    loop
      Hpr_Api.Timebook_Post(i_Company_Id  => v_Company_Id,
                            i_Filial_Id   => v_Filial_Id,
                            i_Timebook_Id => v_Timebook_Ids(i));
    
      r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => v_Company_Id,
                                         i_Filial_Id   => v_Filial_Id,
                                         i_Timebook_Id => v_Timebook_Ids(i));
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpr_Util.t_Notification_Title_Timebook_Post(i_Company_Id      => v_Company_Id,
                                                                                                 i_User_Id         => v_User_Id,
                                                                                                 i_Timebook_Number => r_Timebook.Timebook_Number,
                                                                                                 i_Month           => r_Timebook.Month),
                                  i_Uri           => Hpr_Pref.c_Form_Timebook_View,
                                  i_Uri_Param     => Fazo.Zip_Map('timebook_id', v_Timebook_Ids(i)),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_User_Id      number := Ui.User_Id;
    r_Timebook     Hpr_Timebooks%rowtype;
    v_Timebook_Ids Array_Number := Fazo.Sort(p.r_Array_Number('timebook_id'));
  begin
    for i in 1 .. v_Timebook_Ids.Count
    loop
      Hpr_Api.Timebook_Unpost(i_Company_Id  => v_Company_Id,
                              i_Filial_Id   => v_Filial_Id,
                              i_Timebook_Id => v_Timebook_Ids(i));
    
      r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => v_Company_Id,
                                         i_Filial_Id   => v_Filial_Id,
                                         i_Timebook_Id => v_Timebook_Ids(i));
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpr_Util.t_Notification_Title_Timebook_Unpost(i_Company_Id      => v_Company_Id,
                                                                                                   i_User_Id         => v_User_Id,
                                                                                                   i_Timebook_Number => r_Timebook.Timebook_Number,
                                                                                                   i_Month           => r_Timebook.Month),
                                  i_Uri           => Hpr_Pref.c_Form_Timebook_View,
                                  i_Uri_Param     => Fazo.Zip_Map('timebook_id', v_Timebook_Ids(i)),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_User_Id      number := Ui.User_Id;
    r_Timebook     Hpr_Timebooks%rowtype;
    v_Timebook_Ids Array_Number := Fazo.Sort(p.r_Array_Number('timebook_id'));
  begin
    for i in 1 .. v_Timebook_Ids.Count
    loop
      r_Timebook := z_Hpr_Timebooks.Load(i_Company_Id  => v_Company_Id,
                                         i_Filial_Id   => v_Filial_Id,
                                         i_Timebook_Id => v_Timebook_Ids(i));
    
      Hpr_Api.Timebook_Delete(i_Company_Id  => v_Company_Id,
                              i_Filial_Id   => v_Filial_Id,
                              i_Timebook_Id => v_Timebook_Ids(i));
    
      Href_Core.Send_Notification(i_Company_Id    => v_Company_Id,
                                  i_Filial_Id     => v_Filial_Id,
                                  i_Title         => Hpr_Util.t_Notification_Title_Timebook_Delete(i_Company_Id      => v_Company_Id,
                                                                                                   i_User_Id         => v_User_Id,
                                                                                                   i_Timebook_Number => r_Timebook.Timebook_Number,
                                                                                                   i_Month           => r_Timebook.Month),
                                  i_Uri           => Hpr_Pref.c_Form_Timebook_View,
                                  i_Uri_Param     => Fazo.Zip_Map('timebook_id', v_Timebook_Ids(i)),
                                  i_Check_Setting => true,
                                  i_User_Id       => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hpr_Timebooks
       set Company_Id    = null,
           Filial_Id     = null,
           Timebook_Id   = null,
           Timebook_Date = null,
           Division_Id   = null,
           month         = null,
           Period_Begin  = null,
           Period_End    = null,
           Period_Kind   = null,
           Posted        = null,
           Note          = null,
           Barcode       = null,
           Created_By    = null,
           Created_On    = null,
           Modified_By   = null,
           Modified_On   = null;
    update Hpr_Timesheet_Locks
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Timesheet_Date = null,
           Timebook_Id    = null;
    update Htt_Timesheet_Locks
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Timesheet_Date = null,
           Facts_Changed  = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           name        = null;
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           name         = null,
           Parent_Id    = null,
           State        = null,
           Pcode        = null;
    update Hpr_Timebook_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Timebook_Id = null,
           Division_Id = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Org_Unit_Id = null;
    update Hpd_Agreements_Cache
       set Company_Id = null,
           Filial_Id  = null,
           Staff_Id   = null,
           Robot_Id   = null,
           Begin_Date = null,
           End_Date   = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Org_Unit_Id = null;
  end;

end Ui_Vhr74;
/
