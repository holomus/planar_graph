create or replace package Ui_Vhr70 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr70;
/
create or replace package body Ui_Vhr70 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_fixed_term_bases', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('fixed_term_base_id');
    q.Varchar2_Field('name', 'text', 'state', 'code');
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Fixed_Term_Base_Ids Array_Number := Fazo.Sort(p.r_Array_Number('fixed_term_base_id'));
  begin
    for i in 1 .. v_Fixed_Term_Base_Ids.Count
    loop
      Href_Api.Fixed_Term_Base_Delete(i_Company_Id         => Ui.Company_Id,
                                      i_Fixed_Term_Base_Id => v_Fixed_Term_Base_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Fixed_Term_Bases
       set Company_Id         = null,
           Fixed_Term_Base_Id = null,
           Text               = null,
           name               = null,
           State              = null,
           Code               = null;
  end;

end Ui_Vhr70;
/
