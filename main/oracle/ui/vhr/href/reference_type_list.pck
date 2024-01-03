create or replace package Ui_Vhr45 is
  ----------------------------------------------------------------------------------------------------   
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr45;
/
create or replace package body Ui_Vhr45 is
  ----------------------------------------------------------------------------------------------------   
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_reference_types', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('reference_type_id');
    q.Varchar2_Field('name', 'state', 'code');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id         number := Ui.Company_Id;
    v_Reference_Type_Ids Array_Number := Fazo.Sort(p.r_Array_Number('reference_type_id'));
  begin
    for i in 1 .. v_Reference_Type_Ids.Count
    loop
      Href_Api.Reference_Type_Delete(i_Company_Id        => v_Company_Id,
                                     i_Reference_Type_Id => v_Reference_Type_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Reference_Types
       set Company_Id        = null,
           Reference_Type_Id = null,
           name              = null,
           State             = null,
           Code              = null;
  end;

end Ui_Vhr45;
/
