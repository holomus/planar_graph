create or replace package Ui_Vhr247 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Persons(p Hashmap) return Fazo_Query;
end Ui_Vhr247;
/
create or replace package body Ui_Vhr247 is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR247:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_All_Persons        number;
    v_Passed_Persons     number;
    v_Not_Passed_Persons number;
    r_Training           Hln_Trainings%rowtype;
    v_Subject_Names      varchar2(2000);
    result               Hashmap;
  begin
    r_Training := z_Hln_Trainings.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Training_Id => p.r_Number('training_id'));
  
    select count(*), sum(Decode(q.Passed, 'Y', 1, 0)), sum(Decode(q.Passed, 'N', 1, 0))
      into v_All_Persons, v_Passed_Persons, v_Not_Passed_Persons
      from Hln_Training_Persons q
     where q.Company_Id = r_Training.Company_Id
       and q.Filial_Id = r_Training.Filial_Id
       and q.Training_Id = r_Training.Training_Id;
  
    result := z_Hln_Trainings.To_Map(r_Training,
                                     z.Training_Id,
                                     z.Training_Number,
                                     z.Address,
                                     z.Status,
                                     z.Created_On,
                                     z.Modified_On);
  
    select Listagg((select w.Name
                     from Hln_Training_Subjects w
                    where w.Company_Id = q.Company_Id
                      and w.Filial_Id = q.Filial_Id
                      and w.Subject_Id = q.Subject_Id),
                   ', ')
      into v_Subject_Names
      from Hln_Training_Current_Subjects q
     where q.Company_Id = r_Training.Company_Id
       and q.Filial_Id = r_Training.Filial_Id
       and q.Training_Id = r_Training.Training_Id;
  
    Result.Put('subject_group_name',
               z_Hln_Training_Subject_Groups.Take(i_Company_Id => r_Training.Company_Id, --
               i_Filial_Id => r_Training.Filial_Id, -- 
               i_Subject_Group_Id => r_Training.Subject_Group_Id).Name);
    Result.Put('mentor_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Training.Company_Id, i_Person_Id => r_Training.Mentor_Id).Name);
    Result.Put('subject_names', v_Subject_Names);
    Result.Put('begin_date', to_char(r_Training.Begin_Date, Href_Pref.c_Date_Format_Minute));
    Result.Put('all_persons', v_All_Persons);
    Result.Put('passed_persons', v_Passed_Persons);
    Result.Put('not_passed_persons', v_Not_Passed_Persons);
    Result.Put('status_name', Hln_Util.t_Training_Status(r_Training.Status));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Training.Company_Id, i_User_Id => r_Training.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Training.Company_Id, i_User_Id => r_Training.Modified_By).Name);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Persons(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.*,
                            (select count(*)
                               from hln_training_person_subjects w
                              where w.company_id = q.company_id
                                and w.filial_id = q.filial_id
                                and w.training_id = q.training_id 
                                and w.person_id = q.person_id) as all_subjects_count,
                            (select count(*)
                               from hln_training_person_subjects w
                              where w.company_id = q.company_id
                                and w.filial_id = q.filial_id
                                and w.training_id = q.training_id 
                                and w.person_id = q.person_id
                                and w.passed = ''Y'') as passed_subjects_count
                       from hln_training_persons q
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.training_id = :training_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'training_id',
                                 p.r_Number('training_id')));
  
    q.Number_Field('training_id', 'person_id', 'all_subjects_count', 'passed_subjects_count');
    q.Varchar2_Field('passed');
  
    q.Refer_Field('person_name',
                  'person_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select * 
                     from mr_natural_persons w
                    where w.company_id = :company_id
                      and exists (select 1 
                            from mrf_persons f
                           where f.company_id = w.company_id
                             and f.filial_id = :filial_id
                             and f.person_id = w.person_id)');
    q.Option_Field('passed_name',
                   'passed',
                   Array_Varchar2('Y', 'N', 'I'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No, t('indeterminate')));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Training_Persons
       set Company_Id  = null,
           Filial_Id   = null,
           Training_Id = null,
           Person_Id   = null,
           Passed      = null;
    update Hln_Training_Person_Subjects
       set Company_Id  = null,
           Filial_Id   = null,
           Training_Id = null,
           Person_Id   = null,
           Passed      = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mrf_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Person_Id  = null;
  end;

end Ui_Vhr247;
/
