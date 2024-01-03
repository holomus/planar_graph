create or replace package Hln_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Required_Groups
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Question_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Question_New
  (
    o_Question     in out nocopy Hln_Pref.Question_Rt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Question_Id  number,
    i_Name         varchar2,
    i_Answer_Type  varchar2,
    i_Code         varchar2,
    i_State        varchar2,
    i_Writing_Hint varchar2,
    i_Files        Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Question_Add_Option
  (
    p_Question           in out nocopy Hln_Pref.Question_Rt,
    i_Question_Option_Id number,
    i_Name               varchar2,
    i_File_Sha           varchar2,
    i_Is_Correct         varchar2,
    i_Order_No           number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Question_Add_Group_Bind
  (
    p_Question          in out nocopy Hln_Pref.Question_Rt,
    i_Question_Group_Id number,
    i_Question_Type_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Exam_New
  (
    o_Exam                out Hln_Pref.Exam_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Exam_Id             number,
    i_Name                varchar2,
    i_Pick_Kind           varchar2,
    i_Duration            number,
    i_Passing_Score       number,
    i_Passing_Percentage  number,
    i_Question_Count      number,
    i_Randomize_Questions varchar2,
    i_Randomize_Options   varchar2,
    i_For_Recruitment     varchar2,
    i_State               varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Exam_Add_Question
  (
    p_Exam        in out nocopy Hln_Pref.Exam_Rt,
    i_Question_Id number,
    i_Order_No    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Exam_Add_Pattern
  (
    p_Exam                     in out nocopy Hln_Pref.Exam_Rt,
    i_Pattern_Id               number,
    i_Quantity                 number,
    i_Has_Writing_Question     varchar2,
    i_Max_Cnt_Writing_Question number,
    i_Order_No                 number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Pattern_Add_Question_Type
  (
    p_Pattern           in out nocopy Hln_Pref.Exam_Pattern_Rt,
    i_Question_Group_Id number,
    i_Question_Type_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Training_New
  (
    o_Training         out Hln_Pref.Training_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Training_Id      number,
    i_Training_Number  varchar2,
    i_Begin_Date       date,
    i_Mentor_Id        number,
    i_Subject_Group_Id number,
    i_Subject_Ids      Array_Number,
    i_Address          varchar2,
    i_Persons          Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_New
  (
    o_Attestation             out Hln_Pref.Attestation_Rt,
    i_Company_Id              number,
    i_Filial_Id               number,
    i_Attestation_Id          number,
    i_Attestation_Number      varchar2,
    i_Name                    varchar2,
    i_Attestation_Date        date,
    i_Begin_Time_Period_Begin date,
    i_Begin_Time_Period_End   date,
    i_Examiner_Id             number,
    i_Note                    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_Add_Testing
  (
    p_Attestation in out nocopy Hln_Pref.Attestation_Rt,
    i_Testing_Id  number,
    i_Person_Id   number,
    i_Exam_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_Person
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Testing_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Function Question_Type_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Has_Writing_Question
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Testing_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Randomizer_Array
  (
    i_Array       Array_Number,
    i_Result_Size number := null
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Gen_Questions
  (
    i_Company_Id                 number,
    i_Filial_Id                  number,
    i_Question_Types             Array_Number,
    i_Has_Writing_Question       varchar2,
    i_Max_Count_Writing_Question number,
    i_Used_Question_Ids          Array_Number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Attestation_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Testing_Id number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Assess
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number,
    i_Mentor_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Function Testing_Period_Change_Setting_Load
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Validate_Exam_Questions
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Exam_Name  varchar2,
    i_Question   Hln_Pref.Exam_Question_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Function t_Answer_Type(i_Answer_Type varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Answer_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Pick_Kind(i_Pick_Kind varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Pick_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Action_Attach
  (
    i_Person_Type   varchar2,
    i_Action_Number varchar2,
    i_Begin_Time    date,
    i_End_Time      date := null,
    i_Is_Period     varchar2 := null,
    i_Action_Kind   varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Action_Detach
  (
    i_Action_Number varchar2,
    i_Begin_Time    date,
    i_End_Time      date := null,
    i_Is_Period     varchar2 := null,
    i_Action_Kind   varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Action_Update
  (
    i_Action_Number varchar2,
    i_Begin_Time    date,
    i_End_Time      date := null,
    i_Is_Period     varchar2 := null,
    i_Action_Kind   varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Testing_Status(i_Testing_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Testing_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Attestation_Status(i_Attestation_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Attestation_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Training_Status(i_Training_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Training_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Passed_Indeterminate return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Action_Kind(i_Action_Kind varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Kind(i_Person_Kind varchar2) return varchar2;
end Hln_Util;
/
create or replace package body Hln_Util is
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
    return b.Translate('HLN:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Required_Groups
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Question_Id number
  ) is
    v_Group_Ids   Array_Number;
    v_Group_Names Array_Varchar2;
  begin
    select g.Question_Group_Id
      bulk collect
      into v_Group_Ids
      from Hln_Question_Groups g
     where g.Company_Id = i_Company_Id
       and g.Filial_Id = i_Filial_Id
       and g.State = 'A'
       and g.Is_Required = 'Y'
       and not exists (select 1
              from Hln_Question_Group_Binds t
             where t.Company_Id = g.Company_Id
               and t.Filial_Id = g.Filial_Id
               and t.Question_Id = i_Question_Id
               and t.Question_Group_Id = g.Question_Group_Id);
  
    if v_Group_Ids.Count > 0 then
      select g.Name
        bulk collect
        into v_Group_Names
        from Hln_Question_Groups g
       where g.Company_Id = i_Company_Id
         and g.Filial_Id = i_Filial_Id
         and g.Question_Group_Id member of v_Group_Ids;
    
      Hln_Error.Raise_001(Fazo.Gather(v_Group_Names, ', '));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Question_New
  (
    o_Question     in out nocopy Hln_Pref.Question_Rt,
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Question_Id  number,
    i_Name         varchar2,
    i_Answer_Type  varchar2,
    i_Code         varchar2,
    i_State        varchar2,
    i_Writing_Hint varchar2,
    i_Files        Array_Varchar2
  ) is
  begin
    o_Question.Company_Id   := i_Company_Id;
    o_Question.Filial_Id    := i_Filial_Id;
    o_Question.Question_Id  := i_Question_Id;
    o_Question.Name         := i_Name;
    o_Question.Answer_Type  := i_Answer_Type;
    o_Question.Code         := i_Code;
    o_Question.State        := i_State;
    o_Question.Writing_Hint := i_Writing_Hint;
    o_Question.Files        := i_Files;
  
    o_Question.Options     := Hln_Pref.Question_Option_Nt();
    o_Question.Group_Binds := Hln_Pref.Question_Group_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Question_Add_Option
  (
    p_Question           in out nocopy Hln_Pref.Question_Rt,
    i_Question_Option_Id number,
    i_Name               varchar2,
    i_File_Sha           varchar2,
    i_Is_Correct         varchar2,
    i_Order_No           number
  ) is
    v_Option Hln_Pref.Question_Option_Rt;
  begin
    v_Option.Question_Option_Id := i_Question_Option_Id;
    v_Option.Name               := i_Name;
    v_Option.File_Sha           := i_File_Sha;
    v_Option.Is_Correct         := i_Is_Correct;
    v_Option.Order_No           := i_Order_No;
  
    p_Question.Options.Extend;
    p_Question.Options(p_Question.Options.Count) := v_Option;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Question_Add_Group_Bind
  (
    p_Question          in out nocopy Hln_Pref.Question_Rt,
    i_Question_Group_Id number,
    i_Question_Type_Id  number
  ) is
    v_Group_Binds Hln_Pref.Question_Group_Rt;
  begin
    v_Group_Binds.Question_Group_Id := i_Question_Group_Id;
    v_Group_Binds.Question_Type_Id  := i_Question_Type_Id;
  
    p_Question.Group_Binds.Extend;
    p_Question.Group_Binds(p_Question.Group_Binds.Count) := v_Group_Binds;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Exam_New
  (
    o_Exam                out Hln_Pref.Exam_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Exam_Id             number,
    i_Name                varchar2,
    i_Pick_Kind           varchar2,
    i_Duration            number,
    i_Passing_Score       number,
    i_Passing_Percentage  number,
    i_Question_Count      number,
    i_Randomize_Questions varchar2,
    i_Randomize_Options   varchar2,
    i_For_Recruitment     varchar2,
    i_State               varchar2
  ) is
  begin
    o_Exam.Company_Id          := i_Company_Id;
    o_Exam.Filial_Id           := i_Filial_Id;
    o_Exam.Exam_Id             := i_Exam_Id;
    o_Exam.Name                := i_Name;
    o_Exam.Pick_Kind           := i_Pick_Kind;
    o_Exam.Duration            := i_Duration;
    o_Exam.Passing_Score       := i_Passing_Score;
    o_Exam.Passing_Percentage  := i_Passing_Percentage;
    o_Exam.Question_Count      := i_Question_Count;
    o_Exam.Randomize_Questions := i_Randomize_Questions;
    o_Exam.Randomize_Options   := i_Randomize_Options;
    o_Exam.For_Recruitment     := i_For_Recruitment;
    o_Exam.State               := i_State;
  
    o_Exam.Exam_Question := Hln_Pref.Exam_Question_Nt();
    o_Exam.Exam_Pattern  := Hln_Pref.Exam_Pattern_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Exam_Add_Question
  (
    p_Exam        in out nocopy Hln_Pref.Exam_Rt,
    i_Question_Id number,
    i_Order_No    number
  ) is
    v_Question Hln_Pref.Exam_Question_Rt;
  begin
    v_Question.Question_Id := i_Question_Id;
    v_Question.Order_No    := i_Order_No;
  
    p_Exam.Exam_Question.Extend;
    p_Exam.Exam_Question(p_Exam.Exam_Question.Count) := v_Question;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Exam_Add_Pattern
  (
    p_Exam                     in out nocopy Hln_Pref.Exam_Rt,
    i_Pattern_Id               number,
    i_Quantity                 number,
    i_Has_Writing_Question     varchar2,
    i_Max_Cnt_Writing_Question number,
    i_Order_No                 number
  ) is
    v_Pattern Hln_Pref.Exam_Pattern_Rt;
  begin
    v_Pattern.Pattern_Id               := i_Pattern_Id;
    v_Pattern.Quantity                 := i_Quantity;
    v_Pattern.Has_Writing_Question     := i_Has_Writing_Question;
    v_Pattern.Max_Cnt_Writing_Question := i_Max_Cnt_Writing_Question;
    v_Pattern.Order_No                 := i_Order_No;
    v_Pattern.Question_Types           := Hln_Pref.Question_Group_Nt();
  
    p_Exam.Exam_Pattern.Extend;
    p_Exam.Exam_Pattern(p_Exam.Exam_Pattern.Count) := v_Pattern;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Pattern_Add_Question_Type
  (
    p_Pattern           in out nocopy Hln_Pref.Exam_Pattern_Rt,
    i_Question_Group_Id number,
    i_Question_Type_Id  number
  ) is
    v_Type Hln_Pref.Question_Group_Rt;
  begin
    v_Type.Question_Group_Id := i_Question_Group_Id;
    v_Type.Question_Type_Id  := i_Question_Type_Id;
  
    p_Pattern.Question_Types.Extend;
    p_Pattern.Question_Types(p_Pattern.Question_Types.Count) := v_Type;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Training_New
  (
    o_Training         out Hln_Pref.Training_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Training_Id      number,
    i_Training_Number  varchar2,
    i_Begin_Date       date,
    i_Mentor_Id        number,
    i_Subject_Group_Id number,
    i_Subject_Ids      Array_Number,
    i_Address          varchar2,
    i_Persons          Array_Number
  ) is
  begin
    o_Training.Company_Id       := i_Company_Id;
    o_Training.Filial_Id        := i_Filial_Id;
    o_Training.Training_Id      := i_Training_Id;
    o_Training.Training_Number  := i_Training_Number;
    o_Training.Begin_Date       := i_Begin_Date;
    o_Training.Mentor_Id        := i_Mentor_Id;
    o_Training.Subject_Group_Id := i_Subject_Group_Id;
    o_Training.Subject_Ids      := i_Subject_Ids;
    o_Training.Address          := i_Address;
    o_Training.Persons          := i_Persons;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_New
  (
    o_Attestation             out Hln_Pref.Attestation_Rt,
    i_Company_Id              number,
    i_Filial_Id               number,
    i_Attestation_Id          number,
    i_Attestation_Number      varchar2,
    i_Name                    varchar2,
    i_Attestation_Date        date,
    i_Begin_Time_Period_Begin date,
    i_Begin_Time_Period_End   date,
    i_Examiner_Id             number,
    i_Note                    varchar2
  ) is
  begin
    o_Attestation.Company_Id              := i_Company_Id;
    o_Attestation.Filial_Id               := i_Filial_Id;
    o_Attestation.Attestation_Id          := i_Attestation_Id;
    o_Attestation.Attestation_Number      := i_Attestation_Number;
    o_Attestation.Name                    := i_Name;
    o_Attestation.Attestation_Date        := i_Attestation_Date;
    o_Attestation.Begin_Time_Period_Begin := i_Begin_Time_Period_Begin;
    o_Attestation.Begin_Time_Period_End   := i_Begin_Time_Period_End;
    o_Attestation.Examiner_Id             := i_Examiner_Id;
    o_Attestation.Note                    := i_Note;
  
    o_Attestation.Testings := Hln_Pref.Testing_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_Add_Testing
  (
    p_Attestation in out nocopy Hln_Pref.Attestation_Rt,
    i_Testing_Id  number,
    i_Person_Id   number,
    i_Exam_Id     number
  ) is
    v_Testing Hln_Pref.Testing_Rt;
  begin
    v_Testing.Testing_Id := i_Testing_Id;
    v_Testing.Person_Id  := i_Person_Id;
    v_Testing.Exam_Id    := i_Exam_Id;
  
    p_Attestation.Testings.Extend;
    p_Attestation.Testings(p_Attestation.Testings.Count) := v_Testing;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Access_Person
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Testing_Id number,
    i_Person_Id  number
  ) is
    v_Attached_Person_Name varchar2(100);
    v_Person_Name          varchar2(100);
    r_Testing              Hln_Testings%rowtype;
  begin
    r_Testing := z_Hln_Testings.Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Person_Id <> i_Person_Id then
      v_Attached_Person_Name := z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id, i_Person_Id => r_Testing.Person_Id).Name;
      v_Person_Name          := z_Mr_Natural_Persons.Load(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id).Name;
    
      Hln_Error.Raise_048(i_Testing_Number       => r_Testing.Testing_Number,
                          i_Attached_Person_Name => v_Attached_Person_Name,
                          i_Person_Name          => v_Person_Name);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Question_Type_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select Qt.Question_Type_Id
      into result
      from Hln_Question_Types Qt
     where Qt.Company_Id = i_Company_Id
       and Qt.Filial_Id = i_Filial_Id
       and Lower(Qt.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when No_Data_Found then
      Hln_Error.Raise_049(i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Writing_Question
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Testing_Id number
  ) return varchar2 is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hln_Questions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Answer_Type = Hln_Pref.c_Answer_Type_Writing
       and exists (select *
              from Hln_Testing_Questions Tq
             where Tq.Company_Id = i_Company_Id
               and Tq.Filial_Id = i_Filial_Id
               and Tq.Testing_Id = i_Testing_Id
               and Tq.Question_Id = q.Question_Id)
       and Rownum = 1;
    return 'Y';
  
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Randomizer_Array
  (
    i_Array       Array_Number,
    i_Result_Size number := null
  ) return Array_Number is
    v_Array       Array_Number := i_Array;
    v_Result_Size number := Least(Nvl(i_Result_Size, i_Array.Count), i_Array.Count);
    v_Size        number := i_Array.Count;
    result        Array_Number := Array_Number();
    v_Random      number;
  begin
    Result.Extend(v_Result_Size);
  
    for i in 1 .. v_Result_Size
    loop
      v_Random := Href_Util.Random_Integer(i_Low => 1, i_High => v_Size);
    
      result(i) := v_Array(v_Random);
    
      v_Array(v_Random) := v_Array(v_Size);
      v_Array(v_Size) := result(i);
      v_Size := v_Size - 1;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Gen_Questions
  (
    i_Company_Id                 number,
    i_Filial_Id                  number,
    i_Question_Types             Array_Number,
    i_Has_Writing_Question       varchar2,
    i_Max_Count_Writing_Question number,
    i_Used_Question_Ids          Array_Number
  ) return Array_Number is
    v_Question_Ids         Array_Number;
    v_Writing_Question_Ids Array_Number := Array_Number();
  begin
    if i_Has_Writing_Question = 'Y' then
      select q.Question_Id
        bulk collect
        into v_Writing_Question_Ids
        from Hln_Questions q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Question_Id not in (select Column_Value
                                     from table(i_Used_Question_Ids))
         and q.State = 'A'
         and q.Answer_Type = Hln_Pref.c_Answer_Type_Writing
         and not exists (select 1
                from table(i_Question_Types)
               where not exists (select *
                        from Hln_Question_Group_Binds Gb
                       where Gb.Company_Id = q.Company_Id
                         and Gb.Filial_Id = q.Filial_Id
                         and Gb.Question_Id = q.Question_Id
                         and Gb.Question_Type_Id = Column_Value));
    
      if i_Max_Count_Writing_Question is not null then
        v_Writing_Question_Ids := Randomizer_Array(v_Writing_Question_Ids,
                                                   i_Max_Count_Writing_Question);
      end if;
    end if;
  
    select q.Question_Id
      bulk collect
      into v_Question_Ids
      from Hln_Questions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Question_Id not in (select Column_Value
                                   from table(i_Used_Question_Ids))
       and q.State = 'A'
       and q.Answer_Type in (Hln_Pref.c_Answer_Type_Multiple, Hln_Pref.c_Answer_Type_Single)
       and not exists (select 1
              from table(i_Question_Types)
             where not exists (select 1
                      from Hln_Question_Group_Binds Gb
                     where Gb.Company_Id = q.Company_Id
                       and Gb.Filial_Id = q.Filial_Id
                       and Gb.Question_Id = q.Question_Id
                       and Gb.Question_Type_Id = Column_Value));
  
    return v_Writing_Question_Ids multiset union v_Question_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Attestation_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Testing_Id number
  ) return number is
    result number;
  begin
    select q.Attestation_Id
      into result
      from Hln_Attestation_Testings q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Testing_Id = i_Testing_Id
       and Rownum = 1;
  
    return result;
  
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Assess
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number,
    i_Mentor_Id   number
  ) is
    r_Training Hln_Trainings%rowtype;
  begin
    r_Training := z_Hln_Trainings.Load(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Training_Id => i_Training_Id);
  
    if r_Training.Mentor_Id <> i_Mentor_Id and Md_Pref.User_Admin(i_Company_Id) <> Md_Env.User_Id then
      Hln_Error.Raise_050(r_Training.Training_Number);
    end if;
  
    if r_Training.Status <> Hln_Pref.c_Training_Status_Executed then
      Hln_Error.Raise_051(i_Training_Number => r_Training.Training_Number,
                          i_Status_Name     => Hln_Util.t_Training_Status(r_Training.Status));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Testing_Period_Change_Setting_Load
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Code       => Hln_Pref.c_Testing_Period_Change_Setting),
               'N');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Check_Questions
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Question_Id number,
    i_Exam_Name   varchar2
  ) is
    v_Count number;
  begin
    select count(*)
      into v_Count
      from Hln_Question_Options Qo
     where Qo.Company_Id = i_Company_Id
       and Qo.Filial_Id = i_Filial_Id
       and Qo.Question_Id = i_Question_Id;
  
    if v_Count > 4 then
      Hln_Error.Raise_059(i_Exam_Name => i_Exam_Name, i_Question_Id => i_Question_Id);
    end if;
  
    select 1
      into v_Count
      from Dual
     where exists (select 1
              from Hln_Question_Files q
             where q.Company_Id = i_Company_Id
               and q.Filial_Id = i_Filial_Id
               and q.Question_Id = i_Question_Id)
        or exists (select 1
              from Hln_Question_Options Qo
             where Qo.Company_Id = i_Company_Id
               and Qo.Filial_Id = i_Filial_Id
               and Qo.Question_Id = i_Question_Id
               and Qo.File_Sha is not null);
  
    Hln_Error.Raise_058(i_Exam_Name => i_Exam_Name, i_Question_Id => i_Question_Id);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validate_Exam_Questions
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Exam_Name  varchar2,
    i_Question   Hln_Pref.Exam_Question_Nt
  ) is
    v_Question Hln_Pref.Exam_Question_Rt;
    r_Quesiton Hln_Questions%rowtype;
  begin
    for i in 1 .. i_Question.Count
    loop
      v_Question := i_Question(i);
    
      r_Quesiton := z_Hln_Questions.Lock_Load(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Question_Id => v_Question.Question_Id);
    
      if r_Quesiton.Answer_Type <> Hln_Pref.c_Answer_Type_Single then
        Hln_Error.Raise_060(i_Exam_Name => i_Exam_Name, i_Question_Id => v_Question.Question_Id);
      end if;
    
      Check_Questions(i_Company_Id  => i_Company_Id,
                      i_Filial_Id   => i_Filial_Id,
                      i_Question_Id => v_Question.Question_Id,
                      i_Exam_Name   => i_Exam_Name);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Answer_Type_Single return varchar2 is
  begin
    return t('answer_type:single');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Answer_Type_Multiple return varchar2 is
  begin
    return t('answer_type:multiple');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Answer_Type_Writing return varchar2 is
  begin
    return t('answer_type:writing');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Answer_Type(i_Answer_Type varchar2) return varchar2 is
  begin
    return --
    case i_Answer_Type --
    when Hln_Pref.c_Answer_Type_Single then t_Answer_Type_Single --
    when Hln_Pref.c_Answer_Type_Multiple then t_Answer_Type_Multiple --
    when Hln_Pref.c_Answer_Type_Writing then t_Answer_Type_Writing --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Answer_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hln_Pref.c_Answer_Type_Single,
                                          Hln_Pref.c_Answer_Type_Multiple,
                                          Hln_Pref.c_Answer_Type_Writing),
                           Array_Varchar2(t_Answer_Type_Single,
                                          t_Answer_Type_Multiple,
                                          t_Answer_Type_Writing));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Pick_Kind_Manual return varchar2 is
  begin
    return t('pick_kind:manual');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Pick_Kind_Auto return varchar2 is
  begin
    return t('pick_kind:auto');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Pick_Kind(i_Pick_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Pick_Kind --
    when Hln_Pref.c_Exam_Pick_Kind_Manual then t_Pick_Kind_Manual --
    when Hln_Pref.c_Exam_Pick_Kind_Auto then t_Pick_Kind_Auto --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Pick_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hln_Pref.c_Exam_Pick_Kind_Manual,
                                          Hln_Pref.c_Exam_Pick_Kind_Auto),
                           Array_Varchar2(t_Pick_Kind_Manual, --
                                          t_Pick_Kind_Auto));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Action_Attach
  (
    i_Person_Type   varchar2,
    i_Action_Number varchar2,
    i_Begin_Time    date,
    i_End_Time      date := null,
    i_Is_Period     varchar2 := null,
    i_Action_Kind   varchar2
  ) return varchar2 is
  begin
    if i_Is_Period = 'Y' then
      return t('you attached as $1{person_type} to $2{action_kind} with $3{action_number} on between $4{begin_time} and $5{end_time}',
               i_Person_Type,
               i_Action_Kind,
               i_Action_Number,
               to_char(i_Begin_Time, 'DD.MM.YYYY HH24:MI'),
               to_char(i_End_Time, 'DD.MM.YYYY HH24:MI'));
    else
      return t('you attached as $1{person_type} to $2{action_kind} with $3{action_number} on $4{begin_time}',
               i_Person_Type,
               i_Action_Kind,
               i_Action_Number,
               to_char(i_Begin_Time, 'DD.MM.YYYY HH24:MI'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Action_Detach
  (
    i_Action_Number varchar2,
    i_Begin_Time    date,
    i_End_Time      date := null,
    i_Is_Period     varchar2 := null,
    i_Action_Kind   varchar2
  ) return varchar2 is
  begin
    if i_Is_Period = 'Y' then
      return t('you detached from $1{action_kind} with $2{action_number} on between $3{begin_time} and $4{end_time}',
               i_Action_Kind,
               i_Action_Number,
               to_char(i_Begin_Time, 'DD.MM.YYYY HH24:MI'),
               to_char(i_End_Time, 'DD.MM.YYYY HH24:MI'));
    else
      return t('you detached from $1{action_kind} with $2{action_number} on $3{begin_time}',
               i_Action_Kind,
               i_Action_Number,
               to_char(i_Begin_Time, 'DD.MM.YYYY HH24:MI'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Action_Update
  (
    i_Action_Number varchar2,
    i_Begin_Time    date,
    i_End_Time      date := null,
    i_Is_Period     varchar2 := null,
    i_Action_Kind   varchar2
  ) return varchar2 is
  begin
    if i_Is_Period = 'Y' then
      return t('your $1{action_kind} info updated to $2{action_number} on between $3{begin_time} and $4{end_time}',
               i_Action_Kind,
               i_Action_Number,
               to_char(i_Begin_Time, 'DD.MM.YYYY HH24:MI'),
               to_char(i_End_Time, 'DD.MM.YYYY HH24:MI'));
    else
      return t('your $1{action_kind} info updated to $2{action_number} on $3{begin_time}',
               i_Action_Kind,
               i_Action_Number,
               to_char(i_Begin_Time, 'DD.MM.YYYY HH24:MI'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Testing_Status_New return varchar2 is
  begin
    return t('testing_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Testing_Status_Executed return varchar2 is
  begin
    return t('testing_status:executed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Testing_Status_Paused return varchar2 is
  begin
    return t('testing_status:paused');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Testing_Status_Checking return varchar2 is
  begin
    return t('testing_status:checking');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Testing_Status_Finished return varchar2 is
  begin
    return t('testing_status:finished');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Testing_Status(i_Testing_Status varchar2) return varchar2 is
  begin
    return --
    case i_Testing_Status --
    when Hln_Pref.c_Testing_Status_New then t_Testing_Status_New --
    when Hln_Pref.c_Testing_Status_Executed then t_Testing_Status_Executed --
    when Hln_Pref.c_Testing_Status_Paused then t_Testing_Status_Paused --
    when Hln_Pref.c_Testing_Status_Checking then t_Testing_Status_Checking --
    when Hln_Pref.c_Testing_Status_Finished then t_Testing_Status_Finished --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Testing_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hln_Pref.c_Testing_Status_New,
                                          Hln_Pref.c_Testing_Status_Executed,
                                          Hln_Pref.c_Testing_Status_Paused,
                                          Hln_Pref.c_Testing_Status_Checking,
                                          Hln_Pref.c_Testing_Status_Finished),
                           Array_Varchar2(t_Testing_Status_New,
                                          t_Testing_Status_Executed,
                                          t_Testing_Status_Paused,
                                          t_Testing_Status_Checking,
                                          t_Testing_Status_Finished));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attestation_Status_New return varchar2 is
  begin
    return t('attestation_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attestation_Status_Processing return varchar2 is
  begin
    return t('attestation_status:processing');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attestation_Status_Finished return varchar2 is
  begin
    return t('attestation_status:finished');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attestation_Status(i_Attestation_Status varchar2) return varchar2 is
  begin
    return --
    case i_Attestation_Status --
    when Hln_Pref.c_Attestation_Status_New then t_Attestation_Status_New --
    when Hln_Pref.c_Attestation_Status_Processing then t_Attestation_Status_Processing --
    when Hln_Pref.c_Attestation_Status_Finished then t_Attestation_Status_Finished --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Attestation_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hln_Pref.c_Attestation_Status_New,
                                          Hln_Pref.c_Attestation_Status_Processing,
                                          Hln_Pref.c_Attestation_Status_Finished),
                           Array_Varchar2(t_Attestation_Status_New,
                                          t_Attestation_Status_Processing,
                                          t_Attestation_Status_Finished));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Training_Status_New return varchar2 is
  begin
    return t('training_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Training_Status_Executed return varchar2 is
  begin
    return t('training_status:executed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Training_Status_Finished return varchar2 is
  begin
    return t('training_status:finished');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Training_Status(i_Training_Status varchar2) return varchar2 is
  begin
    return --
    case i_Training_Status --
    when Hln_Pref.c_Training_Status_New then t_Training_Status_New --
    when Hln_Pref.c_Training_Status_Executed then t_Training_Status_Executed --
    when Hln_Pref.c_Training_Status_Finished then t_Training_Status_Finished --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Training_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hln_Pref.c_Training_Status_New,
                                          Hln_Pref.c_Training_Status_Executed,
                                          Hln_Pref.c_Training_Status_Finished),
                           Array_Varchar2(t_Training_Status_New,
                                          t_Training_Status_Executed,
                                          t_Training_Status_Finished));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Passed_Indeterminate return varchar2 is
  begin
    return t('passed: indeterminate');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Testing return varchar2 is
  begin
    return t('testing');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Attestation return varchar2 is
  begin
    return t('attestation');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Training return varchar2 is
  begin
    return t('training');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Action_Kind(i_Action_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Action_Kind --
    when Hln_Pref.c_Action_Kind_Testing then t_Testing --
    when Hln_Pref.c_Action_Kind_Attestation then t_Attestation --
    when Hln_Pref.c_Action_Kind_Training then t_Training --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Mentor return varchar2 is
  begin
    return t('mentor');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Examiner return varchar2 is
  begin
    return t('examiner');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Participant return varchar2 is
  begin
    return t('participant');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Kind(i_Person_Kind varchar2) return varchar2 is
  begin
    return case i_Person_Kind --
    when Hln_Pref.c_Person_Kind_Mentor then t_Mentor --
    when Hln_Pref.c_Person_Kind_Examiner then t_Examiner --
    when Hln_Pref.c_Person_Kind_Participant then t_Participant --
    end;
  end;

end Hln_Util;
/
