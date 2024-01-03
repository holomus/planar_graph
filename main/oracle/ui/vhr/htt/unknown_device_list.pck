create or replace package Ui_Vhr355 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Unreliable(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------
  Procedure Reliable(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Tracks(p Hashmap);
end Ui_Vhr355;
/
create or replace package body Ui_Vhr355 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Location_Id number := p.o_Number('location_id');
    v_Params      Hashmap;
    v_Query       varchar2(4000);
    q             Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id);
  
    v_Query := 'select q.*,
                       (select w.name
                          from htt_device_types w
                         where w.device_type_id = q.device_type_id) as device_type_name
                  from htt_devices q 
                 where q.company_id = :company_id
                   and q.state = ''A''
                   and exists (select 1
                          from htt_unknown_devices d
                         where d.company_id = :company_id
                           and d.device_id = q.device_id)';
  
    if v_Location_Id is not null then
      v_Params.Put('location_id', v_Location_Id);
    
      v_Query := v_Query || ' and q.location_id = :location_id';
    end if;
  
    if not Ui.Is_Filial_Head then
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = q.location_id)';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('device_id', 'location_id', 'device_type_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'serial_number', 'device_type_name');
    q.Date_Field('last_seen_on', 'created_on', 'modified_on');
  
    v_Query := 'select * 
                  from htt_locations q 
                 where q.company_id = :company_id';
  
    if v_Location_Id is not null then
      v_Query := v_Query || ' and q.location_id = :location_id';
    end if;
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = q.location_id)';
    end if;
  
    q.Refer_Field('location_name', 'location_id', 'htt_locations', 'location_id', 'name', v_Query);
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
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Unreliable(p Hashmap) return Arraylist is
    v_Device_Ids Array_Number := Fazo.Sort(p.r_Array_Number('device_id'));
    v_Count      number;
    v_Data       Hashmap;
    v_Company_Id number := Ui.Company_Id;
    v_Tracks     Arraylist := Arraylist();
    r_Device     Htt_Devices%rowtype;
  begin
    for i in 1 .. v_Device_Ids.Count
    loop
      Htt_Api.Unreliable_Device(i_Company_Id => v_Company_Id, i_Device_Id => v_Device_Ids(i));
    
      select count(*)
        into v_Count
        from Htt_Tracks q
       where q.Company_Id = v_Company_Id
         and q.Device_Id = v_Device_Ids(i);
    
      if v_Count > 0 then
        v_Data   := Hashmap();
        r_Device := z_Htt_Devices.Load(i_Company_Id => v_Company_Id, i_Device_Id => v_Device_Ids(i));
      
        v_Data.Put('tracks_count', v_Count);
        v_Data.Put('device_id', v_Device_Ids(i));
        v_Data.Put('device_name', r_Device.Name);
        v_Data.Put('serial_number', r_Device.Serial_Number);
      
        v_Tracks.Push(v_Data);
      end if;
    end loop;
  
    return v_Tracks;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reliable(p Hashmap) is
    v_Device_Ids Array_Number := Fazo.Sort(p.r_Array_Number('device_id'));
    v_Company_Id number := Ui.Company_Id;
  begin
    for i in 1 .. v_Device_Ids.Count
    loop
      Htt_Api.Reliable_Device(i_Company_Id => v_Company_Id, i_Device_Id => v_Device_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Clear_Tracks(p Hashmap) is
    v_Device_Ids Array_Number := Fazo.Sort(p.r_Array_Number('device_id'));
    v_Company_Id number := Ui.Company_Id;
  begin
    for i in 1 .. v_Device_Ids.Count
    loop
      Htt_Api.Clear_Device_Tracks(i_Company_Id => v_Company_Id, i_Device_Id => v_Device_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Devices
       set Company_Id     = null,
           Device_Id      = null,
           name           = null,
           Device_Type_Id = null,
           Serial_Number  = null,
           State          = null,
           Last_Seen_On   = null,
           Created_By     = null,
           Created_On     = null,
           Modified_By    = null,
           Modified_On    = null;
    update Htt_Unknown_Devices
       set Company_Id = null,
           Device_Id  = null;
    update Htt_Device_Types
       set Device_Type_Id = null,
           name           = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           State       = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr355;
/
