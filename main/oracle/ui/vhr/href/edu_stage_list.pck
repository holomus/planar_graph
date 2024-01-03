create or replace package Ui_Vhr1 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr1;
/
create or replace package body Ui_Vhr1 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_edu_stages', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('edu_stage_id', 'order_no');
    q.Varchar2_Field('name', 'state', 'code');
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Education_Stage_Ids Array_Number := Fazo.Sort(p.r_Array_Number('edu_stage_id'));
  begin
    for i in 1 .. v_Education_Stage_Ids.Count
    loop
      Href_Api.Edu_Stage_Delete(i_Company_Id   => Ui.Company_Id,
                                i_Edu_Stage_Id => v_Education_Stage_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Href_Edu_Stages
       set Company_Id   = null,
           Edu_Stage_Id = null,
           name         = null,
           State        = null,
           Code         = null,
           Order_No     = null;
  end;

end Ui_Vhr1;
/
