create or replace package Ui_Vhr522 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Person_Groups(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Groups(p Hashmap) return Runtime_Service;
end Ui_Vhr522;
/
create or replace package body Ui_Vhr522 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Person_Groups(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*
                       from hac_dss_ex_person_groups q
                      where q.server_id = :server_id',
                    Fazo.Zip_Map('server_id', p.r_Number('server_id')));
  
    q.Number_Field('server_id');
    q.Varchar2_Field('person_group_code', 'person_group_name', 'extra_info');
    q.Date_Field('created_on', 'modified_on');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Server_Id          number := p.r_Number('server_id');
    v_Person_Group_Codes Array_Varchar2 := Fazo.Sort(p.r_Array_Varchar2('person_group_code'));
  begin
    for i in 1 .. v_Person_Group_Codes.Count
    loop
      z_Hac_Dss_Ex_Person_Groups.Delete_One(i_Server_Id         => v_Server_Id,
                                            i_Person_Group_Code => v_Person_Group_Codes(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Person_Groups(p Hashmap) return Runtime_Service is
  begin
    return Uit_Hac.Get_Person_Groups(p);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update Hac_Dss_Ex_Person_Groups
       set Server_Id         = null,
           Person_Group_Code = null,
           Person_Group_Name = null,
           Extra_Info        = null,
           Created_On        = null,
           Modified_On       = null;
  end;

end Ui_Vhr522;
/
