create or replace package Htm_Api is
  ----------------------------------------------------------------------------------------------------
  -- Experience
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Save(i_Experience Htm_Pref.Experience_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Delete
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Add_Job
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number,
    i_Job_Id        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Remove_Job
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number,
    i_Job_Id        number
  );
  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Save(i_Document Htm_Pref.Recommended_Rank_Document_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Update_Trainings
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number,
    i_Staffs      Htm_Pref.Recommended_Rank_Training_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Update_Status
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number,
    i_Staffs      Htm_Pref.Recommended_Rank_Status_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_New
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Set_Training
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Training
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Waiting
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  );
end Htm_Api;
/
create or replace package body Htm_Api is
  ----------------------------------------------------------------------------------------------------
  -- Experience
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Save(i_Experience Htm_Pref.Experience_Rt) is
    v_From_Rank_Ids Array_Number := Array_Number();
    v_Attempt_Nos   Array_Number;
    v_Period        Htm_Pref.Experience_Period_Rt;
    v_Attempt       Htm_Pref.Experience_Period_Attempt_Rt;
    v_Attempt_No    number;
    r_Experience    Htm_Experiences%rowtype;
  
    --------------------------------------------------
    Function Rank_Name
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Rank_Id    number
    ) return varchar2 is
    begin
      return z_Mhr_Ranks.Take(i_Company_Id => i_Company_Id, --
                              i_Filial_Id  => i_Filial_Id,
                              i_Rank_Id    => i_Rank_Id).Name;
    end;
  
  begin
    z_Htm_Experiences.Init(p_Row           => r_Experience,
                           i_Company_Id    => i_Experience.Company_Id,
                           i_Filial_Id     => i_Experience.Filial_Id,
                           i_Experience_Id => i_Experience.Experience_Id,
                           i_Name          => i_Experience.Name,
                           i_Order_No      => i_Experience.Order_No,
                           i_State         => i_Experience.State,
                           i_Code          => i_Experience.Code);
  
    z_Htm_Experiences.Save_Row(r_Experience);
  
    for i in 1 .. i_Experience.Periods.Count
    loop
      v_Period := i_Experience.Periods(i);
    
      continue when v_Period.Attempts is null or v_Period.Attempts.Count = 0;
    
      Fazo.Push(v_From_Rank_Ids, v_Period.From_Rank_Id);
    
      z_Htm_Experience_Periods.Save_One(i_Company_Id    => i_Experience.Company_Id,
                                        i_Filial_Id     => i_Experience.Filial_Id,
                                        i_Experience_Id => i_Experience.Experience_Id,
                                        i_From_Rank_Id  => v_Period.From_Rank_Id,
                                        i_To_Rank_Id    => v_Period.To_Rank_Id,
                                        i_Order_No      => v_Period.Order_No);
    
      v_Attempt_Nos := Array_Number();
    
      for j in 1 .. v_Period.Attempts.Count
      loop
        v_Attempt_No := j;
        v_Attempt    := v_Period.Attempts(j);
      
        Fazo.Push(v_Attempt_Nos, v_Attempt_No);
      
        if v_Attempt.Period < v_Attempt.Nearest then
          Htm_Error.Raise_001(i_From_Rank_Name => Rank_Name(i_Company_Id => i_Experience.Company_Id,
                                                            i_Filial_Id  => i_Experience.Filial_Id,
                                                            i_Rank_Id    => v_Period.From_Rank_Id),
                              i_Attempt_No     => v_Attempt_No);
        end if;
      
        if v_Attempt.Success_Score < v_Attempt.Ignore_Score then
          Htm_Error.Raise_008(i_Ignore_Score   => v_Attempt.Ignore_Score,
                              i_Success_Score  => v_Attempt.Success_Score,
                              i_From_Rank_Name => Rank_Name(i_Company_Id => i_Experience.Company_Id,
                                                            i_Filial_Id  => i_Experience.Filial_Id,
                                                            i_Rank_Id    => v_Period.From_Rank_Id),
                              i_Attempt_No     => v_Attempt_No);
        end if;
      
        if v_Attempt.Ignore_Score >= 100 then
          Htm_Error.Raise_009(i_Ignore_Score   => v_Attempt.Ignore_Score,
                              i_From_Rank_Name => Rank_Name(i_Company_Id => i_Experience.Company_Id,
                                                            i_Filial_Id  => i_Experience.Filial_Id,
                                                            i_Rank_Id    => v_Period.From_Rank_Id),
                              i_Attempt_No     => v_Attempt_No);
        end if;
      
        if v_Attempt.Success_Score > 100 then
          Htm_Error.Raise_010(i_Success_Score  => v_Attempt.Success_Score,
                              i_From_Rank_Name => Rank_Name(i_Company_Id => i_Experience.Company_Id,
                                                            i_Filial_Id  => i_Experience.Filial_Id,
                                                            i_Rank_Id    => v_Period.From_Rank_Id),
                              i_Attempt_No     => v_Attempt_No);
        end if;
      
        if Nvl(v_Attempt.Period, 0) <= 0 then
          Htm_Error.Raise_011(i_From_Rank_Name => Rank_Name(i_Company_Id => i_Experience.Company_Id,
                                                            i_Filial_Id  => i_Experience.Filial_Id,
                                                            i_Rank_Id    => v_Period.From_Rank_Id),
                              i_Attempt_No     => v_Attempt_No);
        end if;
      
        if Nvl(v_Attempt.Nearest, 0) <= 0 then
          Htm_Error.Raise_012(i_From_Rank_Name => Rank_Name(i_Company_Id => i_Experience.Company_Id,
                                                            i_Filial_Id  => i_Experience.Filial_Id,
                                                            i_Rank_Id    => v_Period.From_Rank_Id),
                              i_Attempt_No     => v_Attempt_No);
        end if;
      
        if v_Attempt.Penalty_Period <= 0 then
          v_Attempt.Penalty_Period := null;
        end if;
      
        z_Htm_Experience_Period_Attempts.Save_One(i_Company_Id        => i_Experience.Company_Id,
                                                  i_Filial_Id         => i_Experience.Filial_Id,
                                                  i_Experience_Id     => i_Experience.Experience_Id,
                                                  i_From_Rank_Id      => v_Period.From_Rank_Id,
                                                  i_Attempt_No        => v_Attempt_No,
                                                  i_Period            => v_Attempt.Period,
                                                  i_Nearest           => v_Attempt.Nearest,
                                                  i_Penalty_Period    => v_Attempt.Penalty_Period,
                                                  i_Exam_Id           => v_Attempt.Exam_Id,
                                                  i_Success_Score     => v_Attempt.Success_Score,
                                                  i_Ignore_Score      => v_Attempt.Ignore_Score,
                                                  i_Recommend_Failure => v_Attempt.Recommend_Failure);
      
        for k in 1 .. v_Attempt.Indicators.Count
        loop
          z_Htm_Experience_Period_Indicators.Insert_Try(i_Company_Id    => i_Experience.Company_Id,
                                                        i_Filial_Id     => i_Experience.Filial_Id,
                                                        i_Experience_Id => i_Experience.Experience_Id,
                                                        i_From_Rank_Id  => v_Period.From_Rank_Id,
                                                        i_Attempt_No    => v_Attempt_No,
                                                        i_Indicator_Id  => v_Attempt.Indicators(k));
        end loop;
      
        for k in 1 .. v_Attempt.Subjects.Count
        loop
          z_Htm_Experience_Training_Subjects.Insert_Try(i_Company_Id    => i_Experience.Company_Id,
                                                        i_Filial_Id     => i_Experience.Filial_Id,
                                                        i_Experience_Id => i_Experience.Experience_Id,
                                                        i_From_Rank_Id  => v_Period.From_Rank_Id,
                                                        i_Attempt_No    => v_Attempt_No,
                                                        i_Subject_Id    => v_Attempt.Subjects(k));
        end loop;
      
        delete Htm_Experience_Period_Indicators q
         where q.Company_Id = i_Experience.Company_Id
           and q.Filial_Id = i_Experience.Filial_Id
           and q.Experience_Id = i_Experience.Experience_Id
           and q.From_Rank_Id = v_Period.From_Rank_Id
           and q.Attempt_No = v_Attempt_No
           and q.Indicator_Id not member of v_Attempt.Indicators;
      
        delete Htm_Experience_Training_Subjects q
         where q.Company_Id = i_Experience.Company_Id
           and q.Filial_Id = i_Experience.Filial_Id
           and q.Experience_Id = i_Experience.Experience_Id
           and q.From_Rank_Id = v_Period.From_Rank_Id
           and q.Attempt_No = v_Attempt_No
           and q.Subject_Id not member of v_Attempt.Subjects;
      end loop;
    
      for r in (select *
                  from Htm_Experience_Period_Attempts q
                 where q.Company_Id = i_Experience.Company_Id
                   and q.Filial_Id = i_Experience.Filial_Id
                   and q.Experience_Id = i_Experience.Experience_Id
                   and q.From_Rank_Id = v_Period.From_Rank_Id
                   and q.Attempt_No not member of v_Attempt_Nos)
      loop
        z_Htm_Experience_Period_Attempts.Delete_One(i_Company_Id    => r.Company_Id,
                                                    i_Filial_Id     => r.Filial_Id,
                                                    i_Experience_Id => r.Experience_Id,
                                                    i_From_Rank_Id  => r.From_Rank_Id,
                                                    i_Attempt_No    => r.Attempt_No);
      end loop;
    end loop;
  
    for r in (select q.*
                from Htm_Experience_Periods q
               where q.Company_Id = i_Experience.Company_Id
                 and q.Filial_Id = i_Experience.Filial_Id
                 and q.Experience_Id = i_Experience.Experience_Id
                 and q.From_Rank_Id not member of v_From_Rank_Ids)
    loop
      z_Htm_Experience_Periods.Delete_One(i_Company_Id    => r.Company_Id,
                                          i_Filial_Id     => r.Filial_Id,
                                          i_Experience_Id => r.Experience_Id,
                                          i_From_Rank_Id  => r.From_Rank_Id);
    end loop;
  
    Htm_Core.Fix_Experience_Job_Rank(i_Company_Id    => i_Experience.Company_Id,
                                     i_Filial_Id     => i_Experience.Filial_Id,
                                     i_Experience_Id => i_Experience.Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Delete
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number
  ) is
  begin
    z_Htm_Experiences.Delete_One(i_Company_Id    => i_Company_Id,
                                 i_Filial_Id     => i_Filial_Id,
                                 i_Experience_Id => i_Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Add_Job
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number,
    i_Job_Id        number
  ) is
    v_Row Htm_Experience_Jobs%rowtype;
  begin
    select *
      into v_Row
      from Htm_Experience_Jobs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Job_Id = i_Job_Id;
  
    Htm_Error.Raise_002(i_Job_Name        => z_Mhr_Jobs.Load(i_Company_Id => v_Row.Company_Id, i_Filial_Id => v_Row.Filial_Id, i_Job_Id => v_Row.Job_Id).Name,
                        i_Experience_Name => z_Htm_Experiences.Load(i_Company_Id => v_Row.Company_Id, i_Filial_Id => v_Row.Filial_Id, i_Experience_Id => v_Row.Experience_Id).Name);
  exception
    when No_Data_Found then
      z_Htm_Experience_Jobs.Insert_One(i_Company_Id    => i_Company_Id,
                                       i_Filial_Id     => i_Filial_Id,
                                       i_Experience_Id => i_Experience_Id,
                                       i_Job_Id        => i_Job_Id);
    
      Htm_Core.Fix_Experience_Job_Rank(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Job_Id     => i_Job_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Remove_Job
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Experience_Id number,
    i_Job_Id        number
  ) is
  begin
    z_Htm_Experience_Jobs.Delete_One(i_Company_Id    => i_Company_Id,
                                     i_Filial_Id     => i_Filial_Id,
                                     i_Experience_Id => i_Experience_Id,
                                     i_Job_Id        => i_Job_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  -- Recommended Rank Document
  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Save(i_Document Htm_Pref.Recommended_Rank_Document_Rt) is
    r_Document  Htm_Recommended_Rank_Documents%rowtype;
    r_Attempt   Htm_Experience_Period_Attempts%rowtype;
    r_Old_Staff Htm_Recommended_Rank_Staffs%rowtype;
    v_Staff     Htm_Pref.Recommended_Rank_Staff_Rt;
    v_Staff_Ids Array_Number := Array_Number();
    v_Exists    boolean;
  
    v_Indicator_Ids Array_Number;
    v_Subject_Ids   Array_Number;
  begin
    if z_Htm_Recommended_Rank_Documents.Exist_Lock(i_Company_Id  => i_Document.Company_Id,
                                                   i_Filial_Id   => i_Document.Filial_Id,
                                                   i_Document_Id => i_Document.Document_Id,
                                                   o_Row         => r_Document) then
      if r_Document.Status <> Htm_Pref.c_Document_Status_New then
        Htm_Error.Raise_003(r_Document.Document_Number);
      end if;
    
      v_Exists := true;
    else
      r_Document.Company_Id  := i_Document.Company_Id;
      r_Document.Filial_Id   := i_Document.Filial_Id;
      r_Document.Document_Id := i_Document.Document_Id;
      r_Document.Status      := Htm_Pref.c_Document_Status_New;
      v_Exists               := false;
    end if;
  
    r_Document.Document_Number := i_Document.Document_Number;
    r_Document.Document_Date   := i_Document.Document_Date;
    r_Document.Division_Id     := i_Document.Division_Id;
    r_Document.Note            := i_Document.Note;
  
    if v_Exists then
      z_Htm_Recommended_Rank_Documents.Update_Row(r_Document);
    else
      if r_Document.Document_Number is null then
        r_Document.Document_Number := Md_Core.Gen_Number(i_Company_Id => r_Document.Company_Id,
                                                         i_Filial_Id  => r_Document.Filial_Id,
                                                         i_Table      => Zt.Htm_Recommended_Rank_Documents,
                                                         i_Column     => z.Document_Number);
      end if;
    
      z_Htm_Recommended_Rank_Documents.Insert_Row(r_Document);
    end if;
  
    for i in 1 .. i_Document.Staffs.Count
    loop
      v_Staff := i_Document.Staffs(i);
    
      continue when not z_Htm_Experience_Period_Attempts.Exist_Lock(i_Company_Id    => r_Document.Company_Id,
                                                                    i_Filial_Id     => r_Document.Filial_Id,
                                                                    i_Experience_Id => v_Staff.Experience_Id,
                                                                    i_From_Rank_Id  => v_Staff.From_Rank_Id,
                                                                    i_Attempt_No    => v_Staff.Attempt_No,
                                                                    o_Row           => r_Attempt) --
      and not z_Htm_Recommended_Rank_Staffs.Exist_Lock(i_Company_Id  => r_Document.Company_Id,
                                                       i_Filial_Id   => r_Document.Filial_Id,
                                                       i_Document_Id => r_Document.Document_Id,
                                                       i_Staff_Id    => v_Staff.Staff_Id,
                                                       o_Row         => r_Old_Staff);
    
      Fazo.Push(v_Staff_Ids, v_Staff.Staff_Id);
    
      z_Htm_Recommended_Rank_Staffs.Save_One(i_Company_Id         => r_Document.Company_Id,
                                             i_Filial_Id          => r_Document.Filial_Id,
                                             i_Document_Id        => r_Document.Document_Id,
                                             i_Staff_Id           => v_Staff.Staff_Id,
                                             i_Robot_Id           => v_Staff.Robot_Id,
                                             i_From_Rank_Id       => v_Staff.From_Rank_Id,
                                             i_Last_Change_Date   => v_Staff.Last_Change_Date,
                                             i_To_Rank_Id         => v_Staff.To_Rank_Id,
                                             i_New_Change_Date    => v_Staff.New_Change_Date,
                                             i_Period             => v_Staff.Period,
                                             i_Nearest            => v_Staff.Nearest,
                                             i_Old_Penalty_Period => v_Staff.Old_Penalty_Period,
                                             i_Note               => v_Staff.Note,
                                             i_Attempt_No         => v_Staff.Attempt_No,
                                             i_Increment_Status   => Htm_Pref.c_Increment_Status_Ignored,
                                             i_Penalty_Period     => Nvl(r_Attempt.Penalty_Period,
                                                                         r_Old_Staff.Penalty_Period),
                                             i_Exam_Id            => Nvl(r_Attempt.Exam_Id,
                                                                         r_Old_Staff.Exam_Id),
                                             i_Success_Score      => Nvl(r_Attempt.Success_Score,
                                                                         r_Old_Staff.Success_Score),
                                             i_Ignore_Score       => Nvl(r_Attempt.Ignore_Score,
                                                                         r_Old_Staff.Ignore_Score),
                                             i_Recommend_Failure  => Nvl(r_Attempt.Recommend_Failure,
                                                                         r_Old_Staff.Recommend_Failure));
    
      if r_Attempt.Company_Id is not null then
        v_Indicator_Ids := Array_Number();
        v_Subject_Ids   := Array_Number();
      
        for r in (select *
                    from Htm_Experience_Period_Indicators q
                   where q.Company_Id = r_Document.Company_Id
                     and q.Filial_Id = r_Document.Filial_Id
                     and q.Experience_Id = v_Staff.Experience_Id
                     and q.From_Rank_Id = v_Staff.From_Rank_Id
                     and q.Attempt_No = v_Staff.Attempt_No)
        loop
          z_Htm_Recommended_Rank_Staff_Indicators.Save_One(i_Company_Id      => r_Document.Company_Id,
                                                           i_Filial_Id       => r_Document.Filial_Id,
                                                           i_Document_Id     => r_Document.Document_Id,
                                                           i_Staff_Id        => v_Staff.Staff_Id,
                                                           i_Indicator_Id    => r.Indicator_Id,
                                                           i_Indicator_Value => null);
        
          v_Indicator_Ids.Extend;
          v_Indicator_Ids(v_Indicator_Ids.Count) := r.Indicator_Id;
        end loop;
      
        for r in (select *
                    from Htm_Experience_Training_Subjects q
                   where q.Company_Id = r_Document.Company_Id
                     and q.Filial_Id = r_Document.Filial_Id
                     and q.Experience_Id = v_Staff.Experience_Id
                     and q.From_Rank_Id = v_Staff.From_Rank_Id
                     and q.Attempt_No = v_Staff.Attempt_No)
        loop
          z_Htm_Recommended_Rank_Staff_Subjects.Insert_Try(i_Company_Id  => r_Document.Company_Id,
                                                           i_Filial_Id   => r_Document.Filial_Id,
                                                           i_Document_Id => r_Document.Document_Id,
                                                           i_Staff_Id    => v_Staff.Staff_Id,
                                                           i_Subject_Id  => r.Subject_Id);
        
          v_Subject_Ids.Extend;
          v_Subject_Ids(v_Subject_Ids.Count) := r.Subject_Id;
        end loop;
      
        delete Htm_Recommended_Rank_Staff_Indicators q
         where q.Company_Id = r_Document.Company_Id
           and q.Filial_Id = r_Document.Filial_Id
           and q.Document_Id = r_Document.Document_Id
           and q.Staff_Id = v_Staff.Staff_Id
           and q.Indicator_Id not member of v_Indicator_Ids;
      
        delete Htm_Recommended_Rank_Staff_Subjects q
         where q.Company_Id = r_Document.Company_Id
           and q.Filial_Id = r_Document.Filial_Id
           and q.Document_Id = r_Document.Document_Id
           and q.Staff_Id = v_Staff.Staff_Id
           and q.Subject_Id not member of v_Subject_Ids;
      end if;
    end loop;
  
    delete from Htm_Recommended_Rank_Staffs q
     where q.Company_Id = r_Document.Company_Id
       and q.Filial_Id = r_Document.Filial_Id
       and q.Document_Id = r_Document.Document_Id
       and q.Staff_Id not member of v_Staff_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Document_Id => i_Document_Id);
  
    if r_Document.Status = Htm_Pref.c_Document_Status_Approved then
      Htm_Error.Raise_004(r_Document.Document_Number);
    end if;
  
    z_Htm_Recommended_Rank_Documents.Delete_One(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Document_Id => i_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Update_Trainings
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number,
    i_Staffs      Htm_Pref.Recommended_Rank_Training_Nt
  ) is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
    r_Staff    Htm_Recommended_Rank_Staffs%rowtype;
    v_Staff    Htm_Pref.Recommended_Rank_Training_Rt;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Document_Id => i_Document_Id);
  
    if r_Document.Status not in (Htm_Pref.c_Document_Status_Set_Training) then
      Htm_Error.Raise_006(i_Document_Status => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Set_Training),
                          i_Current_Status  => Htm_Util.t_Document_Status(r_Document.Status));
    end if;
  
    for i in 1 .. i_Staffs.Count
    loop
      v_Staff := i_Staffs(i);
    
      r_Staff := z_Htm_Recommended_Rank_Staffs.Take(i_Company_Id  => i_Company_Id,
                                                    i_Filial_Id   => i_Filial_Id,
                                                    i_Document_Id => i_Document_Id,
                                                    i_Staff_Id    => v_Staff.Staff_Id);
    
      continue when r_Staff.Company_Id is null;
    
      z_Htm_Recommended_Rank_Staffs.Update_One(i_Company_Id  => i_Company_Id,
                                               i_Filial_Id   => i_Filial_Id,
                                               i_Document_Id => i_Document_Id,
                                               i_Staff_Id    => v_Staff.Staff_Id,
                                               i_Exam_Id     => Option_Number(v_Staff.Exam_Id));
    
      for j in 1 .. v_Staff.Subject_Ids.Count
      loop
        z_Htm_Recommended_Rank_Staff_Subjects.Insert_Try(i_Company_Id  => i_Company_Id,
                                                         i_Filial_Id   => i_Filial_Id,
                                                         i_Document_Id => i_Document_Id,
                                                         i_Staff_Id    => v_Staff.Staff_Id,
                                                         i_Subject_Id  => v_Staff.Subject_Ids(j));
      end loop;
    
      delete Htm_Recommended_Rank_Staff_Subjects q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Document_Id = i_Document_Id
         and q.Staff_Id = v_Staff.Staff_Id
         and q.Subject_Id not member of v_Staff.Subject_Ids;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Update_Status
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number,
    i_Staffs      Htm_Pref.Recommended_Rank_Status_Nt
  ) is
    r_Document Htm_Recommended_Rank_Documents%rowtype;
  begin
    r_Document := z_Htm_Recommended_Rank_Documents.Lock_Load(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Document_Id => i_Document_Id);
  
    if r_Document.Status not in (Htm_Pref.c_Document_Status_Waiting) then
      Htm_Error.Raise_007(i_Document_Status => Htm_Util.t_Document_Status(Htm_Pref.c_Document_Status_Waiting),
                          i_Current_Status  => Htm_Util.t_Document_Status(r_Document.Status));
    end if;
  
    Htm_Core.Recommended_Rank_Document_Update_Status(i_Company_Id  => i_Company_Id,
                                                     i_Filial_Id   => i_Filial_Id,
                                                     i_Document_Id => i_Document_Id,
                                                     i_Staffs      => i_Staffs);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_New
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
  begin
    Htm_Core.Recommended_Rank_Document_Status_New(i_Company_Id  => i_Company_Id,
                                                  i_Filial_Id   => i_Filial_Id,
                                                  i_Document_Id => i_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Set_Training
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
  begin
    Htm_Core.Recommended_Rank_Document_Set_Training(i_Company_Id  => i_Company_Id,
                                                    i_Filial_Id   => i_Filial_Id,
                                                    i_Document_Id => i_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Training
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
  begin
    Htm_Core.Recommended_Rank_Document_Status_Training(i_Company_Id  => i_Company_Id,
                                                       i_Filial_Id   => i_Filial_Id,
                                                       i_Document_Id => i_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Waiting
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
  begin
    Htm_Core.Recommended_Rank_Document_Status_Waiting(i_Company_Id  => i_Company_Id,
                                                      i_Filial_Id   => i_Filial_Id,
                                                      i_Document_Id => i_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Recommended_Rank_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Document_Id number
  ) is
  begin
    Htm_Core.Recommended_Rank_Document_Status_Approved(i_Company_Id  => i_Company_Id,
                                                       i_Filial_Id   => i_Filial_Id,
                                                       i_Document_Id => i_Document_Id);
  end;

end Htm_Api;
/
