create or replace package Ui_Vhr515 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Organizations(p Hashmap) return Runtime_Service;
end Ui_Vhr515;
/
create or replace package body Ui_Vhr515 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hac_hik_ex_organizations',
                    Fazo.Zip_Map('server_id', p.r_Number('server_id')),
                    true);
  
    q.Varchar2_Field('organization_code', 'organization_name');
    q.Date_Field('created_on', 'modified_on');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id          number := p.r_Number('server_id');
    v_Organization_Codes Array_Varchar2 := Fazo.Sort(p.r_Array_Varchar2('organization_code'));
  begin
    for i in 1 .. v_Organization_Codes.Count
    loop
      z_Hac_Hik_Ex_Organizations.Delete_One(i_Server_Id         => v_Server_Id,
                                            i_Organization_Code => v_Organization_Codes(i));
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Organizations(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hac.Get_Organizations(p);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Hik_Ex_Organizations
       set Server_Id         = null,
           Organization_Code = null,
           Organization_Name = null,
           Created_On        = null,
           Modified_On       = null;
  end;

end Ui_Vhr515;
/
