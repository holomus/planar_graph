create or replace package Ui_Vhr465 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr465;
/
create or replace package body Ui_Vhr465 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_inventory_types', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('inventory_type_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'state');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select q.* 
                     from md_users q
                    where q.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select d.* 
                     from md_users d 
                    where d.company_id = :company_id');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('inventory_type_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Href_Api.Inventory_Type_Delete(i_Company_Id => v_Company_Id, i_Inventory_Type_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Inventory_Types
       set Company_Id        = null,
           Inventory_Type_Id = null,
           name              = null,
           State             = null,
           Created_By        = null,
           Created_On        = null,
           Modified_By       = null,
           Modified_On       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr465;
/
