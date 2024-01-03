create or replace package Ui_Vhr228 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Finish(p Hashmap);
end Ui_Vhr228;
/
create or replace package body Ui_Vhr228 is
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
    return b.Translate('UI-VHR228:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Answers
  (
    i_Question_Ids Array_Number,
    i_Testing_Id   number
  ) return Arraylist is
    r_Question         Hln_Questions%rowtype;
    r_Testing_Question Hln_Testing_Questions%rowtype;
    v_Question         Hashmap;
    result             Arraylist := Arraylist();
  begin
    for i in 1 .. i_Question_Ids.Count
    loop
      r_Question         := z_Hln_Questions.Load(i_Company_Id  => Ui.Company_Id,
                                                 i_Filial_Id   => Ui.Filial_Id,
                                                 i_Question_Id => i_Question_Ids(i));
      r_Testing_Question := z_Hln_Testing_Questions.Load(i_Company_Id  => Ui.Company_Id,
                                                         i_Filial_Id   => Ui.Filial_Id,
                                                         i_Testing_Id  => i_Testing_Id,
                                                         i_Question_Id => r_Question.Question_Id);
      v_Question         := z_Hln_Questions.To_Map(r_Question,
                                                   z.Question_Id,
                                                   z.Name,
                                                   z.Code,
                                                   z.Writing_Hint);
    
      v_Question.Put('writing_answer', r_Testing_Question.Writing_Answer);
      v_Question.Put('order_no', r_Testing_Question.Order_No);
      v_Question.Put('correct', Nvl(r_Testing_Question.Correct, 'N'));
    
      Result.Push(v_Question);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    v_Question_Ids   Array_Number;
    r_Testing        Hln_Testings%rowtype;
    r_Natural_Person Mr_Natural_Persons%rowtype;
    result           Hashmap;
  begin
    r_Testing := z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Testing_Id => p.r_Number('testing_id'));
  
    if r_Testing.Status = Hln_Pref.c_Testing_Status_Finished then
      b.Raise_Error(t('model: test already finished, testing_id=$1', p.r_Number('testing_id')));
    end if;
  
    select q.Question_Id
      bulk collect
      into v_Question_Ids
      from Hln_Testing_Questions q
      join Hln_Questions w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Question_Id = q.Question_Id
       and w.Answer_Type = Hln_Pref.c_Answer_Type_Writing
     where q.Company_Id = r_Testing.Company_Id
       and q.Filial_Id = r_Testing.Filial_Id
       and q.Testing_Id = r_Testing.Testing_Id
     order by Order_No;
  
    result := z_Hln_Testings.To_Map(r_Testing,
                                    z.Testing_Id,
                                    z.Exam_Id,
                                    z.Person_Id,
                                    z.Testing_Number);
  
    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Testing.Company_Id,
                                                  i_Person_Id  => r_Testing.Person_Id);
  
    Result.Put('exam_name',
               z_Hln_Exams.Load(i_Company_Id => r_Testing.Company_Id, i_Filial_Id => r_Testing.Filial_Id, i_Exam_Id => r_Testing.Exam_Id).Name);
    Result.Put('person_name', r_Natural_Person.Name);
    Result.Put('photo_sha',
               z_Md_Persons.Load(i_Company_Id => r_Testing.Company_Id, i_Person_Id => r_Testing.Person_Id).Photo_Sha);
    Result.Put('gender', r_Natural_Person.Gender);
    Result.Put('answers',
               Load_Answers(i_Question_Ids => v_Question_Ids, i_Testing_Id => r_Testing.Testing_Id));
    Result.Put('status', r_Testing.Status);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Finish(p Hashmap) is
    v_Answers Arraylist := p.r_Arraylist('answers');
    v_Answer  Hashmap;
  begin
    for i in 1 .. v_Answers.Count
    loop
      v_Answer := Treat(v_Answers.r_Hashmap(i) as Hashmap);
    
      Hln_Api.Check_Answer(i_Company_Id  => Ui.Company_Id,
                           i_Filial_Id   => Ui.Filial_Id,
                           i_Testing_Id  => p.r_Number('testing_id'),
                           i_Question_Id => v_Answer.r_Number('question_id'),
                           i_Correct     => v_Answer.r_Varchar2('correct'));
    end loop;
  
    Hln_Api.Testing_Finish(i_Company_Id     => Ui.Company_Id,
                           i_Filial_Id      => Ui.Filial_Id,
                           i_Testing_Id     => p.r_Number('testing_id'),
                           i_Attestation_Id => p.o_Number('attestation_id'));
  end;

end Ui_Vhr228;
/
