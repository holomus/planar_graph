create or replace package Ui_Vhr19 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr19;
/
create or replace package body Ui_Vhr19 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_lang_levels', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('lang_level_id');
    q.Varchar2_Field('name', 'state', 'order_no', 'code');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id     number := Ui.Company_Id;
    v_Lang_Level_Ids Array_Number := Fazo.Sort(p.r_Array_Number('lang_level_id'));
  begin
    for i in 1 .. v_Lang_Level_Ids.Count
    loop
      Href_Api.Lang_Level_Delete(i_Company_Id    => v_Company_Id,
                                 i_Lang_Level_Id => v_Lang_Level_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Lang_Levels
       set Company_Id    = null,
           Lang_Level_Id = null,
           name          = null,
           State         = null,
           Order_No      = null,
           Code          = null;
  end;

end Ui_Vhr19;
/
