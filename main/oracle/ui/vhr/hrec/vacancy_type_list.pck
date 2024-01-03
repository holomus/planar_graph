create or replace package Ui_Vhr642 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr642;
/
create or replace package body Ui_Vhr642 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap is
  begin
    return Fazo.Zip_Map('group_name',
                        z_Hrec_Vacancy_Groups.Load(i_Company_Id => Ui.Company_Id, i_Vacancy_Group_Id => p.r_Number('vacancy_group_id')).Name);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Query(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrec_vacancy_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'vacancy_group_id',
                                 p.r_Number('vacancy_group_id')),
                    true);
  
    q.Number_Field('vacancy_group_id', 'vacancy_type_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'code', 'pcode', 'state');
    q.Date_Field('created_on', 'modified_on');
  
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
    v_Ids        Array_Number := Fazo.Sort(p.r_Array_Number('vacancy_type_id'));
  begin
    for i in 1 .. v_Ids.Count
    loop
      Hrec_Api.Vacancy_Type_Delete(i_Company_Id => v_Company_Id, i_Vacancy_Type_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hrec_Vacancy_Types
       set Company_Id       = null,
           Vacancy_Group_Id = null,
           Vacancy_Type_Id  = null,
           name             = null,
           Code             = null,
           Pcode            = null,
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

end Ui_Vhr642;
/
