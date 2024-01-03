create or replace package Ui_Vhr282 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Eval(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
end Ui_Vhr282;
/
create or replace package body Ui_Vhr282 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('attlog_error_status_new', Hzk_Pref.c_Attlog_Error_Status_New);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query  := 'select q.* 
                   from hzk_attlog_errors q
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
                                     and fl.location_id = d.location_id
                                   where d.company_id = :company_id
                                     and d.device_id = q.device_id)';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('error_id', 'device_id');
    q.Varchar2_Field('command', 'error', 'status');
  
    v_Matrix := Hzk_Util.Attlog_Error_Status;
  
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
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Eval(p Hashmap) is
    v_Error_Ids Array_Number := Fazo.Sort(p.r_Array_Number('error_id'));
  begin
    for i in 1 .. v_Error_Ids.Count
    loop
      Hzk_Api.Eval_Attlog_Error(Ui.Company_Id, v_Error_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hzk_Attlog_Errors
       set Company_Id = null,
           Error_Id   = null,
           Device_Id  = null,
           Command    = null,
           Error      = null;
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

end Ui_Vhr282;
/
