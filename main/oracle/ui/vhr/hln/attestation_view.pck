create or replace package Ui_Vhr248 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query_Testings(p Hashmap) return Fazo_Query;
end Ui_Vhr248;
/
create or replace package body Ui_Vhr248 is
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
    return b.Translate('UI-VHR248:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Attestation        Hln_Attestations%rowtype;
    v_All_Persons        number;
    v_Finished_Persons   number;
    v_Passed_Persons     number;
    v_Not_Passed_Persons number;
    result               Hashmap;
  begin
    r_Attestation := z_Hln_Attestations.Load(i_Company_Id     => Ui.Company_Id,
                                             i_Filial_Id      => Ui.Filial_Id,
                                             i_Attestation_Id => p.r_Number('attestation_id'));
  
    select count(*),
           sum(Decode(w.Status, 'F', 1, 0)),
           sum(Decode(w.Passed, 'Y', 1, 0)),
           sum(Decode(w.Passed, 'N', 1, 0))
      into v_All_Persons, v_Finished_Persons, v_Passed_Persons, v_Not_Passed_Persons
      from Hln_Attestation_Testings q
      join Hln_Testings w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Testing_Id = q.Testing_Id
     where q.Company_Id = r_Attestation.Company_Id
       and q.Filial_Id = r_Attestation.Filial_Id
       and q.Attestation_Id = r_Attestation.Attestation_Id;
  
    result := z_Hln_Attestations.To_Map(r_Attestation,
                                        z.Attestation_Id,
                                        z.Attestation_Number,
                                        z.Name,
                                        z.Attestation_Date,
                                        z.Note,
                                        z.Status,
                                        z.Created_On,
                                        z.Modified_On);
  
    Result.Put('examiner_name',
               z_Mr_Natural_Persons.Load(i_Company_Id => r_Attestation.Company_Id, i_Person_Id => r_Attestation.Examiner_Id).Name);
    Result.Put('begin_time_period_begin',
               to_char(r_Attestation.Begin_Time_Period_Begin, Href_Pref.c_Time_Format_Minute));
    Result.Put('begin_time_period_end',
               to_char(r_Attestation.Begin_Time_Period_End, Href_Pref.c_Time_Format_Minute));
    Result.Put('status_name', Hln_Util.t_Attestation_Status(r_Attestation.Status));
    Result.Put('all_persons', v_All_Persons);
    Result.Put('finished_persons', v_Finished_Persons);
    Result.Put('passed_persons', v_Passed_Persons);
    Result.Put('not_passed_persons', v_Not_Passed_Persons);
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Attestation.Company_Id, i_User_Id => r_Attestation.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Attestation.Company_Id, i_User_Id => r_Attestation.Modified_By).Name);
    Result.Put('is_period',
               Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => r_Attestation.Company_Id,
                                                           i_Filial_Id  => r_Attestation.Filial_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Testings(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select w.*, 
                            r.duration, 
                            r.passing_score,
                            r.passing_percentage
                       from hln_testings w
                       join hln_exams r 
                         on r.company_id = w.company_id
                        and r.filial_id = w.filial_id
                        and r.exam_id = w.exam_id
                      where w.company_id = :company_id
                        and w.filial_id = :filial_id
                        and exists (select 1
                               from hln_attestation_testings q
                              where q.company_id = :company_id
                                and q.filial_id = :filial_id
                                and q.attestation_id = :attestation_id
                                and q.testing_id = w.testing_id)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'attestation_id',
                                 p.r_Number('attestation_id')));
  
    q.Number_Field('testing_id',
                   'exam_id',
                   'person_id',
                   'current_question_no',
                   'correct_questions_count',
                   'duration',
                   'passing_score',
                   'passing_percentage',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('testing_number', 'passed', 'status', 'note');
    q.Date_Field('begin_time_period_begin',
                 'begin_time_period_end',
                 'end_time',
                 'pause_time',
                 'fact_begin_time',
                 'fact_end_time',
                 'created_on',
                 'modified_on');
  
    q.Refer_Field('exam_name',
                  'exam_id',
                  'hln_exams',
                  'exam_id',
                  'name',
                  'select *
                     from hln_exams k
                    where k.company_id = :company_id
                      and k.filial_id = :filial_id');
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
  
    v_Matrix := Hln_Util.Testing_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Attestation_Testings
       set Company_Id     = null,
           Filial_Id      = null,
           Attestation_Id = null,
           Testing_Id     = null;
    update Hln_Testings
       set Company_Id              = null,
           Filial_Id               = null,
           Testing_Id              = null,
           Exam_Id                 = null,
           Person_Id               = null,
           Testing_Number          = null,
           Begin_Time_Period_Begin = null,
           Begin_Time_Period_End   = null,
           End_Time                = null,
           Fact_Begin_Time         = null,
           Fact_End_Time           = null,
           Pause_Time              = null,
           Passed                  = null,
           Current_Question_No     = null,
           Correct_Questions_Count = null,
           Status                  = null,
           Note                    = null,
           Created_On              = null,
           Created_By              = null,
           Modified_On             = null,
           Modified_By             = null;
    update Hln_Exams
       set Company_Id         = null,
           Filial_Id          = null,
           Exam_Id            = null,
           name               = null,
           Duration           = null,
           Passing_Score      = null,
           Passing_Percentage = null;
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
  end;

end Ui_Vhr248;
/
