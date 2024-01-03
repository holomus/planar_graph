create or replace package Ui_Vhr357 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Deactivate(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr357;
/
create or replace package body Ui_Vhr357 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select *
                  from htt_location_qr_codes q
                 where q.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = q.location_id)';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('company_id', 'location_id');
    q.Varchar2_Field('unique_key', 'state');
    q.Date_Field('created_on');
  
    v_Query := 'select *
                  from htt_locations w
                 where w.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || -- 
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = w.location_id)';
    end if;
  
    q.Refer_Field('location_name', 'location_id', 'htt_locations', 'location_id', 'name', v_Query);
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Deactivate(p Hashmap) is
    v_Unique_Keys Array_Varchar2 := p.r_Array_Varchar2('unique_key');
    v_Company_Id  number := Ui.Company_Id;
  begin
    for i in 1 .. v_Unique_Keys.Count
    loop
      Htt_Api.Location_Qr_Code_Deactivate(i_Company_Id => v_Company_Id,
                                          i_Unique_Key => v_Unique_Keys(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Unique_Keys Array_Varchar2 := p.r_Array_Varchar2('unique_key');
    v_Company_Id  number := Ui.Company_Id;
  begin
    for i in 1 .. v_Unique_Keys.Count
    loop
      Htt_Api.Location_Qr_Code_Delete(i_Company_Id => v_Company_Id,
                                      i_Unique_Key => v_Unique_Keys(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Location_Qr_Codes
       set Company_Id  = null,
           Location_Id = null,
           Unique_Key  = null,
           State       = null,
           Created_On  = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           State       = null;
  end;

end Ui_Vhr357;
/
