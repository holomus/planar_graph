create or replace package Ui_Vhr430 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Kind_Audit(p Hashmap) return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr430;
/
create or replace package body Ui_Vhr430 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Kind_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2 := Htt_Util.Carryover_Policies;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from x_htt_request_kinds q
                      where q.t_company_id = :company_id
                        and q.request_kind_id = :request_kind_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'request_kind_id',
                                 p.r_Number('request_kind_id')));
  
    q.Number_Field('t_audit_id',
                   't_user_id',
                   't_context_id',
                   'request_kind_id',
                   'time_kind_id',
                   'annual_day_limit',
                   'request_restriction_days',
                   'carryover_cap_days',
                   'carryover_expires_days');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'name',
                     'annually_limited',
                     'day_count_type',
                     'user_permitted',
                     'allow_unused_time',
                     'state',
                     'carryover_policy');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Refer_Field('time_kind_name',
                  'time_kind_id',
                  'htt_time_kinds',
                  'time_kind_id',
                  'name',
                  'select *
                     from htt_time_kinds s
                    where s.company_id = :company_id');
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id');
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
  
    q.Option_Field('carryover_policy_name', 'carryover_policy', v_Matrix(1), v_Matrix(2));
    q.Option_Field('annually_limited_name',
                   'annually_limited',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('allow_unused_time_name',
                   'allow_unused_time',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('user_permitted_name',
                   'user_permitted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    v_Matrix := Md_Util.Events;
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    r_Data       Htt_Request_Kinds%rowtype;
    v_Company_Id number := Ui.Company_Id;
    result       Hashmap;
  begin
    r_Data := z_Htt_Request_Kinds.Load(i_Company_Id      => v_Company_Id,
                                       i_Request_Kind_Id => p.r_Number('request_kind_id'));
  
    result := z_Htt_Request_Kinds.To_Map(r_Data,
                                         z.Request_Kind_Id,
                                         z.Name,
                                         z.Annually_Limited,
                                         z.Annual_Day_Limit,
                                         z.Request_Restriction_Days,
                                         z.State,
                                         z.Carryover_Cap_Days,
                                         z.Carryover_Expires_Days,
                                         z.Created_On,
                                         z.Modified_On);
  
    Result.Put('user_permitted',
               Md_Util.Decode(r_Data.User_Permitted, 'N', Ui.t_No, 'Y', Ui.t_Yes));
    Result.Put('allow_unused_time',
               Md_Util.Decode(r_Data.Allow_Unused_Time, 'N', Ui.t_No, 'Y', Ui.t_Yes));
    Result.Put('day_count_type_name', Htt_Util.t_Day_Count_Type(r_Data.Day_Count_Type));
    Result.Put('time_kind_name',
               z_Htt_Time_Kinds.Take(i_Company_Id => v_Company_Id, i_Time_Kind_Id => r_Data.Time_Kind_Id).Name);
    Result.Put('carryover_policy_name', Htt_Util.t_Carryover_Policy(r_Data.Carryover_Policy));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update x_Htt_Request_Kinds
       set t_Company_Id             = null,
           t_Audit_Id               = null,
           t_Event                  = null,
           t_Timestamp              = null,
           t_Date                   = null,
           t_User_Id                = null,
           Request_Kind_Id          = null,
           name                     = null,
           Time_Kind_Id             = null,
           Annually_Limited         = null,
           Day_Count_Type           = null,
           Annual_Day_Limit         = null,
           User_Permitted           = null,
           Allow_Unused_Time        = null,
           Request_Restriction_Days = null,
           Carryover_Policy         = null,
           Carryover_Cap_Days       = null,
           Carryover_Expires_Days   = null;
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           name         = null,
           Plan_Load    = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
  
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr430;
/
