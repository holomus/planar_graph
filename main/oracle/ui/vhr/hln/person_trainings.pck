create or replace package Ui_Vhr242 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Testings(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Trainings(p Hashmap) return Fazo_Query;
end Ui_Vhr242;
/
create or replace package body Ui_Vhr242 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Testings(p Hashmap) return Fazo_Query is
    v_Filial_Id number;
    v_Matrix    Matrix_Varchar2;
    q           Fazo_Query;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    else
      v_Filial_Id := Ui.Filial_Id;
    end if;
  
    q := Fazo_Query('select w.*,
                            r.duration,
                            r.question_count,
                            r.passing_score,
                            nvl(r.passing_percentage, round((r.passing_score/r.question_count)*100, 2)) passing_percent
                       from hln_testings w
                       join hln_exams r
                         on r.company_id = :company_id
                        and r.filial_id = :filial_id
                        and r.exam_id = w.exam_id
                      where w.company_id = :company_id
                        and w.filial_id = :filial_id
                        and w.person_id = :person_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 v_Filial_Id,
                                 'person_id',
                                 p.r_Number('person_id')));
  
    q.Number_Field('testing_id',
                   'exam_id',
                   'examiner_id',
                   'duration',
                   'passing_score',
                   'current_question_no',
                   'correct_question_count',
                   'created_by',
                   'modified_by');
    q.Number_Field('duration', 'passing_score', 'question_count', 'passing_percent');
    q.Date_Field('testing_date',
                 'begin_time_period_begin',
                 'begin_time_period_end',
                 'end_time',
                 'fact_begin_time',
                 'fact_end_time',
                 'pause_time',
                 'created_on',
                 'modified_on');
    q.Varchar2_Field('testing_number',
                     'exam_name',
                     'passed',
                     'status',
                     'note',
                     'has_writing_question');
  
    q.Refer_Field('exam_name',
                  'exam_id',
                  'hln_exams',
                  'exam_id',
                  'name',
                  'select *
                     from hln_exams e 
                    where e.company_id = :company_id
                      and e.filial_id = :filial_id');
    q.Refer_Field('examiner_name',
                  'examiner_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select q.*
                     from mr_natural_persons q
                    where q.company_id = :company_id
                      and exists (select 1 
                            from mrf_persons f
                           where f.company_id = q.company_id
                             and f.filial_id = :filial_id
                             and f.person_id = q.person_id)');
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
    q.Option_Field('passed_name',
                   'passed',
                   Array_Varchar2('Y', 'N', Hln_Pref.c_Passed_Indeterminate),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No, Hln_Util.t_Passed_Indeterminate));
  
    v_Matrix := Hln_Util.Testing_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('has_writing_question',
                'hln_util.has_writing_question(:company_id, :filial_id, $testing_id)');
    q.Map_Field('attestation_name',
                'select a.name
                   from hln_attestations a
                  where a.company_id = :company_id
                    and a.filial_id = :filial_id
                    and exists (select *
                           from hln_attestation_testings at
                          where at.company_id = a.company_id
                            and at.filial_id = a.filial_id
                            and at.attestation_id = a.attestation_id
                            and at.testing_id = $testing_id)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Trainings(p Hashmap) return Fazo_Query is
    q           Fazo_Query;
    v_Filial_Id number := Ui.Filial_Id;
    v_Matrix    Matrix_Varchar2;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    q := Fazo_Query('select q.*, tp.passed
                       from hln_trainings q
                       join hln_training_persons tp
                         on tp.company_id = q.company_id
                        and tp.filial_id = q.filial_id
                        and tp.training_id = q.training_id
                        and tp.person_id = :person_id
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 v_Filial_Id,
                                 'person_id',
                                 p.r_Number('person_id')));
  
    q.Number_Field('training_id', 'mentor_id', 'created_by', 'modified_by');
    q.Date_Field('begin_date', 'created_on', 'modified_on');
    q.Varchar2_Field('training_number', 'address', 'status', 'passed');
  
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
                              and f.person_id = k.person_id))');
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
    q.Option_Field('passed_name',
                   'passed',
                   Array_Varchar2('Y', 'N', Hln_Pref.c_Passed_Indeterminate),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No, Hln_Util.t_Passed_Indeterminate));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Hln_Testings
       set Company_Id              = null,
           Filial_Id               = null,
           Testing_Id              = null,
           Exam_Id                 = null,
           Person_Id               = null,
           Examiner_Id             = null,
           Testing_Number          = null,
           Testing_Date            = null,
           Begin_Time_Period_Begin = null,
           Begin_Time_Period_End   = null,
           End_Time                = null,
           Fact_Begin_Time         = null,
           Fact_End_Time           = null,
           Pause_Time              = null,
           Passed                  = null,
           Status                  = null,
           Note                    = null,
           Created_By              = null,
           Created_On              = null,
           Modified_By             = null,
           Modified_On             = null;
  
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
  
    update Hln_Training_Persons
       set Company_Id  = null,
           Filial_Id   = null,
           Training_Id = null,
           Person_Id   = null,
           Passed      = null;
  
    update Hln_Training_Subjects
       set Company_Id = null,
           Filial_Id  = null,
           Subject_Id = null,
           name       = null;
  
    update Hln_Training_Current_Subjects
       set Company_Id  = null,
           Filial_Id   = null,
           Training_Id = null,
           Subject_Id  = null;
  end;

end Ui_Vhr242;
/
