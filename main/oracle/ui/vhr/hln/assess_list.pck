create or replace package Ui_Vhr240 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Assess_Person(p Hashmap);
end Ui_Vhr240;
/
create or replace package body Ui_Vhr240 is
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
    return b.Translate('UI-VHR240:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Matrix   Matrix_Varchar2;
    r_Training Hln_Trainings%rowtype;
    result     Hashmap;
  begin
    r_Training := z_Hln_Trainings.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Training_Id => p.r_Number('training_id'));
  
    Hln_Util.Assert_Assess(i_Company_Id  => r_Training.Company_Id,
                           i_Filial_Id   => r_Training.Filial_Id,
                           i_Training_Id => r_Training.Training_Id,
                           i_Mentor_Id   => Ui.User_Id);
  
    select Array_Varchar2(q.Person_Id,
                          f.Name,
                          Decode(q.Passed, Hln_Pref.c_Passed_Indeterminate, 'N', q.Passed))
      bulk collect
      into v_Matrix
      from Hln_Training_Persons q
      join Mr_Natural_Persons f
        on f.Company_Id = q.Company_Id
       and f.Person_Id = q.Person_Id
     where q.Company_Id = r_Training.Company_Id
       and q.Filial_Id = r_Training.Filial_Id
       and q.Training_Id = r_Training.Training_Id
     order by f.Name;
  
    result := z_Hln_Trainings.To_Map(r_Training, z.Training_Id, z.Training_Number);
    Result.Put('persons', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('subject_group_name',
               z_Hln_Training_Subject_Groups.Take(i_Company_Id => r_Training.Company_Id, --
               i_Filial_Id => r_Training.Filial_Id, --
               i_Subject_Group_Id => r_Training.Subject_Group_Id).Name);
  
    select Array_Varchar2(q.Person_Id,
                          q.Subject_Id,
                          Decode(q.Passed, Hln_Pref.c_Passed_Indeterminate, 'N', q.Passed))
      bulk collect
      into v_Matrix
      from Hln_Training_Person_Subjects q
     where q.Company_Id = r_Training.Company_Id
       and q.Filial_Id = r_Training.Filial_Id
       and q.Training_Id = r_Training.Training_Id
     order by q.Subject_Id;
  
    Result.Put('person_subjects', Fazo.Zip_Matrix(v_Matrix));
  
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
       and q.Training_Id = r_Training.Training_Id
     order by q.Subject_Id;
  
    Result.Put('training_subjects', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assess_Person(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_Training_Id number := p.r_Number('training_id');
    v_Persons     Arraylist := p.r_Arraylist('persons');
    v_Person      Hashmap;
    v_Subjects    Arraylist;
    v_Subject     Hashmap;
  begin
    for i in 1 .. v_Persons.Count
    loop
      v_Person   := Treat(v_Persons.r_Hashmap(i) as Hashmap);
      v_Subjects := v_Person.o_Arraylist('subjects');
    
      Hln_Api.Assess_Person(i_Company_Id  => v_Company_Id,
                            i_Filial_Id   => v_Filial_Id,
                            i_Training_Id => v_Training_Id,
                            i_Person_Id   => v_Person.r_Number('person_id'),
                            i_Passed      => v_Person.r_Varchar2('passed'));
    
      for j in 1 .. v_Subjects.Count
      loop
        v_Subject := Treat(v_Subjects.r_Hashmap(j) as Hashmap);
      
        Hln_Api.Assess_Person_Subject(i_Company_Id  => v_Company_Id,
                                      i_Filial_Id   => v_Filial_Id,
                                      i_Training_Id => v_Training_Id,
                                      i_Person_Id   => v_Person.r_Number('person_id'),
                                      i_Subject_Id  => v_Subject.r_Number('subject_id'),
                                      i_Passed      => v_Subject.r_Varchar2('passed'));
      end loop;
    end loop;
  end;

end Ui_Vhr240;
/
