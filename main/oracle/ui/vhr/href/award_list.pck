create or replace package Ui_Vhr28 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr28;
/
create or replace package body Ui_Vhr28 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_awards', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('award_id');
    q.Varchar2_Field('name', 'state');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Award_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('award_id'));
    v_Company_Id number := Ui.Company_Id;
  begin
    for i in 1 .. v_Award_Ids.Count
    loop
      Href_Api.Award_Delete(i_Company_Id => v_Company_Id, i_Award_Id => v_Award_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Awards
       set Company_Id = null,
           Award_Id   = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr28;
/
