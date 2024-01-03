create or replace package Ui_Vhr284 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
end Ui_Vhr284;
/
create or replace package body Ui_Vhr284 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query  := 'select q.* 
                   from hzk_commands q
                  where q.company_id = :company_id';
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id);
  
    if p.Has('device_id') then
      v_Params.Put('device_id', p.r_Number('device_id'));
      v_Query := v_Query || ' and q.device_id = :device_id';
    end if;
  
    if not Ui.Is_Filial_Head then
      v_Params.Put('filial_id', Ui.Filial_Id);
      v_Query := v_Query || ' and exists (select 1 
                                    from htt_devices d 
                                    join htt_location_filials fl
                                      on fl.company_id = :company_id
                                     and fl.filial_id = :filial_id
                                     and d.location_id = fl.location_id
                                   where d.company_id = :company_id
                                     and d.device_id = q.device_id)';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('command_id', 'device_id');
    q.Varchar2_Field('command', 'state');
    q.Date_Field('state_changed_on');
  
    v_Matrix := Hzk_Util.Command_States;
  
    v_Query := 'select q.*
                  from htt_devices q
                 where q.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || ' and exists (select 1 
                                    from htt_location_filials fl
                                   where fl.company_id = :company_id
                                     and fl.filial_id = :filial_id
                                     and fl.location_id = q.location_id)';
    end if;
  
    q.Refer_Field('device_name', 'device_id', 'htt_devices', 'device_id', 'name', v_Query);
  
    q.Option_Field('state_name', 'state', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hzk_Commands
       set Company_Id       = null,
           Device_Id        = null,
           Command          = null,
           State            = null,
           State_Changed_On = null;
    update Htt_Devices
       set Company_Id  = null,
           Device_Id   = null,
           name        = null,
           Location_Id = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
  end;

end Ui_Vhr284;
/
