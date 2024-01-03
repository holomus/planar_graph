create or replace package Ui_Vhr520 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Access_Groups(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Get_Access_Groups_Response(i_Data Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Access_Groups(p Hashmap) return Runtime_Service;
end Ui_Vhr520;
/
create or replace package body Ui_Vhr520 is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals(i_Server_Id number := null) is
  begin
    g_Server_Id := i_Server_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Access_Groups(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from hac_dss_ex_access_groups q
                      where q.server_id = :server_id',
                    Fazo.Zip_Map('server_id', p.r_Number('server_id')));
  
    q.Number_Field('server_id', 'person_count');
    q.Varchar2_Field('access_group_code', 'access_group_name', 'extra_info');
    q.Date_Field('created_on', 'modified_on');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id          number := p.r_Number('server_id');
    v_Access_Group_Codes Array_Varchar2 := Fazo.Sort(p.r_Array_Varchar2('access_group_code'));
  begin
    for i in 1 .. v_Access_Group_Codes.Count
    loop
      z_Hac_Dss_Ex_Access_Groups.Delete_One(i_Server_Id         => v_Server_Id,
                                            i_Access_Group_Code => v_Access_Group_Codes(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Get_Access_Groups_Response(i_Data Hashmap) is
  begin
    Uit_Hac.Dss_Get_Access_Groups_Response(i_Data => i_Data, i_Server_Id => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Access_Groups(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Dss_Get_Access_Groups(i_Responce_Procedure => 'Ui_Vhr520.Get_Access_Groups_Response',
                                         i_Server_Id          => g_Server_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Hac_Dss_Ex_Access_Groups
       set Server_Id         = null,
           Access_Group_Code = null,
           Access_Group_Name = null,
           Person_Count      = null,
           Extra_Info        = null,
           Created_On        = null,
           Modified_On       = null;
  end;

end Ui_Vhr520;
/
