create or replace package Ui_Vhr81 is
  ----------------------------------------------------------------------------------------------------  
  Function Location_Name(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Terminal_Models return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Admins return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Langs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr81;
/
create or replace package body Ui_Vhr81 is
  ----------------------------------------------------------------------------------------------------  
  Function Location_Name(p Hashmap) return Hashmap is
    v_Location_Name varchar2(100 char);
  begin
    v_Location_Name := z_Htt_Locations.Load(i_Company_Id => Ui.Company_Id, --
                       i_Location_Id => p.r_Number('location_id')).Name;
  
    return Fazo.Zip_Map('location_name', v_Location_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Terminal_Models return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from htt_terminal_models q
                      where q.state = ''A''');
  
    q.Number_Field('model_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query is
    v_Query  varchar2(2000);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query  := 'select q.*
                   from htt_locations q
                  where q.company_id = :company_id
                    and q.prohibited = ''N''
                    and q.state = ''A''';
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id);
  
    if Ui.Is_Filial_Head = false then
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Query := v_Query || ' and exists (select 1
                                    from htt_location_filials w
                                   where w.company_id = :company_id
                                     and w.filial_id = :filial_id
                                     and w.location_id = q.location_id)';
    
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('location_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Admins return Fazo_Query is
    v_Query  varchar2(2000);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query := 'select q.*
                  from mr_natural_persons q
                 where q.company_id = :company_id
                   and q.state = ''A''';
  
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id);
  
    if Ui.Is_Filial_Head = false then
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Query := v_Query || ' and exists (select 1
                                    from mhr_employees w
                                   where w.company_id = :company_id
                                     and w.filial_id = :filial_id
                                     and w.employee_id = q.person_id
                                     and w.state = ''A'')';
    
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Langs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_langs', Fazo.Zip_Map('state', 'A'), true);
  
    q.Varchar2_Field('lang_code', 'name');
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function References return Hashmap is
    r_Device_Type  Htt_Device_Types%rowtype;
    v_Device_Types Hashmap := Hashmap();
    result         Hashmap := Hashmap();
  begin
    r_Device_Type := z_Htt_Device_Types.Load(Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal));
  
    v_Device_Types.Put('terminal',
                       z_Htt_Device_Types.To_Map(r_Device_Type, z.Device_Type_Id, z.Name));
  
    r_Device_Type := z_Htt_Device_Types.Load(Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision));
  
    v_Device_Types.Put('hikvision',
                       z_Htt_Device_Types.To_Map(r_Device_Type, z.Device_Type_Id, z.Name));
  
    r_Device_Type := z_Htt_Device_Types.Load(Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua));
  
    v_Device_Types.Put('dahua', z_Htt_Device_Types.To_Map(r_Device_Type, z.Device_Type_Id, z.Name));
  
    r_Device_Type := z_Htt_Device_Types.Load(Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad));
  
    v_Device_Types.Put('timepad',
                       z_Htt_Device_Types.To_Map(r_Device_Type, z.Device_Type_Id, z.Name));
    Result.Put('device_types', v_Device_Types);
    Result.Put('protocols', Fazo.Zip_Matrix_Transposed(Htt_Util.Protocols));
    Result.Put('track_type_input', Htt_Pref.c_Track_Type_Input);
    Result.Put('track_type_output', Htt_Pref.c_Track_Type_Output);
    Result.Put('track_type_check', Htt_Pref.c_Track_Type_Check);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    v_Lang_Code varchar2(5) := Hes_Util.Get_Lang_Code(Ui.Company_Id);
    result      Hashmap := Hashmap();
  begin
    Result.Put('device_type_id', Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad));
    Result.Put('use_settings', 'Y');
    Result.Put('lang_code', v_Lang_Code);
    Result.Put('lang_name', z_Md_Langs.Load(v_Lang_Code).Name);
    Result.Put('autogen_input', 'N');
    Result.Put('autogen_output', 'N');
    Result.Put('only_last_restricted', 'N');
    Result.Put('ignore_tracks', 'N');
    Result.Put('ignore_images', 'N');
    Result.Put('state', 'A');
    Result.Put('dynamic_ip', 'N');
    Result.Put('protocol', Htt_Pref.c_Protocol_Http);
    Result.Put('integrate_by_service', 'Y');
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Data        Htt_Devices%rowtype;
    r_Acms        Htt_Acms_Devices%rowtype;
    r_Device_Type Htt_Device_Types%rowtype;
    v_Matrix      Matrix_Varchar2;
    result        Hashmap;
  begin
    r_Data        := z_Htt_Devices.Load(i_Company_Id => Ui.Company_Id,
                                        i_Device_Id  => p.r_Number('device_id'));
    r_Device_Type := z_Htt_Device_Types.Load(r_Data.Device_Type_Id);
  
    result := z_Htt_Devices.To_Map(r_Data,
                                   z.Device_Id,
                                   z.Device_Type_Id,
                                   z.Name,
                                   z.Serial_Number,
                                   z.Model_Id,
                                   z.Location_Id,
                                   z.State,
                                   z.Track_Types,
                                   z.Mark_Types,
                                   z.Emotion_Types,
                                   z.Lang_Code,
                                   z.Use_Settings,
                                   z.Autogen_Inputs,
                                   z.Autogen_Outputs,
                                   z.Ignore_Tracks,
                                   z.Ignore_Images,
                                   z.Restricted_Type,
                                   z.Only_Last_Restricted);
  
    Result.Put('device_type_name', r_Device_Type.Name);
    Result.Put('location_name',
               z_Htt_Locations.Take(i_Company_Id => r_Data.Company_Id, i_Location_Id => r_Data.Location_Id).Name);
    Result.Put('lang_name', z_Md_Langs.Take(r_Data.Lang_Code).Name);
  
    Result.Put('model_name', z_Htt_Terminal_Models.Take(r_Data.Model_Id).Name);
  
    select Array_Varchar2(q.Person_Id,
                          (select w.Name
                             from Mr_Natural_Persons w
                            where w.Company_Id = q.Company_Id
                              and w.Person_Id = q.Person_Id))
      bulk collect
      into v_Matrix
      from Htt_Device_Admins q
     where q.Company_Id = r_Data.Company_Id
       and q.Device_Id = r_Data.Device_Id;
  
    Result.Put('admins', Fazo.Zip_Matrix(v_Matrix));
  
    if r_Device_Type.Pcode in
       (Htt_Pref.c_Pcode_Device_Type_Hikvision, Htt_Pref.c_Pcode_Device_Type_Dahua) then
      if z_Htt_Acms_Devices.Exist(i_Company_Id => r_Data.Company_Id,
                                  i_Device_Id  => r_Data.Device_Id,
                                  o_Row        => r_Acms) then
        Result.Put_All(z_Htt_Acms_Devices.To_Map(r_Acms,
                                                 z.Dynamic_Ip,
                                                 z.Ip_Address,
                                                 z.Port,
                                                 z.Host,
                                                 z.Login));
      
        Result.Put('protocol', Nvl(r_Acms.Protocol, Htt_Pref.c_Protocol_Http));
        Result.Put('integrate_by_service', 'Y');
      else
        Result.Put('dynamic_ip', 'N');
        Result.Put('protocol', Htt_Pref.c_Protocol_Http);
        Result.Put('integrate_by_service', 'N');
      end if;
    end if;
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Acms_Device_Save
  (
    p           Hashmap,
    i_Device_Id number
  ) is
    r_Device Htt_Acms_Devices%rowtype;
  begin
    z_Htt_Acms_Devices.To_Row(r_Device,
                              p,
                              z.Dynamic_Ip,
                              z.Ip_Address,
                              z.Port,
                              z.Protocol,
                              z.Host,
                              z.Login,
                              z.Password);
  
    r_Device.Company_Id := Ui.Company_Id;
    r_Device.Device_Id  := i_Device_Id;
  
    Htt_Api.Acms_Device_Save(r_Device);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
    r_Device    Htt_Devices%rowtype;
    v_Zktime    Hzk_Pref.Zktime_Rt;
    v_Admin_Ids Array_Number := Array_Number();
  begin
    r_Device.Company_Id := Ui.Company_Id;
    r_Device.Device_Id  := Htt_Next.Device_Id;
    r_Device.Status     := Htt_Pref.c_Device_Status_Unknown;
  
    z_Htt_Devices.To_Row(r_Device,
                         p,
                         z.Name,
                         z.Device_Type_Id,
                         z.Serial_Number,
                         z.Model_Id,
                         z.Location_Id,
                         z.Host,
                         z.Login,
                         z.Password,
                         z.State,
                         z.Track_Types,
                         z.Mark_Types,
                         z.Emotion_Types,
                         z.Lang_Code,
                         z.Use_Settings,
                         z.Autogen_Inputs,
                         z.Autogen_Outputs,
                         z.Ignore_Tracks,
                         z.Ignore_Images,
                         z.Restricted_Type,
                         z.Only_Last_Restricted);
  
    if r_Device.Device_Type_Id not in --
       (Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
        Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua)) then
      v_Admin_Ids := p.r_Array_Number('admins');
    end if;
  
    if r_Device.Device_Type_Id = Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Terminal) then
      v_Zktime.Company_Id      := r_Device.Company_Id;
      v_Zktime.Device_Id       := r_Device.Device_Id;
      v_Zktime.Serial_Number   := r_Device.Serial_Number;
      v_Zktime.Name            := r_Device.Name;
      v_Zktime.Model_Id        := r_Device.Model_Id;
      v_Zktime.Location_Id     := r_Device.Location_Id;
      v_Zktime.Autogen_Inputs  := r_Device.Autogen_Inputs;
      v_Zktime.Autogen_Outputs := r_Device.Autogen_Outputs;
      v_Zktime.Ignore_Tracks   := r_Device.Ignore_Tracks;
      v_Zktime.Ignore_Images   := r_Device.Ignore_Images;
      v_Zktime.Restricted_Type := r_Device.Restricted_Type;
      v_Zktime.State           := r_Device.State;
    
      Hzk_Api.Device_Add(v_Zktime);
    else
      Htt_Api.Device_Add(r_Device);
    end if;
  
    for i in 1 .. v_Admin_Ids.Count
    loop
      Htt_Api.Device_Add_Admin(i_Company_Id => r_Device.Company_Id,
                               i_Device_Id  => r_Device.Device_Id,
                               i_Person_Id  => v_Admin_Ids(i));
    end loop;
  
    for r in (select *
                from Htt_Device_Admins q
               where q.Company_Id = r_Device.Company_Id
                 and q.Device_Id = r_Device.Device_Id
                 and q.Person_Id not member of v_Admin_Ids)
    loop
      Htt_Api.Device_Remove_Admin(i_Company_Id => r.Company_Id,
                                  i_Device_Id  => r.Device_Id,
                                  i_Person_Id  => r.Person_Id);
    end loop;
  
    if r_Device.Device_Type_Id in
       (Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
        Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua)) and
       Nvl(p.o_Varchar2('integrate_by_service'), 'Y') = 'Y' then
      Acms_Device_Save(p, r_Device.Device_Id);
    end if;
  
    if p.o_Varchar2('sync') is not null then
      Uit_Htt.Sync_Device(r_Device.Device_Id);
    end if;
  
    return z_Htt_Devices.To_Map(r_Device, z.Device_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    v_Admin_Ids Array_Number;
    r_Device    Htt_Devices%rowtype;
  begin
    r_Device := z_Htt_Devices.Lock_Load(i_Company_Id => Ui.Company_Id,
                                        i_Device_Id  => p.r_Number('device_id'));
  
    z_Htt_Devices.To_Row(r_Device,
                         p,
                         z.Name,
                         z.Model_Id,
                         z.Location_Id,
                         z.State,
                         z.Track_Types,
                         z.Mark_Types,
                         z.Emotion_Types,
                         z.Lang_Code,
                         z.Use_Settings,
                         z.Autogen_Inputs,
                         z.Autogen_Outputs,
                         z.Ignore_Tracks,
                         z.Ignore_Images,
                         z.Restricted_Type,
                         z.Only_Last_Restricted);
  
    Htt_Api.Device_Update(i_Company_Id           => r_Device.Company_Id,
                          i_Device_Id            => r_Device.Device_Id,
                          i_Name                 => Option_Varchar2(r_Device.Name),
                          i_Model_Id             => Option_Number(r_Device.Model_Id),
                          i_Location_Id          => Option_Number(r_Device.Location_Id),
                          i_State                => Option_Varchar2(r_Device.State),
                          i_Track_Types          => Option_Varchar2(r_Device.Track_Types),
                          i_Mark_Types           => Option_Varchar2(r_Device.Mark_Types),
                          i_Emotion_Types        => Option_Varchar2(r_Device.Emotion_Types),
                          i_Lang_Code            => Option_Varchar2(r_Device.Lang_Code),
                          i_Autogen_Inputs       => Option_Varchar2(r_Device.Autogen_Inputs),
                          i_Autogen_Outputs      => Option_Varchar2(r_Device.Autogen_Outputs),
                          i_Ignore_Tracks        => Option_Varchar2(r_Device.Ignore_Tracks),
                          i_Ignore_Images        => Option_Varchar2(r_Device.Ignore_Images),
                          i_Restricted_Type      => Option_Varchar2(r_Device.Restricted_Type),
                          i_Only_Last_Restricted => Option_Varchar2(r_Device.Only_Last_Restricted),
                          i_Use_Settings         => Option_Varchar2(r_Device.Use_Settings));
  
    if r_Device.Device_Type_Id not in --
       (Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
        Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Dahua)) then
      v_Admin_Ids := p.r_Array_Number('admins');
    
      for i in 1 .. v_Admin_Ids.Count
      loop
        Htt_Api.Device_Add_Admin(i_Company_Id => r_Device.Company_Id,
                                 i_Device_Id  => r_Device.Device_Id,
                                 i_Person_Id  => v_Admin_Ids(i));
      end loop;
    
      for r in (select *
                  from Htt_Device_Admins q
                 where q.Company_Id = r_Device.Company_Id
                   and q.Device_Id = r_Device.Device_Id
                   and q.Person_Id not member of v_Admin_Ids)
      loop
        Htt_Api.Device_Remove_Admin(i_Company_Id => r.Company_Id,
                                    i_Device_Id  => r.Device_Id,
                                    i_Person_Id  => r.Person_Id);
      end loop;
    elsif Nvl(p.o_Varchar2('integrate_by_service'), 'N') = 'Y' then
      Acms_Device_Save(p, r_Device.Device_Id);
    end if;
  
    if p.o_Varchar2('sync') is not null then
      Uit_Htt.Sync_Device(r_Device.Device_Id);
    end if;
  
    return z_Htt_Devices.To_Map(r_Device, z.Device_Id, z.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Terminal_Models
       set Model_Id = null,
           name     = null,
           State    = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           Prohibited  = null,
           State       = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Md_Langs
       set Lang_Code = null,
           name      = null,
           State     = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           State       = null;
  end;

end Ui_Vhr81;
/
