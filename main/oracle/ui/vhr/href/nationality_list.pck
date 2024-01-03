create or replace package Ui_Vhr449 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr449;
/
create or replace package body Ui_Vhr449 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_nationalities', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('nationality_id');
    q.Varchar2_Field('name', 'state', 'code');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id      number := Ui.Company_Id;
    v_Nationality_Ids Array_Number := Fazo.Sort(p.r_Array_Number('nationality_id'));
  begin
    for i in 1 .. v_Nationality_Ids.Count
    loop
      Href_Api.Nationality_Delete(i_Company_Id     => v_Company_Id,
                                  i_Nationality_Id => v_Nationality_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Nationalities
       set Company_Id     = null,
           Nationality_Id = null,
           name           = null,
           State          = null,
           Code           = null;
  end;

end Ui_Vhr449;
/
