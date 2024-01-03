create or replace package Ui_Vhr119 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Kinds(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Limits(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model_Personal return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap);
end Ui_Vhr119;
/
create or replace package body Ui_Vhr119 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Staffs return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select *
                  from href_staffs q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.employee_id <> :user_id
                   and q.hiring_date <= :current_date
                   and (q.dismissal_date is null or q.dismissal_date >= :current_date)
                   and q.state = ''A''';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'user_id',
                             Ui.User_Id,
                             'current_date',
                             Trunc(sysdate));
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('staff_id');
    q.Varchar2_Field('staff_number', 'staff_kind');
  
    q.Map_Field('name',
                'select p.name
                   from mr_natural_persons p
                  where p.company_id = $company_id
                    and p.person_id = $employee_id');
  
    v_Matrix := Href_Util.Staff_Kinds;
    q.Option_Field('staff_kind_name', 'staff_kind', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Request_Kinds(p Hashmap) return Fazo_Query is
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
                                 p.r_Number('staff_id'),
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
  Function Load_Request_Limits(p Hashmap) return Arraylist is
  begin
    return Uit_Htt.Load_Request_Limits(i_Staff_Id        => p.r_Number('staff_id'),
                                       i_Request_Kind_Id => p.r_Number('request_kind_id'),
                                       i_Period_Begin    => p.r_Date('begin_date'),
                                       i_Period_End      => p.r_Date('end_date'),
                                       i_Request_Id      => p.o_Number('request_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    v_Personal_Mode    varchar2(1);
    v_Note_Is_Required varchar2(1) := Href_Util.Request_Note_Is_Required(Ui.Company_Id);
    result             Hashmap;
  begin
    v_Personal_Mode := case
                         when Ui.Request_Mode like '%_personal' then
                          'Y'
                         else
                          'N'
                       end;
  
    result := Fazo.Zip_Map('request_type_part_of_day',
                           Htt_Pref.c_Request_Type_Part_Of_Day,
                           'request_type_full_day',
                           Htt_Pref.c_Request_Type_Full_Day,
                           'request_type_multiple_days',
                           Htt_Pref.c_Request_Type_Multiple_Days,
                           'personal_mode',
                           v_Personal_Mode,
                           'personal_staff_id',
                           Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                          i_Filial_Id   => Ui.Filial_Id,
                                                          i_Employee_Id => Ui.User_Id,
                                                          i_Date        => Trunc(sysdate)),
                           'request_kind_user_permitted',
                           v_Personal_Mode);
  
    Result.Put('plan_load_part', Htt_Pref.c_Plan_Load_Part);
    Result.Put('plan_load_full', Htt_Pref.c_Plan_Load_Full);
    Result.Put('plan_load_extra', Htt_Pref.c_Plan_Load_Extra);
    Result.Put('request_types', Fazo.Zip_Matrix_Transposed(Htt_Util.Request_Types));
    Result.Put('current_date', Trunc(sysdate));
    Result.Put('accrual_kind_plan', Htt_Pref.c_Accrual_Kind_Plan);
    Result.Put('accrual_kind_carryover', Htt_Pref.c_Accrual_Kind_Carryover);
    Result.Put('note_is_required', v_Note_Is_Required);
  
    if v_Note_Is_Required = 'Y' then
      Result.Put('note_limit', Href_Util.Load_Request_Note_Limit(Ui.Company_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Assert_Access(i_Staff_Id number) is
    v_Personal boolean := Ui.Request_Mode like '%_personal';
  begin
    if v_Personal then
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => i_Staff_Id,
                                      i_All      => false,
                                      i_Self     => true,
                                      i_Direct   => false,
                                      i_Undirect => false,
                                      i_Manual   => false);
    else
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => i_Staff_Id, --
                                      i_Self     => false);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('data',
               Fazo.Zip_Map('request_type',
                            Htt_Pref.c_Request_Type_Part_Of_Day,
                            'begin_date',
                            to_char(sysdate, Href_Pref.c_Date_Format_Day),
                            'begin_time',
                            to_char(sysdate, Href_Pref.c_Time_Format_Minute),
                            'accrual_kind',
                            Htt_Pref.c_Accrual_Kind_Plan));
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model_Personal return Hashmap is
    v_Staff_Id number;
  begin
    v_Staff_Id := Href_Util.Get_Primary_Staff_Id(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Employee_Id => Ui.User_Id,
                                                 i_Date        => Trunc(sysdate));
  
    Assert_Access(v_Staff_Id);
  
    return Add_Model;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Request      Htt_Requests%rowtype;
    v_Data         Hashmap;
    result         Hashmap := Hashmap();
    r_Request_Kind Htt_Request_Kinds%rowtype;
  begin
    r_Request := z_Htt_Requests.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Request_Id => p.r_Number('request_id'));
  
    Assert_Access(r_Request.Staff_Id);
  
    v_Data := z_Htt_Requests.To_Map(r_Request,
                                    z.Request_Id,
                                    z.Staff_Id,
                                    z.Note,
                                    z.Status,
                                    z.Accrual_Kind);
  
    v_Data.Put('staff_name',
               Href_Util.Staff_Name(i_Company_Id => r_Request.Company_Id,
                                    i_Filial_Id  => r_Request.Filial_Id,
                                    i_Staff_Id   => r_Request.Staff_Id));
  
    r_Request_Kind := z_Htt_Request_Kinds.Load(i_Company_Id      => r_Request.Company_Id,
                                               i_Request_Kind_Id => r_Request.Request_Kind_Id);
  
    v_Data.Put('request_type', r_Request.Request_Type);
    v_Data.Put('request_kind_id', r_Request.Request_Kind_Id);
    v_Data.Put('request_kind_name', r_Request_Kind.Name);
    v_Data.Put('annually_limited', r_Request_Kind.Annually_Limited);
  
    case r_Request.Request_Type
      when Htt_Pref.c_Request_Type_Part_Of_Day then
        v_Data.Put('begin_date', to_char(r_Request.Begin_Time, Href_Pref.c_Date_Format_Day));
        v_Data.Put('begin_time', to_char(r_Request.Begin_Time, Href_Pref.c_Time_Format_Minute));
        v_Data.Put('end_time', to_char(r_Request.End_Time, Href_Pref.c_Time_Format_Minute));
      when Htt_Pref.c_Request_Type_Full_Day then
        v_Data.Put('begin_date', r_Request.Begin_Time);
      else
        v_Data.Put('begin_date', r_Request.Begin_Time);
        v_Data.Put('end_date', r_Request.End_Time);
    end case;
  
    v_Data.Put('accruals',
               Uit_Htt.Load_Request_Limits(i_Staff_Id        => r_Request.Staff_Id,
                                           i_Request_Kind_Id => r_Request.Request_Kind_Id,
                                           i_Period_Begin    => r_Request.Begin_Time,
                                           i_Period_End      => r_Request.End_Time,
                                           i_Request_Id      => r_Request.Request_Id));
  
    Result.Put('data', v_Data);
    Result.Put('plan_load',
               z_Htt_Time_Kinds.Load(i_Company_Id => r_Request_Kind.Company_Id, i_Time_Kind_Id => r_Request_Kind.Time_Kind_Id).Plan_Load);
    Result.Put_All(References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save
  (
    i_Request_Id number,
    p            Hashmap
  ) is
    v_Begin_Time date;
    v_End_Time   date;
    r_Request    Htt_Requests%rowtype;
  begin
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
  
    r_Request := z_Htt_Requests.To_Row(p,
                                       z.Request_Kind_Id,
                                       z.Staff_Id,
                                       z.Request_Type,
                                       z.Note,
                                       z.Accrual_Kind);
  
    Assert_Access(r_Request.Staff_Id);
  
    r_Request.Company_Id := Ui.Company_Id;
    r_Request.Filial_Id  := Ui.Filial_Id;
    r_Request.Request_Id := i_Request_Id;
    r_Request.Begin_Time := v_Begin_Time;
    r_Request.End_Time   := v_End_Time;
  
    Htt_Api.Request_Save(r_Request);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
  begin
    save(Htt_Next.Request_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edit(p Hashmap) is
    r_Request Htt_Requests%rowtype;
  begin
    r_Request := z_Htt_Requests.Lock_Load(i_Company_Id => Ui.Company_Id,
                                          i_Filial_Id  => Ui.Filial_Id,
                                          i_Request_Id => p.r_Number('request_id'));
  
    save(r_Request.Request_Id, p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Hiring_Date    = null,
           Org_Unit_Id    = null,
           Dismissal_Date = null,
           Staff_Kind     = null,
           State          = null;
    update Htt_Time_Kinds
       set Company_Id   = null,
           Time_Kind_Id = null,
           Plan_Load    = null;
    update Htt_Request_Kinds
       set Company_Id      = null,
           Request_Kind_Id = null,
           Time_Kind_Id    = null,
           name            = null,
           User_Permitted  = null;
    update Htt_Staff_Request_Kinds
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Request_Kind_Id = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  end;

end Ui_Vhr119;
/
