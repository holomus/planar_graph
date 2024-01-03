create or replace package Ui_Vhr172 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Request_Reset(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Request_Cancel(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr172;
/
create or replace package body Ui_Vhr172 is
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
    return b.Translate('UI-VHR172:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Request_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_htt_requests q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id
                        and q.request_id = :request_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                 'request_id',
                                 p.r_Number('request_id')));
  
    q.Number_Field('t_audit_id',
                   't_filial_id',
                   't_user_id',
                   't_context_id',
                   'request_id',
                   'request_kind_id');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'manager_note',
                     'note',
                     'status',
                     'barcode');
    q.Date_Field('t_timestamp', 't_date', 'begin_time', 'end_time');
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Request_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('request_kind_name',
                  'request_kind_id',
                  'htt_request_kinds',
                  'request_kind_id',
                  'name',
                  'select *
                     from htt_request_kinds
                    where company_id = :company_id');
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
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('request_type_part_of_day',
                           Htt_Pref.c_Request_Type_Part_Of_Day,
                           'request_type_full_day',
                           Htt_Pref.c_Request_Type_Full_Day,
                           'request_type_multiple_days',
                           Htt_Pref.c_Request_Type_Multiple_Days);
  
    Result.Put('request_status_new', Htt_Pref.c_Request_Status_New);
    Result.Put('request_status_approved', Htt_Pref.c_Request_Status_Approved);
    Result.Put('request_status_completed', Htt_Pref.c_Request_Status_Completed);
    Result.Put('request_status_denied', Htt_Pref.c_Request_Status_Denied);
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Request_Reset(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                          i_Request_Id => p.r_Number('request_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Request_Reset(i_Company_Id => r_Request.Company_Id,
                          i_Filial_Id  => r_Request.Filial_Id,
                          i_Request_Id => r_Request.Request_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Approve(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                          i_Request_Id => p.r_Number('request_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Request_Approve(i_Company_Id   => r_Request.Company_Id,
                            i_Filial_Id    => r_Request.Filial_Id,
                            i_Request_Id   => r_Request.Request_Id,
                            i_Manager_Note => p.o_Varchar2('manager_note'),
                            i_User_Id      => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Deny(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                          i_Request_Id => p.r_Number('request_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Request_Deny(i_Company_Id   => r_Request.Company_Id,
                         i_Filial_Id    => r_Request.Filial_Id,
                         i_Request_Id   => r_Request.Request_Id,
                         i_Manager_Note => p.o_Varchar2('manager_note'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Complete(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                          i_Request_Id => p.r_Number('request_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Request_Complete(i_Company_Id => r_Request.Company_Id,
                             i_Filial_Id  => r_Request.Filial_Id,
                             i_Request_Id => r_Request.Request_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Request_Cancel(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                          i_Request_Id => p.r_Number('request_id'));
  
    Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Request.Staff_Id,
                                    i_Self     => false,
                                    i_Undirect => false);
  
    Htt_Api.Request_Deny(i_Company_Id => r_Request.Company_Id,
                         i_Filial_Id  => r_Request.Filial_Id,
                         i_Request_Id => r_Request.Request_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Request Htt_Requests%rowtype;
    result    Hashmap := Hashmap;
  begin
    r_Request := z_Htt_Requests.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Nvl(p.o_Number('filial_id'), Ui.Filial_Id),
                                     i_Request_Id => p.r_Number('request_id'));
  
    result := z_Htt_Requests.To_Map(r_Request,
                                    z.Request_Id,
                                    z.Request_Kind_Id,
                                    z.Begin_Time,
                                    z.End_Time,
                                    z.Request_Type,
                                    z.Manager_Note,
                                    z.Note,
                                    z.Status,
                                    z.Barcode,
                                    z.Created_On,
                                    z.Modified_On);
  
    case r_Request.Request_Type
      when Htt_Pref.c_Request_Type_Part_Of_Day then
        Result.Put('begin_date', to_char(r_Request.Begin_Time, Href_Pref.c_Date_Format_Day));
        Result.Put('begin_time', to_char(r_Request.Begin_Time, Href_Pref.c_Time_Format_Minute));
        Result.Put('end_time', to_char(r_Request.End_Time, Href_Pref.c_Time_Format_Minute));
      when Htt_Pref.c_Request_Type_Full_Day then
        Result.Put('begin_date', r_Request.Begin_Time);
      else
        Result.Put('begin_date', r_Request.Begin_Time);
        Result.Put('end_date', r_Request.End_Time);
    end case;
  
    if p.o_Number('filial_id') is not null then
      Result.Put('filial_name',
                 z_Md_Filials.Load(i_Company_Id => r_Request.Company_Id, i_Filial_Id => r_Request.Filial_Id).Name);
    end if;
  
    Result.Put('request_date', Trunc(r_Request.Created_On));
    Result.Put('accrual_kind_name', Htt_Util.t_Accrual_Kinds(r_Request.Accrual_Kind));
    Result.Put('request_kind_name',
               z_Htt_Request_Kinds.Load(i_Company_Id => r_Request.Company_Id, i_Request_Kind_Id => r_Request.Request_Kind_Id).Name);
    Result.Put('status_name', Htt_Util.t_Request_Status(r_Request.Status));
    Result.Put('staff_name',
               Href_Util.Staff_Name(i_Company_Id => r_Request.Company_Id,
                                    i_Filial_Id  => r_Request.Filial_Id,
                                    i_Staff_Id   => r_Request.Staff_Id));
    Result.Put('approved_by_name',
               z_Md_Users.Take(i_Company_Id => r_Request.Company_Id, i_User_Id => r_Request.Approved_By).Name);
    Result.Put('completed_by_name',
               z_Md_Users.Take(i_Company_Id => r_Request.Company_Id, i_User_Id => r_Request.Completed_By).Name);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Request.Company_Id, i_User_Id => r_Request.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Request.Company_Id, i_User_Id => r_Request.Modified_By).Name);
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Htt_Requests
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
           Request_Id            = null,
           Request_Kind_Id       = null,
           Begin_Time            = null,
           End_Time              = null,
           Request_Type          = null,
           Manager_Note          = null,
           Note                  = null,
           Status                = null,
           Barcode               = null;
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
    update Htt_Request_Kinds
       set Company_Id      = null,
           Request_Kind_Id = null,
           name            = null;
  end;

end Ui_Vhr172;
/
