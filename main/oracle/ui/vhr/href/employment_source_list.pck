create or replace package Ui_Vhr141 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr141;
/
create or replace package body Ui_Vhr141 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2 := Href_Util.Employment_Source_Kinds;
    q        Fazo_Query;
  begin
    q := Fazo_Query('href_employment_sources', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('source_id', 'order_no');
    q.Varchar2_Field('name', 'kind', 'state');
  
    q.Option_Field('kind_name', 'kind', v_Matrix(1), v_Matrix(2));
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Source_Ids Array_Number := Fazo.Sort(p.r_Array_Number('source_id'));
  begin
    for i in 1 .. v_Source_Ids.Count
    loop
      Href_Api.Employment_Source_Delete(i_Company_Id => Ui.Company_Id,
                                        i_Source_Id  => v_Source_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Employment_Sources
       set Company_Id = null,
           Source_Id  = null,
           name       = null,
           Kind       = null,
           Order_No   = null,
           State      = null;
  end;

end Ui_Vhr141;
/
