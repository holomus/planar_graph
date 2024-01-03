create or replace package Ui_Vhr47 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr47;
/
create or replace package body Ui_Vhr47 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_labor_functions', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('labor_function_id');
    q.Varchar2_Field('name', 'description', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id         number := Ui.Company_Id;
    v_Labor_Function_Ids Array_Number := Fazo.Sort(p.r_Array_Number('labor_function_id'));
  begin
    for i in 1 .. v_Labor_Function_Ids.Count
    loop
      Href_Api.Labor_Function_Delete(i_Company_Id        => v_Company_Id,
                                     i_Labor_Function_Id => v_Labor_Function_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Labor_Functions
       set Company_Id        = null,
           Labor_Function_Id = null,
           name              = null,
           Description       = null,
           Code              = null;
  end;

end Ui_Vhr47;
/
