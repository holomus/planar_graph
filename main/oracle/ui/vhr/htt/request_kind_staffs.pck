create or replace package Ui_Vhr451 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap);
end Ui_Vhr451;
/
create or replace package body Ui_Vhr451 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query varchar2(32767);
    q       Fazo_Query;
  begin
    v_Query := 'select q.*,
                       (select f.fte_value
                          from href_ftes f
                         where f.company_id = q.company_id
                           and f.fte_id = q.fte_id) fte_value,
                       (select n.name
                          from mr_natural_persons n
                         where n.company_id = :company_id
                           and n.person_id = q.employee_id) as name,
                       trunc(w.period, ''yyyy'') as request_begin_date,
                       w.period as request_end_date,
                       w.accrued_days as request_accrued_days,
                       nvl2(w.accrued_days, htt_util.get_request_kind_used_days(i_company_id      => :company_id,
                                                                                i_filial_id       => :filial_id,
                                                                                i_staff_id        => q.staff_id,
                                                                                i_request_kind_id => :request_kind_id,
                                                                                i_accrual_kind    => :accrual_kind,
                                                                                i_period          => w.period), null) as request_used_days
                  from href_staffs q
                  left join htt_request_kind_accruals w
                    on w.company_id = :company_id
                   and w.filial_id = :filial_id
                   and w.staff_id = q.staff_id
                   and w.request_kind_id = :request_kind_id
                   and :period between trunc(w.period, ''yyyy'') and w.period
                   and w.accrual_kind = :accrual_kind
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.staff_kind = :sk_primary
                   and q.state = ''A''
                   and ';
  
    if p.o_Varchar2('attached') = 'N' then
      v_Query := v_Query || --
                 'q.hiring_date <= :period
              and nvl(q.dismissal_date, :period) >= :period
              and not ';
    end if;
  
    v_Query := v_Query || --
               'exists (select 1
                   from htt_staff_request_kinds sr
                  where sr.company_id = :company_id
                    and sr.filial_id = :filial_id
                    and sr.staff_id = q.staff_id
                    and sr.request_kind_id = :request_kind_id)';
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'request_kind_id',
                                 p.r_Number('request_kind_id'),
                                 'accrual_kind',
                                 p.r_Varchar2('accrual_kind'),
                                 'period',
                                 Trunc(sysdate),
                                 'sk_primary',
                                 Href_Pref.c_Staff_Kind_Primary));
  
    q.Number_Field('staff_id', 'request_accrued_days', 'request_used_days', 'fte_value', 'fte_id');
    q.Varchar2_Field('staff_number', 'name', 'fte_name');
    q.Date_Field('hiring_date', 'request_begin_date', 'request_end_date');
  
    q.Refer_Field('fte_name',
                  'fte_id',
                  'href_ftes',
                  'fte_id',
                  'name',
                  'select *
                     from href_ftes s
                    where s.company_id = :company_id');
  
    q.Map_Field('request_left_days', '$request_accrued_days - $request_used_days');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap) is
    v_Request_Kind_Id number := p.r_Number('request_kind_id');
    v_Staff_Ids       Array_Number := Fazo.Sort(p.r_Array_Number('staff_id'));
  begin
    for i in 1 .. v_Staff_Ids.Count
    loop
      Htt_Api.Staff_Attach_Request_Kind(i_Company_Id      => Ui.Company_Id,
                                        i_Filial_Id       => Ui.Filial_Id,
                                        i_Staff_Id        => v_Staff_Ids(i),
                                        i_Request_Kind_Id => v_Request_Kind_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap) is
    v_Request_Kind_Id number := p.r_Number('request_kind_id');
    v_Staff_Ids       Array_Number := Fazo.Sort(p.r_Array_Number('staff_id'));
  begin
    for i in 1 .. v_Staff_Ids.Count
    loop
      Htt_Api.Staff_Detach_Request_Kind(i_Company_Id      => Ui.Company_Id,
                                        i_Filial_Id       => Ui.Filial_Id,
                                        i_Staff_Id        => v_Staff_Ids(i),
                                        i_Request_Kind_Id => v_Request_Kind_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Number   = null,
           Staff_Kind     = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
  
    update Htt_Request_Kind_Accruals
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Request_Kind_Id = null,
           Period          = null,
           Accrual_Kind    = null,
           Accrued_Days    = null;
  
    update Htt_Staff_Request_Kinds
       set Company_Id      = null,
           Filial_Id       = null,
           Staff_Id        = null,
           Request_Kind_Id = null;
  
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
  
    update Href_Ftes
       set Company_Id = null,
           Fte_Id     = null,
           name       = null,
           Fte_Value  = null;
  
    Uie.x(Htt_Util.Get_Request_Kind_Used_Days(i_Company_Id      => null,
                                              i_Filial_Id       => null,
                                              i_Staff_Id        => null,
                                              i_Request_Kind_Id => null,
                                              i_Accrual_Kind    => null,
                                              i_Period          => null,
                                              i_Request_Id      => null));
  end;

end Ui_Vhr451;
/
