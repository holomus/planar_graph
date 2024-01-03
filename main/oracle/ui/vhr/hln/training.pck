create or replace package Ui_Vhr239 is
  ----------------------------------------------------------------------------------------------------   
  Function Query_Subject_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Subjects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Mentors return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Subjects(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Edit_Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr239;
/
create or replace package body Ui_Vhr239 is
  ----------------------------------------------------------------------------------------------------   
  Function Query_Subject_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_training_subject_groups',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('subject_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Subjects return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_training_subjects',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('subject_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Mentors return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mr_natural_persons',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Load_Subjects(p Hashmap) return Hashmap is
    v_Group_Id number := p.r_Number('subject_group_id');
    v_Matrix   Matrix_Varchar2;
    result     Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Subject_Id,
                          (select w.Name
                             from Hln_Training_Subjects w
                            where w.Company_Id = q.Company_Id
                              and w.Filial_Id = q.Filial_Id
                              and w.Subject_Id = q.Subject_Id))
      bulk collect
      into v_Matrix
      from Hln_Training_Subject_Group_Subjects q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Subject_Group_Id = v_Group_Id;
  
    Result.Put('subjects', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Training Hln_Trainings%rowtype;
    v_Matrix   Matrix_Varchar2;
    result     Hashmap;
  begin
    r_Training := z_Hln_Trainings.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Training_Id => p.r_Number('training_id'));
  
    result := z_Hln_Trainings.To_Map(r_Training,
                                     z.Training_Id,
                                     z.Training_Number,
                                     z.Begin_Date,
                                     z.Mentor_Id,
                                     z.Subject_Group_Id,
                                     z.Subject_Id,
                                     z.Address);
  
    Result.Put('mentor_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Training.Company_Id, --
               i_Person_Id => r_Training.Mentor_Id).Name);
  
    Result.Put('subject_group_name',
               z_Hln_Training_Subject_Groups.Take(i_Company_Id => r_Training.Company_Id, --
               i_Filial_Id => r_Training.Filial_Id, --
               i_Subject_Group_Id => r_Training.Subject_Group_Id).Name);
  
    select Array_Varchar2(Tp.Person_Id,
                          (select n.Name
                             from Mr_Natural_Persons n
                            where n.Company_Id = Tp.Company_Id
                              and n.Person_Id = Tp.Person_Id))
      bulk collect
      into v_Matrix
      from Hln_Training_Persons Tp
     where Tp.Company_Id = r_Training.Company_Id
       and Tp.Filial_Id = r_Training.Filial_Id
       and Tp.Training_Id = r_Training.Training_Id;
  
    Result.Put('persons', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(q.Subject_Id,
                          (select w.Name
                             from Hln_Training_Subjects w
                            where w.Company_Id = q.Company_Id
                              and w.Filial_Id = q.Filial_Id
                              and w.Subject_Id = q.Subject_Id))
      bulk collect
      into v_Matrix
      from Hln_Training_Current_Subjects q
     where q.Company_Id = r_Training.Company_Id
       and q.Filial_Id = r_Training.Filial_Id
       and q.Training_Id = r_Training.Training_Id;
  
    Result.Put('subjects', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function save
  (
    p             Hashmap,
    i_Training_Id number
  ) return Hashmap is
    p_Training Hln_Pref.Training_Rt;
  begin
    Hln_Util.Training_New(o_Training         => p_Training,
                          i_Company_Id       => Ui.Company_Id,
                          i_Filial_Id        => Ui.Filial_Id,
                          i_Training_Id      => i_Training_Id,
                          i_Training_Number  => p.o_Varchar2('training_number'),
                          i_Begin_Date       => p.r_Date('begin_date'),
                          i_Mentor_Id        => p.r_Number('mentor_id'),
                          i_Subject_Group_Id => p.o_Number('subject_group_id'),
                          i_Subject_Ids      => p.r_Array_Number('subject_ids'),
                          i_Address          => p.o_Varchar2('address'),
                          i_Persons          => p.r_Array_Number('persons'));
  
    Hln_Api.Training_Save(i_Training => p_Training, i_User_Id => Ui.User_Id);
  
    return Fazo.Zip_Map('training_id',
                        i_Training_Id,
                        'training_number',
                        z_Hln_Trainings.Load(i_Company_Id => p_Training.Company_Id, --
                        i_Filial_Id => p_Training.Filial_Id, --
                        i_Training_Id => p_Training.Training_Id).Training_Number);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hln_Next.Training_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Edit(p Hashmap) return Hashmap is
    v_Training_Id number := p.r_Number('training_id');
  begin
    z_Hln_Trainings.Lock_Only(i_Company_Id  => Ui.Company_Id,
                              i_Filial_Id   => Ui.Filial_Id,
                              i_Training_Id => v_Training_Id);
  
    return save(p, v_Training_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hln_Training_Subjects
       set Company_Id = null,
           Filial_Id  = null,
           Subject_Id = null,
           name       = null,
           State      = null;
    update Hln_Training_Subject_Groups
       set Company_Id       = null,
           Filial_Id        = null,
           Subject_Group_Id = null,
           name             = null,
           State            = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr239;
/
