create or replace package Hln_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Question_Group_Save(i_Question_Group Hln_Question_Groups%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Question_Group_Delete
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Question_Group_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Question_Type_Save(i_Question_Type Hln_Question_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Question_Type_Delete
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Question_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Question_Save(i_Question Hln_Pref.Question_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Question_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Question_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Exam_Save(i_Exam Hln_Pref.Exam_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Exam_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Exam_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Testing_Period_Change_Setting_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Save
  (
    i_Testing        Hln_Testings%rowtype,
    i_User_Id        number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Set_New
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Enter
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Testing_Return_Execute
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------         
  Procedure Testing_Pause
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------       
  Procedure Testing_Continue
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Return_Checking
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Finish
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Stop
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_User_Id        number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Add_Time
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Added_Time     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Set_Begin_Time
  (
    i_Company_Id              number,
    i_Filial_Id               number,
    i_Testing_Id              number,
    i_Begin_Time_Period_Begin number,
    i_Begin_Time_Period_End   number := null,
    i_Attestation_Id          number := null
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Testing_Start
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Testing_Delete
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_User_Id        number,
    i_Attestation_Id number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_Save
  (
    i_Attestation Hln_Pref.Attestation_Rt,
    i_User_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_Delete
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Attestation_Id number,
    i_User_Id        number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Send_Answer
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Testing_Id          number,
    i_Person_Id           number,
    i_Question_Id         number,
    i_Current_Question_No number,
    i_Question_Option_Ids Array_Number,
    i_Writing_Answer      varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Check_Answer
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Testing_Id  number,
    i_Question_Id number,
    i_Correct     varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Mark_Question
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Testing_Id  number,
    i_Question_Id number,
    i_Person_Id   number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Training_Subject_Group_Save(i_Subject_Group Hln_Pref.Training_Subject_Group_Rt);
  ----------------------------------------------------------------------------------------------------   
  Procedure Trainig_Subject_Group_Delete
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Subject_Group_Id number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Training_Subject_Save(i_Training_Subject Hln_Training_Subjects%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Training_Subject_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Subject_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Training_Save
  (
    i_Training Hln_Pref.Training_Rt,
    i_User_Id  number
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Training_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number,
    i_User_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assess_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number,
    i_Person_Id   number,
    i_Passed      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assess_Person_Subject
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number,
    i_Person_Id   number,
    i_Subject_Id  number,
    i_Passed      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Training_Set_New
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Training_Execute
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Training_Finish
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number
  );
end Hln_Api;
/
create or replace package body Hln_Api is
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
  Procedure Question_Group_Save(i_Question_Group Hln_Question_Groups%rowtype) is
    r_Data Hln_Question_Groups%rowtype;
  begin
    if z_Hln_Question_Groups.Exist_Lock(i_Company_Id        => i_Question_Group.Company_Id,
                                        i_Filial_Id         => i_Question_Group.Filial_Id,
                                        i_Question_Group_Id => i_Question_Group.Question_Group_Id,
                                        o_Row               => r_Data) and r_Data.Pcode is not null then
      if not Fazo.Equal(r_Data.Pcode, i_Question_Group.Pcode) then
        Hln_Error.Raise_004(r_Data.Name);
      end if;
    end if;
  
    z_Hln_Question_Groups.Save_Row(i_Question_Group);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Question_Group_Delete
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Question_Group_Id number
  ) is
    r_Data Hln_Question_Groups%rowtype;
  begin
    if z_Hln_Question_Groups.Exist_Lock(i_Company_Id        => i_Company_Id,
                                        i_Filial_Id         => i_Filial_Id,
                                        i_Question_Group_Id => i_Question_Group_Id,
                                        o_Row               => r_Data) and r_Data.Pcode is not null then
      Hln_Error.Raise_005(r_Data.Name);
    end if;
  
    z_Hln_Question_Groups.Delete_One(i_Company_Id        => i_Company_Id,
                                     i_Filial_Id         => i_Filial_Id,
                                     i_Question_Group_Id => i_Question_Group_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Question_Type_Save(i_Question_Type Hln_Question_Types%rowtype) is
    r_Question_Type Hln_Question_Types%rowtype;
  begin
    if z_Hln_Question_Types.Exist_Lock(i_Company_Id       => i_Question_Type.Company_Id,
                                       i_Filial_Id        => i_Question_Type.Filial_Id,
                                       i_Question_Type_Id => i_Question_Type.Question_Type_Id,
                                       o_Row              => r_Question_Type) and
       (r_Question_Type.Question_Group_Id != i_Question_Type.Question_Group_Id) then
      Hln_Error.Raise_006(i_Question_Type.Name);
    end if;
  
    z_Hln_Question_Types.Save_Row(i_Question_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Question_Type_Delete
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Question_Type_Id number
  ) is
    r_Data Hln_Question_Types%rowtype;
  begin
    if z_Hln_Question_Types.Exist_Lock(i_Company_Id       => i_Company_Id,
                                       i_Filial_Id        => i_Filial_Id,
                                       i_Question_Type_Id => i_Question_Type_Id,
                                       o_Row              => r_Data) and r_Data.Pcode is not null then
      Hln_Error.Raise_007(r_Data.Name);
    end if;
  
    z_Hln_Question_Types.Delete_One(i_Company_Id       => i_Company_Id,
                                    i_Filial_Id        => i_Filial_Id,
                                    i_Question_Type_Id => i_Question_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Question_Save(i_Question Hln_Pref.Question_Rt) is
    v_Option           Hln_Pref.Question_Option_Rt;
    v_Group_Bind       Hln_Pref.Question_Group_Rt;
    v_Option_Ids       Array_Number;
    v_Is_Correct_Count number := 0;
  begin
    z_Hln_Questions.Save_One(i_Company_Id   => i_Question.Company_Id,
                             i_Filial_Id    => i_Question.Filial_Id,
                             i_Question_Id  => i_Question.Question_Id,
                             i_Name         => i_Question.Name,
                             i_Answer_Type  => i_Question.Answer_Type,
                             i_Code         => i_Question.Code,
                             i_State        => i_Question.State,
                             i_Writing_Hint => i_Question.Writing_Hint);
  
    -- question group bind
    delete from Hln_Question_Group_Binds Gb
     where Gb.Company_Id = i_Question.Company_Id
       and Gb.Filial_Id = i_Question.Filial_Id
       and Gb.Question_Id = i_Question.Question_Id;
  
    for i in 1 .. i_Question.Group_Binds.Count
    loop
      v_Group_Bind := i_Question.Group_Binds(i);
    
      if v_Group_Bind.Question_Type_Id is not null then
        z_Hln_Question_Group_Binds.Insert_One(i_Company_Id        => i_Question.Company_Id,
                                              i_Filial_Id         => i_Question.Filial_Id,
                                              i_Question_Id       => i_Question.Question_Id,
                                              i_Question_Group_Id => v_Group_Bind.Question_Group_Id,
                                              i_Question_Type_Id  => v_Group_Bind.Question_Type_Id);
      
      end if;
    end loop;
  
    Hln_Util.Assert_Required_Groups(i_Company_Id  => i_Question.Company_Id,
                                    i_Filial_Id   => i_Question.Filial_Id,
                                    i_Question_Id => i_Question.Question_Id);
  
    -- question files
    for i in 1 .. i_Question.Files.Count
    loop
      z_Hln_Question_Files.Save_One(i_Company_Id  => i_Question.Company_Id,
                                    i_Filial_Id   => i_Question.Filial_Id,
                                    i_Question_Id => i_Question.Question_Id,
                                    i_File_Sha    => i_Question.Files(i),
                                    i_Order_No    => i + 1);
    end loop;
  
    for r in (select *
                from Hln_Question_Files t
               where t.Company_Id = i_Question.Company_Id
                 and t.Filial_Id = i_Question.Filial_Id
                 and t.Question_Id = i_Question.Question_Id
                 and t.File_Sha not member of i_Question.Files)
    loop
      z_Hln_Question_Files.Delete_One(i_Company_Id  => r.Company_Id,
                                      i_Filial_Id   => r.Filial_Id,
                                      i_Question_Id => r.Question_Id,
                                      i_File_Sha    => r.File_Sha);
    end loop;
  
    -- question options
    v_Option_Ids := Array_Number();
  
    if i_Question.Answer_Type = Hln_Pref.c_Answer_Type_Single or
       i_Question.Answer_Type = Hln_Pref.c_Answer_Type_Multiple then
      v_Option_Ids.Extend(i_Question.Options.Count);
    
      if i_Question.Options.Count < 2 then
        Hln_Error.Raise_008(i_Question.Question_Id);
      end if;
    
      for i in 1 .. i_Question.Options.Count
      loop
        v_Option := i_Question.Options(i);
        v_Option_Ids(i) := v_Option.Question_Option_Id;
      
        if v_Option.Is_Correct = 'Y' then
          v_Is_Correct_Count := v_Is_Correct_Count + 1;
        end if;
      
        z_Hln_Question_Options.Save_One(i_Company_Id         => i_Question.Company_Id,
                                        i_Filial_Id          => i_Question.Filial_Id,
                                        i_Question_Option_Id => v_Option.Question_Option_Id,
                                        i_Name               => v_Option.Name,
                                        i_File_Sha           => v_Option.File_Sha,
                                        i_Question_Id        => i_Question.Question_Id,
                                        i_Is_Correct         => v_Option.Is_Correct,
                                        i_Order_No           => v_Option.Order_No);
      end loop;
    
      if v_Is_Correct_Count = 0 then
        Hln_Error.Raise_009(i_Question.Question_Id);
      elsif i_Question.Answer_Type = Hln_Pref.c_Answer_Type_Single and v_Is_Correct_Count != 1 then
        Hln_Error.Raise_010(i_Question.Question_Id);
      end if;
    end if;
  
    for r in (select *
                from Hln_Question_Options t
               where t.Company_Id = i_Question.Company_Id
                 and t.Filial_Id = i_Question.Filial_Id
                 and t.Question_Id = i_Question.Question_Id
                 and t.Question_Option_Id not member of v_Option_Ids)
    loop
      z_Hln_Question_Options.Delete_One(i_Company_Id         => r.Company_Id,
                                        i_Filial_Id          => r.Filial_Id,
                                        i_Question_Option_Id => r.Question_Option_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Question_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Question_Id number
  ) is
  begin
    z_Hln_Questions.Delete_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Question_Id => i_Question_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Exam_Save(i_Exam Hln_Pref.Exam_Rt) is
    r_Exam         Hln_Exams%rowtype;
    v_Question     Hln_Pref.Exam_Question_Rt;
    v_Pattern      Hln_Pref.Exam_Pattern_Rt;
    v_Type         Hln_Pref.Question_Group_Rt;
    v_Question_Ids Array_Number := Array_Number();
    v_Pattern_Ids  Array_Number := Array_Number();
    v_Sum_Quantity number;
    v_Exists       boolean := true;
  begin
    if not z_Hln_Exams.Exist_Lock(i_Company_Id => i_Exam.Company_Id,
                                  i_Filial_Id  => i_Exam.Filial_Id,
                                  i_Exam_Id    => i_Exam.Exam_Id,
                                  o_Row        => r_Exam) then
      r_Exam.Company_Id := i_Exam.Company_Id;
      r_Exam.Filial_Id  := i_Exam.Filial_Id;
      r_Exam.Exam_Id    := i_Exam.Exam_Id;
    
      v_Exists := false;
    end if;
  
    if v_Exists and r_Exam.For_Recruitment = 'Y' and i_Exam.For_Recruitment = 'N' then
      Hln_Error.Raise_061(i_Exam.Name);
    end if;
  
    if i_Exam.For_Recruitment = 'Y' then
      if i_Exam.Pick_Kind = Hln_Pref.c_Exam_Pick_Kind_Auto then
        Hln_Error.Raise_057(i_Exam.Name);
      end if;
    
      Hln_Util.Validate_Exam_Questions(i_Company_Id => i_Exam.Company_Id,
                                       i_Filial_Id  => i_Exam.Filial_Id,
                                       i_Exam_Name  => i_Exam.Name,
                                       i_Question   => i_Exam.Exam_Question);
    end if;
  
    r_Exam.Name                := i_Exam.Name;
    r_Exam.Pick_Kind           := i_Exam.Pick_Kind;
    r_Exam.Duration            := i_Exam.Duration;
    r_Exam.Passing_Percentage  := i_Exam.Passing_Percentage;
    r_Exam.Question_Count      := i_Exam.Question_Count;
    r_Exam.Randomize_Questions := i_Exam.Randomize_Questions;
    r_Exam.Randomize_Options   := i_Exam.Randomize_Options;
    r_Exam.For_Recruitment     := i_Exam.For_Recruitment;
    r_Exam.State               := i_Exam.State;
  
    if r_Exam.Passing_Percentage is not null then
      r_Exam.Passing_Score := Ceil(r_Exam.Passing_Percentage * r_Exam.Question_Count / 100);
    else
      r_Exam.Passing_Score := i_Exam.Passing_Score;
    end if;
  
    if v_Exists then
      z_Hln_Exams.Update_Row(r_Exam);
    else
      z_Hln_Exams.Insert_Row(r_Exam);
    end if;
  
    -- on manual pick kind exam contains manual question
    -- on auto pick contains only patterns
    if r_Exam.Pick_Kind = Hln_Pref.c_Exam_Pick_Kind_Manual then
      if r_Exam.Question_Count > i_Exam.Exam_Question.Count then
        Hln_Error.Raise_011(i_Exam_Question_Count => i_Exam.Exam_Question.Count,
                            i_Question_Count      => r_Exam.Question_Count);
      end if;
    
      v_Question_Ids.Extend(i_Exam.Exam_Question.Count);
    
      for i in 1 .. i_Exam.Exam_Question.Count
      loop
        v_Question := i_Exam.Exam_Question(i);
        v_Question_Ids(i) := v_Question.Question_Id;
      
        z_Hln_Exam_Manual_Questions.Save_One(i_Company_Id  => r_Exam.Company_Id,
                                             i_Filial_Id   => r_Exam.Filial_Id,
                                             i_Exam_Id     => r_Exam.Exam_Id,
                                             i_Question_Id => v_Question.Question_Id,
                                             i_Order_No    => v_Question.Order_No);
      end loop;
    else
      v_Pattern_Ids.Extend(i_Exam.Exam_Pattern.Count);
    
      for i in 1 .. i_Exam.Exam_Pattern.Count
      loop
        v_Pattern := i_Exam.Exam_Pattern(i);
        v_Pattern_Ids(i) := v_Pattern.Pattern_Id;
      
        z_Hln_Exam_Patterns.Save_One(i_Company_Id               => r_Exam.Company_Id,
                                     i_Filial_Id                => r_Exam.Filial_Id,
                                     i_Pattern_Id               => v_Pattern.Pattern_Id,
                                     i_Exam_Id                  => r_Exam.Exam_Id,
                                     i_Quantity                 => v_Pattern.Quantity,
                                     i_Has_Writing_Question     => v_Pattern.Has_Writing_Question,
                                     i_Max_Cnt_Writing_Question => v_Pattern.Max_Cnt_Writing_Question,
                                     i_Order_No                 => v_Pattern.Order_No);
      
        delete from Hln_Pattern_Question_Types Pqt
         where Pqt.Company_Id = r_Exam.Company_Id
           and Pqt.Filial_Id = r_Exam.Filial_Id
           and Pqt.Pattern_Id = v_Pattern.Pattern_Id;
      
        for j in 1 .. v_Pattern.Question_Types.Count
        loop
          v_Type := v_Pattern.Question_Types(j);
        
          z_Hln_Pattern_Question_Types.Save_One(i_Company_Id        => r_Exam.Company_Id,
                                                i_Filial_Id         => r_Exam.Filial_Id,
                                                i_Pattern_Id        => v_Pattern.Pattern_Id,
                                                i_Question_Type_Id  => v_Type.Question_Type_Id,
                                                i_Question_Group_Id => v_Type.Question_Group_Id);
        end loop;
      
        v_Sum_Quantity := v_Sum_Quantity + v_Pattern.Quantity;
      end loop;
    
      if v_Sum_Quantity <> r_Exam.Question_Count then
        Hln_Error.Raise_012(i_Sum_Quantity        => v_Sum_Quantity,
                            i_Exam_Question_Count => r_Exam.Question_Count);
      end if;
    end if;
  
    -- delete manual questions, patterns
    for r in (select *
                from Hln_Exam_Manual_Questions q
               where q.Company_Id = r_Exam.Company_Id
                 and q.Filial_Id = r_Exam.Filial_Id
                 and q.Exam_Id = r_Exam.Exam_Id
                 and q.Question_Id not member of v_Question_Ids)
    loop
      z_Hln_Exam_Manual_Questions.Delete_One(i_Company_Id  => r.Company_Id,
                                             i_Filial_Id   => r.Filial_Id,
                                             i_Exam_Id     => r.Exam_Id,
                                             i_Question_Id => r.Question_Id);
    end loop;
  
    for r in (select *
                from Hln_Exam_Patterns q
               where q.Company_Id = r_Exam.Company_Id
                 and q.Filial_Id = r_Exam.Filial_Id
                 and q.Exam_Id = r_Exam.Exam_Id
                 and q.Pattern_Id not member of v_Pattern_Ids)
    loop
      z_Hln_Exam_Patterns.Delete_One(i_Company_Id => r.Company_Id,
                                     i_Filial_Id  => r.Filial_Id,
                                     i_Pattern_Id => r.Pattern_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Exam_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Exam_Id    number
  ) is
  begin
    z_Hln_Exams.Delete_One(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Exam_Id    => i_Exam_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Testing
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Attestation_Id number,
    i_Testing_Id     number
  ) is
    v_Attestation_Id number;
  begin
    if i_Attestation_Id is not null then
      z_Hln_Attestations.Lock_Only(i_Company_Id     => i_Company_Id,
                                   i_Filial_Id      => i_Filial_Id,
                                   i_Attestation_Id => i_Attestation_Id);
      z_Hln_Attestation_Testings.Lock_Only(i_Company_Id     => i_Company_Id,
                                           i_Filial_Id      => i_Filial_Id,
                                           i_Attestation_Id => i_Attestation_Id,
                                           i_Testing_Id     => i_Testing_Id);
    else
      v_Attestation_Id := Hln_Util.Get_Attestation_Id(i_Company_Id => i_Company_Id,
                                                      i_Filial_Id  => i_Filial_Id,
                                                      i_Testing_Id => i_Testing_Id);
    
      if v_Attestation_Id is not null then
        Hln_Error.Raise_013(i_Testing_Number     => z_Hln_Testings.Load(i_Company_Id => i_Company_Id, --
                                                    i_Filial_Id => i_Filial_Id, --
                                                    i_Testing_Id => i_Testing_Id).Testing_Number,
                            i_Attestation_Number => z_Hln_Attestations.Load(i_Company_Id => i_Company_Id, --
                                                    i_Filial_Id => i_Filial_Id, --
                                                    i_Attestation_Id => v_Attestation_Id).Attestation_Number);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------        
  Procedure Testing_Question_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Testing_Id number,
    i_Exam_Id    number
  ) is
    r_Exam                Hln_Exams%rowtype;
    r_Testing_Question    Hln_Testing_Questions%rowtype;
    r_Question_Option     Hln_Testing_Question_Options%rowtype;
    v_Question_Ids        Array_Number;
    v_Question_Option_Ids Array_Number;
  begin
    r_Exam := z_Hln_Exams.Lock_Load(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Exam_Id    => i_Exam_Id);
  
    delete from Hln_Testing_Questions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Testing_Id = i_Testing_Id;
  
    r_Testing_Question.Company_Id := i_Company_Id;
    r_Testing_Question.Filial_Id  := i_Filial_Id;
    r_Testing_Question.Testing_Id := i_Testing_Id;
  
    r_Question_Option.Company_Id := i_Company_Id;
    r_Question_Option.Filial_Id  := i_Filial_Id;
    r_Question_Option.Testing_Id := i_Testing_Id;
  
    if r_Exam.Pick_Kind = Hln_Pref.c_Exam_Pick_Kind_Manual then
      select Mq.Question_Id
        bulk collect
        into v_Question_Ids
        from Hln_Exam_Manual_Questions Mq
       where Mq.Company_Id = r_Exam.Company_Id
         and Mq.Filial_Id = r_Exam.Filial_Id
         and Mq.Exam_Id = r_Exam.Exam_Id
       order by Mq.Order_No;
    
      if r_Exam.Randomize_Questions = 'Y' then
        v_Question_Ids := Hln_Util.Randomizer_Array(v_Question_Ids);
      end if;
    else
      v_Question_Ids := Hln_Core.Gen_Exam_Questions(i_Company_Id => r_Testing_Question.Company_Id,
                                                    i_Filial_Id  => r_Testing_Question.Filial_Id,
                                                    i_Exam_Id    => r_Exam.Exam_Id);
    end if;
  
    for i in 1 .. r_Exam.Question_Count
    loop
      r_Testing_Question.Question_Id := v_Question_Ids(i);
      r_Testing_Question.Order_No    := i;
    
      z_Hln_Testing_Questions.Save_Row(r_Testing_Question);
    
      --option save
      r_Question_Option.Question_Id := r_Testing_Question.Question_Id;
    
      select q.Question_Option_Id
        bulk collect
        into v_Question_Option_Ids
        from Hln_Question_Options q
       where q.Company_Id = r_Testing_Question.Company_Id
         and q.Filial_Id = r_Testing_Question.Filial_Id
         and q.Question_Id = r_Testing_Question.Question_Id
       order by q.Order_No;
    
      if r_Exam.Randomize_Options = 'Y' then
        v_Question_Option_Ids := Hln_Util.Randomizer_Array(v_Question_Option_Ids);
      end if;
    
      for j in 1 .. v_Question_Option_Ids.Count
      loop
        r_Question_Option.Question_Option_Id := v_Question_Option_Ids(j);
        r_Question_Option.Order_No           := j;
      
        z_Hln_Testing_Question_Options.Save_Row(r_Question_Option);
      end loop;
    end loop;
  end;

  -------------------------------------------------- 
  Procedure Send_Notification
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Person_Ids Array_Number,
    i_Title      varchar2
  ) is
  begin
    Href_Core.Send_Notification(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Title      => i_Title,
                                i_Person_Ids => i_Person_Ids);
  end;

  -------------------------------------------------- 
  Procedure Send_Notification
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_User_Id    number,
    i_Person_Id  number,
    i_Title      varchar2
  ) is
  begin
    if i_User_Id <> i_Person_Id then
      Send_Notification(i_Company_Id => i_Company_Id,
                        i_Filial_Id  => i_Filial_Id,
                        i_Title      => i_Title,
                        i_Person_Ids => Array_Number(i_Person_Id));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Testing_Period_Change_Setting_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Hln_Error.Raise_053;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Hln_Pref.c_Testing_Period_Change_Setting,
                           i_Value      => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Testing_Save
  (
    i_Testing        Hln_Testings%rowtype,
    i_User_Id        number,
    i_Attestation_Id number := null
  ) is
    v_Exists            boolean;
    v_Period_Setting_On varchar2(1) := Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => i_Testing.Company_Id,
                                                                                   i_Filial_Id  => i_Testing.Filial_Id);
    v_Is_Period_On      boolean := v_Period_Setting_On = 'Y';
    r_Testing           Hln_Testings%rowtype;
    r_Exam              Hln_Exams%rowtype;
    r_Old_Testing       Hln_Testings%rowtype;
    t_Participant       varchar2(50) := Hln_Util.t_Person_Kind(Hln_Pref.c_Person_Kind_Participant);
    t_Examiner          varchar2(50) := Hln_Util.t_Person_Kind(Hln_Pref.c_Person_Kind_Examiner);
    t_Testing           varchar2(50) := Hln_Util.t_Action_Kind(Hln_Pref.c_Action_Kind_Testing);
  begin
    if i_Testing.Person_Id = i_Testing.Examiner_Id then
      Hln_Error.Raise_014(i_Testing.Testing_Id);
    end if;
  
    if z_Hln_Testings.Exist_Lock(i_Company_Id => i_Testing.Company_Id,
                                 i_Filial_Id  => i_Testing.Filial_Id,
                                 i_Testing_Id => i_Testing.Testing_Id,
                                 o_Row        => r_Testing) then
      if r_Testing.Status <> Hln_Pref.c_Testing_Status_New then
        Hln_Error.Raise_015(i_Testing_Number => r_Testing.Testing_Number,
                            i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
      end if;
    
      Assert_Testing(i_Company_Id     => i_Testing.Company_Id,
                     i_Filial_Id      => i_Testing.Filial_Id,
                     i_Attestation_Id => i_Attestation_Id,
                     i_Testing_Id     => i_Testing.Testing_Id);
    
      v_Exists      := true;
      r_Old_Testing := r_Testing;
    else
      r_Testing.Company_Id := i_Testing.Company_Id;
      r_Testing.Filial_Id  := i_Testing.Filial_Id;
      r_Testing.Testing_Id := i_Testing.Testing_Id;
      r_Testing.Passed     := Hln_Pref.c_Passed_Indeterminate;
      r_Testing.Status     := Hln_Pref.c_Testing_Status_New;
    
      v_Exists := false;
    end if;
  
    r_Testing.Exam_Id                 := i_Testing.Exam_Id;
    r_Testing.Person_Id               := i_Testing.Person_Id;
    r_Testing.Examiner_Id             := i_Testing.Examiner_Id;
    r_Testing.Testing_Number          := i_Testing.Testing_Number;
    r_Testing.Testing_Date            := i_Testing.Testing_Date;
    r_Testing.Begin_Time_Period_Begin := i_Testing.Begin_Time_Period_Begin;
    r_Testing.Begin_Time_Period_End   := i_Testing.Begin_Time_Period_End;
    r_Testing.End_Time                := null;
    r_Testing.Fact_Begin_Time         := null;
    r_Testing.Fact_End_Time           := null;
    r_Testing.Pause_Time              := null;
    r_Testing.Current_Question_No     := null;
    r_Testing.Correct_Questions_Count := null;
    r_Testing.Note                    := i_Testing.Note;
  
    r_Exam := z_Hln_Exams.Lock_Load(i_Company_Id => r_Testing.Company_Id,
                                    i_Filial_Id  => r_Testing.Filial_Id,
                                    i_Exam_Id    => r_Testing.Exam_Id);
  
    if v_Is_Period_On and r_Testing.Begin_Time_Period_Begin > r_Testing.Begin_Time_Period_End then
      Hln_Error.Raise_055(i_Testing_Number => r_Testing.Testing_Number,
                          i_Period_Begin   => r_Testing.Begin_Time_Period_Begin,
                          i_Period_End     => r_Testing.Begin_Time_Period_End);
    end if;
  
    if not v_Is_Period_On then
      r_Testing.End_Time := r_Testing.Begin_Time_Period_Begin +
                            Numtodsinterval(r_Exam.Duration, 'minute');
    end if;
  
    if v_Exists then
      z_Hln_Testings.Update_Row(r_Testing);
    
      if r_Old_Testing.Person_Id <> r_Testing.Person_Id then
        Send_Notification(i_Company_Id => r_Old_Testing.Company_Id,
                          i_Filial_Id  => r_Old_Testing.Filial_Id,
                          i_User_Id    => i_User_Id,
                          i_Person_Id  => r_Old_Testing.Person_Id,
                          i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Old_Testing.Testing_Number,
                                                                                i_Begin_Time    => r_Old_Testing.Begin_Time_Period_Begin,
                                                                                i_End_Time      => r_Old_Testing.Begin_Time_Period_End,
                                                                                i_Is_Period     => v_Period_Setting_On,
                                                                                i_Action_Kind   => t_Testing));
      
        Send_Notification(i_Company_Id => r_Testing.Company_Id,
                          i_Filial_Id  => r_Testing.Filial_Id,
                          i_User_Id    => i_User_Id,
                          i_Person_Id  => r_Testing.Person_Id,
                          i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Participant,
                                                                                i_Action_Number => r_Testing.Testing_Number,
                                                                                i_Begin_Time    => r_Testing.Begin_Time_Period_Begin,
                                                                                i_End_Time      => r_Testing.Begin_Time_Period_End,
                                                                                i_Is_Period     => v_Period_Setting_On,
                                                                                i_Action_Kind   => t_Testing));
      else
        if r_Old_Testing.Testing_Number <> r_Testing.Testing_Number or --
           r_Old_Testing.Begin_Time_Period_Begin <> r_Testing.Begin_Time_Period_Begin or --
           r_Old_Testing.Begin_Time_Period_End <> r_Testing.Begin_Time_Period_End then
          Send_Notification(i_Company_Id => r_Testing.Company_Id,
                            i_Filial_Id  => r_Testing.Filial_Id,
                            i_User_Id    => i_User_Id,
                            i_Person_Id  => r_Testing.Person_Id,
                            i_Title      => Hln_Util.t_Notification_Action_Update(i_Action_Number => r_Testing.Testing_Number,
                                                                                  i_Begin_Time    => r_Testing.Begin_Time_Period_Begin,
                                                                                  i_End_Time      => r_Testing.Begin_Time_Period_End,
                                                                                  i_Is_Period     => v_Period_Setting_On,
                                                                                  i_Action_Kind   => t_Testing));
        end if;
      end if;
    
      if i_Attestation_Id is null then
        if r_Old_Testing.Examiner_Id <> r_Testing.Examiner_Id then
          Send_Notification(i_Company_Id => r_Old_Testing.Company_Id,
                            i_Filial_Id  => r_Old_Testing.Filial_Id,
                            i_User_Id    => i_User_Id,
                            i_Person_Id  => r_Old_Testing.Examiner_Id,
                            i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Old_Testing.Testing_Number,
                                                                                  i_Begin_Time    => r_Old_Testing.Begin_Time_Period_Begin,
                                                                                  i_End_Time      => r_Old_Testing.Begin_Time_Period_End,
                                                                                  i_Is_Period     => v_Period_Setting_On,
                                                                                  i_Action_Kind   => t_Testing));
        
          Send_Notification(i_Company_Id => r_Testing.Company_Id,
                            i_Filial_Id  => r_Testing.Filial_Id,
                            i_User_Id    => i_User_Id,
                            i_Person_Id  => r_Testing.Examiner_Id,
                            i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Examiner,
                                                                                  i_Action_Number => r_Testing.Testing_Number,
                                                                                  i_Begin_Time    => r_Testing.Begin_Time_Period_Begin,
                                                                                  i_End_Time      => r_Testing.Begin_Time_Period_End,
                                                                                  i_Is_Period     => v_Period_Setting_On,
                                                                                  i_Action_Kind   => t_Testing));
        else
          if r_Old_Testing.Testing_Number <> r_Testing.Testing_Number or --
             r_Old_Testing.Begin_Time_Period_Begin <> r_Testing.Begin_Time_Period_Begin or --
             r_Old_Testing.Begin_Time_Period_End <> r_Testing.Begin_Time_Period_End then
            Send_Notification(i_Company_Id => r_Testing.Company_Id,
                              i_Filial_Id  => r_Testing.Filial_Id,
                              i_User_Id    => i_User_Id,
                              i_Person_Id  => r_Testing.Examiner_Id,
                              i_Title      => Hln_Util.t_Notification_Action_Update(i_Action_Number => r_Testing.Testing_Number,
                                                                                    i_Begin_Time    => r_Testing.Begin_Time_Period_Begin,
                                                                                    i_End_Time      => r_Testing.Begin_Time_Period_End,
                                                                                    i_Is_Period     => v_Period_Setting_On,
                                                                                    i_Action_Kind   => t_Testing));
          end if;
        end if;
      end if;
    else
      if r_Testing.Testing_Number is null then
        r_Testing.Testing_Number := Md_Core.Gen_Number(i_Company_Id => r_Testing.Company_Id,
                                                       i_Filial_Id  => r_Testing.Filial_Id,
                                                       i_Table      => Zt.Hln_Testings,
                                                       i_Column     => z.Testing_Number);
      end if;
    
      z_Hln_Testings.Insert_Row(r_Testing);
    
      Send_Notification(i_Company_Id => r_Testing.Company_Id,
                        i_Filial_Id  => r_Testing.Filial_Id,
                        i_User_Id    => i_User_Id,
                        i_Person_Id  => r_Testing.Person_Id,
                        i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Participant,
                                                                              i_Action_Number => r_Testing.Testing_Number,
                                                                              i_Begin_Time    => r_Testing.Begin_Time_Period_Begin,
                                                                              i_End_Time      => r_Testing.Begin_Time_Period_End,
                                                                              i_Is_Period     => v_Period_Setting_On,
                                                                              i_Action_Kind   => t_Testing));
    
      if i_Attestation_Id is null then
        Send_Notification(i_Company_Id => r_Testing.Company_Id,
                          i_Filial_Id  => r_Testing.Filial_Id,
                          i_User_Id    => i_User_Id,
                          i_Person_Id  => r_Testing.Examiner_Id,
                          i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Examiner,
                                                                                i_Action_Number => r_Testing.Testing_Number,
                                                                                i_Begin_Time    => r_Testing.Begin_Time_Period_Begin,
                                                                                i_End_Time      => r_Testing.Begin_Time_Period_End,
                                                                                i_Is_Period     => v_Period_Setting_On,
                                                                                i_Action_Kind   => t_Testing));
      end if;
    end if;
  
    Testing_Question_Save(i_Company_Id => r_Testing.Company_Id,
                          i_Filial_Id  => r_Testing.Filial_Id,
                          i_Testing_Id => r_Testing.Testing_Id,
                          i_Exam_Id    => r_Testing.Exam_Id);
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Testing_Set_New
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status = Hln_Pref.c_Testing_Status_New then
      Hln_Error.Raise_016(r_Testing.Testing_Number);
    end if;
  
    -- clear question facts
    for Quest in (select *
                    from Hln_Testing_Questions q
                   where q.Company_Id = i_Company_Id
                     and q.Filial_Id = i_Filial_Id
                     and q.Testing_Id = i_Testing_Id)
    loop
      z_Hln_Testing_Questions.Update_One(i_Company_Id     => Quest.Company_Id,
                                         i_Filial_Id      => Quest.Filial_Id,
                                         i_Testing_Id     => Quest.Testing_Id,
                                         i_Question_Id    => Quest.Question_Id,
                                         i_Writing_Answer => Option_Varchar2(null),
                                         i_Marked         => Option_Varchar2(null),
                                         i_Correct        => Option_Varchar2(null));
    end loop;
  
    for Opt in (select *
                  from Hln_Testing_Question_Options o
                 where o.Company_Id = i_Company_Id
                   and o.Filial_Id = i_Filial_Id
                   and o.Testing_Id = i_Testing_Id)
    loop
      z_Hln_Testing_Question_Options.Update_One(i_Company_Id         => Opt.Company_Id,
                                                i_Filial_Id          => Opt.Filial_Id,
                                                i_Testing_Id         => Opt.Testing_Id,
                                                i_Question_Id        => Opt.Question_Id,
                                                i_Question_Option_Id => Opt.Question_Option_Id,
                                                i_Chosen             => Option_Varchar2(null));
    end loop;
  
    z_Hln_Testings.Update_One(i_Company_Id              => i_Company_Id,
                              i_Filial_Id               => i_Filial_Id,
                              i_Testing_Id              => i_Testing_Id,
                              i_End_Time                => Option_Date(null),
                              i_Pause_Time              => Option_Date(null),
                              i_Fact_Begin_Time         => Option_Date(null),
                              i_Fact_End_Time           => Option_Date(null),
                              i_Current_Question_No     => Option_Number(null),
                              i_Passed                  => Option_Varchar2(Hln_Pref.c_Passed_Indeterminate),
                              i_Correct_Questions_Count => Option_Number(null),
                              i_Status                  => Option_Varchar2(Hln_Pref.c_Testing_Status_New));
  
    if i_Attestation_Id is not null then
      Hln_Core.Make_Dirty_Attestation(i_Company_Id     => r_Testing.Company_Id,
                                      i_Filial_Id      => r_Testing.Filial_Id,
                                      i_Attestation_Id => i_Attestation_Id);
    end if;
  end;

  -- changes testing status to executed
  ----------------------------------------------------------------------------------------------------         
  Procedure Testing_Enter
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  ) is
    v_Is_Period_On boolean := Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => i_Company_Id,
                                                                          i_Filial_Id  => i_Filial_Id) = 'Y';
    v_Current_Date date := Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id, --
                                                     i_Filial_Id  => i_Filial_Id);
    r_Testing      Hln_Testings%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_New then
      Hln_Error.Raise_017(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    if v_Is_Period_On then
      if r_Testing.Begin_Time_Period_Begin is not null and
         v_Current_Date not between r_Testing.Begin_Time_Period_Begin and
         r_Testing.Begin_Time_Period_End then
        Hln_Error.Raise_054(i_Testing_Number => r_Testing.Testing_Number,
                            i_Period_Begin   => r_Testing.Begin_Time_Period_Begin,
                            i_Period_End     => r_Testing.Begin_Time_Period_End);
      end if;
    
      r_Testing.End_Time := v_Current_Date + Numtodsinterval(z_Hln_Exams.Load(i_Company_Id => r_Testing.Company_Id, i_Filial_Id => r_Testing.Filial_Id, i_Exam_Id => r_Testing.Exam_Id).Duration,
                                                             'minute');
    else
      if r_Testing.Begin_Time_Period_Begin is null then
        Hln_Error.Raise_018(r_Testing.Testing_Number);
      elsif r_Testing.End_Time is null then
        if v_Current_Date < r_Testing.Begin_Time_Period_Begin then
          Hln_Error.Raise_019(i_Begin_Time     => to_char(r_Testing.Begin_Time_Period_Begin,
                                                          Href_Pref.c_Date_Format_Minute),
                              i_Testing_Number => r_Testing.Testing_Number);
        end if;
      elsif not v_Current_Date between r_Testing.Begin_Time_Period_Begin and r_Testing.End_Time then
        Hln_Error.Raise_020(i_Begin_Time     => to_char(r_Testing.Begin_Time_Period_Begin,
                                                        Href_Pref.c_Date_Format_Minute),
                            i_End_Time       => to_char(r_Testing.End_Time,
                                                        Href_Pref.c_Date_Format_Minute),
                            i_Testing_Number => r_Testing.Testing_Number);
      end if;
    end if;
  
    z_Hln_Testings.Update_One(i_Company_Id              => i_Company_Id,
                              i_Filial_Id               => i_Filial_Id,
                              i_Testing_Id              => i_Testing_Id,
                              i_End_Time                => Option_Date(r_Testing.End_Time),
                              i_Fact_Begin_Time         => Option_Date(v_Current_Date),
                              i_Passed                  => Option_Varchar2(Hln_Pref.c_Passed_Indeterminate),
                              i_Correct_Questions_Count => Option_Number(null),
                              i_Status                  => Option_Varchar2(Hln_Pref.c_Testing_Status_Executed));
  
    if i_Attestation_Id is not null then
      Hln_Core.Make_Dirty_Attestation(i_Company_Id     => r_Testing.Company_Id,
                                      i_Filial_Id      => r_Testing.Filial_Id,
                                      i_Attestation_Id => i_Attestation_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Testing_Return_Execute
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status not in
       (Hln_Pref.c_Testing_Status_Checking, Hln_Pref.c_Testing_Status_Finished) then
      Hln_Error.Raise_021(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    for r in (select *
                from Hln_Testing_Questions q
               where q.Company_Id = i_Company_Id
                 and q.Testing_Id = i_Testing_Id)
    loop
      z_Hln_Testing_Questions.Update_One(i_Company_Id  => r.Company_Id,
                                         i_Filial_Id   => r.Filial_Id,
                                         i_Testing_Id  => r.Testing_Id,
                                         i_Question_Id => r.Question_Id,
                                         i_Correct     => Option_Varchar2(null));
    end loop;
  
    z_Hln_Testings.Update_One(i_Company_Id              => i_Company_Id,
                              i_Filial_Id               => i_Filial_Id,
                              i_Testing_Id              => i_Testing_Id,
                              i_Fact_End_Time           => Option_Date(null),
                              i_Passed                  => Option_Varchar2(Hln_Pref.c_Passed_Indeterminate),
                              i_Correct_Questions_Count => Option_Number(null),
                              i_Status                  => Option_Varchar2(Hln_Pref.c_Testing_Status_Executed));
  
    if i_Attestation_Id is not null then
      Hln_Core.Make_Dirty_Attestation(i_Company_Id     => r_Testing.Company_Id,
                                      i_Filial_Id      => r_Testing.Filial_Id,
                                      i_Attestation_Id => i_Attestation_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------         
  Procedure Testing_Pause
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_Executed then
      Hln_Error.Raise_022(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    z_Hln_Testings.Update_One(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Testing_Id => i_Testing_Id,
                              i_Pause_Time => Option_Date(Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                                                    i_Filial_Id  => i_Filial_Id)),
                              i_Status     => Option_Varchar2(Hln_Pref.c_Testing_Status_Paused));
  
    if i_Attestation_Id is not null then
      Hln_Core.Make_Dirty_Attestation(i_Company_Id     => r_Testing.Company_Id,
                                      i_Filial_Id      => r_Testing.Filial_Id,
                                      i_Attestation_Id => i_Attestation_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Testing_Continue
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_Paused then
      Hln_Error.Raise_023(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    if r_Testing.End_Time is not null then
      r_Testing.End_Time := r_Testing.End_Time + (Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                                            i_Filial_Id  => i_Filial_Id) -
                            r_Testing.Pause_Time);
    end if;
  
    z_Hln_Testings.Update_One(i_Company_Id => r_Testing.Company_Id,
                              i_Filial_Id  => r_Testing.Filial_Id,
                              i_Testing_Id => r_Testing.Testing_Id,
                              i_End_Time   => Option_Date(r_Testing.End_Time),
                              i_Pause_Time => Option_Date(null),
                              i_Status     => Option_Varchar2(Hln_Pref.c_Testing_Status_Executed));
  
    if i_Attestation_Id is not null then
      Hln_Core.Make_Dirty_Attestation(i_Company_Id     => r_Testing.Company_Id,
                                      i_Filial_Id      => r_Testing.Filial_Id,
                                      i_Attestation_Id => i_Attestation_Id);
    end if;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Testing_Return_Checking
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_Finished then
      Hln_Error.Raise_024(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    -- clear question facts
    for Quest in (select *
                    from Hln_Testing_Questions q
                   where q.Company_Id = i_Company_Id
                     and q.Filial_Id = i_Filial_Id
                     and q.Testing_Id = i_Testing_Id)
    loop
      z_Hln_Testing_Questions.Update_One(i_Company_Id  => Quest.Company_Id,
                                         i_Filial_Id   => Quest.Filial_Id,
                                         i_Testing_Id  => Quest.Testing_Id,
                                         i_Question_Id => Quest.Question_Id,
                                         i_Marked      => Option_Varchar2(null),
                                         i_Correct     => Option_Varchar2(null));
    end loop;
  
    z_Hln_Testings.Update_One(i_Company_Id              => i_Company_Id,
                              i_Filial_Id               => i_Filial_Id,
                              i_Testing_Id              => i_Testing_Id,
                              i_Passed                  => Option_Varchar2(Hln_Pref.c_Passed_Indeterminate),
                              i_Correct_Questions_Count => Option_Number(null),
                              i_Status                  => Option_Varchar2(Hln_Pref.c_Testing_Status_Checking));
  
    if i_Attestation_Id is not null then
      Hln_Core.Make_Dirty_Attestation(i_Company_Id     => r_Testing.Company_Id,
                                      i_Filial_Id      => r_Testing.Filial_Id,
                                      i_Attestation_Id => i_Attestation_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------         
  Procedure Testing_Finish
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  ) is
    r_Testing                 Hln_Testings%rowtype;
    v_Correct_Questions_Count number;
    v_Passed                  varchar2(1);
    v_Dummy                   varchar2(1);
    r_Question                Hln_Questions%rowtype;
    v_Question_Ids            Array_Number;
    v_Option_Ids              Array_Number;
    v_Passing_Score           number;
    v_Correct_Options_Count   number;
    v_Options_Count           number := 0;
    v_Fact_End_Time           date;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    v_Fact_End_Time := r_Testing.Fact_End_Time;
  
    if r_Testing.Status = Hln_Pref.c_Testing_Status_Finished then
      Hln_Error.Raise_025(r_Testing.Testing_Number);
    elsif r_Testing.Status = Hln_Pref.c_Testing_Status_Checking then
      -- check writing questions are checked 
      begin
        select 'x'
          into v_Dummy
          from Hln_Testing_Questions q
         where q.Company_Id = i_Company_Id
           and q.Filial_Id = i_Filial_Id
           and q.Testing_Id = i_Testing_Id
           and q.Correct is null
           and exists (select 1
                  from Hln_Questions w
                 where w.Company_Id = q.Company_Id
                   and w.Filial_Id = q.Filial_Id
                   and w.Question_Id = q.Question_Id
                   and w.Answer_Type = Hln_Pref.c_Answer_Type_Writing)
           and Rownum = 1;
        Hln_Error.Raise_026(r_Testing.Testing_Number);
      exception
        when No_Data_Found then
          null;
      end;
    elsif r_Testing.Status = Hln_Pref.c_Testing_Status_New and r_Testing.End_Time is not null and
          Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id, --
                                    i_Filial_Id  => i_Filial_Id) < r_Testing.End_Time then
      Hln_Error.Raise_027(i_End_Time       => to_char(r_Testing.End_Time,
                                                      Href_Pref.c_Date_Format_Minute),
                          i_Testing_Number => r_Testing.Testing_Number);
    elsif r_Testing.Status in
          (Hln_Pref.c_Testing_Status_Executed, Hln_Pref.c_Testing_Status_Paused) then
      v_Fact_End_Time := Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                   i_Filial_Id  => i_Filial_Id);
    end if;
  
    -- calc testing results
    -- check chosen answers
    select q.Question_Id
      bulk collect
      into v_Question_Ids
      from Hln_Testing_Questions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Testing_Id = i_Testing_Id
       and not exists (select *
              from Hln_Questions Qu
             where Qu.Company_Id = q.Company_Id
               and Qu.Filial_Id = q.Filial_Id
               and Qu.Question_Id = q.Question_Id
               and Qu.Answer_Type = Hln_Pref.c_Answer_Type_Writing);
  
    for i in 1 .. v_Question_Ids.Count
    loop
      r_Question := z_Hln_Questions.Load(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Question_Id => v_Question_Ids(i));
    
      select count(*)
        into v_Correct_Options_Count
        from Hln_Question_Options q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Question_Id = v_Question_Ids(i)
         and q.Is_Correct = 'Y';
    
      select q.Question_Option_Id
        bulk collect
        into v_Option_Ids
        from Hln_Testing_Question_Options q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Testing_Id = i_Testing_Id
         and q.Question_Id = v_Question_Ids(i)
         and q.Chosen = 'Y';
    
      v_Options_Count := 0;
      if v_Correct_Options_Count = v_Option_Ids.Count then
        for j in 1 .. v_Option_Ids.Count
        loop
          if z_Hln_Question_Options.Load(i_Company_Id => i_Company_Id, --
           i_Filial_Id => i_Filial_Id, --
           i_Question_Option_Id => v_Option_Ids(j)).Is_Correct = 'Y' then
          
            v_Options_Count := v_Options_Count + 1;
          end if;
        end loop;
      end if;
    
      if v_Correct_Options_Count = v_Options_Count then
        z_Hln_Testing_Questions.Update_One(i_Company_Id  => i_Company_Id,
                                           i_Filial_Id   => i_Filial_Id,
                                           i_Testing_Id  => i_Testing_Id,
                                           i_Question_Id => v_Question_Ids(i),
                                           i_Correct     => Option_Varchar2('Y'));
      else
        z_Hln_Testing_Questions.Update_One(i_Company_Id  => i_Company_Id,
                                           i_Filial_Id   => i_Filial_Id,
                                           i_Testing_Id  => i_Testing_Id,
                                           i_Question_Id => v_Question_Ids(i),
                                           i_Correct     => Option_Varchar2('N'));
      end if;
    end loop;
  
    -- calc testing total result
    select count(q.Correct)
      into v_Correct_Questions_Count
      from Hln_Testing_Questions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Testing_Id = i_Testing_Id
       and q.Correct = 'Y';
  
    v_Passing_Score := z_Hln_Exams.Load(i_Company_Id => r_Testing.Company_Id, --
                       i_Filial_Id => i_Filial_Id, --
                       i_Exam_Id => r_Testing.Exam_Id).Passing_Score;
  
    if (v_Correct_Questions_Count >= v_Passing_Score) then
      v_Passed := 'Y';
    else
      v_Passed := 'N';
    end if;
  
    z_Hln_Testings.Update_One(i_Company_Id              => i_Company_Id,
                              i_Filial_Id               => i_Filial_Id,
                              i_Testing_Id              => i_Testing_Id,
                              i_Fact_End_Time           => Option_Date(v_Fact_End_Time),
                              i_Pause_Time              => Option_Date(null),
                              i_Correct_Questions_Count => Option_Number(v_Correct_Questions_Count),
                              i_Passed                  => Option_Varchar2(v_Passed),
                              i_Status                  => Option_Varchar2(Hln_Pref.c_Testing_Status_Finished));
  
    if i_Attestation_Id is not null then
      Hln_Core.Make_Dirty_Attestation(i_Company_Id     => r_Testing.Company_Id,
                                      i_Filial_Id      => r_Testing.Filial_Id,
                                      i_Attestation_Id => i_Attestation_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Testing_Stop
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_User_Id        number,
    i_Attestation_Id number := null
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if not (r_Testing.Status = Hln_Pref.c_Testing_Status_Executed or
        r_Testing.Status = Hln_Pref.c_Testing_Status_Paused) then
      Hln_Error.Raise_028(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    if i_User_Id <> r_Testing.Person_Id and r_Testing.End_Time is not null and
       r_Testing.End_Time >
       Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id, --
                                 i_Filial_Id  => i_Filial_Id) then
      Hln_Error.Raise_029(i_End_Time       => r_Testing.End_Time,
                          i_Testing_Number => r_Testing.Testing_Number);
    end if;
  
    if Hln_Util.Has_Writing_Question(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Testing_Id => i_Testing_Id) = 'Y' then
      z_Hln_Testings.Update_One(i_Company_Id    => i_Company_Id,
                                i_Filial_Id     => i_Filial_Id,
                                i_Testing_Id    => i_Testing_Id,
                                i_Fact_End_Time => Option_Date(Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                                                         i_Filial_Id  => i_Filial_Id)),
                                i_Pause_Time    => Option_Date(null),
                                i_Status        => Option_Varchar2(Hln_Pref.c_Testing_Status_Checking));
    
      if i_Attestation_Id is not null then
        Hln_Core.Make_Dirty_Attestation(i_Company_Id     => r_Testing.Company_Id,
                                        i_Filial_Id      => r_Testing.Filial_Id,
                                        i_Attestation_Id => i_Attestation_Id);
      end if;
    else
      Testing_Finish(i_Company_Id     => i_Company_Id,
                     i_Filial_Id      => i_Filial_Id,
                     i_Testing_Id     => i_Testing_Id,
                     i_Attestation_Id => i_Attestation_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Testing_Add_Time
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Added_Time     number,
    i_Attestation_Id number := null
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if (r_Testing.Status = Hln_Pref.c_Testing_Status_Executed or
       r_Testing.Status = Hln_Pref.c_Testing_Status_Paused) then
      if r_Testing.End_Time is not null then
        r_Testing.End_Time := r_Testing.End_Time + Nvl(i_Added_Time, 0) / 1440;
      
        z_Hln_Testings.Update_One(i_Company_Id => r_Testing.Company_Id,
                                  i_Filial_Id  => r_Testing.Filial_Id,
                                  i_Testing_Id => r_Testing.Testing_Id,
                                  i_End_Time   => Option_Date(r_Testing.End_Time));
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Testing_Set_Begin_Time
  (
    i_Company_Id              number,
    i_Filial_Id               number,
    i_Testing_Id              number,
    i_Begin_Time_Period_Begin number,
    i_Begin_Time_Period_End   number := null,
    i_Attestation_Id          number := null
  ) is
    v_Is_Period boolean := Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => i_Company_Id,
                                                                       i_Filial_Id  => i_Filial_Id) = 'Y';
    r_Testing   Hln_Testings%rowtype;
    r_Exam      Hln_Exams%rowtype;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_New then
      Hln_Error.Raise_030(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    r_Exam := z_Hln_Exams.Lock_Load(i_Company_Id => r_Testing.Company_Id,
                                    i_Filial_Id  => r_Testing.Filial_Id,
                                    i_Exam_Id    => r_Testing.Exam_Id);
  
    if v_Is_Period then
      r_Testing.Begin_Time_Period_Begin := r_Testing.Testing_Date +
                                           Numtodsinterval(i_Begin_Time_Period_Begin, 'minute');
      r_Testing.Begin_Time_Period_End   := r_Testing.Testing_Date +
                                           Numtodsinterval(i_Begin_Time_Period_End, 'minute');
    else
      r_Testing.Begin_Time_Period_Begin := r_Testing.Testing_Date +
                                           Numtodsinterval(i_Begin_Time_Period_Begin, 'minute');
      r_Testing.End_Time                := r_Testing.Begin_Time_Period_Begin +
                                           Numtodsinterval(r_Exam.Duration, 'minute');
    end if;
  
    z_Hln_Testings.Update_Row(r_Testing);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Testing_Start
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_Attestation_Id number := null
  ) is
    r_Testing      Hln_Testings%rowtype;
    r_Exam         Hln_Exams%rowtype;
    v_Current_Date date;
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    v_Current_Date := Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                i_Filial_Id  => i_Filial_Id);
  
    if Trunc(v_Current_Date) <> r_Testing.Testing_Date then
      Hln_Error.Raise_031(i_Current_Date   => v_Current_Date,
                          i_Testing_Date   => r_Testing.Testing_Date,
                          i_Testing_Number => r_Testing.Testing_Number);
    end if;
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_New then
      Hln_Error.Raise_032(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    r_Exam := z_Hln_Exams.Lock_Load(i_Company_Id => r_Testing.Company_Id,
                                    i_Filial_Id  => r_Testing.Filial_Id,
                                    i_Exam_Id    => r_Testing.Exam_Id);
  
    r_Testing.Begin_Time_Period_Begin := v_Current_Date;
    r_Testing.End_Time                := r_Testing.Begin_Time_Period_Begin +
                                         Numtodsinterval(r_Exam.Duration, 'minute');
  
    z_Hln_Testings.Update_Row(r_Testing);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Testing_Delete
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Testing_Id     number,
    i_User_Id        number,
    i_Attestation_Id number := null
  ) is
    v_Period_Setting_On varchar2(1) := Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => i_Company_Id,
                                                                                   i_Filial_Id  => i_Filial_Id);
    r_Testing           Hln_Testings%rowtype;
    t_Testing           varchar2(50) := Hln_Util.t_Action_Kind(Hln_Pref.c_Action_Kind_Testing);
  begin
    Assert_Testing(i_Company_Id     => i_Company_Id,
                   i_Filial_Id      => i_Filial_Id,
                   i_Attestation_Id => i_Attestation_Id,
                   i_Testing_Id     => i_Testing_Id);
  
    if i_Attestation_Id is not null then
      z_Hln_Attestation_Testings.Delete_One(i_Company_Id     => i_Company_Id,
                                            i_Filial_Id      => i_Filial_Id,
                                            i_Attestation_Id => i_Attestation_Id,
                                            i_Testing_Id     => i_Testing_Id);
    end if;
  
    r_Testing := z_Hln_Testings.Load(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Testing_Id => i_Testing_Id);
  
    z_Hln_Testings.Delete_One(i_Company_Id => i_Company_Id,
                              i_Filial_Id  => i_Filial_Id,
                              i_Testing_Id => i_Testing_Id);
  
    Send_Notification(i_Company_Id => r_Testing.Company_Id,
                      i_Filial_Id  => r_Testing.Filial_Id,
                      i_User_Id    => i_User_Id,
                      i_Person_Id  => r_Testing.Person_Id,
                      i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Testing.Testing_Number,
                                                                            i_Begin_Time    => r_Testing.Begin_Time_Period_Begin,
                                                                            i_End_Time      => r_Testing.Begin_Time_Period_End,
                                                                            i_Is_Period     => v_Period_Setting_On,
                                                                            i_Action_Kind   => t_Testing));
  
    if i_Attestation_Id is null then
      Send_Notification(i_Company_Id => r_Testing.Company_Id,
                        i_Filial_Id  => r_Testing.Filial_Id,
                        i_User_Id    => i_User_Id,
                        i_Person_Id  => r_Testing.Examiner_Id,
                        i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Testing.Testing_Number,
                                                                              i_Begin_Time    => r_Testing.Begin_Time_Period_Begin,
                                                                              i_End_Time      => r_Testing.Begin_Time_Period_End,
                                                                              i_Is_Period     => v_Period_Setting_On,
                                                                              i_Action_Kind   => t_Testing));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_Save
  (
    i_Attestation Hln_Pref.Attestation_Rt,
    i_User_Id     number
  ) is
    v_Testing           Hln_Pref.Testing_Rt;
    v_Testing_Ids       Array_Number := Array_Number();
    v_Dub_Person_Ids    Array_Number;
    v_Person_Names      Array_Varchar2;
    v_Person_Ids        Array_Number := Array_Number();
    v_Exists            boolean;
    v_Period_Setting_On varchar2(1) := Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => i_Attestation.Company_Id,
                                                                                   i_Filial_Id  => i_Attestation.Filial_Id);
    v_Is_Period         boolean := v_Period_Setting_On = 'Y';
    t_Examiner          varchar2(50) := Hln_Util.t_Person_Kind(Hln_Pref.c_Person_Kind_Examiner);
    t_Attestation       varchar2(50) := Hln_Util.t_Action_Kind(Hln_Pref.c_Action_Kind_Attestation);
    r_Attestation       Hln_Attestations%rowtype;
    r_Old_Attestation   Hln_Attestations%rowtype;
    r_Testing           Hln_Testings%rowtype;
  begin
    if z_Hln_Attestations.Exist_Lock(i_Company_Id     => i_Attestation.Company_Id,
                                     i_Filial_Id      => i_Attestation.Filial_Id,
                                     i_Attestation_Id => i_Attestation.Attestation_Id,
                                     o_Row            => r_Attestation) then
      if r_Attestation.Status <> Hln_Pref.c_Attestation_Status_New then
        Hln_Error.Raise_033(i_Attestation_Number => r_Attestation.Attestation_Number,
                            i_Status_Name        => Hln_Util.t_Attestation_Status(r_Attestation.Status));
      end if;
    
      v_Exists          := true;
      r_Old_Attestation := r_Attestation;
    else
      r_Attestation.Company_Id     := i_Attestation.Company_Id;
      r_Attestation.Filial_Id      := i_Attestation.Filial_Id;
      r_Attestation.Attestation_Id := i_Attestation.Attestation_Id;
      r_Attestation.Status         := Hln_Pref.c_Attestation_Status_New;
    
      v_Exists := false;
    end if;
  
    r_Attestation.Attestation_Number      := i_Attestation.Attestation_Number;
    r_Attestation.Name                    := i_Attestation.Name;
    r_Attestation.Attestation_Date        := i_Attestation.Attestation_Date;
    r_Attestation.Begin_Time_Period_Begin := i_Attestation.Begin_Time_Period_Begin;
    r_Attestation.Begin_Time_Period_End   := i_Attestation.Begin_Time_Period_End;
    r_Attestation.Examiner_Id             := i_Attestation.Examiner_Id;
    r_Attestation.Note                    := i_Attestation.Note;
  
    if v_Is_Period and r_Attestation.Begin_Time_Period_Begin > r_Attestation.Begin_Time_Period_End then
      Hln_Error.Raise_056(i_Attestation_Number => r_Attestation.Attestation_Number,
                          i_Period_Begin       => r_Attestation.Begin_Time_Period_Begin,
                          i_Period_End         => r_Attestation.Begin_Time_Period_End);
    end if;
  
    if v_Exists then
      z_Hln_Attestations.Update_Row(r_Attestation);
    
      if r_Old_Attestation.Examiner_Id <> r_Attestation.Examiner_Id then
        Send_Notification(i_Company_Id => r_Attestation.Company_Id,
                          i_Filial_Id  => r_Attestation.Filial_Id,
                          i_User_Id    => i_User_Id,
                          i_Person_Id  => r_Attestation.Examiner_Id,
                          i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Examiner,
                                                                                i_Action_Number => r_Attestation.Attestation_Number,
                                                                                i_Begin_Time    => r_Attestation.Begin_Time_Period_Begin,
                                                                                i_End_Time      => r_Attestation.Begin_Time_Period_End,
                                                                                i_Is_Period     => v_Period_Setting_On,
                                                                                i_Action_Kind   => t_Attestation));
      
        Send_Notification(i_Company_Id => r_Old_Attestation.Company_Id,
                          i_Filial_Id  => r_Old_Attestation.Filial_Id,
                          i_User_Id    => i_User_Id,
                          i_Person_Id  => r_Old_Attestation.Examiner_Id,
                          i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Old_Attestation.Attestation_Number,
                                                                                i_Begin_Time    => r_Old_Attestation.Begin_Time_Period_Begin,
                                                                                i_End_Time      => r_Old_Attestation.Begin_Time_Period_End,
                                                                                i_Is_Period     => v_Period_Setting_On,
                                                                                i_Action_Kind   => t_Attestation));
      else
        if r_Old_Attestation.Begin_Time_Period_Begin <> r_Attestation.Begin_Time_Period_Begin or --
           r_Old_Attestation.Begin_Time_Period_End <> r_Attestation.Begin_Time_Period_End or --
           r_Old_Attestation.Attestation_Number <> r_Attestation.Attestation_Number then
          Send_Notification(i_Company_Id => r_Old_Attestation.Company_Id,
                            i_Filial_Id  => r_Old_Attestation.Filial_Id,
                            i_User_Id    => i_User_Id,
                            i_Person_Id  => r_Old_Attestation.Examiner_Id,
                            i_Title      => Hln_Util.t_Notification_Action_Update(i_Action_Number => r_Attestation.Attestation_Number,
                                                                                  i_Begin_Time    => r_Attestation.Begin_Time_Period_Begin,
                                                                                  i_End_Time      => r_Attestation.Begin_Time_Period_End,
                                                                                  i_Is_Period     => v_Period_Setting_On,
                                                                                  i_Action_Kind   => t_Attestation));
        end if;
      end if;
    else
      if r_Attestation.Attestation_Number is null then
        r_Attestation.Attestation_Number := Md_Core.Gen_Number(i_Company_Id => r_Attestation.Company_Id,
                                                               i_Filial_Id  => r_Attestation.Filial_Id,
                                                               i_Table      => Zt.Hln_Attestations,
                                                               i_Column     => z.Attestation_Number);
      end if;
    
      z_Hln_Attestations.Insert_Row(r_Attestation);
    
      Send_Notification(i_Company_Id => r_Attestation.Company_Id,
                        i_Filial_Id  => r_Attestation.Filial_Id,
                        i_User_Id    => i_User_Id,
                        i_Person_Id  => r_Attestation.Examiner_Id,
                        i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Examiner,
                                                                              i_Action_Number => r_Attestation.Attestation_Number,
                                                                              i_Begin_Time    => r_Attestation.Begin_Time_Period_Begin,
                                                                              i_End_Time      => r_Attestation.Begin_Time_Period_End,
                                                                              i_Is_Period     => v_Period_Setting_On,
                                                                              i_Action_Kind   => t_Attestation));
    end if;
  
    v_Testing_Ids.Extend(i_Attestation.Testings.Count);
    v_Person_Ids.Extend(i_Attestation.Testings.Count);
  
    for i in 1 .. i_Attestation.Testings.Count
    loop
      v_Testing := i_Attestation.Testings(i);
      v_Testing_Ids(i) := v_Testing.Testing_Id;
      v_Person_Ids(i) := v_Testing.Person_Id;
    
      if not z_Hln_Testings.Exist_Lock(i_Company_Id => i_Attestation.Company_Id,
                                       i_Filial_Id  => i_Attestation.Filial_Id,
                                       i_Testing_Id => v_Testing.Testing_Id,
                                       o_Row        => r_Testing) then
        r_Testing            := null;
        r_Testing.Company_Id := i_Attestation.Company_Id;
        r_Testing.Filial_Id  := i_Attestation.Filial_Id;
        r_Testing.Testing_Id := v_Testing.Testing_Id;
      end if;
    
      r_Testing.Exam_Id                 := v_Testing.Exam_Id;
      r_Testing.Person_Id               := v_Testing.Person_Id;
      r_Testing.Examiner_Id             := i_Attestation.Examiner_Id;
      r_Testing.Testing_Date            := i_Attestation.Attestation_Date;
      r_Testing.Begin_Time_Period_Begin := i_Attestation.Begin_Time_Period_Begin;
      r_Testing.Begin_Time_Period_End   := i_Attestation.Begin_Time_Period_End;
      r_Testing.Note                    := i_Attestation.Note;
      r_Testing.Passed                  := Hln_Pref.c_Passed_Indeterminate;
      r_Testing.Status                  := Hln_Pref.c_Testing_Status_New;
    
      Testing_Save(i_Testing        => r_Testing,
                   i_User_Id        => i_User_Id,
                   i_Attestation_Id => i_Attestation.Attestation_Id);
    
      z_Hln_Attestation_Testings.Insert_Try(i_Company_Id     => i_Attestation.Company_Id,
                                            i_Filial_Id      => i_Attestation.Filial_Id,
                                            i_Attestation_Id => i_Attestation.Attestation_Id,
                                            i_Testing_Id     => v_Testing.Testing_Id);
    end loop;
  
    select Column_Value
      bulk collect
      into v_Dub_Person_Ids
      from table(v_Person_Ids)
     group by Column_Value
    having count(*) > 1;
  
    if v_Dub_Person_Ids.Count > 0 then
      select q.Name
        bulk collect
        into v_Person_Names
        from Mr_Natural_Persons q
       where q.Company_Id = r_Attestation.Company_Id
         and q.Person_Id member of v_Dub_Person_Ids;
    
      Hln_Error.Raise_034(i_Attestation_Number => r_Attestation.Attestation_Number,
                          i_Person_Names       => Fazo.Gather(v_Person_Names, ', '));
    end if;
  
    for r in (select *
                from Hln_Attestation_Testings q
               where q.Company_Id = i_Attestation.Company_Id
                 and q.Filial_Id = i_Attestation.Filial_Id
                 and q.Attestation_Id = i_Attestation.Attestation_Id
                 and q.Testing_Id not member of v_Testing_Ids)
    loop
      Testing_Delete(i_Company_Id     => r.Company_Id,
                     i_Filial_Id      => r.Filial_Id,
                     i_Testing_Id     => r.Testing_Id,
                     i_User_Id        => i_User_Id,
                     i_Attestation_Id => r.Attestation_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Attestation_Delete
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Attestation_Id number,
    i_User_Id        number
  ) is
    v_Period_Setting_On varchar2(1) := Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => i_Company_Id,
                                                                                   i_Filial_Id  => i_Filial_Id);
    r_Attestation       Hln_Attestations%rowtype;
  begin
    r_Attestation := z_Hln_Attestations.Lock_Load(i_Company_Id     => i_Company_Id,
                                                  i_Filial_Id      => i_Filial_Id,
                                                  i_Attestation_Id => i_Attestation_Id);
  
    if r_Attestation.Status <> Hln_Pref.c_Attestation_Status_New then
      Hln_Error.Raise_035(i_Attestation_Number => r_Attestation.Attestation_Number,
                          i_Status_Name        => Hln_Util.t_Attestation_Status(r_Attestation.Status));
    end if;
  
    for r in (select *
                from Hln_Attestation_Testings q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Attestation_Id = i_Attestation_Id)
    loop
      Testing_Delete(i_Company_Id     => r.Company_Id,
                     i_Filial_Id      => r.Filial_Id,
                     i_Testing_Id     => r.Testing_Id,
                     i_User_Id        => i_User_Id,
                     i_Attestation_Id => r.Attestation_Id);
    end loop;
  
    z_Hln_Attestations.Delete_One(i_Company_Id     => i_Company_Id,
                                  i_Filial_Id      => i_Filial_Id,
                                  i_Attestation_Id => i_Attestation_Id);
  
    Send_Notification(i_Company_Id => r_Attestation.Company_Id,
                      i_Filial_Id  => r_Attestation.Filial_Id,
                      i_User_Id    => i_User_Id,
                      i_Person_Id  => r_Attestation.Examiner_Id,
                      i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Attestation.Attestation_Number,
                                                                            i_Begin_Time    => r_Attestation.Begin_Time_Period_Begin,
                                                                            i_End_Time      => r_Attestation.Begin_Time_Period_End,
                                                                            i_Is_Period     => v_Period_Setting_On,
                                                                            i_Action_Kind   => Hln_Util.t_Action_Kind(Hln_Pref.c_Action_Kind_Attestation)));
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Send_Answer
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Testing_Id          number,
    i_Person_Id           number,
    i_Question_Id         number,
    i_Current_Question_No number,
    i_Question_Option_Ids Array_Number,
    i_Writing_Answer      varchar2
  ) is
    r_Testing  Hln_Testings%rowtype;
    r_Question Hln_Questions%rowtype;
  begin
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_Executed then
      Hln_Error.Raise_036(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    Hln_Util.Assert_Access_Person(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Testing_Id => i_Testing_Id,
                                  i_Person_Id  => i_Person_Id);
  
    r_Question := z_Hln_Questions.Load(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Question_Id => i_Question_Id);
  
    if r_Question.Answer_Type = Hln_Pref.c_Answer_Type_Single and i_Question_Option_Ids.Count > 1 then
      Hln_Error.Raise_037(i_Testing_Number => r_Testing.Testing_Number,
                          i_Question_Id    => r_Question.Question_Id);
    elsif r_Question.Answer_Type = Hln_Pref.c_Answer_Type_Writing and
          i_Question_Option_Ids.Count > 0 then
      Hln_Error.Raise_038(i_Testing_Number => r_Testing.Testing_Number,
                          i_Question_Id    => r_Question.Question_Id);
    elsif r_Question.Answer_Type <> Hln_Pref.c_Answer_Type_Writing and i_Writing_Answer is not null then
      Hln_Error.Raise_039(i_Testing_Number => r_Testing.Testing_Number,
                          i_Question_Id    => r_Question.Question_Id);
    end if;
  
    -- save chosen answers
    if r_Question.Answer_Type != Hln_Pref.c_Answer_Type_Writing then
      update Hln_Testing_Question_Options q
         set q.Chosen = 'N'
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Testing_Id = i_Testing_Id
         and q.Question_Id = i_Question_Id
         and q.Question_Option_Id not member of i_Question_Option_Ids;
    
      for i in 1 .. i_Question_Option_Ids.Count
      loop
        z_Hln_Testing_Question_Options.Update_One(i_Company_Id         => i_Company_Id,
                                                  i_Filial_Id          => i_Filial_Id,
                                                  i_Testing_Id         => i_Testing_Id,
                                                  i_Question_Id        => i_Question_Id,
                                                  i_Question_Option_Id => i_Question_Option_Ids(i),
                                                  i_Chosen             => Option_Varchar2('Y'));
      end loop;
    else
      z_Hln_Testing_Questions.Update_One(i_Company_Id     => i_Company_Id,
                                         i_Filial_Id      => i_Filial_Id,
                                         i_Testing_Id     => i_Testing_Id,
                                         i_Question_Id    => i_Question_Id,
                                         i_Writing_Answer => Option_Varchar2(i_Writing_Answer));
    end if;
  
    --update current question number
    z_Hln_Testings.Update_One(i_Company_Id          => i_Company_Id,
                              i_Filial_Id           => i_Filial_Id,
                              i_Testing_Id          => i_Testing_Id,
                              i_Current_Question_No => Option_Number(i_Current_Question_No));
  
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Check_Answer
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Testing_Id  number,
    i_Question_Id number,
    i_Correct     varchar2
  ) is
    r_Testing Hln_Testings%rowtype;
  begin
    r_Testing := z_Hln_Testings.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Testing_Id => i_Testing_Id);
  
    if r_Testing.Status <> Hln_Pref.c_Testing_Status_Checking then
      Hln_Error.Raise_040(i_Testing_Number => r_Testing.Testing_Number,
                          i_Status_Name    => Hln_Util.t_Testing_Status(r_Testing.Status));
    end if;
  
    z_Hln_Testing_Questions.Update_One(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Testing_Id  => i_Testing_Id,
                                       i_Question_Id => i_Question_Id,
                                       i_Correct     => Option_Varchar2(i_Correct));
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure Mark_Question
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Testing_Id  number,
    i_Question_Id number,
    i_Person_Id   number
  ) is
    r_Testing_Question Hln_Testing_Questions%rowtype;
  begin
    Hln_Util.Assert_Access_Person(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Testing_Id => i_Testing_Id,
                                  i_Person_Id  => i_Person_Id);
  
    r_Testing_Question := z_Hln_Testing_Questions.Lock_Load(i_Company_Id  => i_Company_Id,
                                                            i_Filial_Id   => i_Filial_Id,
                                                            i_Testing_Id  => i_Testing_Id,
                                                            i_Question_Id => i_Question_Id);
  
    z_Hln_Testing_Questions.Update_One(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Testing_Id  => i_Testing_Id,
                                       i_Question_Id => i_Question_Id,
                                       i_Marked      => Option_Varchar2(Md_Util.Decode(r_Testing_Question.Marked,
                                                                                       'Y',
                                                                                       'N',
                                                                                       'N',
                                                                                       'Y',
                                                                                       'Y')));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Training_Subject_Group_Save(i_Subject_Group Hln_Pref.Training_Subject_Group_Rt) is
  begin
    z_Hln_Training_Subject_Groups.Save_One(i_Company_Id       => i_Subject_Group.Company_Id,
                                           i_Filial_Id        => i_Subject_Group.Filial_Id,
                                           i_Subject_Group_Id => i_Subject_Group.Subject_Group_Id,
                                           i_Name             => i_Subject_Group.Name,
                                           i_Code             => i_Subject_Group.Code,
                                           i_State            => i_Subject_Group.State);
  
    for i in 1 .. i_Subject_Group.Subject_Ids.Count
    loop
      z_Hln_Training_Subject_Group_Subjects.Insert_Try(i_Company_Id       => i_Subject_Group.Company_Id,
                                                       i_Filial_Id        => i_Subject_Group.Filial_Id,
                                                       i_Subject_Group_Id => i_Subject_Group.Subject_Group_Id,
                                                       i_Subject_Id       => i_Subject_Group.Subject_Ids(i));
    end loop;
  
    delete Hln_Training_Subject_Group_Subjects q
     where q.Company_Id = i_Subject_Group.Company_Id
       and q.Filial_Id = i_Subject_Group.Filial_Id
       and q.Subject_Group_Id = i_Subject_Group.Subject_Group_Id
       and q.Subject_Id not member of i_Subject_Group.Subject_Ids;
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Trainig_Subject_Group_Delete
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Subject_Group_Id number
  ) is
  begin
    z_Hln_Training_Subject_Groups.Delete_One(i_Company_Id       => i_Company_Id,
                                             i_Filial_Id        => i_Filial_Id,
                                             i_Subject_Group_Id => i_Subject_Group_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Training_Subject_Save(i_Training_Subject Hln_Training_Subjects%rowtype) is
  begin
    z_Hln_Training_Subjects.Save_Row(i_Training_Subject);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Training_Subject_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Subject_Id number
  ) is
  begin
    z_Hln_Training_Subjects.Delete_One(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Subject_Id => i_Subject_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Training_Save
  (
    i_Training Hln_Pref.Training_Rt,
    i_User_Id  number
  ) is
    v_Exists                boolean;
    t_Participant           varchar2(50) := Hln_Util.t_Person_Kind(Hln_Pref.c_Person_Kind_Participant);
    t_Mentor                varchar2(50) := Hln_Util.t_Person_Kind(Hln_Pref.c_Person_Kind_Mentor);
    t_Training              varchar2(50) := Hln_Util.t_Action_Kind(Hln_Pref.c_Action_Kind_Training);
    v_Subject_Ids           Array_Number := i_Training.Subject_Ids;
    r_Training              Hln_Trainings%rowtype;
    r_Old_Training          Hln_Trainings%rowtype;
    v_Old_Person_Ids        Array_Number;
    v_Updatable_Person_Ids  Array_Number := Array_Number();
    v_Attachable_Person_Ids Array_Number := Array_Number();
    v_Detachable_Person_Id  Array_Number := Array_Number();
  begin
    if z_Hln_Trainings.Exist_Lock(i_Company_Id  => i_Training.Company_Id,
                                  i_Filial_Id   => i_Training.Filial_Id,
                                  i_Training_Id => i_Training.Training_Id,
                                  o_Row         => r_Training) then
      if r_Training.Status <> Hln_Pref.c_Training_Status_New then
        Hln_Error.Raise_041(i_Training_Number => r_Training.Training_Number,
                            i_Status_Name     => Hln_Util.t_Training_Status(r_Training.Status));
      end if;
    
      v_Exists       := true;
      r_Old_Training := r_Training;
    else
      r_Training.Company_Id  := i_Training.Company_Id;
      r_Training.Filial_Id   := i_Training.Filial_Id;
      r_Training.Training_Id := i_Training.Training_Id;
      r_Training.Status      := Hln_Pref.c_Training_Status_New;
    
      v_Exists := false;
    end if;
  
    r_Training.Training_Number  := i_Training.Training_Number;
    r_Training.Begin_Date       := i_Training.Begin_Date;
    r_Training.Mentor_Id        := i_Training.Mentor_Id;
    r_Training.Address          := i_Training.Address;
    r_Training.Subject_Group_Id := i_Training.Subject_Group_Id;
  
    if v_Exists then
      z_Hln_Trainings.Update_Row(r_Training);
    
      if r_Old_Training.Mentor_Id <> r_Training.Mentor_Id then
        Send_Notification(i_Company_Id => r_Training.Company_Id,
                          i_Filial_Id  => r_Training.Filial_Id,
                          i_User_Id    => i_User_Id,
                          i_Person_Id  => r_Training.Mentor_Id,
                          i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Mentor,
                                                                                i_Action_Number => r_Training.Training_Number,
                                                                                i_Begin_Time    => r_Training.Begin_Date,
                                                                                i_Action_Kind   => t_Training));
      
        Send_Notification(i_Company_Id => r_Old_Training.Company_Id,
                          i_Filial_Id  => r_Old_Training.Filial_Id,
                          i_User_Id    => i_User_Id,
                          i_Person_Id  => r_Old_Training.Mentor_Id,
                          i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Old_Training.Training_Number,
                                                                                i_Begin_Time    => r_Old_Training.Begin_Date,
                                                                                i_Action_Kind   => t_Training));
      else
        if r_Old_Training.Training_Number <> r_Training.Training_Number or --
           r_Old_Training.Begin_Date <> r_Training.Begin_Date then
          Send_Notification(i_Company_Id => r_Training.Company_Id,
                            i_Filial_Id  => r_Training.Filial_Id,
                            i_User_Id    => i_User_Id,
                            i_Person_Id  => r_Training.Mentor_Id,
                            i_Title      => Hln_Util.t_Notification_Action_Update(i_Action_Number => r_Training.Training_Number,
                                                                                  i_Begin_Time    => r_Training.Begin_Date,
                                                                                  i_Action_Kind   => t_Training));
        end if;
      end if;
    
      select q.Person_Id
        bulk collect
        into v_Old_Person_Ids
        from Hln_Training_Persons q
       where q.Company_Id = r_Training.Company_Id
         and q.Filial_Id = r_Training.Filial_Id
         and q.Training_Id = r_Training.Training_Id;
    
      v_Updatable_Person_Ids  := (v_Old_Person_Ids multiset intersect i_Training.Persons) multiset
                                 Except Array_Number(i_User_Id);
      v_Detachable_Person_Id  := (v_Old_Person_Ids multiset Except i_Training.Persons) multiset
                                 Except Array_Number(i_User_Id);
      v_Attachable_Person_Ids := (i_Training.Persons multiset Except v_Old_Person_Ids) multiset
                                 Except Array_Number(i_User_Id);
    
      Send_Notification(i_Company_Id => r_Training.Company_Id,
                        i_Filial_Id  => r_Training.Filial_Id,
                        i_Person_Ids => v_Attachable_Person_Ids,
                        i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Participant,
                                                                              i_Action_Number => r_Training.Training_Number,
                                                                              i_Begin_Time    => r_Training.Begin_Date,
                                                                              i_Action_Kind   => t_Training));
    
      Send_Notification(i_Company_Id => r_Old_Training.Company_Id,
                        i_Filial_Id  => r_Old_Training.Filial_Id,
                        i_Person_Ids => v_Detachable_Person_Id,
                        i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Old_Training.Training_Number,
                                                                              i_Begin_Time    => r_Old_Training.Begin_Date,
                                                                              i_Action_Kind   => t_Training));
    
      if r_Old_Training.Training_Number <> r_Training.Training_Number or --
         r_Old_Training.Begin_Date <> r_Training.Begin_Date then
        Send_Notification(i_Company_Id => r_Training.Company_Id,
                          i_Filial_Id  => r_Training.Filial_Id,
                          i_Person_Ids => v_Updatable_Person_Ids,
                          i_Title      => Hln_Util.t_Notification_Action_Update(i_Action_Number => r_Training.Training_Number,
                                                                                i_Begin_Time    => r_Training.Begin_Date,
                                                                                i_Action_Kind   => t_Training));
      end if;
    else
      if r_Training.Training_Number is null then
        r_Training.Training_Number := Md_Core.Gen_Number(i_Company_Id => r_Training.Company_Id,
                                                         i_Filial_Id  => r_Training.Filial_Id,
                                                         i_Table      => Zt.Hln_Trainings,
                                                         i_Column     => z.Training_Number);
      end if;
    
      z_Hln_Trainings.Insert_Row(r_Training);
    
      Send_Notification(i_Company_Id => r_Training.Company_Id,
                        i_Filial_Id  => r_Training.Filial_Id,
                        i_User_Id    => i_User_Id,
                        i_Person_Id  => r_Training.Mentor_Id,
                        i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Mentor,
                                                                              i_Action_Number => r_Training.Training_Number,
                                                                              i_Begin_Time    => r_Training.Begin_Date,
                                                                              i_Action_Kind   => t_Training));
    
      Send_Notification(i_Company_Id => r_Training.Company_Id,
                        i_Filial_Id  => r_Training.Filial_Id,
                        i_Person_Ids => i_Training.Persons,
                        i_Title      => Hln_Util.t_Notification_Action_Attach(i_Person_Type   => t_Participant,
                                                                              i_Action_Number => r_Training.Training_Number,
                                                                              i_Begin_Time    => r_Training.Begin_Date,
                                                                              i_Action_Kind   => t_Training));
    end if;
  
    if i_Training.Subject_Group_Id is not null then
      select q.Subject_Id
        bulk collect
        into v_Subject_Ids
        from Hln_Training_Subject_Group_Subjects q
       where q.Company_Id = i_Training.Company_Id
         and q.Filial_Id = i_Training.Filial_Id
         and q.Subject_Group_Id = i_Training.Subject_Group_Id;
    
      if v_Subject_Ids.Count = 0 then
        Hln_Error.Raise_062(z_Hln_Training_Subject_Groups.Load(i_Company_Id => i_Training.Company_Id, --
                            i_Filial_Id => i_Training.Filial_Id, -- 
                            i_Subject_Group_Id => i_Training.Subject_Group_Id).Name);
      end if;
    end if;
  
    if v_Subject_Ids.Count = 0 then
      Hln_Error.Raise_052;
    end if;
  
    for i in 1 .. v_Subject_Ids.Count
    loop
      z_Hln_Training_Current_Subjects.Insert_Try(i_Company_Id  => i_Training.Company_Id,
                                                 i_Filial_Id   => i_Training.Filial_Id,
                                                 i_Training_Id => i_Training.Training_Id,
                                                 i_Subject_Id  => v_Subject_Ids(i));
    end loop;
  
    delete from Hln_Training_Current_Subjects q
     where q.Company_Id = i_Training.Company_Id
       and q.Filial_Id = i_Training.Filial_Id
       and q.Training_Id = i_Training.Training_Id
       and q.Subject_Id not member of v_Subject_Ids;
  
    for i in 1 .. i_Training.Persons.Count
    loop
      z_Hln_Training_Persons.Insert_Try(i_Company_Id  => i_Training.Company_Id,
                                        i_Filial_Id   => i_Training.Filial_Id,
                                        i_Training_Id => i_Training.Training_Id,
                                        i_Person_Id   => i_Training.Persons(i),
                                        i_Passed      => Hln_Pref.c_Passed_Indeterminate);
    
      for j in 1 .. v_Subject_Ids.Count
      loop
        z_Hln_Training_Person_Subjects.Insert_Try(i_Company_Id  => i_Training.Company_Id,
                                                  i_Filial_Id   => i_Training.Filial_Id,
                                                  i_Training_Id => i_Training.Training_Id,
                                                  i_Person_Id   => i_Training.Persons(i),
                                                  i_Subject_Id  => v_Subject_Ids(j),
                                                  i_Passed      => Hln_Pref.c_Passed_Indeterminate);
      end loop;
    end loop;
  
    for r in (select *
                from Hln_Training_Persons q
               where q.Company_Id = i_Training.Company_Id
                 and q.Filial_Id = i_Training.Filial_Id
                 and q.Training_Id = i_Training.Training_Id
                 and q.Person_Id not member of i_Training.Persons)
    loop
      z_Hln_Training_Persons.Delete_One(i_Company_Id  => r.Company_Id,
                                        i_Filial_Id   => r.Filial_Id,
                                        i_Training_Id => r.Training_Id,
                                        i_Person_Id   => r.Person_Id);
    end loop;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Training_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number,
    i_User_Id     number
  ) is
    v_Person_Ids Array_Number;
    r_Training   Hln_Trainings%rowtype;
  begin
    r_Training := z_Hln_Trainings.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Training_Id => i_Training_Id);
  
    if r_Training.Status <> Hln_Pref.c_Training_Status_New then
      Hln_Error.Raise_042(i_Training_Number => r_Training.Training_Number,
                          i_Status_Name     => Hln_Util.t_Training_Status(r_Training.Status));
    end if;
  
    select q.Person_Id
      bulk collect
      into v_Person_Ids
      from Hln_Training_Persons q
     where q.Company_Id = r_Training.Company_Id
       and q.Filial_Id = r_Training.Filial_Id
       and q.Training_Id = r_Training.Training_Id
       and q.Person_Id <> i_User_Id;
  
    if r_Training.Mentor_Id <> i_User_Id then
      Fazo.Push(v_Person_Ids, r_Training.Mentor_Id);
    end if;
  
    z_Hln_Trainings.Delete_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Training_Id => i_Training_Id);
  
    Send_Notification(i_Company_Id => r_Training.Company_Id,
                      i_Filial_Id  => r_Training.Filial_Id,
                      i_Person_Ids => v_Person_Ids,
                      i_Title      => Hln_Util.t_Notification_Action_Detach(i_Action_Number => r_Training.Training_Number,
                                                                            i_Begin_Time    => r_Training.Begin_Date,
                                                                            i_Action_Kind   => Hln_Util.t_Action_Kind(Hln_Pref.c_Action_Kind_Training)));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assess_Person
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number,
    i_Person_Id   number,
    i_Passed      varchar2
  ) is
    r_Training Hln_Trainings%rowtype;
  begin
    r_Training := z_Hln_Trainings.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Training_Id => i_Training_Id);
  
    if r_Training.Status <> Hln_Pref.c_Training_Status_Executed then
      Hln_Error.Raise_043(i_Training_Number => r_Training.Training_Number,
                          i_Status_Name     => Hln_Util.t_Training_Status(r_Training.Status));
    end if;
  
    z_Hln_Training_Persons.Update_One(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Training_Id => i_Training_Id,
                                      i_Person_Id   => i_Person_Id,
                                      i_Passed      => Option_Varchar2(i_Passed));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assess_Person_Subject
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number,
    i_Person_Id   number,
    i_Subject_Id  number,
    i_Passed      varchar2
  ) is
  begin
    z_Hln_Training_Person_Subjects.Update_One(i_Company_Id  => i_Company_Id,
                                              i_Filial_Id   => i_Filial_Id,
                                              i_Training_Id => i_Training_Id,
                                              i_Person_Id   => i_Person_Id,
                                              i_Subject_Id  => i_Subject_Id,
                                              i_Passed      => Option_Varchar2(i_Passed));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Training_Set_New
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number
  ) is
    r_Training Hln_Trainings%rowtype;
  begin
    r_Training := z_Hln_Trainings.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Training_Id => i_Training_Id);
  
    if r_Training.Status <> Hln_Pref.c_Training_Status_Executed then
      Hln_Error.Raise_044(i_Training_Number => r_Training.Training_Number,
                          i_Status_Name     => Hln_Util.t_Training_Status(r_Training.Status));
    end if;
  
    update Hln_Training_Persons q
       set q.Passed = Hln_Pref.c_Passed_Indeterminate
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Training_Id = i_Training_Id;
  
    z_Hln_Trainings.Update_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Training_Id => i_Training_Id,
                               i_Status      => Option_Varchar2(Hln_Pref.c_Training_Status_New));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Training_Execute
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number
  ) is
    r_Training Hln_Trainings%rowtype;
  begin
    r_Training := z_Hln_Trainings.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Training_Id => i_Training_Id);
  
    if r_Training.Status = Hln_Pref.c_Training_Status_Executed then
      Hln_Error.Raise_045(i_Training_Number => r_Training.Training_Number,
                          i_Status_Name     => Hln_Util.t_Training_Status(r_Training.Status));
    end if;
  
    z_Hln_Trainings.Update_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Training_Id => i_Training_Id,
                               i_Status      => Option_Varchar2(Hln_Pref.c_Training_Status_Executed));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Training_Finish
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Training_Id number
  ) is
    r_Training Hln_Trainings%rowtype;
    v_Dummy    varchar2(1);
  begin
    r_Training := z_Hln_Trainings.Lock_Load(i_Company_Id  => i_Company_Id,
                                            i_Filial_Id   => i_Filial_Id,
                                            i_Training_Id => i_Training_Id);
  
    begin
      select 'x'
        into v_Dummy
        from Hln_Training_Persons q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Training_Id = i_Training_Id
         and q.Passed = Hln_Pref.c_Passed_Indeterminate
         and Rownum = 1;
      Hln_Error.Raise_046(r_Training.Training_Number);
    exception
      when No_Data_Found then
        null;
    end;
  
    if r_Training.Status <> Hln_Pref.c_Training_Status_Executed then
      Hln_Error.Raise_047(i_Training_Number => r_Training.Training_Number,
                          i_Status_Name     => Hln_Util.t_Training_Status(r_Training.Status));
    end if;
  
    z_Hln_Trainings.Update_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Training_Id => i_Training_Id,
                               i_Status      => Option_Varchar2(Hln_Pref.c_Training_Status_Finished));
  end;

end Hln_Api;
/
