create or replace package Ui_Vhr229 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Change_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Change_Days_Audit(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Change_Day_Weights(p Hashmap);
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
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr229;
/
create or replace package body Ui_Vhr229 is
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
    return b.Translate('UI-VHR229:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Change_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_htt_plan_changes q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.change_id = :change_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                 'change_id',
                                 p.r_Number('change_id')));
  
    q.Number_Field('t_audit_id', 't_filial_id', 't_user_id', 't_context_id', 'change_id');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'change_kind',
                     'note',
                     'status',
                     'manager_note');
    q.Date_Field('t_timestamp', 't_date');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Change_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Change_Kinds;
    q.Option_Field('change_kind_name', 'change_kind', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s 
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Change_Days_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_htt_change_days q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.change_id = :change_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                 'change_id',
                                 p.r_Number('change_id')));
  
    q.Number_Field('t_company_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'staff_id',
                   'plan_time');
    q.Varchar2_Field('t_event', 't_source_project_code', 'day_kind', 'break_enabled');
    q.Date_Field('t_timestamp',
                 't_date',
                 'change_date',
                 'swapped_date',
                 'begin_time',
                 'end_time',
                 'break_begin_time',
                 'break_end_time');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Day_Kinds;
    q.Option_Field('day_kind_name', 'day_kind', v_Matrix(1), v_Matrix(2));
    q.Map_Field('staff_name',
                'select p.name
                   from href_staffs q
                   join mr_natural_persons p
                     on p.company_id = q.company_id
                    and p.person_id = q.employee_id
                  where q.company_id = $t_company_id
                    and q.filial_id  = $t_filial_id
                    and q.staff_id  = $staff_id');
  
    q.Refer_Field('t_filial_name',
                  't_filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select *
                     from md_filials s 
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('day_kind_work',
                           Htt_Pref.c_Day_Kind_Work,
                           'change_status_new',
                           Htt_Pref.c_Change_Status_New,
                           'change_status_approved',
                           Htt_Pref.c_Change_Status_Approved,
                           'change_status_completed',
                           Htt_Pref.c_Change_Status_Completed,
                           'change_status_denied',
                           Htt_Pref.c_Change_Status_Denied);
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Change_Day_Weights(p Hashmap) is
    p_Change_Day_Weights Htt_Pref.Change_Day_Weights;
    v_Weights            Arraylist := Nvl(p.o_Arraylist('weights'), Arraylist());
    v_Weight             Hashmap;
  begin
    Htt_Util.Change_Day_Weight_New(o_Change_Day_Weights => p_Change_Day_Weights,
                                   i_Company_Id         => Ui.Company_Id,
                                   i_Filial_Id          => Ui.Filial_Id,
                                   i_Staff_Id           => p.r_Number('staff_id'),
                                   i_Change_Id          => p.r_Number('change_id'),
                                   i_Change_Date        => p.r_Date('change_date'));
  
    for i in 1 .. v_Weights.Count
    loop
      v_Weight := Treat(v_Weights.r_Hashmap(i) as Hashmap);
    
      Htt_Util.Change_Day_Weight_Add(o_Change_Day_Weights => p_Change_Day_Weights,
                                     i_Begin_Time         => v_Weight.r_Number('begin_time'),
                                     i_End_Time           => v_Weight.r_Number('end_time'),
                                     i_Weight             => v_Weight.r_Number('weight'));
    end loop;
  
    Htt_Api.Change_Day_Weights_Save(i_Change_Day_Weights => p_Change_Day_Weights);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Reset(p Hashmap) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Nvl(p.o_Number('filial_id'),
                                                                 Ui.Filial_Id),
                                             i_Change_Id  => p.r_Number('change_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Change_Reset(i_Company_Id => r_Change.Company_Id,
                         i_Filial_Id  => r_Change.Filial_Id,
                         i_Change_Id  => r_Change.Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Approve(p Hashmap) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Nvl(p.o_Number('filial_id'),
                                                                 Ui.Filial_Id),
                                             i_Change_Id  => p.r_Number('change_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Change_Approve(i_Company_Id   => r_Change.Company_Id,
                           i_Filial_Id    => r_Change.Filial_Id,
                           i_Change_Id    => r_Change.Change_Id,
                           i_Manager_Note => p.o_Varchar2('manager_note'),
                           i_User_Id      => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Deny(p Hashmap) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Nvl(p.o_Number('filial_id'),
                                                                 Ui.Filial_Id),
                                             i_Change_Id  => p.r_Number('change_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Change_Deny(i_Company_Id   => r_Change.Company_Id,
                        i_Filial_Id    => r_Change.Filial_Id,
                        i_Change_Id    => r_Change.Change_Id,
                        i_Manager_Note => p.o_Varchar2('manager_note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Complete(p Hashmap) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Nvl(p.o_Number('filial_id'),
                                                                 Ui.Filial_Id),
                                             i_Change_Id  => p.r_Number('change_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Change_Complete(i_Company_Id => r_Change.Company_Id,
                            i_Filial_Id  => r_Change.Filial_Id,
                            i_Change_Id  => r_Change.Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Cancel(p Hashmap) is
    r_Change Htt_Plan_Changes%rowtype;
  begin
    r_Change := z_Htt_Plan_Changes.Lock_Load(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Nvl(p.o_Number('filial_id'),
                                                                 Ui.Filial_Id),
                                             i_Change_Id  => p.r_Number('change_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Change.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Change_Deny(i_Company_Id => r_Change.Company_Id,
                        i_Filial_Id  => r_Change.Filial_Id,
                        i_Change_Id  => r_Change.Change_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Change    Htt_Plan_Changes%rowtype;
    v_Matrix    Matrix_Varchar2;
    v_Filial_Id number := p.o_Number('filial_id');
    result      Hashmap := Hashmap;
  begin
    r_Change := z_Htt_Plan_Changes.Load(i_Company_Id => Ui.Company_Id,
                                        i_Filial_Id  => Nvl(v_Filial_Id, Ui.Filial_Id),
                                        i_Change_Id  => p.r_Number('change_id'));
  
    result := z_Htt_Plan_Changes.To_Map(r_Change,
                                        z.Change_Id,
                                        z.Staff_Id,
                                        z.Change_Kind,
                                        z.Note,
                                        z.Status,
                                        z.Created_On,
                                        z.Modified_On,
                                        z.Manager_Note);
  
    Result.Put('staff_name',
               Href_Util.Staff_Name(i_Company_Id => r_Change.Company_Id,
                                    i_Filial_Id  => r_Change.Filial_Id,
                                    i_Staff_Id   => r_Change.Staff_Id));
    Result.Put('status_name', Htt_Util.t_Change_Status(r_Change.Status));
  
    select Array_Varchar2(to_char(q.Change_Date, Href_Pref.c_Date_Format_Day),
                          to_char(q.Swapped_Date, Href_Pref.c_Date_Format_Day),
                          q.Day_Kind,
                          Htt_Util.t_Day_Kind(q.Day_Kind),
                          to_char(q.Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(q.End_Time, Href_Pref.c_Time_Format_Minute),
                          q.Break_Enabled,
                          to_char(q.Break_Begin_Time, Href_Pref.c_Time_Format_Minute),
                          to_char(q.Break_End_Time, Href_Pref.c_Time_Format_Minute),
                          Htt_Util.To_Time(Round(q.Plan_Time / 60, 2)))
      bulk collect
      into v_Matrix
      from Htt_Change_Days q
     where q.Company_Id = r_Change.Company_Id
       and q.Filial_Id = r_Change.Filial_Id
       and q.Change_Id = r_Change.Change_Id;
  
    if v_Filial_Id is not null then
      Result.Put('filial_id', v_Filial_Id);
      Result.Put('filial_name',
                 z_Md_Filials.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => v_Filial_Id).Name);
    end if;
  
    Result.Put('change_date', Trunc(r_Change.Created_On));
    Result.Put('change_dates', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Change_Date, -- 
                          mod(q.Begin_Time, 1440),
                          mod(q.End_Time, 1440),
                          q.Weight)
      bulk collect
      into v_Matrix
      from Htt_Change_Day_Weights q
     where q.Company_Id = r_Change.Company_Id
       and q.Filial_Id = r_Change.Filial_Id
       and q.Staff_Id = r_Change.Staff_Id
       and q.Change_Id = r_Change.Change_Id
     order by q.Begin_Time;
  
    Result.Put('weights', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('change_kind_name', Htt_Util.t_Change_Kind(r_Change.Change_Kind));
    Result.Put('approved_by_name',
               z_Md_Users.Take(i_Company_Id => r_Change.Company_Id, i_User_Id => r_Change.Approved_By).Name);
    Result.Put('completed_by_name',
               z_Md_Users.Take(i_Company_Id => r_Change.Company_Id, i_User_Id => r_Change.Completed_By).Name);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Change.Company_Id, i_User_Id => r_Change.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Change.Company_Id, i_User_Id => r_Change.Modified_By).Name);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Htt_Plan_Changes
       set t_Company_Id          = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Session_Id          = null,
           t_Context_Id          = null,
           Change_Id             = null,
           Change_Kind           = null,
           Note                  = null,
           Status                = null,
           Manager_Note          = null;
    update x_Htt_Change_Days
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Session_Id          = null,
           t_Context_Id          = null,
           Change_Id             = null,
           Change_Date           = null,
           Swapped_Date          = null,
           Staff_Id              = null,
           Day_Kind              = null,
           Begin_Time            = null,
           End_Time              = null,
           Break_Enabled         = null,
           Break_Begin_Time      = null,
           Break_End_Time        = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
    update Htt_Plan_Changes
       set Company_Id   = null,
           Filial_Id    = null,
           Change_Id    = null,
           Staff_Id     = null,
           Change_Kind  = null,
           Note         = null,
           Status       = null,
           Created_By   = null,
           Created_On   = null,
           Modified_By  = null,
           Modified_On  = null,
           Manager_Note = null;
    update Htt_Change_Days
       set Company_Id       = null,
           Filial_Id        = null,
           Change_Id        = null,
           Change_Date      = null,
           Swapped_Date     = null,
           Staff_Id         = null,
           Day_Kind         = null,
           Begin_Time       = null,
           End_Time         = null,
           Break_Enabled    = null,
           Break_Begin_Time = null,
           Break_End_Time   = null,
           Plan_Time        = null,
           Full_Time        = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Employee_Id = null,
           State       = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr229;
/
