create or replace package Ui_Vhr673 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------   
  Procedure Del(p Hashmap);
end Ui_Vhr673;
/
create or replace package body Ui_Vhr673 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_training_subject_groups',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('subject_group_id', 'created_by', 'modified_by');
    q.Varchar2_Field('name', 'code', 'state');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k
                    where k.company_id = :company_id
                      and exists (select 1 
                             from md_user_filials r
                            where r.company_id = :company_id 
                              and r.filial_id = :filial_id
                              and r.user_id = k.user_id)');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users k 
                    where k.company_id = :company_id
                      and exists (select 1 
                             from md_user_filials r
                            where r.company_id = :company_id 
                              and r.filial_id = :filial_id
                              and r.user_id = k.user_id)');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Del(p Hashmap) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id ;
    v_Group_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('subject_group_id'));
  begin
    for i in 1 .. v_Group_Ids.Count
    loop
      Hln_Api.Trainig_Subject_Group_Delete(i_Company_Id       => v_Company_Id,
                                           i_Filial_Id        => v_Filial_Id,
                                           i_Subject_Group_Id => v_Group_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hln_Training_Subject_Groups
       set Company_Id       = null,
           Filial_Id        = null,
           Subject_Group_Id = null,
           name             = null,
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
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
  end;

end Ui_Vhr673;
/
