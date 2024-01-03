create or replace package Ui_Vhr223 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Hr return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_User return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Control(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Set_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Return_Execute(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Pause(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure continue(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Return_Checking(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Stop(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Begin_Time(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure To_Start(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Add_Time(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Finish(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap);
end Ui_Vhr223;
/
create or replace package body Ui_Vhr223 is
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
    return b.Translate('UI-VHR223:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access(i_Testing_Id number) is
  begin
    if not Ui.Grant_Has('all_access') and
       Ui.User_Id <> z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Testing_Id => i_Testing_Id).Examiner_Id then
      b.Raise_Unauthorized;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query
  (
    i_Personal boolean := false,
    i_Examiner boolean := false,
    i_Control  boolean := false,
    p          Hashmap := null
  ) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
    v_Params Hashmap := Hashmap();
    v_Query  varchar2(32767);
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id);
  
    v_Query := 'select w.*,
                       r.duration,
                       r.question_count,
                       r.passing_score,
                       nvl(r.passing_percentage, round((r.passing_score/r.question_count)*100, 2)) passing_percent
                  from hln_testings w
                  join hln_exams r
                    on r.company_id = w.company_id
                   and r.filial_id = w.filial_id
                   and r.exam_id = w.exam_id
                 where w.company_id = :company_id
                   and w.filial_id = :filial_id';
  
    if i_Personal then
      v_Query := v_Query || ' and w.person_id = :person_id';
      v_Params.Put('person_id', Ui.User_Id);
    end if;
  
    if i_Examiner then
      v_Query := v_Query || ' and w.examiner_id = :examiner_id';
      v_Params.Put('examiner_id', Ui.User_Id);
    end if;
  
    if i_Control then
      v_Query := v_Query || ' and exists (select 1 
                                     from hln_attestation_testings at
                                    where at.company_id = w.company_id
                                      and at.filial_id = w.filial_id
                                      and at.attestation_id = :attestation_id
                                      and at.testing_id = w.testing_id)';
    
      v_Params.Put('attestation_id', p.r_Number('attestation_id'));
    elsif not i_Personal then
      v_Query := v_Query || --
                 ' and not exists (select 1
                              from hln_attestation_testings at
                             where at.company_id = w.company_id
                               and at.filial_id = w.filial_id
                               and at.testing_id = w.testing_id)';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('testing_id',
                   'exam_id',
                   'person_id',
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
  
    q.Refer_Field('person_name',
                  'person_id',
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
  Function Query_Hr return Fazo_Query is
  begin
    return Query(i_Examiner => not Ui.Grant_Has('all_access'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_User return Fazo_Query is
  begin
    return Query(i_Personal => true);
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Query_Control(p Hashmap) return Fazo_Query is
  begin
    return Query(i_Control => true, p => p);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('is_period',
                        Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => Ui.Company_Id,
                                                                    i_Filial_Id  => Ui.Filial_Id));
  end;

  ----------------------------------------------------------------------------------------------------       
  Function Get_Attestation_Id(p Hashmap) return number is
  begin
    if Ui.Request_Mode = 'control' then
      return p.r_Number('attestation_id');
    else
      return null;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_New(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Set_New(i_Company_Id     => Ui.Company_Id,
                              i_Filial_Id      => Ui.Filial_Id,
                              i_Testing_Id     => v_Testing_Ids(i),
                              i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Return_Execute(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Return_Execute(i_Company_Id     => Ui.Company_Id,
                                     i_Filial_Id      => Ui.Filial_Id,
                                     i_Testing_Id     => v_Testing_Ids(i),
                                     i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Pause(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Pause(i_Company_Id     => Ui.Company_Id,
                            i_Filial_Id      => Ui.Filial_Id,
                            i_Testing_Id     => v_Testing_Ids(i),
                            i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure continue(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Continue(i_Company_Id     => Ui.Company_Id,
                               i_Filial_Id      => Ui.Filial_Id,
                               i_Testing_Id     => v_Testing_Ids(i),
                               i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Return_Checking(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Return_Checking(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Testing_Id     => v_Testing_Ids(i),
                                      i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Stop(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Stop(i_Company_Id     => Ui.Company_Id,
                           i_Filial_Id      => Ui.Filial_Id,
                           i_Testing_Id     => v_Testing_Ids(i),
                           i_User_Id        => Ui.User_Id,
                           i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Begin_Time(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Set_Begin_Time(i_Company_Id              => Ui.Company_Id,
                                     i_Filial_Id               => Ui.Filial_Id,
                                     i_Testing_Id              => v_Testing_Ids(i),
                                     i_Begin_Time_Period_Begin => p.o_Number('begin_time_period_begin'),
                                     i_Begin_Time_Period_End   => p.o_Number('begin_time_period_end'),
                                     i_Attestation_Id          => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure To_Start(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Start(i_Company_Id     => Ui.Company_Id,
                            i_Filial_Id      => Ui.Filial_Id,
                            i_Testing_Id     => v_Testing_Ids(i),
                            i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add_Time(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Add_Time(i_Company_Id     => Ui.Company_Id,
                               i_Filial_Id      => Ui.Filial_Id,
                               i_Testing_Id     => v_Testing_Ids(i),
                               i_Added_Time     => p.o_Number('added_time'),
                               i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Finish(p Hashmap) is
    v_Attestation_Id number := Get_Attestation_Id(p);
    v_Testing_Ids    Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Assert_Access(v_Testing_Ids(i));
    
      Hln_Api.Testing_Finish(i_Company_Id     => Ui.Company_Id,
                             i_Filial_Id      => Ui.Filial_Id,
                             i_Testing_Id     => v_Testing_Ids(i),
                             i_Attestation_Id => v_Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    v_User_Id     number := Ui.User_Id;
    v_Testing_Ids Array_Number := Fazo.Sort(p.r_Array_Number('testing_id'));
  begin
    for i in 1 .. v_Testing_Ids.Count
    loop
      Hln_Api.Testing_Delete(i_Company_Id => v_Company_Id,
                             i_Filial_Id  => v_Filial_Id,
                             i_Testing_Id => v_Testing_Ids(i),
                             i_User_Id    => v_User_Id);
    end loop;
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
  end;

end Ui_Vhr223;
/
