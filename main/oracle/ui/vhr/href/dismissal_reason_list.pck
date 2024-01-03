create or replace package Ui_Vhr49 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr49;
/
create or replace package body Ui_Vhr49 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2;
  begin
    q := Fazo_Query('href_dismissal_reasons', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('dismissal_reason_id');
    q.Varchar2_Field('name', 'description', 'reason_type');
  
    v_Matrix := Href_Util.Dismissal_Reasons_Type;
  
    q.Option_Field('reason_type_name', 'reason_type', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id           number := Ui.Company_Id;
    v_Dismissal_Reason_Ids Array_Number := Fazo.Sort(p.r_Array_Number('dismissal_reason_id'));
  begin
    for i in 1 .. v_Dismissal_Reason_Ids.Count
    loop
      Href_Api.Dismissal_Reason_Delete(i_Company_Id          => v_Company_Id,
                                       i_Dismissal_Reason_Id => v_Dismissal_Reason_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null,
           Description         = null;
  end;

end Ui_Vhr49;
/
