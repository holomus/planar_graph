create or replace package Ui_Vhr227 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Answer(p Hashmap) return Fazo_Query;
end Ui_Vhr227;
/
create or replace package body Ui_Vhr227 is
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
    return b.Translate('UI-VHR227:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Testing        Hln_Testings%rowtype;
    r_Exam           Hln_Exams%rowtype;
    r_Natural_Person Mr_Natural_Persons%rowtype;
    result           Hashmap;
  begin
    r_Testing := z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Testing_Id => p.r_Number('testing_id'));
  
    result := z_Hln_Testings.To_Map(r_Testing,
                                    z.Testing_Id,
                                    z.Testing_Number,
                                    z.Testing_Date,
                                    z.Pause_Time,
                                    z.Passed,
                                    z.Correct_Questions_Count,
                                    z.Status,
                                    z.Note,
                                    z.Created_On,
                                    z.Modified_On);
  
    r_Exam           := z_Hln_Exams.Load(i_Company_Id => r_Testing.Company_Id,
                                         i_Filial_Id  => r_Testing.Filial_Id,
                                         i_Exam_Id    => r_Testing.Exam_Id);
    r_Natural_Person := z_Mr_Natural_Persons.Load(i_Company_Id => r_Testing.Company_Id,
                                                  i_Person_Id  => r_Testing.Person_Id);
  
    Result.Put_All(z_Hln_Exams.To_Map(r_Exam,
                                      z.Name,
                                      z.Passing_Score,
                                      z.Passing_Percentage,
                                      z.Question_Count,
                                      i_Name               => 'exam_name',
                                      i_Question_Count     => 'questions_count'));
  
    Result.Put('person_name', r_Natural_Person.Name);
    Result.Put('photo_sha',
               z_Md_Persons.Load(i_Company_Id => r_Testing.Company_Id, i_Person_Id => r_Testing.Person_Id).Photo_Sha);
    Result.Put('gender', r_Natural_Person.Gender);
    Result.Put('examiner_name',
               z_Mr_Natural_Persons.Take(i_Company_Id => r_Testing.Company_Id, i_Person_Id => r_Testing.Examiner_Id).Name);
    Result.Put('begin_time_period_begin',
               to_char(r_Testing.Begin_Time_Period_Begin, Href_Pref.c_Date_Format_Minute));
    Result.Put('begin_time_period_end',
               to_char(r_Testing.Begin_Time_Period_End, Href_Pref.c_Date_Format_Minute));
    Result.Put('end_time', to_char(r_Testing.End_Time, Href_Pref.c_Date_Format_Minute));
    Result.Put('fact_begin_time',
               to_char(r_Testing.Fact_Begin_Time, Href_Pref.c_Date_Format_Minute));
    Result.Put('fact_end_time', to_char(r_Testing.Fact_End_Time, Href_Pref.c_Date_Format_Minute));
    Result.Put('status_name', Hln_Util.t_Testing_Status(r_Testing.Status));
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Testing.Company_Id, i_User_Id => r_Testing.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Testing.Company_Id, i_User_Id => r_Testing.Modified_By).Name);
    Result.Put('is_period',
               Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => r_Testing.Company_Id,
                                                           i_Filial_Id  => r_Testing.Filial_Id));
  
    if r_Testing.Status = Hln_Pref.c_Testing_Status_Finished then
      Result.Put('passed_name',
                 Md_Util.Decode(r_Testing.Passed,
                                'Y',
                                t('passed'), --
                                'N',
                                t('not passed')));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Answer(p Hashmap) return Fazo_Query is
    v_State  varchar2(1) := 'N';
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    -- TODO check for access in testing
    q := Fazo_Query('select w.*, 
                            r.name, 
                            r.code, 
                            r.answer_type
                       from hln_testing_questions w
                       join hln_questions r
                         on r.company_id = w.company_id
                        and r.filial_id = w.filial_id
                        and r.question_id = w.question_id
                      where w.company_id = :company_id
                        and w.filial_id = :filial_id
                        and w.testing_id = :testing_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'testing_id',
                                 p.r_Number('testing_id')));
  
    if z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Testing_Id => p.r_Number('testing_id'))
     .Status = Hln_Pref.c_Testing_Status_New then
      v_State := 'Y';
    end if;
  
    q.Number_Field('testing_id', 'question_id', 'order_no');
    q.Varchar2_Field('writing_answer', 'marked', 'correct', 'name', 'code', 'answer_type');
  
    v_Matrix := Hln_Util.Answer_Types;
  
    q.Option_Field('answer_type_name', 'answer_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('correct_name',
                   'correct',
                   Array_Varchar2('Y', 'N', null),
                   Array_Varchar2(Ui.t_Yes,
                                  Ui.t_No,
                                  Md_Util.Decode(v_State,
                                                 'N',
                                                 t('to be checked'), --
                                                 'Y',
                                                 t('to be started'))));
    q.Refer_Field('writing_answer',
                  'question_id',
                  'select q.question_id, q.writing_answer
                     from hln_testing_questions q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id
                      and q.testing_id = :testing_id',
                  'question_id',
                  'writing_answer');
    q.Refer_Field('writing_hint', 'question_id', 'hln_questions', 'question_id', 'writing_hint');
    q.Multi_Number_Field('question_option_ids',
                         'select w.question_id, w.question_option_id
                            from hln_question_options w
                           where w.company_id = :company_id
                             and w.filial_id = :filial_id
                             and w.is_correct = ''Y''',
                         '@question_id=$question_id',
                         'question_option_id');
    q.Refer_Field('correct_answers',
                  'question_option_ids',
                  'hln_question_options',
                  'question_option_id',
                  'name',
                  'select *
                     from hln_question_options w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
    q.Multi_Number_Field('option_ids',
                         'select w.question_id, w.question_option_id
                            from hln_testing_question_options w
                           where w.company_id = :company_id
                             and w.filial_id = :filial_id
                             and w.testing_id = :testing_id
                             and w.chosen = ''Y''',
                         '@question_id=$question_id',
                         'question_option_id');
    q.Refer_Field('chosen_answers',
                  'option_ids',
                  'hln_question_options',
                  'question_option_id',
                  'name',
                  'select *
                     from hln_question_options w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Testing_Questions
       set Company_Id     = null,
           Filial_Id      = null,
           Testing_Id     = null,
           Question_Id    = null,
           Order_No       = null,
           Writing_Answer = null,
           Marked         = null,
           Correct        = null;
    update Hln_Questions
       set Company_Id  = null,
           Filial_Id   = null,
           Question_Id = null,
           name        = null,
           Answer_Type = null,
           Code        = null;
    update Hln_Testing_Question_Options
       set Company_Id         = null,
           Filial_Id          = null,
           Testing_Id         = null,
           Question_Id        = null,
           Question_Option_Id = null,
           Chosen             = null;
    update Hln_Question_Options
       set Company_Id         = null,
           Filial_Id          = null,
           Question_Option_Id = null,
           name               = null,
           Is_Correct         = null;
  end;

end Ui_Vhr227;
/
