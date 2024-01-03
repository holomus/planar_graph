create or replace package Ui_Vhr78 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Generate_Qr_Code(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Attached_Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Detached_Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Influences(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr78;
/
create or replace package body Ui_Vhr78 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('qr_code_limit_time', Hes_Util.Get_Qr_Code_Limit_Time(Ui.Company_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Generate_Qr_Code(p Hashmap) return Hashmap is
  begin
    return Fazo.Zip_Map('unique_key',
                        Htt_Api.Location_Qr_Code_Generate(i_Company_Id  => Ui.Company_Id,
                                                          i_Location_Id => p.r_Number('location_id')));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query
  (
    i_Kind varchar2,
    p      Hashmap := Hashmap()
  ) return Fazo_Query is
    v_Query     varchar2(4000);
    v_Params    Hashmap;
    v_Filial_Id number;
    q           Fazo_Query;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.o_Number('filial_id');
    else
      v_Filial_Id := Ui.Filial_Id;
    end if;
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'device_status_ofline',
                             Htt_Pref.c_Device_Status_Offline);
    v_Query  := 'select q.*,
                        case
                           when exists (select 1
                                   from htt_location_polygon_vertices pv
                                  where pv.company_id = q.company_id
                                    and pv.location_id = q.location_id) then
                            ''Y''
                           else
                            ''N''
                         end has_polygon,
                        (select nullif(count(s.device_id), 0)
                           from htt_devices s
                          where s.company_id = q.company_id
                            and s.location_id = q.location_id) device_count,
                        case
                          when exists (select 1
                                  from htt_devices dev
                                 where dev.company_id = q.company_id
                                   and dev.location_id = q.location_id 
                                   and dev.status = :device_status_ofline) then
                            ''Y''
                            else
                            ''N''
                         end as has_offline_device,
                        (select nullif(count(distinct k.person_id), 0)
                           from htt_location_persons k
                          where k.company_id = q.company_id';
  
    if v_Filial_Id is not null then
      v_Params.Put('filial_id', v_Filial_Id);
    
      v_Query := v_Query || --
                 ' and k.filial_id = :filial_id';
    end if;
  
    v_Query := v_Query || --
               ' and k.location_id = q.location_id
                 and not exists (select *
                                from htt_blocked_person_tracking bp
                               where bp.company_id = k.company_id
                                 and bp.filial_id = k.filial_id
                                 and bp.employee_id = k.person_id)) user_count                                  
                from htt_locations q
               where q.company_id = :company_id';
  
    case i_Kind
      when 'A' then
        v_Query := v_Query || --
                   ' and exists (select 1 
                            from htt_location_filials w 
                           where w.company_id = q.company_id 
                             and w.filial_id = :filial_id 
                             and w.location_id = q.location_id)';
      when 'D' then
        v_Query := v_Query || --
                   ' and not exists (select 1 
                            from htt_location_filials w 
                           where w.company_id = q.company_id 
                             and w.filial_id = :filial_id 
                             and w.location_id = q.location_id)';
      when 'H' then
        if v_Filial_Id is not null then
          v_Query := v_Query || --
                     ' and exists (select 1 
                              from htt_location_filials w 
                             where w.company_id = q.company_id 
                               and w.filial_id = :filial_id 
                               and w.location_id = q.location_id)';
        end if;
    end case;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('location_id',
                   'location_type_id',
                   'region_id',
                   'accuracy',
                   'created_by',
                   'modified_by',
                   'device_count',
                   'user_count');
    q.Varchar2_Field('name',
                     'has_offline_device',
                     'timezone_code',
                     'address',
                     'latlng',
                     'bssids',
                     'prohibited',
                     'state',
                     'code',
                     'has_polygon');
    q.Date_Field('created_on', 'modified_on');
  
    q.Option_Field('has_polygon_name',
                   'has_polygon',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Refer_Field('location_type_name',
                  'location_type_id',
                  'htt_location_types',
                  'location_type_id',
                  'name',
                  'select *
                     from htt_location_types w
                    where w.company_id = :company_id');
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions w
                    where w.company_id = :company_id');
    q.Refer_Field('timezone_name', 'timezone_code', 'md_timezones', 'timezone_code', 'name_ru');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k
                    where k.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k 
                    where k.company_id = :company_id');
  
    q.Option_Field('prohibited_name',
                   'prohibited',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('has_offline_device_name',
                   'has_offline_device',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Attached_Query(p Hashmap) return Fazo_Query is
  begin
    if Ui.Is_Filial_Head then
      return Query('H', p);
    else
      return Query('A');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Detached_Query return Fazo_Query is
  begin
    return Query('D');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach(p Hashmap) is
    v_Location_Ids Array_Number := Fazo.Sort(p.r_Array_Number('location_id'));
  begin
    for i in 1 .. v_Location_Ids.Count
    loop
      Htt_Api.Location_Add_Filial(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach(p Hashmap) is
    v_Location_Ids Array_Number := Fazo.Sort(p.r_Array_Number('location_id'));
  begin
    for i in 1 .. v_Location_Ids.Count
    loop
      Htt_Api.Location_Remove_Filial(i_Company_Id  => Ui.Company_Id,
                                     i_Filial_Id   => Ui.Filial_Id,
                                     i_Location_Id => v_Location_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Influences(p Hashmap) return Hashmap is
    v_Location_Ids Array_Number := p.r_Array_Number('location_id');
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Division_Cnt number;
    v_Person_Cnt   number;
  begin
    select count(*)
      into v_Division_Cnt
      from Htt_Location_Divisions q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Location_Id member of v_Location_Ids;
  
    select count(*)
      into v_Person_Cnt
      from Htt_Location_Persons q
     where q.Company_Id = v_Company_Id
       and q.Filial_Id = v_Filial_Id
       and q.Location_Id member of v_Location_Ids
       and not exists (select 1
              from Htt_Blocked_Person_Tracking Bp
             where Bp.Company_Id = q.Company_Id
               and Bp.Filial_Id = q.Filial_Id
               and Bp.Employee_Id = q.Person_Id);
  
    return Fazo.Zip_Map('person_count', v_Person_Cnt, 'division_count', v_Division_Cnt);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Location_Ids Array_Number := Fazo.Sort(p.r_Array_Number('location_id'));
  begin
    for i in 1 .. v_Location_Ids.Count
    loop
      Htt_Api.Location_Delete(i_Company_Id => Ui.Company_Id, i_Location_Id => v_Location_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Locations
       set Company_Id    = null,
           Location_Id   = null,
           name          = null,
           Timezone_Code = null,
           Region_Id     = null,
           Address       = null,
           Latlng        = null,
           Accuracy      = null,
           Bssids        = null,
           Prohibited    = null,
           State         = null,
           Code          = null;
    update Htt_Location_Persons
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null,
           Person_Id   = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Devices
       set Company_Id  = null,
           Location_Id = null,
           Device_Id   = null,
           Status      = null;
    update Htt_Location_Types
       set Company_Id       = null,
           Location_Type_Id = null,
           name             = null;
    update Htt_Location_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null,
           Division_Id = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Division_Id = null,
           Filial_Id   = null,
           name        = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Timezones
       set Timezone_Code = null,
           Name_Ru       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Htt_Blocked_Person_Tracking
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  end;

end Ui_Vhr78;
/
