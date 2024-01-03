create or replace package Ui_Vhr482 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Filial return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Set_Valid(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Invalid(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr482;
/
create or replace package body Ui_Vhr482 is
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
    return b.Translate('UI-VHR482:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    v_Query  varchar2(32767);
    v_Param  Hashmap;
    q        Fazo_Query;
  begin
    v_Query := 'select q.*,
                       q.photo_sha quality_photo_sha,
                       s.name,
                       (select k.location_type_id
                          from htt_locations k
                         where k.company_id = q.company_id
                           and k.location_id = q.location_id) location_type_id,
                       (select k.region_id
                          from htt_locations k
                         where k.company_id = q.company_id
                           and k.location_id = q.location_id) region_id,
                       to_char(q.track_time, :format) track_time_hh24_mi,
                       nvl2(q.latlng, ''Y'', ''N'') latlng_exists,
                       nvl2(q.photo_sha, ''Y'', ''N'') photo_exists,
                       case 
                         when q.latlng is not null then
                           nvl2(q.bssid, :defined_by_bssid, :defined_by_gps)
                         else 
                           null
                        end as location_defined_by,
                       case 
                         when exists (select 1
                                 from htt_timesheet_tracks f
                                where f.company_id = q.company_id
                                  and f.filial_id = q.filial_id
                                  and f.track_id = q.track_id
                                  and f.track_type = :potential_output) then
                           ''Y''
                         else
                           ''N''
                       end as is_potential_output,
                       s.device_type_id
                  from htt_tracks q
                  left join htt_devices s
                    on q.company_id = s.company_id
                   and q.device_id = s.device_id 
                 where q.company_id = :company_id';
  
    v_Param := Fazo.Zip_Map('company_id',
                            Ui.Company_Id,
                            'filial_head',
                            Ui.Filial_Id,
                            'format',
                            Href_Pref.c_Time_Format_Minute,
                            'defined_by_gps',
                            Htt_Pref.c_Location_Defined_By_Gps,
                            'defined_by_bssid',
                            Htt_Pref.c_Location_Defined_By_Bssid,
                            'device_type_id',
                            Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Staff));
  
    v_Param.Put('potential_output', Htt_Pref.c_Track_Type_Potential_Output);
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('filial_id',
                   'track_id',
                   'person_id',
                   'location_id',
                   'location_type_id',
                   'region_id',
                   'device_id',
                   'device_type_id',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('mark_type',
                     'photo_sha',
                     'quality_photo_sha',
                     'latlng',
                     'accuracy',
                     'note',
                     'original_type',
                     'is_valid',
                     'track_time_hh24_mi');
    q.Varchar2_Field('device_type_name',
                     'status',
                     'latlng_exists',
                     'photo_exists',
                     'location_defined_by',
                     'is_potential_output');
    q.Date_Field('track_date', 'track_time', 'created_on', 'modified_on');
  
    q.Multi_Varchar2_Field(i_Name        => 'track_type',
                           i_Table_Name  => 'htt_timesheet_tracks',
                           i_Join_Clause => '     @company_id = $company_id ' ||
                                            ' and @filial_id = $filial_id ' ||
                                            ' and @track_id = $track_id',
                           i_For         => 'track_type');
  
    v_Matrix := Htt_Util.Track_Types;
  
    q.Option_Field('track_type_name', 'track_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('original_type_name', 'original_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Mark_Types;
  
    q.Option_Field('mark_type_name', 'mark_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Track_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Location_Defined_Types;
  
    q.Option_Field('location_defined_by_name', 'location_defined_by', v_Matrix(1), v_Matrix(2));
  
    q.Option_Field('is_valid_name',
                   'is_valid',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('latlng_exists_name',
                   'latlng_exists',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('photo_exists_name',
                   'photo_exists',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('track_changed_name',
                   'track_changed',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('is_potential_output_name',
                   'is_potential_output',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Refer_Field('filial_name',
                  'filial_id',
                  'md_filials',
                  'filial_id',
                  'name',
                  'select q.* 
                     from md_filials q 
                    where q.company_id = :company_id
                      and q.filial_id <> :filial_head');
    q.Refer_Field('person_name',
                  'person_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select q.*
                     from mr_natural_persons q
                    where q.company_id = :company_id');
    q.Refer_Field('location_name',
                  'location_id',
                  'htt_locations',
                  'location_id',
                  'name',
                  'select *
                     from htt_locations s
                    where s.company_id = :company_id');
    q.Refer_Field('location_type_name',
                  'location_type_id',
                  'htt_location_types',
                  'location_type_id',
                  'name',
                  'select *
                     from htt_location_types s
                    where s.company_id = :company_id');
    q.Refer_Field('device_type_name',
                  'device_type_id',
                  'htt_device_types',
                  'device_type_id',
                  'name');
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select * 
                     from md_regions s
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
    q.Refer_Field('device_name',
                  'device_id',
                  'htt_devices',
                  'device_id',
                  'name',
                  'select * 
                     from htt_devices q 
                    where q.company_id = :company_id
                      and q.device_type_id <> :device_type_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Filial return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from md_filials q
                      where q.company_id = :company_id
                        and q.filial_id <> :filial_head
                        and state = ''A''',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_head', Ui.Filial_Id));
  
    q.Number_Field('filial_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Persons(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from mr_natural_persons q
                      where q.company_id = :company_id
                        and q.person_id != :user_id
                        and exists (select 1 
                               from mhr_employees s
                              where s.company_id = :company_id
                                and s.filial_id = :filial_id
                                and s.employee_id = q.person_id
                                and s.state = ''A'')',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 p.r_Number('filial_id'),
                                 'user_id',
                                 Ui.User_Id));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Locations(p Hashmap) return Fazo_Query is
    q           Fazo_Query;
    v_Param     Hashmap := Fazo.Zip_Map('company_id', Ui.Company_Id);
    v_Query     varchar2(4000);
    v_Filial_Id number := p.o_Number('filial_id');
  begin
    v_Query := 'select *
                  from htt_locations q
                 where q.company_id = :company_id
                   and q.prohibited = ''N''
                   and q.state = ''A''';
  
    if v_Filial_Id is not null then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = q.location_id)';
    
      v_Param.Put('filial_id', v_Filial_Id);
    end if;
  
    q := Fazo_Query(v_Query, v_Param);
  
    q.Number_Field('location_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    result := Fazo.Zip_Map('default_is_valid',
                           'Y',
                           'access_all_employee',
                           Uit_Href.User_Access_All_Employees,
                           'head_filial_id',
                           Ui.Filial_Id);
  
    if Ui.Grant_Has('track_type_check') then
      Result.Put('default_track_type', Htt_Pref.c_Track_Type_Check);
    elsif Ui.Grant_Has('track_type_input') then
      Result.Put('default_track_type', Htt_Pref.c_Track_Type_Input);
    elsif Ui.Grant_Has('track_type_output') then
      Result.Put('default_track_type', Htt_Pref.c_Track_Type_Output);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Valid(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Track_Ids  Array_Number := p.r_Array_Number('track_id');
    v_Filial_Ids Array_Number := p.r_Array_Number('filial_id');
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    for i in 1 .. v_Track_Ids.Count
    loop
      Htt_Api.Track_Set_Valid(i_Company_Id => v_Company_Id,
                              i_Filial_Id  => v_Filial_Ids(i),
                              i_Track_Id   => v_Track_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Invalid(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Track_Ids  Array_Number := p.r_Array_Number('track_id');
    v_Filial_Ids Array_Number := p.r_Array_Number('filial_id');
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    for i in 1 .. v_Track_Ids.Count
    loop
      Htt_Api.Track_Set_Invalid(i_Company_Id => v_Company_Id,
                                i_Filial_Id  => v_Filial_Ids(i),
                                i_Track_Id   => v_Track_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
    r_Track Htt_Tracks%rowtype;
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    r_Track := z_Htt_Tracks.To_Row(p, --
                                   z.Filial_Id,
                                   z.Person_Id,
                                   z.Location_Id,
                                   z.Track_Type,
                                   z.Note,
                                   z.Is_Valid);
  
    case r_Track.Track_Type
      when Htt_Pref.c_Track_Type_Check then
        if not Ui.Grant_Has('track_type_check') then
          b.Raise_Unauthorized;
        end if;
      when Htt_Pref.c_Track_Type_Input then
        if not Ui.Grant_Has('track_type_input') then
          b.Raise_Unauthorized;
        end if;
      when Htt_Pref.c_Track_Type_Output then
        if not Ui.Grant_Has('track_type_output') then
          b.Raise_Unauthorized;
        end if;
      else
        b.Raise_Error(t('track type not selected'));
    end case;
  
    r_Track.Company_Id := Ui.Company_Id;
    r_Track.Track_Id   := Htt_Next.Track_Id;
    r_Track.Track_Time := p.r_Date('track_time');
    r_Track.Mark_Type  := Htt_Pref.c_Mark_Type_Manual;
  
    Htt_Api.Track_Add(r_Track);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Track_Ids  Array_Number := p.r_Array_Number('track_id');
    v_Filial_Ids Array_Number := p.r_Array_Number('filial_id');
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    for i in 1 .. v_Track_Ids.Count
    loop
      Htt_Api.Track_Delete(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => v_Filial_Ids(i),
                           i_Track_Id   => v_Track_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------     
  Procedure Validation is
  begin
    update Htt_Tracks
       set Company_Id     = null,
           Filial_Id      = null,
           Track_Id       = null,
           Track_Time     = null,
           Track_Datetime = null,
           Person_Id      = null,
           Track_Type     = null,
           Mark_Type      = null,
           Device_Id      = null,
           Location_Id    = null,
           Latlng         = null,
           Accuracy       = null,
           Photo_Sha      = null,
           Note           = null,
           Original_Type  = null,
           Is_Valid       = null,
           Status         = null,
           Created_By     = null,
           Created_On     = null,
           Modified_By    = null,
           Modified_On    = null;
    update Htt_Timesheet_Tracks
       set Company_Id = null,
           Filial_Id  = null,
           Track_Id   = null,
           Track_Type = null;
    update Md_Filials
       set Company_Id = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           Prohibited  = null,
           State       = null,
           Region_Id   = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Device_Types
       set Device_Type_Id = null,
           name           = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
    update Htt_Devices
       set Company_Id = null,
           Device_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Division_Id = null,
           State       = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr482;
/
