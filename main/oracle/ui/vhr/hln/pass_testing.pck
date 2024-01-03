create or replace package Ui_Vhr222 is
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Mark_Question(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Send_Answer(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Finish_Testing(p Hashmap) return Hashmap;
end Ui_Vhr222;
/
create or replace package body Ui_Vhr222 is
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
    return b.Translate('UI-VHR222:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Current_Date return date is
  begin
    return Htt_Util.Get_Current_Date(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Questions_Count(i_Testing_Id number) return number is
    v_Questions_Count number;
  begin
    select count(*)
      into v_Questions_Count
      from Hln_Testing_Questions q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Testing_Id = i_Testing_Id;
  
    return v_Questions_Count;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Answered_Questions(i_Testing_Id number) return Array_Varchar2 is
    v_Chosen  Array_Varchar2;
    v_Writing Array_Varchar2;
  begin
    select w.Order_No
      bulk collect
      into v_Chosen
      from Hln_Testing_Questions w
     where w.Company_Id = Ui.Company_Id
       and w.Filial_Id = Ui.Filial_Id
       and w.Testing_Id = i_Testing_Id
       and exists (select 1
              from Hln_Testing_Question_Options r
             where r.Company_Id = w.Company_Id
               and r.Filial_Id = w.Filial_Id
               and r.Testing_Id = w.Testing_Id
               and r.Question_Id = w.Question_Id
               and r.Chosen = 'Y');
  
    select q.Order_No
      bulk collect
      into v_Writing
      from Hln_Testing_Questions q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Testing_Id = i_Testing_Id
       and q.Writing_Answer is not null;
  
    return v_Chosen multiset union v_Writing;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Marks(i_Testing_Id number) return Array_Varchar2 is
    v_Marks Array_Varchar2;
  begin
    select q.Marked
      bulk collect
      into v_Marks
      from Hln_Testing_Questions q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Testing_Id = i_Testing_Id
     order by q.Order_No;
  
    return v_Marks;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Duration(i_Testing_Id number) return number is
    r_Testing      Hln_Testings%rowtype;
    v_Duration     number := 0;
    v_Current_Date date := Get_Current_Date;
  begin
    r_Testing := z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Testing_Id => i_Testing_Id);
  
    v_Duration := Floor((r_Testing.End_Time - v_Current_Date) * 86400);
  
    return v_Duration;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Get_Options
  (
    i_Testing_Id  number,
    i_Question_Id number
  ) return Hashmap is
    v_Matrix Matrix_Varchar2;
    result   Hashmap := Hashmap();
  begin
    select Array_Varchar2(q.Question_Option_Id,
                          q.Order_No,
                          q.Chosen,
                          w.Name,
                          w.File_Sha,
                          (select r.File_Name
                             from Biruni_Files r
                            where r.Sha = w.File_Sha))
      bulk collect
      into v_Matrix
      from Hln_Testing_Question_Options q
      join Hln_Question_Options w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Question_Option_Id = q.Question_Option_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Testing_Id = i_Testing_Id
       and q.Question_Id = i_Question_Id
     order by q.Order_No;
  
    Result.Put('options', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Question_Info
  (
    i_Testing_Id number,
    i_Order_No   number
  ) return Hashmap is
    r_Question       Hln_Questions%rowtype;
    v_Question_Id    number;
    v_Marked         varchar2(1);
    v_Writing_Answer varchar2(500 char);
    v_Matrix         Matrix_Varchar2;
    result           Hashmap := Hashmap();
  begin
    begin
      select q.Question_Id, q.Marked, q.Writing_Answer
        into v_Question_Id, v_Marked, v_Writing_Answer
        from Hln_Testing_Questions q
       where q.Company_Id = Ui.Company_Id
         and q.Filial_Id = Ui.Filial_Id
         and q.Testing_Id = i_Testing_Id
         and q.Order_No = i_Order_No;
    
    exception
      when No_Data_Found then
        b.Raise_Error(t('question not found'));
    end;
  
    select Array_Varchar2(q.File_Sha,
                          (select r.File_Name
                             from Biruni_Files r
                            where r.Sha = q.File_Sha))
      bulk collect
      into v_Matrix
      from Hln_Question_Files q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Question_Id = v_Question_Id
     order by q.Order_No;
  
    r_Question := z_Hln_Questions.Load(i_Company_Id  => Ui.Company_Id,
                                       i_Filial_Id   => Ui.Filial_Id,
                                       i_Question_Id => v_Question_Id);
  
    Result.Put('name', r_Question.Name);
    Result.Put('answer_type', r_Question.Answer_Type);
    Result.Put('code', r_Question.Code);
    Result.Put('order_no', i_Order_No);
    Result.Put('question_id', v_Question_Id);
    Result.Put('marked', v_Marked);
    Result.Put('writing_answer', v_Writing_Answer);
    Result.Put('files', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('duration', Get_Duration(i_Testing_Id));
    Result.Put('status',
               z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Testing_Id => i_Testing_Id).Status);
    Result.Put_All(Get_Options(i_Testing_Id => i_Testing_Id, i_Question_Id => v_Question_Id));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Testing      Hln_Testings%rowtype;
    v_Testing_Id   number := p.r_Number('testing_id');
    v_Current_Date date := Get_Current_Date;
    v_Is_Period    boolean := Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => Ui.Company_Id,
                                                                          i_Filial_Id  => Ui.Filial_Id) = 'Y';
    result         Hashmap := Hashmap();
  begin
    Hln_Util.Assert_Access_Person(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Testing_Id => v_Testing_Id,
                                  i_Person_Id  => Ui.User_Id);
  
    r_Testing := z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Testing_Id => v_Testing_Id);
  
    Result.Put('exam_name',
               z_Hln_Exams.Load(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Exam_Id => r_Testing.Exam_Id).Name);
  
    if v_Current_Date < r_Testing.Begin_Time_Period_Begin then
      Result.Put('waiting_time',
                 Floor((r_Testing.Begin_Time_Period_Begin - v_Current_Date) * 86400));
    
      return result;
    end if;
  
    if v_Is_Period then
      if v_Current_Date > r_Testing.Begin_Time_Period_End then
        Result.Put('time_expired', 'Y');
      
        return result;
      end if;
    else
      if v_Current_Date > r_Testing.End_Time then
        Result.Put('time_expired', 'Y');
      
        return result;
      end if;
    end if;
  
    Result.Put('duration', Get_Duration(r_Testing.Testing_Id));
    Result.Put('marks', Get_Marks(i_Testing_Id => v_Testing_Id));
    Result.Put('answered_questions', Get_Answered_Questions(i_Testing_Id => v_Testing_Id));
    Result.Put('questions_count', Get_Questions_Count(i_Testing_Id => v_Testing_Id));
    Result.Put_All(Get_Question_Info(i_Testing_Id => v_Testing_Id,
                                     i_Order_No   => Nvl(r_Testing.Current_Question_No, 1)));
  
    if r_Testing.Status = Hln_Pref.c_Testing_Status_New then
      Hln_Api.Testing_Enter(i_Company_Id     => r_Testing.Company_Id,
                            i_Filial_Id      => r_Testing.Filial_Id,
                            i_Testing_Id     => r_Testing.Testing_Id,
                            i_Attestation_Id => Hln_Util.Get_Attestation_Id(i_Company_Id => r_Testing.Company_Id,
                                                                            i_Filial_Id  => r_Testing.Filial_Id,
                                                                            i_Testing_Id => r_Testing.Testing_Id));
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Mark_Question(p Hashmap) is
  begin
    Hln_Api.Mark_Question(i_Company_Id  => Ui.Company_Id,
                          i_Filial_Id   => Ui.Filial_Id,
                          i_Testing_Id  => p.r_Number('testing_id'),
                          i_Question_Id => p.r_Number('question_id'),
                          i_Person_Id   => Ui.User_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Send_Answer(p Hashmap) return Hashmap is
  begin
    Hln_Api.Send_Answer(i_Company_Id          => Ui.Company_Id,
                        i_Filial_Id           => Ui.Filial_Id,
                        i_Testing_Id          => p.r_Number('testing_id'),
                        i_Person_Id           => Ui.User_Id,
                        i_Question_Id         => p.r_Number('question_id'),
                        i_Current_Question_No => p.r_Number('order_no'),
                        i_Question_Option_Ids => Nvl(p.o_Array_Number('question_option_ids'),
                                                     Array_Number()),
                        i_Writing_Answer      => p.o_Varchar2('writing_answer'));
  
    return Get_Question_Info(i_Testing_Id => p.r_Number('testing_id'),
                             i_Order_No   => p.r_Number('order_no'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Finish_Testing(p Hashmap) return Hashmap is
    r_Testing           Hln_Testings%rowtype;
    v_Specially_Pressed varchar2(1) := p.r_Varchar2('specially_pressed');
  begin
    r_Testing := z_Hln_Testings.Load(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_Testing_Id => p.r_Number('testing_id'));
  
    if v_Specially_Pressed = 'N' then
      if r_Testing.End_Time > Get_Current_Date then
        return Fazo.Zip_Map('duration', Get_Duration(r_Testing.Testing_Id));
      end if;
    end if;
  
    Hln_Api.Send_Answer(i_Company_Id          => r_Testing.Company_Id,
                        i_Filial_Id           => r_Testing.Filial_Id,
                        i_Testing_Id          => p.r_Number('testing_id'),
                        i_Person_Id           => Ui.User_Id,
                        i_Question_Id         => p.r_Number('question_id'),
                        i_Current_Question_No => null,
                        i_Question_Option_Ids => p.o_Array_Number('question_option_ids'),
                        i_Writing_Answer      => p.o_Varchar2('writing_answer'));
  
    Hln_Api.Testing_Stop(i_Company_Id     => r_Testing.Company_Id,
                         i_Filial_Id      => r_Testing.Filial_Id,
                         i_Testing_Id     => p.r_Number('testing_id'),
                         i_User_Id        => Ui.User_Id,
                         i_Attestation_Id => Hln_Util.Get_Attestation_Id(i_Company_Id => r_Testing.Company_Id,
                                                                         i_Filial_Id  => r_Testing.Filial_Id,
                                                                         i_Testing_Id => r_Testing.Testing_Id));
  
    r_Testing := z_Hln_Testings.Load(i_Company_Id => r_Testing.Company_Id,
                                     i_Filial_Id  => r_Testing.Filial_Id,
                                     i_Testing_Id => p.r_Number('testing_id'));
  
    return Fazo.Zip_Map('status', r_Testing.Status);
  end;

end Ui_Vhr222;
/
