create or replace package Ui_Vhr234 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Locations(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap);
end Ui_Vhr234;
/
create or replace package body Ui_Vhr234 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Locations(p Hashmap) return Fazo_Query is
    v_Query     varchar2(4000);
    v_Params    Hashmap;
    v_Person_Id number := p.r_Number('person_id');
    v_Filial_Id number := Ui.Filial_Id;
    v_Matrix    Matrix_Varchar2;
    q           Fazo_Query;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    v_Query := 'select lc.*,
                       case
                          when exists (select 1
                                  from htt_location_polygon_vertices pv
                                 where pv.company_id = lc.company_id
                                   and pv.location_id = lc.location_id) then
                           ''Y''
                          else
                           ''N''
                        end has_polygon,
                       w.attach_type,
                       w.created_by attached_by,
                       w.created_on attached_on 
                  from htt_locations lc';
  
    if p.o_Varchar2('mode') = 'detach' then
      v_Query := v_Query || --
                 ' join (select null attach_type,
                                null created_by,
                                null created_on
                           from dual) w
                     on lc.company_id = :company_id
                    and not exists (select 1 
                               from htt_location_persons lp
                              where lp.company_id = :company_id
                                and lp.filial_id = :filial_id
                                and lp.person_id = :person_id
                                and lp.location_id = lc.location_id
                                and not exists (select 1
                                           from htt_blocked_person_tracking bp
                                          where bp.company_id = lp.company_id
                                            and bp.filial_id = lp.filial_id
                                            and bp.employee_id = lp.person_id))';
    else
      v_Query := v_Query || --
                 ' join htt_location_persons w
                     on w.company_id = :company_id
                    and w.filial_id = :filial_id
                    and w.person_id = :person_id
                    and w.location_id = lc.location_id
                    and not exists (select 1
                               from htt_blocked_person_tracking bp
                              where bp.company_id = w.company_id
                                and bp.filial_id = w.filial_id
                                and bp.employee_id = w.person_id)';
    end if;
  
    v_Query := v_Query || --
               ' where lc.company_id = :company_id
                   and exists (select 1
                                 from htt_location_filials lf
                                where lf.company_id = lf.company_id
                                  and lf.filial_id = :filial_id
                                  and lf.location_id = lc.location_id)';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             v_Filial_Id,
                             'person_id',
                             v_Person_Id);
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('location_id', 'location_type_id', 'region_id', 'accuracy', 'attached_by');
    q.Varchar2_Field('name',
                     'timezone_code',
                     'address',
                     'latlng',
                     'prohibited',
                     'state',
                     'code',
                     'attach_type',
                     'has_polygon');
    q.Date_Field('attached_on');
  
    v_Matrix := Htt_Util.Attach_Types;
  
    q.Refer_Field('location_type_name',
                  'location_type_id',
                  'htt_location_types',
                  'location_type_id',
                  'name',
                  'select *
                     from htt_location_types s 
                    where s.company_id = :company_id');
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions s 
                    where s.company_id = :company_id');
    q.Refer_Field('attached_by_name',
                  'attached_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users s 
                    where s.company_id = :company_id');
  
    q.Option_Field('attach_type_name', 'attach_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('prohibited_name',
                   'prohibited',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    q.Option_Field('has_polygon_name',
                   'has_polygon',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap) is
    v_Person_Id    number := p.r_Number('person_id');
    v_Location_Ids Array_Number := Fazo.Sort(p.r_Array_Number('location_id'));
  begin
    for i in 1 .. v_Location_Ids.Count
    loop
      Htt_Api.Location_Add_Person(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Ids(i),
                                  i_Person_Id   => v_Person_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap) is
    v_Person_Id    number := p.r_Number('person_id');
    v_Location_Ids Array_Number := Fazo.Sort(p.r_Array_Number('location_id'));
  begin
    for i in 1 .. v_Location_Ids.Count
    loop
      Htt_Api.Location_Remove_Person(i_Company_Id  => Ui.Company_Id,
                                     i_Filial_Id   => Ui.Filial_Id,
                                     i_Location_Id => v_Location_Ids(i),
                                     i_Person_Id   => v_Person_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Locations
       set Company_Id       = null,
           Location_Id      = null,
           Location_Type_Id = null,
           name             = null,
           Timezone_Code    = null,
           Region_Id        = null,
           Address          = null,
           Latlng           = null,
           Accuracy         = null,
           Prohibited       = null,
           State            = null,
           Code             = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Location_Types
       set Company_Id       = null,
           Location_Type_Id = null,
           name             = null;
    update Htt_Location_Persons
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null,
           Person_Id   = null,
           Attach_Type = null,
           Created_By  = null,
           Created_On  = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Htt_Blocked_Person_Tracking
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  end;

end Ui_Vhr234;
/
