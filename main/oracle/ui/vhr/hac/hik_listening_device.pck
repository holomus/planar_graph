create or replace package Ui_Vhr666 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Companies return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function save(p Hashmap) return Hashmap;
end Ui_Vhr666;
/
create or replace package body Ui_Vhr666 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Companies return Fazo_Query is
    v_Query varchar2(4000);
    q       Fazo_Query;
  begin
    v_Query := 'select q.*
                  from md_companies q
                 where q.state = :state';
  
    q := Fazo_Query(v_Query, Fazo.Zip_Map('state', 'A'));
  
    q.Number_Field('company_id');
    q.Varchar2_Field('name', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('listening_route_uri', Hac_Pref.c_Hik_Device_Event_Receiver_Route_Uri);
  
    Result.Put('auth_types', Fazo.Zip_Matrix_Transposed(Hac_Util.Person_Auth_Types));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('device_token',
                           Hac_Util.Gen_Token,
                           'person_auth_type',
                           Hac_Pref.c_Person_Auth_Type_External_Code);
  
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save(p Hashmap) return Hashmap is
    r_Device Hac_Hik_Listening_Devices%rowtype;
  begin
    r_Device := z_Hac_Hik_Listening_Devices.To_Row(p,
                                                   z.Device_Token,
                                                   z.Serial_Number,
                                                   z.Company_Id,
                                                   z.Person_Auth_Type);
  
    Hac_Api.Hik_Listening_Device_Save(r_Device);
  
    return z_Hac_Hik_Listening_Devices.To_Map(r_Device, z.Serial_Number, z.Device_Token);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           Code       = null;
  end;

end Ui_Vhr666;
/
