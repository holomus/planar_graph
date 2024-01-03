create or replace package Ui_Vhr57 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr57;
/
create or replace package body Ui_Vhr57 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_indicators', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('indicator_id', 'created_by', 'modified_by', 'indicator_group_id');
    q.Varchar2_Field('name', 'short_name', 'identifier', 'state', 'pcode');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('indicator_group_name',
                  'indicator_group_id',
                  'href_indicator_groups',
                  'indicator_group_id',
                  'name',
                  'select q.*
                     from href_indicator_groups q
                    where q.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select s.* 
                     from md_users s 
                    where s.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select s.* 
                     from md_users s 
                    where s.company_id = :company_id');
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id    number := Ui.Company_Id;
    v_Indicator_Ids Array_Number := p.r_Array_Number('indicator_id');
  begin
    for i in 1 .. v_Indicator_Ids.Count
    loop
      Href_Api.Indicator_Delete(i_Company_Id => v_Company_Id, i_Indicator_Id => v_Indicator_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Href_Indicators
       set Company_Id         = null,
           Indicator_Id       = null,
           Indicator_Group_Id = null,
           name               = null,
           Short_Name         = null,
           Identifier         = null,
           State              = null,
           Pcode              = null;
  
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  
    update Href_Indicator_Groups
       set Company_Id         = null,
           Indicator_Group_Id = null,
           name               = null;
  end;

end Ui_Vhr57;
/
