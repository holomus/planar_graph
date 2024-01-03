create or replace package Ui_Vhr93 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Location_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Location_Person_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Persons(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Devices(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Attach_Division(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Detach_Division(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Attach_Person(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Detach_Person(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Person(p Hashmap);
end Ui_Vhr93;
/
create or replace package body Ui_Vhr93 is
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
    return b.Translate('UI-VHR93:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
    r_Location Htt_Locations%rowtype;
    v_Array    Array_Varchar2;
    result     Hashmap;
  begin
    r_Location := z_Htt_Locations.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Location_Id => p.r_Number('location_id'));
  
    result := z_Htt_Locations.To_Map(r_Location, --
                                     z.Location_Id,
                                     z.Name,
                                     z.Address,
                                     z.Latlng,
                                     z.Accuracy,
                                     z.Bssids,
                                     z.State,
                                     z.Code,
                                     z.Created_On,
                                     z.Modified_On);
  
    Result.Put('location_type_name',
               z_Htt_Location_Types.Take(i_Company_Id => Ui.Company_Id, i_Location_Type_Id => r_Location.Location_Type_Id).Name);
    Result.Put('prohibited_name',
               case r_Location.Prohibited when 'Y' then Ui.t_Yes else Ui.t_No end);
    Result.Put('state_name', case r_Location.State when 'A' then Ui.t_Active else Ui.t_Passive end);
    Result.Put('region_name',
               z_Md_Regions.Take(i_Company_Id => Ui.Company_Id, i_Region_Id => r_Location.Region_Id).Name);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => r_Location.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => Ui.Company_Id, i_User_Id => r_Location.Modified_By).Name);
    Result.Put('timezone_name',
               Md_Util.Timezone_Name(i_Company_Id    => r_Location.Company_Id,
                                     i_Timezone_Code => r_Location.Timezone_Code));
  
    v_Array := Array_Varchar2();
  
    select t.Latlng
      bulk collect
      into v_Array
      from Htt_Location_Polygon_Vertices t
     where t.Company_Id = Ui.Company_Id
       and t.Location_Id = r_Location.Location_Id
     order by t.Order_No;
  
    Result.Put('polygon_vertices', v_Array);
  
    if v_Array.Count > 0 then
      Result.Put('has_polygon_name', Ui.t_Yes);
    else
      Result.Put('has_polygon__name', Ui.t_No);
    end if;
  
    if Ui.Is_Filial_Head then
      v_Array := Array_Varchar2();
    
      select (select k.Name
                from Md_Filials k
               where k.Company_Id = t.Company_Id
                 and k.Filial_Id = t.Filial_Id)
        bulk collect
        into v_Array
        from Htt_Location_Filials t
       where t.Company_Id = r_Location.Company_Id
         and t.Location_Id = r_Location.Location_Id;
    
      Result.Put('filial_name', Fazo.Gather(v_Array, ', '));
    end if;
  
    Result.Put('references',
               Fazo.Zip_Map('dt_terminal',
                            Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal),
                            'dt_hikvision',
                            Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
                            'dt_dahua',
                            Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua)));
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Location_Audit(p Hashmap) return Fazo_Query is
    v_Events Matrix_Varchar2 := Md_Util.Events;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from x_htt_locations q
                      where q.t_company_id = :company_id
                        and q.location_id = :location_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'location_id',
                                 p.r_Number('location_id')));
  
    q.Number_Field('t_audit_id',
                   't_user_id',
                   't_context_id',
                   'location_id',
                   'location_type_id',
                   'accuracy');
    q.Varchar2_Field('t_event',
                     't_source_project_code',
                     'name',
                     'timezone_code',
                     'region_id',
                     'address',
                     'latlng',
                     'prohibited',
                     'state',
                     'code');
    q.Date_Field('t_timestamp', 't_date');
  
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
  
    q.Map_Field('timezone_name',
                'md_util.timezone_name(i_company_id    => :company_id,
                                       i_timezone_code => $timezone_code)');
  
    q.Option_Field('prohibited_name',
                   'prohibited',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Location_Person_Audit(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2 := Md_Util.Events;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select q.* 
                       from x_htt_location_persons q 
                      where q.t_company_id = :company_id 
                        and q.location_id = :location_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'location_id',
                                 p.r_Number('location_id')));
  
    q.Number_Field('t_audit_id', 't_user_id', 't_context_id', 'location_id', 'person_id');
    q.Varchar2_Field('t_event', 't_source_project_code', 'attach_type');
    q.Date_Field('t_timestamp', 't_date');
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Attach_Types;
  
    q.Option_Field('attach_type_name', 'attach_type', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('person_name',
                  'person_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select q.* 
                     from mr_natural_persons q
                    where q.company_id = :company_id');
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
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Divisions(p Hashmap) return Fazo_Query is
    v_Query varchar2(4000);
    q       Fazo_Query;
  begin
    v_Query := 'select *
                  from mhr_divisions q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and';
  
    if p.o_Varchar2('mode') = 'detach' then
      v_Query := v_Query || ' not';
    end if;
  
    v_Query := v_Query || ' exists (select 1
                               from htt_location_divisions w
                              where w.company_id = q.company_id
                                and w.filial_id = q.filial_id
                                and w.location_id = :location_id
                                and w.division_id = q.division_id)';
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'location_Id',
                                 p.r_Number('location_id')));
  
    q.Number_Field('division_id', 'parent_id', 'division_group_id');
    q.Varchar2_Field('name', 'state', 'code');
    q.Date_Field('opened_date', 'closed_date');
  
    q.Refer_Field('parent_name',
                  'parent_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  'select s.* 
                     from mhr_divisions s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('division_group_name',
                  'division_group_id',
                  'mhr_division_groups',
                  'division_group_id',
                  'name',
                  'select s.*
                     from mhr_division_groups s
                    where s.company_id = :company_id');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Persons(p Hashmap) return Fazo_Query is
    v_Query  varchar2(4000);
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select k.person_id,
                       q.photo_sha,
                       k.name,
                       k.first_name,
                       k.last_name,
                       k.middle_name,
                       k.gender,
                       k.birthday,
                       k.code,
                       w.tin,
                       w.region_id,
                       w.main_phone,
                       q.email,
                       w.address,
                       w.legal_address,
                       m.iapa,
                       m.npin,
                       e.state,
                       st.robot_id,
                       st.division_id,
                       sp.attach_type,
                       sp.created_by attached_by, 
                       sp.created_on attached_on 
                  from md_persons q
                  join mr_natural_persons k
                    on k.company_id = q.company_id
                   and k.person_id = q.person_id
                  join mr_person_details w
                    on w.company_id = k.company_id
                   and w.person_id = k.person_id
                  left join href_person_details m
                    on m.company_id = k.company_id
                   and m.person_id = k.person_id
                  left join mhr_employees e
                    on e.company_id = :company_id
                   and e.filial_id = :filial_id
                   and e.employee_id = k.person_id
                  left join href_staffs st
                    on st.company_id = q.company_id
                   and st.filial_id = :filial_id 
                   and st.employee_id = q.person_id
                   and st.staff_kind = :sk_primary
                   and st.hiring_date <= :current_date
                   and (st.dismissal_date is null or st.dismissal_date >= :current_date)
                   and st.state = ''A''';
  
    if p.o_Varchar2('mode') = 'attach' then
      v_Query := v_Query || --
                 ' join htt_location_persons sp
                     on sp.company_id = q.company_id
                    and sp.filial_id = :filial_id
                    and sp.location_id = :location_id
                    and sp.person_id = q.person_id
                    and not exists (select 1 
                              from htt_blocked_person_tracking w
                             where w.company_id = sp.company_id
                               and w.filial_id = sp.filial_id
                               and w.employee_id = sp.person_id)';
    else
      v_Query := v_Query || --
                 ' join (select null attach_type, 
                                null created_on, 
                                null created_by
                           from dual) sp
                     on q.company_id = :company_id
                    and not exists (select 1 
                               from htt_location_persons lp
                              where lp.company_id = :company_id
                                and lp.filial_id = :filial_id
                                and lp.location_id = :location_id
                                and lp.person_id = q.person_id)';
    end if;
  
    v_Query := v_Query || ' where q.company_id = :company_id';
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'location_Id',
                                 p.r_Number('location_id'),
                                 'sk_primary',
                                 Href_Pref.c_Staff_Kind_Primary,
                                 'current_date',
                                 Trunc(sysdate)));
  
    q.Number_Field('person_id', 'region_id', 'robot_id', 'division_id', 'attached_by');
    q.Varchar2_Field('name',
                     'first_name',
                     'last_name',
                     'middle_name',
                     'gender',
                     'photo_sha',
                     'tin',
                     'iapa',
                     'npin',
                     'main_phone');
    q.Varchar2_Field('email', 'address', 'legal_address', 'code', 'state', 'attach_type');
    q.Date_Field('birthday', 'attached_on');
  
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions s 
                    where s.company_id = :company_id');
    q.Refer_Field('robot_name',
                  'robot_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select *
                     from mrf_robots s 
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id
                      and exists (select 1
                             from hrm_robots t
                            where t.company_id = s.company_id
                              and t.filial_id = s.filial_id
                              and t.robot_id = s.robot_id)');
    q.Refer_Field('division_name',
                  'division_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  'select *
                     from mhr_divisions s 
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('attached_by_name',
                  'attached_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users s 
                    where s.company_id = :company_id');
  
    v_Matrix := Md_Util.Person_Genders;
  
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Attach_Types;
  
    q.Option_Field('attach_type_name', 'attach_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Devices(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from htt_devices q
                      where q.company_id = :company_id
                        and q.location_id = :location_id
                        and q.device_type_id <> :mobile_type_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'location_id',
                                 p.r_Number('location_id'),
                                 'mobile_type_id',
                                 Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff)));
  
    q.Number_Field('device_id', 'device_type_id', 'location_id');
    q.Varchar2_Field('name', 'serial_number', 'state');
    q.Date_Field('last_seen_on');
  
    q.Refer_Field('device_type_name',
                  'device_type_id',
                  'htt_device_types',
                  'device_type_id',
                  'name');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Division(p Hashmap) is
    v_Location_Id  number := p.r_Number('location_id');
    v_Division_Ids Array_Number := Fazo.Sort(p.r_Array_Number('division_id'));
  begin
    for i in 1 .. v_Division_Ids.Count
    loop
      Htt_Api.Location_Add_Division(i_Company_Id  => Ui.Company_Id,
                                    i_Filial_Id   => Ui.Filial_Id,
                                    i_Location_Id => v_Location_Id,
                                    i_Division_Id => v_Division_Ids(i));
    end loop;
  
    Htt_Api.Location_Sync_Persons(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach_Division(p Hashmap) is
    v_Location_Id  number := p.r_Number('location_id');
    v_Division_Ids Array_Number := Fazo.Sort(p.r_Array_Number('division_id'));
  begin
    for i in 1 .. v_Division_Ids.Count
    loop
      Htt_Api.Location_Remove_Division(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Location_Id => v_Location_Id,
                                       i_Division_Id => v_Division_Ids(i));
    end loop;
  
    Htt_Api.Location_Sync_Persons(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attach_Person(p Hashmap) is
    v_Location_Id number := p.r_Number('location_id');
    v_Person_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('person_id'));
  begin
    for i in 1 .. v_Person_Ids.Count
    loop
      Htt_Api.Location_Add_Person(i_Company_Id  => Ui.Company_Id,
                                  i_Filial_Id   => Ui.Filial_Id,
                                  i_Location_Id => v_Location_Id,
                                  i_Person_Id   => v_Person_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Detach_Person(p Hashmap) is
    v_Location_Id number := p.r_Number('location_id');
    v_Person_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('person_id'));
  begin
    for i in 1 .. v_Person_Ids.Count
    loop
      Htt_Api.Location_Remove_Person(i_Company_Id  => Ui.Company_Id,
                                     i_Filial_Id   => Ui.Filial_Id,
                                     i_Location_Id => v_Location_Id,
                                     i_Person_Id   => v_Person_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Device(p Hashmap) is
    v_Location_Id number := p.r_Number('location_id');
    v_Device_Ids  Array_Number := p.r_Array_Number('device_id');
  begin
    for r in (select q.Device_Id
                from Htt_Devices q
               where q.Company_Id = Ui.Company_Id
                 and q.Device_Id member of v_Device_Ids
                 and q.Location_Id <> v_Location_Id
                 and Rownum = 1)
    loop
      b.Raise_Error(t('sync_device: selected device is not attached to this location, device_id=$1',
                      r.Device_Id));
    end loop;
  
    for i in 1 .. v_Device_Ids.Count
    loop
      Uit_Htt.Sync_Device(v_Device_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Person(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Filial_Id       number := Ui.Filial_Id;
    v_Location_Id     number := p.r_Number('location_id');
    v_Person_Ids      Array_Number := p.r_Array_Number('person_id');
    v_Dt_Terminal_Id  number;
    v_Dt_Hikvision_Id number;
    v_Dt_Dahua_Id     number;
  begin
    for r in (select Column_Value as Person_Id
                from table(v_Person_Ids)
               where Column_Value not in (select q.Person_Id
                                            from Htt_Location_Persons q
                                           where q.Company_Id = v_Company_Id
                                             and q.Filial_Id = v_Filial_Id
                                             and q.Location_Id = v_Location_Id)
                 and Rownum = 1)
    loop
      b.Raise_Error(t('sync_person: selected person is not attached to this location, person_id=$1',
                      r.Person_Id));
    end loop;
  
    v_Dt_Terminal_Id  := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal);
    v_Dt_Hikvision_Id := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision);
    v_Dt_Dahua_Id     := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua);
  
    for r in (select q.Device_Id
                from Htt_Devices q
               where q.Company_Id = v_Company_Id
                 and q.Location_Id = v_Location_Id
                 and q.Device_Type_Id in (v_Dt_Terminal_Id, v_Dt_Hikvision_Id, v_Dt_Dahua_Id)
                 and q.State = 'A')
    loop
      Uit_Htt.Sync_Persons(i_Device_Id => r.Device_Id, i_Person_Ids => v_Person_Ids);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mhr_Divisions
       set Company_Id        = null,
           Filial_Id         = null,
           Division_Id       = null,
           name              = null,
           Parent_Id         = null,
           Division_Group_Id = null,
           Opened_Date       = null,
           Closed_Date       = null,
           State             = null,
           Code              = null;
    update Mhr_Division_Groups
       set Company_Id        = null,
           Division_Group_Id = null,
           name              = null;
    update Htt_Location_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null,
           Division_Id = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           Photo_Sha  = null,
           Email      = null;
    update Mr_Person_Details
       set Company_Id    = null,
           Person_Id     = null,
           Tin           = null,
           Main_Phone    = null,
           Address       = null,
           Legal_Address = null,
           Region_Id     = null;
    update Mr_Natural_Persons
       set Company_Id  = null,
           Person_Id   = null,
           name        = null,
           First_Name  = null,
           Last_Name   = null,
           Middle_Name = null,
           Gender      = null,
           Birthday    = null,
           Code        = null,
           State       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           name       = null;
    update Href_Person_Details
       set Company_Id = null,
           Person_Id  = null,
           Iapa       = null,
           Npin       = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Htt_Location_Persons
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null,
           Person_Id   = null,
           Attach_Type = null,
           Created_By  = null,
           Created_On  = null;
    update Htt_Devices
       set Company_Id     = null,
           Device_Id      = null,
           name           = null,
           Device_Type_Id = null,
           Serial_Number  = null,
           Location_Id    = null,
           State          = null,
           Last_Seen_On   = null;
    update Htt_Device_Types
       set Device_Type_Id = null,
           name           = null;
    update Hrm_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Htt_Location_Types
       set Company_Id       = null,
           Location_Type_Id = null,
           name             = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update x_Htt_Locations
       set t_Company_Id     = null,
           t_Audit_Id       = null,
           t_Event          = null,
           t_Timestamp      = null,
           t_Date           = null,
           t_User_Id        = null,
           Location_Id      = null,
           name             = null,
           Location_Type_Id = null,
           Timezone_Code    = null,
           Region_Id        = null,
           Address          = null,
           Latlng           = null,
           Accuracy         = null,
           Prohibited       = null,
           State            = null;
    update x_Htt_Location_Persons
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Location_Id           = null,
           Person_Id             = null,
           Attach_Type           = null;
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
    update Htt_Blocked_Person_Tracking
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  
    Uie.x(Ui_Kernel.Project_Name(null));
    Uie.x(Md_Util.Timezone_Name(null, null));
  end;

end Ui_Vhr93;
/
