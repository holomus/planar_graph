create or replace package Ui_Vhr113 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Required(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Not_Required(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr113;
/
create or replace package body Ui_Vhr113 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_document_types', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('doc_type_id');
    q.Varchar2_Field('name', 'is_required', 'state', 'code');
    q.Option_Field('is_required_name',
                   'is_required',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Is_Required
  (
    i_Doc_Type_Ids Array_Number,
    i_Is_Required  varchar2
  ) is
  begin
    for i in 1 .. i_Doc_Type_Ids.Count
    loop
      Href_Api.Document_Type_Update_Is_Required(i_Company_Id  => Ui.Company_Id,
                                                i_Doc_Type_Id => i_Doc_Type_Ids(i),
                                                i_Is_Required => i_Is_Required);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Required(p Hashmap) is
  begin
    Update_Is_Required(p.r_Array_Number('doc_type_id'), 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Not_Required(p Hashmap) is
  begin
    Update_Is_Required(p.r_Array_Number('doc_type_id'), 'N');
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Document_Type_Ids Array_Number := Fazo.Sort(p.r_Array_Number('doc_type_id'));
  begin
    for i in 1 .. v_Document_Type_Ids.Count
    loop
      Href_Api.Document_Type_Delete(i_Company_Id  => Ui.Company_Id,
                                    i_Doc_Type_Id => v_Document_Type_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Document_Types
       set Company_Id  = null,
           Doc_Type_Id = null,
           name        = null,
           State       = null,
           Code        = null;
  end;

end Ui_Vhr113;
/
