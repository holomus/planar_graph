create or replace package Ui_Vhr255 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr255;
/
create or replace package body Ui_Vhr255 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hrm_wage_scale_registers',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('register_id', 'wage_scale_id', 'base_wage', 'created_by', 'modified_by');
    q.Varchar2_Field('register_number', 'round_model', 'posted', 'note');
    q.Date_Field('register_date', 'valid_from', 'created_on', 'modified_on');
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    q.Refer_Field('wage_scale_name',
                  'wage_scale_id',
                  'hrm_wage_scales',
                  'wage_scale_id',
                  'name',
                  'select * 
                     from hrm_wage_scales w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Register_Ids Array_Number := Fazo.Sort(p.r_Array_Number('register_id'));
  begin
    for i in 1 .. v_Register_Ids.Count
    loop
      Hrm_Api.Wage_Scale_Register_Post(i_Company_Id  => v_Company_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Register_Id => v_Register_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Register_Ids Array_Number := Fazo.Sort(p.r_Array_Number('register_id'));
  begin
    for i in 1 .. v_Register_Ids.Count
    loop
      Hrm_Api.Wage_Scale_Register_Unpost(i_Company_Id  => v_Company_Id,
                                         i_Filial_Id   => v_Filial_Id,
                                         i_Register_Id => v_Register_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Register_Ids Array_Number := Fazo.Sort(p.r_Array_Number('register_id'));
  begin
    for i in 1 .. v_Register_Ids.Count
    loop
      Hrm_Api.Wage_Scale_Register_Delete(i_Company_Id  => v_Company_Id,
                                         i_Filial_Id   => v_Filial_Id,
                                         i_Register_Id => v_Register_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hrm_Wage_Scale_Registers
       set Company_Id      = null,
           Filial_Id       = null,
           Register_Id     = null,
           Register_Date   = null,
           Register_Number = null,
           Wage_Scale_Id   = null,
           Round_Model     = null,
           Base_Wage       = null,
           Valid_From      = null,
           Posted          = null,
           Note            = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
  
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Filial_Id     = null,
           Wage_Scale_Id = null,
           name          = null;
  
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr255;
/
