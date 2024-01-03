create or replace package Ui_Vhr162 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr162;
/
create or replace package body Ui_Vhr162 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_location_types', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('location_type_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'color', 'state', 'code');
    q.Date_Field('created_on', 'modified_on');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.*
                     from md_users w
                    where w.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Ids Array_Number := Fazo.Sort(p.r_Array_Number('location_type_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Htt_Api.Location_Type_Delete(i_Company_Id       => Ui.Company_Id, --
                                   i_Location_Type_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Location_Types
       set Company_Id       = null,
           Location_Type_Id = null,
           name             = null,
           Color            = null,
           State            = null,
           Code             = null,
           Created_By       = null,
           Modified_On      = null,
           Modified_By      = null,
           Created_On       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr162;
/
