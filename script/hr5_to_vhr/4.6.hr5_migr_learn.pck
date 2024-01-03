create or replace package Hr5_Migr_Learn is
  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Learn_References(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Learn_Data(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
end Hr5_Migr_Learn;
/
create or replace package body Hr5_Migr_Learn is
  ----------------------------------------------------------------------------------------------------  
  Procedure Migr_Question_Categories is
    v_Total                  number;
    v_Id                     number;
    v_Temp_Question_Group_Id number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Categories', 'started Migr_Categories');
  
    -- total count of question categories
    select count(*)
      into v_Total
      from Hr5_Hr_Learn_Categories Lc
     where exists (select 1
              from Hr5_Hr_Learn_Questions q
             where q.Category_Id = Lc.Category_Id)
       and not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Category
               and Uk.Old_Id = Lc.Category_Id);
  
    -- opened one question group and all categories will be inserted as question type of this group
    -- check the next time not to add question group
  
    begin
      select g.Question_Group_Id
        into v_Temp_Question_Group_Id
        from Hln_Question_Groups g
       where g.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and g.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
         and g.Code = Hr5_Migr_Pref.c_Temp_Question_Group_Code;
    
    exception
      when No_Data_Found then
        v_Temp_Question_Group_Id := Hln_Next.Question_Group_Id;
      
        z_Hln_Question_Groups.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                         i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                                         i_Question_Group_Id => v_Temp_Question_Group_Id,
                                         i_Name              => 'Группа вопросов после миграции',
                                         i_Code              => Hr5_Migr_Pref.c_Temp_Question_Group_Code,
                                         i_Is_Required       => 'N',
                                         i_Order_No          => 1,
                                         i_State             => 'A',
                                         i_Pcode             => null);
    end;
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Learn_Categories q
               where exists (select 1
                        from Hr5_Hr_Learn_Questions f
                       where q.Category_Id = f.Category_Id)
                 and not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Category
                         and Uk.Old_Id = q.Category_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Categories',
                                       'inserted ' || (r.Rownum - 1) || ' Category(ies) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Hln_Next.Question_Type_Id;
      
        z_Hln_Question_Types.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                        i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                                        i_Question_Type_Id  => v_Id,
                                        i_Question_Group_Id => v_Temp_Question_Group_Id,
                                        i_Name              => r.Name,
                                        i_Code              => null,
                                        i_Order_No          => r.Order_No,
                                        i_State             => r.State,
                                        i_Pcode             => null);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Learn_Category,
                                i_Old_Id     => r.Category_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Learn_Categories',
                                 i_Key_Id        => r.Category_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Categories', 'finished Migr_Categories');
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Migr_Questions is
    v_Total             number;
    v_Id                number;
    v_Option_Id         number;
    v_Question_Group_Id number;
    v_Type_Id           number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Questions', 'started Migr_Questions');
  
    -- get the only one question group id
    select g.Question_Group_Id
      into v_Question_Group_Id
      from Hln_Question_Groups g
     where g.Company_Id = Hr5_Migr_Pref.g_Company_Id
       and g.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
       and g.Code = Hr5_Migr_Pref.c_Temp_Question_Group_Code;
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Learn_Questions q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Question
               and Uk.Old_Id = q.Question_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Learn_Questions q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Question
                         and Uk.Old_Id = q.Question_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Questions',
                                       'inserted ' || (r.Rownum - 1) || ' Question(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Hln_Next.Question_Id;
      
        z_Hln_Questions.Insert_One(i_Company_Id   => Hr5_Migr_Pref.g_Company_Id,
                                   i_Filial_Id    => Hr5_Migr_Pref.g_Filial_Id,
                                   i_Question_Id  => v_Id,
                                   i_Name         => r.Name,
                                   i_Answer_Type  => case
                                                       when r.Question_Kind = 'W' then
                                                        Hln_Pref.c_Answer_Type_Writing
                                                       else
                                                        r.Answer_Type
                                                     end,
                                   i_Code         => null,
                                   i_State        => 'A',
                                   i_Writing_Hint => null);
      
        if r.Photo_Sha is not null then
          z_Hln_Question_Files.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                          i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                          i_Question_Id => v_Id,
                                          i_File_Sha    => r.Photo_Sha,
                                          i_Order_No    => null);
        end if;
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Learn_Question,
                                i_Old_Id     => r.Question_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        -- question group bind
        if r.Category_Id is not null then
          v_Type_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                i_Key_Name   => Hr5_Migr_Pref.c_Learn_Category,
                                                i_Old_Id     => r.Category_Id,
                                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        
          z_Hln_Question_Group_Binds.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                                i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                                                i_Question_Id       => v_Id,
                                                i_Question_Group_Id => v_Question_Group_Id,
                                                i_Question_Type_Id  => v_Type_Id);
        end if;
      
        -- question option add
        for Opt in (select *
                      from Hr5_Hr_Learn_Question_Options o
                     where o.Question_Id = r.Question_Id)
        loop
          v_Option_Id := Hln_Next.Question_Option_Id;
        
          z_Hln_Question_Options.Insert_One(i_Company_Id         => Hr5_Migr_Pref.g_Company_Id,
                                            i_Filial_Id          => Hr5_Migr_Pref.g_Filial_Id,
                                            i_Question_Option_Id => v_Option_Id,
                                            i_Name               => Opt.Name,
                                            i_File_Sha           => null,
                                            i_Question_Id        => v_Id,
                                            i_Is_Correct         => case
                                                                      when Opt.Mark = 0 then
                                                                       'N'
                                                                      else
                                                                       'Y'
                                                                    end,
                                            i_Order_No           => Opt.Order_No);
        
          Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                  i_Key_Name   => Hr5_Migr_Pref.c_Learn_Option,
                                  i_Old_Id     => Opt.Question_Option_Id,
                                  i_New_Id     => v_Option_Id,
                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        end loop;
      
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Learn_Questions',
                                 i_Key_Id        => r.Question_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Questions', 'finished Migr_Questions');
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Migr_Tests is
    v_Total           number;
    v_Id              number;
    v_New_Question_Id number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Tests', 'started Migr_Tests');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Learn_Tests q
      left join Hr5_Hr_Learn_Testings t
        on q.Test_Id = t.Test_Id
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Test
               and Uk.Old_Id = q.Test_Id)
       and q.Test_Id not in (281, 741, 1081); -- total_questions = 0 tests
  
    for r in (select d.*, Rownum
                from (select q.Test_Id,
                             min(q.Name) name,
                             min(q.State) State,
                             min(q.Total_Questions) Total_Questions,
                             Stats_Mode(t.Pass_Percent) Pass_Percent,
                             Stats_Mode(t.Limit_Time) Limit_Time
                        from Hr5_Hr_Learn_Tests q
                        left join Hr5_Hr_Learn_Testings t
                          on q.Test_Id = t.Test_Id
                       where not exists (select 1
                                from Hr5_Migr_Used_Keys Uk
                               where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Test
                                 and Uk.Old_Id = q.Test_Id)
                         and q.Test_Id not in (281, 741, 1081) -- total_questions = 0 tests
                       group by q.Test_Id) d)
    loop
      Dbms_Application_Info.Set_Module('Migr_Tests',
                                       'inserted ' || (r.Rownum - 1) || ' test(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        if r.Total_Questions is not null then
          v_Id := Hln_Next.Exam_Id;
        
          z_Hln_Exams.Insert_One(i_Company_Id          => Hr5_Migr_Pref.g_Company_Id,
                                 i_Filial_Id           => Hr5_Migr_Pref.g_Filial_Id,
                                 i_Exam_Id             => v_Id,
                                 i_Name                => r.Name,
                                 i_Pick_Kind           => Hln_Pref.c_Exam_Pick_Kind_Manual,
                                 i_Duration            => r.Limit_Time,
                                 i_Passing_Score       => Trunc((Nvl(r.Pass_Percent,
                                                                     Hr5_Migr_Pref.c_Default_Passing_Percent) *
                                                                r.Total_Questions + 1) / 100),
                                 i_Question_Count      => r.Total_Questions,
                                 i_Randomize_Questions => 'Y',
                                 i_Randomize_Options   => 'N',
                                 i_State               => r.State);
        
          Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                  i_Key_Name   => Hr5_Migr_Pref.c_Learn_Test,
                                  i_Old_Id     => r.Test_Id,
                                  i_New_Id     => v_Id,
                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        
          for Qn in (select *
                       from Hr5_Hr_Learn_Test_Questions s
                      where s.Test_Id = r.Test_Id)
          loop
            v_New_Question_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                          i_Key_Name   => Hr5_Migr_Pref.c_Learn_Question,
                                                          i_Old_Id     => Qn.Question_Id,
                                                          i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
          
            z_Hln_Exam_Manual_Questions.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                                   i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                                   i_Exam_Id     => v_Id,
                                                   i_Question_Id => v_New_Question_Id,
                                                   i_Order_No    => Qn.Order_No);
          end loop;
        end if;
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Learn_Tests',
                                 i_Key_Id        => r.Test_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Tests', 'finished Migr_Tests');
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Migr_Testings is
    v_Total                number;
    v_Id                   number;
    v_Corr_Question_Count  number;
    v_Total_Question_Count number;
    v_Passed               varchar2(1);
    -- v_Array_Order_No       Array_Number;
    v_Question_Order_No number;
  
    --------------------------------------------------    
    Function Fixed_Order_No(i_Permutations Arraylist) return Array_Number is
      result Array_Number := Array_Number();
    begin
      if i_Permutations is not null then
        Result.Extend(i_Permutations.Count);
      
        for i in 1 .. i_Permutations.Count
        loop
          result(i_Permutations.r_Number(i)) := i;
        end loop;
      end if;
    
      return result;
    end;
  begin
    Dbms_Application_Info.Set_Module('Migr_Testings', 'started Migr_Testings');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Learn_Testings q
      join Hr5_Hr_Learn_Testing_Persons p
        on q.Testing_Id = p.Testing_Id
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Testing
               and Uk.Old_Id = q.Testing_Id)
       and q.Test_Id not in (281, 741, 1081); -- total_questions = 0 tests
  
    for r in (select t.Pass_Percent,
                     t.Admin_Id,
                     t.Test_Id,
                     t.Testing_Date,
                     t.Limit_Time,
                     t.State,
                     p.*,
                     Rownum
                from Hr5_Hr_Learn_Testings t
                join Hr5_Hr_Learn_Testing_Persons p
                  on t.Testing_Id = p.Testing_Id
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Testing || p.Person_Id
                         and Uk.Old_Id = p.Testing_Id)
                 and t.Test_Id not in (281, 741, 1081) -- total_questions = 0 tests
              )
    loop
      Dbms_Application_Info.Set_Module('Migr_testings',
                                       'inserted ' || (r.Rownum - 1) || ' testing(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Hln_Next.Testing_Id;
      
        -- permutated order no removed beacuse of questions exceeded in learn_tests than previously applied questions count in testings
        -- v_Array_Order_No := Fixed_Order_No(Fazo.Parse_Array(r.Permutations));
      
        -- calc correct questions count
        select count(*), sum(t.Mark)
          into v_Total_Question_Count, v_Corr_Question_Count
          from Hr5_Hr_Learn_Testing_Answers t
         where t.Testing_Id = r.Testing_Id
           and t.Person_Id = r.Person_Id
           and t.Test_Id = r.Test_Id;
      
        v_Passed := case
                      when v_Corr_Question_Count / v_Total_Question_Count * 100 >= r.Pass_Percent then
                       'Y'
                      else
                       'N'
                    end;
      
        -- curr question no
        begin
          select c.Order_No
            into v_Question_Order_No
            from Hr5_Hr_Learn_Test_Questions c
           where c.Test_Id = r.Test_Id
             and c.Question_Id = r.Cur_Question_Id;
        
          /*if r.Permutations is not null then
            v_Question_Order_No := v_Array_Order_No(v_Question_Order_No);
          end if;*/
        exception
          when No_Data_Found then
            v_Question_Order_No := null;
        end;
      
        z_Hln_Testings.Insert_One(i_Company_Id              => Hr5_Migr_Pref.g_Company_Id,
                                  i_Filial_Id               => Hr5_Migr_Pref.g_Filial_Id,
                                  i_Testing_Id              => v_Id,
                                  i_Exam_Id                 => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                        i_Key_Name   => Hr5_Migr_Pref.c_Learn_Test,
                                                                                        i_Old_Id     => r.Test_Id,
                                                                                        i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id),
                                  i_Person_Id               => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                        i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                        i_Old_Id     => r.Person_Id),
                                  i_Examiner_Id             => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                        i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                        i_Old_Id     => r.Admin_Id),
                                  i_Testing_Number          => Md_Core.Gen_Number(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                  i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                                                                  i_Table      => Zt.Hln_Testings,
                                                                                  i_Column     => z.Testing_Number),
                                  i_Testing_Date            => Nvl(Trunc(r.Start_Time), r.Testing_Date),
                                  i_Begin_Time              => r.Start_Time,
                                  i_End_Time                => r.Finish_Time,
                                  i_Fact_Begin_Time         => r.Start_Time,
                                  i_Fact_End_Time           => r.End_Time,
                                  i_Pause_Time              => null,
                                  i_Passed                  => case
                                                                 when r.State = 'C' then
                                                                  v_Passed
                                                                 else
                                                                  Hln_Pref.c_Passed_Indeterminate
                                                               end,
                                  i_Current_Question_No     => v_Question_Order_No,
                                  i_Correct_Questions_Count => v_Corr_Question_Count,
                                  i_Note                    => null,
                                  i_Status                  => case
                                                                 when r.State = 'N' or r.State = 'D' then
                                                                  Hln_Pref.c_Testing_Status_New
                                                                 when r.State = 'E' then
                                                                  Hln_Pref.c_Testing_Status_Executed
                                                                 when r.State = 'C' then
                                                                  Hln_Pref.c_Testing_Status_Finished
                                                                 else
                                                                  null
                                                               end);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Learn_Testing || r.Person_Id,
                                i_Old_Id     => r.Testing_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        -- insert testing questions with permutations and options
        for Tq in (select q.*,
                          (select Ta.Answer
                             from Hr5_Hr_Learn_Testing_Answers Ta
                            where Ta.Testing_Id = r.Testing_Id
                              and Ta.Test_Id = r.Test_Id
                              and Ta.Person_Id = r.Person_Id
                              and Ta.Question_Id = q.Question_Id) Answer,
                          (select case
                                    when Ta.Mark = 1 then
                                     'Y'
                                    else
                                     'N'
                                  end
                             from Hr5_Hr_Learn_Testing_Answers Ta
                            where Ta.Testing_Id = r.Testing_Id
                              and Ta.Test_Id = r.Test_Id
                              and Ta.Person_Id = r.Person_Id
                              and Ta.Question_Id = q.Question_Id) Is_Correct
                     from Hr5_Hr_Learn_Test_Questions q
                    where q.Test_Id = r.Test_Id)
        loop
          z_Hln_Testing_Questions.Insert_One(i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                             i_Filial_Id      => Hr5_Migr_Pref.g_Filial_Id,
                                             i_Testing_Id     => v_Id,
                                             i_Question_Id    => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                          i_Key_Name   => Hr5_Migr_Pref.c_Learn_Question,
                                                                                          i_Old_Id     => Tq.Question_Id,
                                                                                          i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id),
                                             i_Order_No       => Tq.Order_No, -- case when r.Permutations is not null then v_Array_Order_No(Tq.Order_No) else Tq.Order_No end
                                             i_Writing_Answer => Tq.Answer,
                                             i_Marked         => 'N',
                                             i_Correct        => Tq.Is_Correct);
        
          for Opt in (select Qo.*,
                             case
                                when exists (select 1
                                        from Hr5_Hr_Learn_Testing_Answers Ta
                                       where Ta.Testing_Id = r.Testing_Id
                                         and Ta.Person_Id = r.Person_Id
                                         and Ta.Test_Id = r.Test_Id
                                         and Ta.Question_Id = Qo.Question_Id
                                         and Ta.Question_Option_Id = Qo.Question_Option_Id) then
                                 'Y'
                                else
                                 'N'
                              end as Chosen
                        from Hr5_Hr_Learn_Question_Options Qo
                       where Qo.Question_Id = Tq.Question_Id)
          loop
            z_Hln_Testing_Question_Options.Insert_One(i_Company_Id         => Hr5_Migr_Pref.g_Company_Id,
                                                      i_Filial_Id          => Hr5_Migr_Pref.g_Filial_Id,
                                                      i_Testing_Id         => v_Id,
                                                      i_Question_Id        => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                                       i_Key_Name   => Hr5_Migr_Pref.c_Learn_Question,
                                                                                                       i_Old_Id     => Tq.Question_Id,
                                                                                                       i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id),
                                                      i_Question_Option_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                                       i_Key_Name   => Hr5_Migr_Pref.c_Learn_Option,
                                                                                                       i_Old_Id     => Opt.Question_Option_Id,
                                                                                                       i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id),
                                                      i_Order_No           => Opt.Order_No,
                                                      i_Chosen             => Opt.Chosen);
          end loop;
        end loop;
      
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Learn_Testings',
                                 i_Key_Id        => r.Testing_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Testings', 'finished Migr_Testings');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Training_Subjects is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Training_Subjects', 'started Migr_Training_Subjects');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Learn_Categories q
     where exists (select 1
              from Hr5_Hr_Learn_Trains d
             where d.Category_Id = q.Category_Id
               and d.Train_Kind = 'T')
       and not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Subject
               and Uk.Old_Id = q.Category_Id);
  
    --migr training subject
    for Ts in (select Lc.*, Rownum
                 from Hr5_Hr_Learn_Categories Lc
                where exists (select 1
                         from Hr5_Hr_Learn_Trains q
                        where q.Category_Id = Lc.Category_Id
                          and q.Train_Kind = 'T')
                  and not exists (select 1
                         from Hr5_Migr_Used_Keys Uk
                        where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                          and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Subject
                          and Uk.Old_Id = Lc.Category_Id))
    loop
      begin
        Dbms_Application_Info.Set_Module('Migr_Training_Subjects',
                                         'inserted ' || (Ts.Rownum - 1) ||
                                         ' Training_Subject(s) out of ' || v_Total);
        savepoint Try_Catch;
      
        v_Id := Hln_Next.Subject_Id;
      
        z_Hln_Training_Subjects.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                           i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                           i_Subject_Id => v_Id,
                                           i_Name       => Ts.Name,
                                           i_Code       => null,
                                           i_State      => Ts.State);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Learn_Subject,
                                i_Old_Id     => Ts.Category_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Learn_Categories',
                                 i_Key_Id        => Ts.Category_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(Ts.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Training_Subjects', 'finished Migr_Training_Subjects');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Migr_Train is
    v_Total        number;
    v_New_Train_Id number;
    v_Testing_Id   number;
    v_Examiner_Id  number;
    v_Mentor_Id    number;
    v_Status       varchar2(1);
  begin
    Dbms_Application_Info.Set_Module('Migr_Trains', 'started Migr_Trains');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Learn_Trains q
      join Hr5_Hr_Learn_Train_Parts k
        on q.Train_Id = k.Train_Id
     where (q.Train_Kind = 'A' and exists
            (select 1
               from Hr5_Hr_Learn_Part_Testings t
              where t.Train_Part_Id = k.Train_Part_Id) or q.Train_Kind = 'T')
       and not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Train
               and Uk.Old_Id = k.Train_Part_Id);
  
    for r in (select q.*, k.Train_Kind, k.Category_Id, k.Name, k.State, Rownum
                from Hr5_Hr_Learn_Train_Parts q
                join Hr5_Hr_Learn_Trains k
                  on q.Train_Id = k.Train_Id
               where (k.Train_Kind = 'A' and exists
                      (select 1
                         from Hr5_Hr_Learn_Part_Testings t
                        where t.Train_Part_Id = q.Train_Part_Id) or k.Train_Kind = 'T')
                 and not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Learn_Train
                         and Uk.Old_Id = q.Train_Part_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Trains',
                                       'inserted ' || (r.Rownum - 1) || ' train(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        if r.Train_Kind = 'A' then
          v_New_Train_Id := Hln_Next.Attestation_Id;
        
          -- get mode among parts
          select Stats_Mode(t.Admin_Id)
            into v_Examiner_Id
            from Hr5_Hr_Learn_Part_Testings t
           where t.Train_Part_Id = r.Train_Part_Id
             and t.Admin_Id is not null
           group by t.Admin_Id;
        
          v_Examiner_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                    i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                    i_Old_Id     => v_Examiner_Id);
        
          -- get status of attestation
          select case
                   when sum(Decode(t.State, 'C', 1, 0)) = count(*) then
                    'F'
                   when sum(Decode(t.State, 'N', 1, 'D', 1, 0)) = count(*) then
                    'N'
                   else
                    'P'
                 end
            into v_Status
            from Hr5_Hr_Learn_Part_Testings d
            join Hr5_Hr_Learn_Testings t
              on d.Testing_Id = t.Testing_Id
           where d.Train_Part_Id = r.Train_Part_Id
           group by t.State
           fetch first row only;
        
          z_Hln_Attestations.Insert_One(i_Company_Id         => Hr5_Migr_Pref.g_Company_Id,
                                        i_Filial_Id          => Hr5_Migr_Pref.g_Filial_Id,
                                        i_Attestation_Id     => v_New_Train_Id,
                                        i_Attestation_Number => Md_Core.Gen_Number(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                   i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                                                                   i_Table      => Zt.Hln_Attestations,
                                                                                   i_Column     => z.Attestation_Number),
                                        i_Name               => r.Name,
                                        i_Attestation_Date   => Trunc(r.Begin_Time),
                                        i_Begin_Time         => r.Begin_Time,
                                        i_Examiner_Id        => v_Examiner_Id,
                                        i_Note               => r.Note,
                                        i_Status             => v_Status);
        
          -- insert train testings as a testing of attestation
          for Part in (select p.*
                         from Hr5_Hr_Learn_Part_Testings t
                         join Hr5_Hr_Learn_Testing_Persons p
                           on p.Testing_Id = t.Testing_Id
                        where t.Train_Part_Id = r.Train_Part_Id
                          and t.Testing_Id not in (238, 239, 5485)) -- not inserted testings because of not inserted tests
          loop
            v_Testing_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                     i_Key_Name   => Hr5_Migr_Pref.c_Learn_Testing ||
                                                                     Part.Person_Id,
                                                     i_Old_Id     => Part.Testing_Id,
                                                     i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
          
            z_Hln_Attestation_Testings.Insert_One(i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                                  i_Filial_Id      => Hr5_Migr_Pref.g_Filial_Id,
                                                  i_Attestation_Id => v_New_Train_Id,
                                                  i_Testing_Id     => v_Testing_Id);
          end loop;
        else
          --just one training on Makro's case
          v_New_Train_Id := Hln_Next.Training_Id;
        
          select Stats_Mode(Pp.Person_Id)
            into v_Mentor_Id
            from Hr5_Hr_Learn_Part_Persons Pp
           where Pp.Train_Id = r.Train_Id
             and Pp.Train_Part_Id = r.Train_Part_Id
             and Pp.Person_Kind = 'L'
           group by Pp.Person_Id;
        
          z_Hln_Trainings.Insert_One(i_Company_Id      => Hr5_Migr_Pref.g_Company_Id,
                                     i_Filial_Id       => Hr5_Migr_Pref.g_Filial_Id,
                                     i_Training_Id     => v_New_Train_Id,
                                     i_Training_Number => Md_Core.Gen_Number(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                             i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                                                             i_Table      => Zt.Hln_Trainings,
                                                                             i_Column     => z.Training_Number),
                                     i_Begin_Date      => r.Begin_Time,
                                     i_Mentor_Id       => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                   i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                   i_Old_Id     => v_Mentor_Id),
                                     i_Address         => '-',
                                     i_Status          => case
                                                            when r.State = 'N' or r.State = 'D' then
                                                             Hln_Pref.c_Training_Status_New
                                                            when r.State = 'E' then
                                                             Hln_Pref.c_Training_Status_Executed
                                                            when r.State = 'C' then
                                                             Hln_Pref.c_Training_Status_Finished
                                                            else
                                                             null
                                                          end);
        
          z_Hln_Training_Current_Subjects.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                                     i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                                     i_Training_Id => v_New_Train_Id,
                                                     i_Subject_Id  => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                               i_Key_Name   => Hr5_Migr_Pref.c_Learn_Subject,
                                                                                               i_Old_Id     => r.Category_Id,
                                                                                               i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id));
        
          -- insert training persons
          for Trp in (select distinct Pp.Person_Id
                        from Hr5_Hr_Learn_Part_Persons Pp
                       where Pp.Train_Id = r.Train_Id
                         and Pp.Train_Part_Id = r.Train_Part_Id
                         and Pp.Person_Kind = 'P')
          loop
            z_Hln_Training_Persons.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                              i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                              i_Training_Id => v_New_Train_Id,
                                              i_Person_Id   => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                        i_Key_Name   => Hr5_Migr_Pref.c_Md_Person,
                                                                                        i_Old_Id     => Trp.Person_Id),
                                              i_Passed      => Hln_Pref.c_Passed_Indeterminate);
          end loop;
        end if;
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Learn_Train,
                                i_Old_Id     => r.Train_Part_Id,
                                i_New_Id     => v_New_Train_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Learn_Trains',
                                 i_Key_Id        => r.Train_Part_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Trains', 'finished Migr_Trains');
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Migr_Learn_References(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Migr_Question_Categories;
    Migr_Questions;
    Migr_Training_Subjects;
  
    Hr5_Migr_Util.Clear;
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Migr_Learn_Data(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Migr_Tests; -- exam
    Migr_Testings;
    Migr_Train; -- attestation and training
  
    Hr5_Migr_Util.Clear;
  end;

end Hr5_Migr_Learn;
/
