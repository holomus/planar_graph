create or replace package Ui_Vhr214 is
  ---------------------------------------------------------------------------------------------------- 
  Function Query_Question_Types(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Load_Manual_Questions(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Function Check_Generating_Questions(p Hashmap) return Arraylist;
  ----------------------------------------------------------------------------------------------------  
  Function Edit_Model(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add_Model return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Add(p Hashmap) return Hashmap;
  ---------------------------------------------------------------------------------------------------- 
  Function Edit(p Hashmap) return Hashmap;
end Ui_Vhr214;
/
create or replace package body Ui_Vhr214 is
  ---------------------------------------------------------------------------------------------------- 
  Function Question_Groups return Matrix_Varchar2 is
    v_Matrix Matrix_Varchar2;
  begin
    select Array_Varchar2(q.Question_Group_Id, q.Name)
      bulk collect
      into v_Matrix
      from Hln_Question_Groups q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.State = 'A'
     order by q.Order_No, q.Pcode, Lower(q.Name);
  
    return v_Matrix;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Question_Types(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('hln_question_types',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'question_group_id',
                                 p.r_Number('question_group_id'),
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('question_type_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Questions(i_Question_Ids Array_Number) return Arraylist is
    r_Question        Hln_Questions%rowtype;
    v_Group_Type_Name varchar2(500);
    v_Groups          Matrix_Varchar2 := Question_Groups;
    v_Question        Hashmap := Hashmap();
    result            Arraylist := Arraylist();
    -------------------------------------------------- 
    Function Type_Name
    (
      i_Question_Id       number,
      i_Question_Group_Id number
    ) return varchar2 is
      v_Array Array_Varchar2;
    begin
      select distinct q.Name
        bulk collect
        into v_Array
        from Hln_Question_Types q
        join Hln_Question_Group_Binds t
          on q.Company_Id = t.Company_Id
         and q.Filial_Id = t.Filial_Id
         and q.Question_Group_Id = t.Question_Group_Id
         and q.Question_Type_Id = t.Question_Type_Id
       where t.Company_Id = Ui.Company_Id
         and t.Filial_Id = Ui.Filial_Id
         and t.Question_Id = i_Question_Id
         and t.Question_Group_Id = i_Question_Group_Id;
    
      return Fazo.Gather(v_Array, ',');
    end;
  begin
    for i in 1 .. i_Question_Ids.Count
    loop
      r_Question := z_Hln_Questions.Load(i_Company_Id  => Ui.Company_Id,
                                         i_Filial_Id   => Ui.Filial_Id,
                                         i_Question_Id => i_Question_Ids(i));
    
      v_Question := z_Hln_Questions.To_Map(r_Question, --
                                           z.Question_Id,
                                           z.Name,
                                           z.Code,
                                           z.State,
                                           z.Writing_Hint);
      v_Question.Put('answer_type', Hln_Util.t_Answer_Type(r_Question.Answer_Type));
      v_Question.Put('state_name',
                     Md_Util.Decode(r_Question.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
    
      for j in 1 .. Least(5, v_Groups.Count)
      loop
        v_Group_Type_Name := Type_Name(r_Question.Question_Id, v_Groups(j) (1));
        v_Question.Put('group' || j, v_Group_Type_Name);
      end loop;
    
      Result.Push(v_Question);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Manual_Questions(p Hashmap) return Arraylist is
  begin
    return Load_Questions(p.r_Array_Number('question_ids'));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Generating_Questions(p Hashmap) return Arraylist is
    v_Patterns               Arraylist := p.r_Arraylist('patterns');
    v_Pattern                Hashmap;
    v_Question_Types         Array_Number := Array_Number();
    v_Question_Ids           Array_Number := Array_Number();
    v_Generated_Question_Ids Array_Number := Array_Number();
    v_Data                   Hashmap := Hashmap();
    v_Quantity               number;
    result                   Arraylist := Arraylist();
  begin
    for i in 1 .. v_Patterns.Count
    loop
      v_Pattern  := Treat(v_Patterns.r_Hashmap(i) as Hashmap);
      v_Quantity := v_Pattern.o_Number('quantity');
    
      v_Question_Types := v_Pattern.r_Array_Number('question_types');
    
      v_Generated_Question_Ids := Hln_Util.Gen_Questions(i_Company_Id                 => Ui.Company_Id,
                                                         i_Filial_Id                  => Ui.Filial_Id,
                                                         i_Question_Types             => v_Question_Types,
                                                         i_Has_Writing_Question       => v_Pattern.r_Varchar2('has_writing_question'),
                                                         i_Max_Count_Writing_Question => v_Pattern.o_Number('max_cnt_writing_question'),
                                                         i_Used_Question_Ids          => v_Question_Ids);
    
      if v_Quantity is not null and v_Quantity < v_Generated_Question_Ids.Count then
        v_Generated_Question_Ids.Trim(v_Generated_Question_Ids.Count - v_Quantity);
      end if;
    
      v_Question_Ids := v_Question_Ids multiset union v_Generated_Question_Ids;
    
      v_Data.Put('order_no', v_Pattern.r_Number('order_no'));
      v_Data.Put('quantity', v_Pattern.o_Number('quantity'));
      v_Data.Put('found_questions_count', v_Generated_Question_Ids.Count);
    
      Result.Push(v_Data);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('has_duration',
                           'N',
                           'state',
                           'A',
                           'randomize_options',
                           'N',
                           'pick_kind',
                           'M',
                           'for_recruitment',
                           'N');
  
    Result.Put('question_groups', Fazo.Zip_Matrix(Question_Groups));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit_Model(p Hashmap) return Hashmap is
    r_Exam         Hln_Exams%rowtype;
    v_Matrix       Matrix_Varchar2;
    v_Pattern_Ids  Array_Number;
    v_Question_Ids Array_Number;
    result         Hashmap;
  begin
    r_Exam := z_Hln_Exams.Load(i_Company_Id => Ui.Company_Id,
                               i_Filial_Id  => Ui.Filial_Id,
                               i_Exam_Id    => p.r_Number('exam_id'));
  
    result := z_Hln_Exams.To_Map(r_Exam,
                                 z.Exam_Id,
                                 z.Name,
                                 z.Pick_Kind,
                                 z.Duration,
                                 z.Passing_Score,
                                 z.Passing_Percentage,
                                 z.Question_Count,
                                 z.Randomize_Questions,
                                 z.Randomize_Options,
                                 z.For_Recruitment,
                                 z.State);
  
    Result.Put('has_duration', case when r_Exam.Duration is null then 'N' else 'Y' end);
  
    select q.Question_Id
      bulk collect
      into v_Question_Ids
      from Hln_Questions q
      join Hln_Exam_Manual_Questions Mq
        on q.Company_Id = Mq.Company_Id
       and q.Filial_Id = Mq.Filial_Id
       and Mq.Exam_Id = r_Exam.Exam_Id
       and q.Question_Id = Mq.Question_Id
     where q.Company_Id = r_Exam.Company_Id
       and q.Filial_Id = r_Exam.Filial_Id
     order by Mq.Order_No, Lower(q.Name);
  
    Result.Put('questions', Load_Questions(v_Question_Ids));
  
    select Array_Varchar2(Ep.Pattern_Id,
                          Ep.Quantity,
                          Ep.Has_Writing_Question,
                          Ep.Max_Cnt_Writing_Question,
                          Ep.Order_No),
           Ep.Pattern_Id
      bulk collect
      into v_Matrix, v_Pattern_Ids
      from Hln_Exam_Patterns Ep
     where Ep.Company_Id = r_Exam.Company_Id
       and Ep.Filial_Id = r_Exam.Filial_Id
       and Ep.Exam_Id = r_Exam.Exam_Id;
  
    Result.Put('patterns', Fazo.Zip_Matrix(v_Matrix));
  
    select Array_Varchar2(Qt.Pattern_Id,
                          Qt.Question_Group_Id,
                          Qt.Question_Type_Id,
                          (select q.Name
                             from Hln_Question_Types q
                            where q.Company_Id = Qt.Company_Id
                              and q.Filial_Id = Qt.Filial_Id
                              and q.Question_Type_Id = Qt.Question_Type_Id))
      bulk collect
      into v_Matrix
      from Hln_Pattern_Question_Types Qt
     where Qt.Company_Id = r_Exam.Company_Id
       and Qt.Filial_Id = r_Exam.Filial_Id
       and Qt.Pattern_Id in (select *
                               from table(v_Pattern_Ids));
  
    Result.Put('types', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('question_groups', Fazo.Zip_Matrix(Question_Groups));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save
  (
    p         Hashmap,
    i_Exam_Id number
  ) return Hashmap is
    p_Exam       Hln_Pref.Exam_Rt;
    v_Questions  Arraylist := p.o_Arraylist('questions');
    v_Patterns   Arraylist := p.o_Arraylist('patterns');
    v_Types      Arraylist;
    v_Question   Hashmap;
    v_Pattern    Hashmap;
    v_Type       Hashmap;
    v_Pattern_Id number;
    v_Pick_Kind  varchar2(1) := p.r_Varchar2('pick_kind');
  begin
    Hln_Util.Exam_New(o_Exam                => p_Exam,
                      i_Company_Id          => Ui.Company_Id,
                      i_Filial_Id           => Ui.Filial_Id,
                      i_Exam_Id             => i_Exam_Id,
                      i_Name                => p.r_Varchar2('name'),
                      i_Pick_Kind           => v_Pick_Kind,
                      i_Duration            => p.o_Number('duration'),
                      i_Passing_Score       => p.o_Number('passing_score'),
                      i_Passing_Percentage  => p.o_Number('passing_percentage'),
                      i_Question_Count      => p.r_Number('question_count'),
                      i_Randomize_Questions => p.o_Varchar2('randomize_questions'),
                      i_Randomize_Options   => p.r_Varchar2('randomize_options'),
                      i_For_Recruitment     => p.r_Varchar2('for_recruitment'),
                      i_State               => p.r_Varchar2('state'));
  
    for i in 1 .. v_Questions.Count
    loop
      v_Question := Treat(v_Questions.r_Hashmap(i) as Hashmap);
    
      Hln_Util.Exam_Add_Question(p_Exam        => p_Exam,
                                 i_Question_Id => v_Question.r_Number('question_id'),
                                 i_Order_No    => v_Question.r_Number('order_no'));
    end loop;
  
    for i in 1 .. v_Patterns.Count
    loop
      v_Pattern    := Treat(v_Patterns.r_Hashmap(i) as Hashmap);
      v_Pattern_Id := v_Pattern.o_Number('pattern_id');
    
      if v_Pattern_Id is null then
        v_Pattern_Id := Hln_Next.Pattern_Id;
      end if;
    
      Hln_Util.Exam_Add_Pattern(p_Exam                     => p_Exam,
                                i_Pattern_Id               => v_Pattern_Id,
                                i_Quantity                 => v_Pattern.r_Number('quantity'),
                                i_Has_Writing_Question     => v_Pattern.r_Varchar2('has_writing_question'),
                                i_Max_Cnt_Writing_Question => v_Pattern.o_Number('max_cnt_writing_question'),
                                i_Order_No                 => v_Pattern.o_Number('order_no'));
    
      --question type add to pattern 
      v_Types := Nvl(v_Pattern.o_Arraylist('question_types'), Arraylist());
    
      for j in 1 .. v_Types.Count
      loop
        v_Type := Treat(v_Types.r_Hashmap(j) as Hashmap);
      
        Hln_Util.Pattern_Add_Question_Type(p_Pattern           => p_Exam.Exam_Pattern(p_Exam.Exam_Pattern.Count),
                                           i_Question_Group_Id => v_Type.r_Number('question_group_id'),
                                           i_Question_Type_Id  => v_Type.r_Number('question_type_id'));
      end loop;
    end loop;
  
    Hln_Api.Exam_Save(p_Exam);
  
    return Fazo.Zip_Map('exam_id', i_Exam_Id, 'name', p_Exam.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Add(p Hashmap) return Hashmap is
  begin
    return save(p, Hln_Next.Exam_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edit(p Hashmap) return Hashmap is
    r_Exam Hln_Exams%rowtype;
  begin
    r_Exam := z_Hln_Exams.Lock_Load(i_Company_Id => Ui.Company_Id,
                                    i_Filial_Id  => Ui.Filial_Id,
                                    i_Exam_Id    => p.r_Number('exam_id'));
  
    return save(p, r_Exam.Exam_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hln_Question_Types
       set Company_Id        = null,
           Filial_Id         = null,
           Question_Group_Id = null,
           Question_Type_Id  = null,
           name              = null,
           State             = null;
  end;

end Ui_Vhr214;
/
