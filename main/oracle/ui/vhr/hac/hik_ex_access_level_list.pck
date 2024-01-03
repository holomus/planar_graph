create or replace package Ui_Vhr514 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Access_Levels(p Hashmap) return Runtime_Service;
  ----------------------------------------------------------------------------------------------------
  Function Access_Level_List_Response_Handler(i_Val Array_Varchar2) return Hashmap;
end Ui_Vhr514;
/
create or replace package body Ui_Vhr514 is
  ----------------------------------------------------------------------------------------------------
  g_Server_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Init_Globals(i_Server_Id number := null) is
  begin
    g_Server_Id := i_Server_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hac_hik_ex_access_levels',
                    Fazo.Zip_Map('server_id', p.r_Number('server_id')),
                    true);
  
    q.Varchar2_Field('access_level_code', 'access_level_name', 'description');
    q.Date_Field('created_on', 'modified_on');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id          number := p.r_Number('server_id');
    v_Access_Level_Codes Array_Varchar2 := Fazo.Sort(p.r_Array_Varchar2('access_level_code'));
  begin
    for i in 1 .. v_Access_Level_Codes.Count
    loop
      z_Hac_Hik_Ex_Access_Levels.Delete_One(i_Server_Id         => v_Server_Id,
                                            i_Access_Level_Code => v_Access_Level_Codes(i));
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Access_Levels(p Hashmap) return Runtime_Service is
  begin
    Init_Globals(i_Server_Id => p.r_Number('server_id'));
  
    return Uit_Hac.Hik_Get_Access_Levels(p                    => p,
                                         i_Response_Procedure => 'Ui_Vhr514.Access_Level_List_Response_Handler',
                                         i_Server_Id          => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Access_Level_List_Response_Handler(i_Val Array_Varchar2) return Hashmap is
  begin
    return Uit_Hac.Hik_Access_Level_List_Response_Handler(i_Val       => i_Val,
                                                          i_Server_Id => g_Server_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hac_Hik_Ex_Access_Levels
       set Server_Id         = null,
           Access_Level_Code = null,
           Access_Level_Name = null,
           Description       = null,
           Created_On        = null,
           Modified_On       = null;
  end;

end Ui_Vhr514;
/
