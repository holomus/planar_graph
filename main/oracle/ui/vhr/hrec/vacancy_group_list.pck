create or replace package Ui_Vhr640 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr640;
/
create or replace package body Ui_Vhr640 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_vacancy_groups', Fazo.Zip_Map('company_id', Ui.Company_Id), true);
  
    q.Number_Field('vacancy_group_id', 'order_no', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'is_required', 'multiple_select', 'code', 'pcode', 'state');
    q.Date_Field('created_on', 'modified_on');
  
    q.Option_Field('is_required_name',
                   'is_required',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('multiple_select_name',
                   'multiple_select',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users w
                    where w.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('vacancy_group_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Hrec_Api.Vacancy_Group_Delete(i_Company_Id => v_Company_Id, i_Vacancy_Group_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hrec_Vacancy_Groups
       set Company_Id       = null,
           Vacancy_Group_Id = null,
           name             = null,
           Order_No         = null,
           Is_Required      = null,
           Multiple_Select  = null,
           Code             = null,
           State            = null,
           Created_By       = null,
           Created_On       = null,
           Modified_By      = null,
           Modified_On      = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr640;
/
