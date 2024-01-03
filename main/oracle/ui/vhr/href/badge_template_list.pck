create or replace package Ui_Vhr453 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr453;
/
create or replace package body Ui_Vhr453 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_badge_templates', Hashmap(), true);
  
    q.Number_Field('badge_template_id');
    q.Varchar2_Field('name', 'state', 'html_value');
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    r_Data Href_Badge_Templates%rowtype;
  begin
    r_Data.Badge_Template_Id := Coalesce(p.o_Number('badge_template_id'),
                                         Href_Next.Badge_Template_Id);
    r_Data.Name              := p.r_Varchar2('name');
    r_Data.Html_Value        := p.r_Varchar2('html_value');
    r_Data.State             := p.r_Varchar2('state');
  
    Href_Api.Badge_Template_Save(r_Data);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Badge_Template_Ids Array_Number := Fazo.Sort(p.r_Array_Number('badge_template_id'));
  begin
    for i in 1 .. v_Badge_Template_Ids.Count
    loop
      Href_Api.Badge_Template_Delete(v_Badge_Template_Ids(i));
    end loop;
  end;

end Ui_Vhr453;
/
