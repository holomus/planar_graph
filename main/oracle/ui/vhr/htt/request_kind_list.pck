create or replace package Ui_Vhr116 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr116;
/
create or replace package body Ui_Vhr116 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query    varchar2(32767);
    v_Params   Hashmap;
    v_Matrix   Matrix_Varchar2;
    v_Staff_Id number;
    q          Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id);
    v_Query  := 'select *
                   from htt_request_kinds q
                  where q.company_id = :company_id';
  
    if p.Has('staff_id') or p.Has('employee_id') then
      v_Staff_Id := p.o_Number('staff_id');
    
      if v_Staff_Id is null then
        v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                     i_Filial_Id   => Ui.Filial_Id,
                                                     i_Employee_Id => p.r_Number('employee_id'),
                                                     i_Date        => Trunc(sysdate));
      end if;
    
      v_Params.Put('filial_id', Ui.Filial_Id);
      v_Params.Put('staff_id', v_Staff_Id);
      v_Params.Put('sk_primary', Href_Pref.c_Staff_Kind_Primary);
      v_Params.Put('period', Trunc(sysdate));
    
      v_Query := v_Query || --
                 ' and ((select count(*)
                           from htt_staff_request_kinds w
                          where w.company_id = :company_id
                            and w.filial_id = :filial_id
                            and w.request_kind_id = q.request_kind_id
                            and exists (select 1
                                   from href_staffs s
                                  where s.company_id = :company_id
                                    and s.filial_id = :filial_id
                                    and s.staff_id = w.staff_id
                                    and s.staff_kind = :sk_primary
                                    and s.state = ''A''
                                    and s.hiring_date <= :period
                                    and nvl(s.dismissal_date, :period) >= :period)) = 0 or exists
                        (select 1
                           from htt_staff_request_kinds w
                          where w.company_id = :company_id
                            and w.filial_id = :filial_id
                            and w.staff_id = :staff_id
                            and w.request_kind_id = q.request_kind_id))';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('request_kind_id',
                   'time_kind_id',
                   'annual_day_limit',
                   'request_restriction_days',
                   'carryover_cap_days',
                   'carryover_expires_days',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('name',
                     'annually_limited',
                     'day_count_type',
                     'allow_unused_time',
                     'user_permitted',
                     'carryover_policy',
                     'state');
    q.Date_Field('created_on', 'modified_on');
  
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
  
    v_Matrix := Htt_Util.Day_Count_Types;
    q.Option_Field('day_count_type_name', 'day_count_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Carryover_Policies;
    q.Option_Field('carryover_policy_name', 'carryover_policy', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('time_kind_name',
                  'time_kind_id',
                  'htt_time_kinds',
                  'time_kind_id',
                  'name',
                  'select *
                     from htt_time_kinds s
                    where s.company_id = :company_id');
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
    q.Refer_Field('plan_load',
                  'time_kind_id',
                  'htt_time_kinds',
                  'time_kind_id',
                  'plan_load',
                  'select *
                     from htt_time_kinds w
                    where q.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Request_Kind_Ids Array_Number := Fazo.Sort(p.r_Array_Number('request_kind_id'));
  begin
    for i in 1 .. v_Request_Kind_Ids.Count
    loop
      Htt_Api.Request_Kind_Delete(i_Company_Id      => Ui.Company_Id,
                                  i_Request_Kind_Id => v_Request_Kind_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Request_Kinds
       set Company_Id               = null,
           Request_Kind_Id          = null,
           name                     = null,
           Time_Kind_Id             = null,
           Annually_Limited         = null,
           Day_Count_Type           = null,
           Annual_Day_Limit         = null,
           Allow_Unused_Time        = null,
           User_Permitted           = null,
           Request_Restriction_Days = null,
           Carryover_Policy         = null,
           Carryover_Cap_Days       = null,
           Carryover_Expires_Days   = null,
           State                    = null,
           Created_By               = null,
           Created_On               = null,
           Modified_By              = null,
           Modified_On              = null;
  
    update Htt_Staff_Request_Kinds
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Request_Kind_Id = null;
  
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Kind     = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
  
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           name         = null,
           Plan_Load    = null;
  
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr116;
/
