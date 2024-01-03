create or replace package Ui_Vhr628 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Available_Changes return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Director_Changes return Fazo_Query;
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
end Ui_Vhr628;
/
create or replace package body Ui_Vhr628 is
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
    return b.Translate('UI-VHR628:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(i_Directors boolean := false) return Fazo_Query is
    v_Query  varchar2(32700);
    v_Params Hashmap;
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2;
  begin
    v_Query := 'select q.*,
                       w.employee_id,
                       w.division_id,
                       w.org_unit_id,
                       w.job_id, 
                       q.created_on change_date
                  from htt_plan_changes q
                  join href_staffs w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.staff_id = q.staff_id
                   and w.state = ''A''';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'user_id',
                             Ui.User_Id,
                             'nls_language',
                             Htt_Util.Get_Nls_Language);
  
    if i_Directors then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from mrf_division_managers dv
                         where dv.company_id = w.company_id
                           and dv.filial_id = w.filial_id
                           and dv.manager_id = w.robot_id
                           and exists (select 1 
                                 from mhr_divisions d 
                                where d.company_id = dv.company_id
                                  and d.filial_id = dv.filial_id
                                  and d.division_id = dv.division_id
                                  and d.parent_id is null))
                 where q.company_id = :company_id';
    
      v_Query := 'select qr.*, :access_level_other access_level 
                    from (' || v_Query || ') qr';
    
      v_Params.Put('access_level_other', Href_Pref.c_User_Access_Level_Other);
    else
      v_Query := v_Query || --
                 ' where q.company_id = :company_id
                     and exists (select 1 
                            from md_user_filials mf 
                           where mf.company_id = :company_id
                             and mf.user_id = :user_id
                             and mf.filial_id = q.filial_id)';
    
      v_Query := Uit_Href.Make_Subordinated_Query(i_Query            => v_Query,
                                                  i_Include_Undirect => false,
                                                  i_Include_Manual   => true,
                                                  i_Is_Filial        => false);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('change_id',
                   'filial_id',
                   'staff_id',
                   'division_id',
                   'job_id',
                   'approved_by',
                   'completed_by',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('change_kind', 'manager_note', 'note', 'status', 'access_level');
    q.Date_Field('created_on', 'change_date', 'modified_on');
  
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
                                                   i_Include_Manual   => true,
                                                   i_Is_Filial        => false));
    q.Refer_Field('filial_name',
                  'filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials
                    where company_id = :company_id');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Current_Filial => false, i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query(i_Current_Filial => false));
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select * 
                       from mhr_jobs d 
                      where d.company_id = :company_id 
                        and d.state = ''A''');
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
  Function Query_Available_Changes return Fazo_Query is
  begin
    return Query;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Director_Changes return Fazo_Query is
  begin
    return Query(true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Reset(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    r_Change     Htt_Plan_Changes%rowtype;
    v_Changes    Arraylist := p.r_Arraylist('changes');
    v_Change     Hashmap;
  begin
    for i in 1 .. v_Changes.Count
    loop
      v_Change := Treat(v_Changes.r_Hashmap(i) as Hashmap);
    
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Change.r_Number('filial_id'),
                                               i_Change_Id  => v_Change.r_Number('change_id'));
    
      if Href_Util.Is_Director(i_Company_Id => r_Change.Company_Id,
                               i_Filial_Id  => r_Change.Filial_Id,
                               i_Staff_Id   => r_Change.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                        i_Self     => false,
                                        i_Undirect => false);
      end if;
    
      Htt_Api.Change_Reset(i_Company_Id => r_Change.Company_Id,
                           i_Filial_Id  => r_Change.Filial_Id,
                           i_Change_Id  => r_Change.Change_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Approve(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    r_Change       Htt_Plan_Changes%rowtype;
    v_Changes      Arraylist := p.r_Arraylist('changes');
    v_Change       Hashmap;
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    for i in 1 .. v_Changes.Count
    loop
      v_Change := Treat(v_Changes.r_Hashmap(i) as Hashmap);
    
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Change.r_Number('filial_id'),
                                               i_Change_Id  => v_Change.r_Number('change_id'));
    
      if Href_Util.Is_Director(i_Company_Id => r_Change.Company_Id,
                               i_Filial_Id  => r_Change.Filial_Id,
                               i_Staff_Id   => r_Change.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                        i_Self     => false,
                                        i_Undirect => false);
      end if;
    
      Htt_Api.Change_Approve(i_Company_Id   => r_Change.Company_Id,
                             i_Filial_Id    => r_Change.Filial_Id,
                             i_Change_Id    => r_Change.Change_Id,
                             i_Manager_Note => v_Manager_Note,
                             i_User_Id      => Ui.User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Deny(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    r_Change       Htt_Plan_Changes%rowtype;
    v_Changes      Arraylist := p.r_Arraylist('changes');
    v_Change       Hashmap;
    v_Manager_Note Htt_Requests.Manager_Note%type := p.o_Varchar2('manager_note');
  begin
    for i in 1 .. v_Changes.Count
    loop
      v_Change := Treat(v_Changes.r_Hashmap(i) as Hashmap);
    
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Change.r_Number('filial_id'),
                                               i_Change_Id  => v_Change.r_Number('change_id'));
    
      if Href_Util.Is_Director(i_Company_Id => r_Change.Company_Id,
                               i_Filial_Id  => r_Change.Filial_Id,
                               i_Staff_Id   => r_Change.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                        i_Self     => false,
                                        i_Undirect => false);
      end if;
    
      Htt_Api.Change_Deny(i_Company_Id   => r_Change.Company_Id,
                          i_Filial_Id    => r_Change.Filial_Id,
                          i_Change_Id    => r_Change.Change_Id,
                          i_Manager_Note => v_Manager_Note);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Complete(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    r_Change     Htt_Plan_Changes%rowtype;
    v_Changes    Arraylist := p.r_Arraylist('changes');
    v_Change     Hashmap;
  begin
    for i in 1 .. v_Changes.Count
    loop
      v_Change := Treat(v_Changes.r_Hashmap(i) as Hashmap);
    
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Change.r_Number('filial_id'),
                                               i_Change_Id  => v_Change.r_Number('change_id'));
    
      if Href_Util.Is_Director(i_Company_Id => r_Change.Company_Id,
                               i_Filial_Id  => r_Change.Filial_Id,
                               i_Staff_Id   => r_Change.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                        i_Self     => false,
                                        i_Undirect => false);
      end if;
    
      Htt_Api.Change_Complete(i_Company_Id => r_Change.Company_Id,
                              i_Filial_Id  => r_Change.Filial_Id,
                              i_Change_Id  => r_Change.Change_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Cancel(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    r_Change     Htt_Plan_Changes%rowtype;
    v_Changes    Arraylist := p.r_Arraylist('changes');
    v_Change     Hashmap;
  begin
    for i in 1 .. v_Changes.Count
    loop
      v_Change := Treat(v_Changes.r_Hashmap(i) as Hashmap);
    
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Change.r_Number('filial_id'),
                                               i_Change_Id  => v_Change.r_Number('change_id'));
    
      if Href_Util.Is_Director(i_Company_Id => r_Change.Company_Id,
                               i_Filial_Id  => r_Change.Filial_Id,
                               i_Staff_Id   => r_Change.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                        i_Self     => false,
                                        i_Undirect => false);
      end if;
    
      Htt_Api.Change_Deny(i_Company_Id => r_Change.Company_Id,
                          i_Filial_Id  => r_Change.Filial_Id,
                          i_Change_Id  => r_Change.Change_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Delete(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    r_Change     Htt_Plan_Changes%rowtype;
    v_Changes    Arraylist := p.r_Arraylist('changes');
    v_Change     Hashmap;
  begin
    for i in 1 .. v_Changes.Count
    loop
      v_Change := Treat(v_Changes.r_Hashmap(i) as Hashmap);
    
      r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Change.r_Number('filial_id'),
                                               i_Change_Id  => v_Change.r_Number('change_id'));
    
      if Href_Util.Is_Director(i_Company_Id => r_Change.Company_Id,
                               i_Filial_Id  => r_Change.Filial_Id,
                               i_Staff_Id   => r_Change.Staff_Id) then
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                        i_Self     => false,
                                        i_Undirect => false);
      end if;
    
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
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
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
    update Mrf_Division_Managers
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Manager_Id  = null;
  end;

end Ui_Vhr628;
/
