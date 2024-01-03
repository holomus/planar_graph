create or replace package Ui_Vhr238 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr238;
/
create or replace package body Ui_Vhr238 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_training_subjects',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('subject_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'code', 'state');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k
                    where k.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k 
                    where k.company_id = :company_id');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Subject_Ids Array_Number := Fazo.Sort(p.r_Array_Number('subject_id'));
  begin
    for i in 1 .. v_Subject_Ids.Count
    loop
      Hln_Api.Training_Subject_Delete(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_Subject_Id => v_Subject_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Training_Subjects
       set Company_Id  = null,
           Filial_Id   = null,
           Subject_Id  = null,
           name        = null,
           Code        = null,
           State       = null,
           Created_On  = null,
           Created_By  = null,
           Modified_On = null,
           Modified_By = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr238;
/
