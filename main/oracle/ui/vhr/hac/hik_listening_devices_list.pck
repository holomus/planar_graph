create or replace package Ui_Vhr665 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr665;
/
create or replace package body Ui_Vhr665 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('hac_hik_listening_devices');
  
    q.Number_Field('company_id');
    q.Varchar2_Field('device_token', 'serial_number', 'person_auth_type');
  
    q.Refer_Field(i_Name       => 'company_name',
                  i_For        => 'company_id',
                  i_Table_Name => 'md_companies',
                  i_Code_Field => 'company_id',
                  i_Name_Field => 'name');
  
    v_Matrix := Hac_Util.Person_Auth_Types;
  
    q.Option_Field(i_Name  => 'person_auth_type_name',
                   i_For   => 'person_auth_type',
                   i_Codes => v_Matrix(1),
                   i_Names => v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('listening_route_uri', Hac_Pref.c_Hik_Device_Event_Receiver_Route_Uri);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Device_Tokens Array_Varchar2 := p.r_Array_Varchar2('device_token');
  begin
    for i in 1 .. v_Device_Tokens.Count
    loop
      Hac_Api.Hik_Listening_Device_Delete(v_Device_Tokens(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Hik_Listening_Devices
       set Company_Id       = null,
           Device_Token     = null,
           Serial_Number    = null,
           Person_Auth_Type = null;
  
    update Md_Companies
       set Company_Id = null,
           name       = null;
  end;

end Ui_Vhr665;
/
