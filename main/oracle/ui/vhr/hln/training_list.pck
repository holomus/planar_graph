create or replace package Ui_Vhr241 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Procedure Set_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure execute(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Finish(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr241;
/
create or replace package body Ui_Vhr241 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q        Fazo_Query;
    v_Matrix Matrix_Varchar2;
  begin
    q := Fazo_Query('hln_trainings',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('training_id', 'mentor_id', 'subject_group_id', 'created_by', 'modified_by');
    q.Date_Field('begin_date', 'created_on', 'modified_on');
    q.Varchar2_Field('training_number', 'address', 'status');
  
    q.Refer_Field('subject_group_name',
                  'subject_group_id',
                  'hln_training_subject_groups',
                  'subject_group_id',
                  'name',
                  'select *  
                     from hln_training_subject_groups k
                    where k.company_id = :company_id
                      and k.filial_id = :filial_id');
    q.Refer_Field('mentor_name',
                  'mentor_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *  
                     from mr_natural_persons k
                    where k.company_id = :company_id
                      and exists (select 1 
                            from mrf_persons f
                           where f.company_id = k.company_id
                             and f.filial_id = :filial_id
                             and f.person_id = k.person_id)');
    q.Multi_Number_Field('subject_ids',
                         'select q.training_id,
                                 q.subject_id  
                            from hln_training_current_subjects q
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id',
                         '@training_id = $training_id',
                         'subject_id');
  
    q.Refer_Field('subject_names',
                  'subject_ids',
                  'hln_training_subjects',
                  'subject_id',
                  'name',
                  'select q.* 
                     from hln_training_subjects q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
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
  
    v_Matrix := Hln_Util.Training_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('person_count',
                'select count(tp.person_id)
                   from hln_training_persons tp
                  where tp.company_id = :company_id
                    and tp.filial_id = :filial_id
                    and tp.training_id = $training_id',
                i_Field_Type => q.Ft_Number);
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_New(p Hashmap) is
    v_Training_Ids Array_Number := Fazo.Sort(p.r_Array_Number('training_id'));
  begin
    for i in 1 .. v_Training_Ids.Count
    loop
      Hln_Api.Training_Set_New(i_Company_Id  => Ui.Company_Id,
                               i_Filial_Id   => Ui.Filial_Id,
                               i_Training_Id => v_Training_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure execute(p Hashmap) is
    v_Training_Ids Array_Number := Fazo.Sort(p.r_Array_Number('training_id'));
  begin
    for i in 1 .. v_Training_Ids.Count
    loop
      Hln_Api.Training_Execute(i_Company_Id  => Ui.Company_Id,
                               i_Filial_Id   => Ui.Filial_Id,
                               i_Training_Id => v_Training_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Finish(p Hashmap) is
    v_Training_Ids Array_Number := Fazo.Sort(p.r_Array_Number('training_id'));
  begin
    for i in 1 .. v_Training_Ids.Count
    loop
      Hln_Api.Training_Finish(i_Company_Id  => Ui.Company_Id,
                              i_Filial_Id   => Ui.Filial_Id,
                              i_Training_Id => v_Training_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_User_Id      number := Ui.User_Id;
    v_Training_Ids Array_Number := Fazo.Sort(p.r_Array_Number('training_id'));
  begin
    for i in 1 .. v_Training_Ids.Count
    loop
      Hln_Api.Training_Delete(i_Company_Id  => v_Company_Id,
                              i_Filial_Id   => v_Filial_Id,
                              i_Training_Id => v_Training_Ids(i),
                              i_User_Id     => v_User_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hln_Trainings
       set Company_Id      = null,
           Filial_Id       = null,
           Training_Id     = null,
           Training_Number = null,
           Begin_Date      = null,
           Mentor_Id       = null,
           Address         = null,
           Status          = null,
           Created_On      = null,
           Modified_On     = null,
           Created_By      = null,
           Modified_By     = null;
    update Hln_Training_Subjects
       set Company_Id = null,
           Filial_Id  = null,
           Subject_Id = null,
           name       = null;
    update Hln_Training_Subject_Groups
       set Company_Id       = null,
           Filial_Id        = null,
           Subject_Group_Id = null,
           name             = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
    update Hln_Training_Current_Subjects
       set Company_Id  = null,
           Filial_Id   = null,
           Training_Id = null,
           Subject_Id  = null;
  end;

end Ui_Vhr241;
/
