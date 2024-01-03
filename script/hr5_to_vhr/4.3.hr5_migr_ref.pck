create or replace package Hr5_Migr_Ref is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Reference_Data(i_Company_Id number := Md_Pref.c_Migr_Company_Id);
end Hr5_Migr_Ref;
/
create or replace package body Hr5_Migr_Ref is
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Personal_Documents is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Personal_Documents', 'started Migr_Personal_Documents');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Personal_Documents q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Personal_Document
               and Uk.Old_Id = q.Document_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Personal_Documents q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Personal_Document
                         and Uk.Old_Id = q.Document_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Personal_Documents',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Personal_Document(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Document_Type_Id;
      
        z_Href_Document_Types.Insert_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                         i_Doc_Type_Id => v_Id,
                                         i_Name        => r.Name,
                                         i_State       => r.State,
                                         i_Is_Required => 'N',
                                         i_Code        => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Personal_Document,
                                i_Old_Id     => r.Document_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Personal_Documents',
                                 i_Key_Id        => r.Document_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Personal_Documents', 'finished Migr_Personal_Documents');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Education_Types is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Education_Types', 'started Migr_Education_Types');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Education_Types q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Education_Type
               and Uk.Old_Id = q.Education_Type_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Education_Types q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Education_Type
                         and Uk.Old_Id = q.Education_Type_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Education_Types',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Education_Type(s) out of ' || v_Total);
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Edu_Stage_Id;
      
        z_Href_Edu_Stages.Insert_One(i_Company_Id   => Hr5_Migr_Pref.g_Company_Id,
                                     i_Edu_Stage_Id => v_Id,
                                     i_Name         => r.Name,
                                     i_State        => r.State,
                                     i_Code         => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Education_Type,
                                i_Old_Id     => r.Education_Type_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Education_Types',
                                 i_Key_Id        => r.Education_Type_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Education_Types', 'finished Migr_Education_Types');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Institutions is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Institutions', 'started Migr_Institutions');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Institutions q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Institution
               and Uk.Old_Id = q.Institution_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Institutions q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Institution
                         and Uk.Old_Id = q.Institution_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Institutions',
                                       'inserted ' || (r.Rownum - 1) || ' Institution(s) out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Institution_Id;
      
        z_Href_Institutions.Insert_One(i_Company_Id     => Hr5_Migr_Pref.g_Company_Id,
                                       i_Institution_Id => v_Id,
                                       i_Name           => r.Name,
                                       i_State          => r.State,
                                       i_Code           => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Institution,
                                i_Old_Id     => r.Institution_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Institutions',
                                 i_Key_Id        => r.Institution_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Institutions', 'finished Migr_Institutions');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Specialities is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Specialities', 'started Migr_Specialities');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Specialities q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Speciality
               and Uk.Old_Id = q.Speciality_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Specialities q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Speciality
                         and Uk.Old_Id = q.Speciality_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Specialities',
                                       'inserted ' || (r.Rownum - 1) || ' Speciality(es) out of ' ||
                                       v_Total);
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Specialty_Id;
      
        z_Href_Specialties.Insert_One(i_Company_Id   => Hr5_Migr_Pref.g_Company_Id,
                                      i_Specialty_Id => v_Id,
                                      i_Name         => r.Name,
                                      i_Kind         => Href_Pref.c_Specialty_Kind_Specialty,
                                      i_State        => r.State,
                                      i_Code         => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Speciality,
                                i_Old_Id     => r.Speciality_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Specialities',
                                 i_Key_Id        => r.Speciality_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Specialities', 'finished Migr_Specialities');
  end;

  /*----------------------------------------------------------------------------------------------------
  Procedure Migr_Professions is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Professions', 'started Migr_Professions');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Professions q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Profession
               and Uk.Old_Id = q.Profession_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Professions q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Profession
                         and Uk.Old_Id = q.Profession_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Professions',
                                       'inserted ' || (r.Rownum - 1) || ' Profession(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Profession_Id;
      
        z_Href_Professions.Insert_One(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                      i_Profession_Id => v_Id,
                                      i_Name          => r.Name,
                                      i_State         => r.State,
                                      i_Code          => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Profession,
                                i_Old_Id     => r.Profession_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Professions',
                                 i_Key_Id        => r.Profession_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Professions', 'finished Migr_Professions');
  end;*/

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Languages is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Languages', 'started Migr_Languages');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Languages q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Language
               and Uk.Old_Id = q.Lang_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Languages q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Language
                         and Uk.Old_Id = q.Lang_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Languages',
                                       'inserted ' || (r.Rownum - 1) || ' Language(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Lang_Id;
      
        z_Href_Langs.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Lang_Id    => v_Id,
                                i_Name       => r.Name,
                                i_State      => r.State,
                                i_Code       => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Language,
                                i_Old_Id     => r.Lang_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Languages',
                                 i_Key_Id        => r.Lang_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Languages', 'finished Migr_Languages');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Lang_Levels is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Lang_Levels', 'started Migr_Lang_Levels');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Lang_Levels q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Lang_Level
               and Uk.Old_Id = q.Level_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Lang_Levels q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Lang_Level
                         and Uk.Old_Id = q.Level_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Lang_Levels',
                                       'inserted ' || (r.Rownum - 1) || ' Lang_Level(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Lang_Level_Id;
      
        z_Href_Lang_Levels.Insert_One(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                      i_Lang_Level_Id => v_Id,
                                      i_Name          => r.Name,
                                      i_State         => r.State,
                                      i_Code          => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Lang_Level,
                                i_Old_Id     => r.Level_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Lang_Levels',
                                 i_Key_Id        => r.Level_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Lang_Levels', 'finished Migr_Lang_Levels');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Marriage_Conds is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Marriage_Conds', 'started Migr_Marriage_Conds');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Marriage_Conds q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Marriage_Cond
               and Uk.Old_Id = q.Condition_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Marriage_Conds q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Marriage_Cond
                         and Uk.Old_Id = q.Condition_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Marriage_Conds',
                                       'inserted ' || (r.Rownum - 1) || ' Marriage_Cond(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Marital_Status_Id;
      
        z_Href_Marital_Statuses.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                           i_Marital_Status_Id => v_Id,
                                           i_Name              => r.Name,
                                           i_State             => r.State,
                                           i_Code              => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Marriage_Cond,
                                i_Old_Id     => r.Condition_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Marriage_Conds',
                                 i_Key_Id        => r.Condition_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Marriage_Conds', 'finished Migr_Marriage_Conds');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Relationships is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Relationships', 'started Migr_Relationships');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Relationships q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Relationship
               and Uk.Old_Id = q.Relationship_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Relationships q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Relationship
                         and Uk.Old_Id = q.Relationship_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Relationships',
                                       'inserted ' || (r.Rownum - 1) || ' Relationship(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Relation_Degree_Id;
      
        z_Href_Relation_Degrees.Insert_One(i_Company_Id         => Hr5_Migr_Pref.g_Company_Id,
                                           i_Relation_Degree_Id => v_Id,
                                           i_Name               => r.Name,
                                           i_State              => r.State,
                                           i_Code               => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Relationship,
                                i_Old_Id     => r.Relationship_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Relationships',
                                 i_Key_Id        => r.Relationship_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Relationships', 'finished Migr_Relationships');
  end;

  ----------------------------------------------------------------------------------------------------
  -- dismissal reasons
  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Reasons is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Reasons', 'started Migr_Reasons');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Reasons q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Reason
               and Uk.Old_Id = q.Reason_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Reasons q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Reason
                         and Uk.Old_Id = q.Reason_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Reasons',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Dismissal Reason(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Dismissal_Reason_Id;
      
        -- todo state, code
        z_Href_Dismissal_Reasons.Insert_One(i_Company_Id          => Hr5_Migr_Pref.g_Company_Id,
                                            i_Dismissal_Reason_Id => v_Id,
                                            i_Name                => r.Name,
                                            i_Description         => 'Reason type: ' ||
                                                                     case r.Reason_Type
                                                                       when 'P' then
                                                                        'positive'
                                                                       else
                                                                        'negative'
                                                                     end,
                                            i_Reason_Type         => r.Reason_Type);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Reason,
                                i_Old_Id     => r.Reason_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Reasons',
                                 i_Key_Id        => r.Reason_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Reasons', 'finished Migr_Reasons');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Post_Types is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Post_Types', 'started Migr_Post_Types');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Post_Types q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Post_Type
               and Uk.Old_Id = q.Post_Type_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Post_Types q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Post_Type
                         and Uk.Old_Id = q.Post_Type_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Post_Types',
                                       'inserted ' || (r.Rownum - 1) || ' Post_Type(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Mhr_Next.Job_Group_Id;
      
        -- todo: expense_coa_id, expense_ref_set 
      
        z_Mhr_Job_Groups.Insert_One(i_Company_Id   => Hr5_Migr_Pref.g_Company_Id,
                                    i_Job_Group_Id => v_Id,
                                    i_Name         => r.Name,
                                    i_State        => r.State,
                                    i_Code         => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Post_Type,
                                i_Old_Id     => r.Post_Type_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Post_Types',
                                 i_Key_Id        => r.Post_Type_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Post_Types', 'finished Migr_Post_Types');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Department_Types is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Department_Types', 'started Migr_Department_Types');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Department_Types q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department_Type
               and Uk.Old_Id = q.Dept_Type_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Department_Types q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department_Type
                         and Uk.Old_Id = q.Dept_Type_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Department_Types',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Department_Type(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Mhr_Next.Division_Group_Id;
      
        z_Mhr_Division_Groups.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                         i_Division_Group_Id => v_Id,
                                         i_Name              => r.Name,
                                         i_State             => r.State);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department_Type,
                                i_Old_Id     => r.Dept_Type_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Department_Types',
                                 i_Key_Id        => r.Dept_Type_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Department_Types', 'finished Migr_Department_Types');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Rewards is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Rewards', 'started Migr_Rewards');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Rewards q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Reward
               and Uk.Old_Id = q.Reward_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Rewards q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Reward
                         and Uk.Old_Id = q.Reward_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Rewards',
                                       'inserted ' || (r.Rownum - 1) || ' Reward(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Award_Id;
      
        -- todo place, reward 
        z_Href_Awards.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                 i_Award_Id   => v_Id,
                                 i_Name       => r.Name, -- name 200 char
                                 i_State      => 'A');
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Reward,
                                i_Old_Id     => r.Reward_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Rewards',
                                 i_Key_Id        => r.Reward_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Rewards', 'finished Migr_Rewards');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Ranks is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Ranks', 'started Migr_Ranks');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Ranks q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Rank
               and Uk.Old_Id = q.Rank_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Ranks q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Rank
                         and Uk.Old_Id = q.Rank_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Ranks',
                                       'inserted ' || (r.Rownum - 1) || ' Rank(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Mhr_Next.Rank_Id;
      
        -- todo affect_wage 
        z_Mhr_Ranks.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                               i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                               i_Rank_Id    => v_Id,
                               i_Name       => r.Name,
                               i_Order_No   => r.Order_No,
                               i_Code       => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Rank,
                                i_Old_Id     => r.Rank_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Ranks',
                                 i_Key_Id        => r.Rank_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Ranks', 'finished Migr_Ranks');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Business_Reasons is
    v_Total number;
    v_Id    number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Business_Reasons', 'started Migr_Business_Reasons');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Business_Reasons q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Business_Reason
               and Uk.Old_Id = q.Reason_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Business_Reasons q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Business_Reason
                         and Uk.Old_Id = q.Reason_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Business_Reasons',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Business_Reason(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Href_Next.Business_Trip_Reason_Id;
      
        -- todo affect_wage 
        z_Href_Business_Trip_Reasons.Insert_One(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id,
                                                i_Reason_Id  => v_Id,
                                                i_Name       => r.Name,
                                                i_State      => r.State,
                                                i_Code       => r.Code);
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Business_Reason,
                                i_Old_Id     => r.Reason_Id,
                                i_New_Id     => v_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Business_Reasons',
                                 i_Key_Id        => r.Reason_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Business_Reasons', 'finished Migr_Business_Reasons');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Division_Structures is
    v_Total     number;
    v_Id        number;
    v_Parent_Id number;
  
    --------------------------------------------------
    Function Name_Fix
    (
      i_Id        number,
      i_Name      varchar2,
      i_Parent_Id number
    ) return varchar2 is
      v_Dummy varchar2(1);
    begin
      select 'X'
        into v_Dummy
        from Mhr_Divisions d
       where d.Company_Id = Hr5_Migr_Pref.g_Company_Id
         and d.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
         and Lower(d.Name) = Lower(i_Name)
         and (i_Parent_Id is null and d.Parent_Id is null or i_Parent_Id = d.Parent_Id);
    
      return i_Name || '(' || i_Id || ')';
    exception
      when No_Data_Found then
        return i_Name;
    end;
  begin
    Dbms_Application_Info.Set_Module('Migr_Division_Structures',
                                     'started Migr_Division_Structures');
  
    -- departments
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Departments q
     where q.Filial_Id = Hr5_Migr_Pref.g_Old_Filial_Id
       and not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department
               and Uk.Old_Id = q.Department_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Departments q
               where q.Filial_Id = Hr5_Migr_Pref.g_Old_Filial_Id
                 and not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                         and Uk.Old_Id = q.Department_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Division_Structures',
                                       'inserted ' || (r.Rownum - 1) || ' Department(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Id := Mhr_Next.Division_Id;
      
        -- todo begin_date, address, square, lat_lng, phone_number, photo_sha, kind, region_id  
        z_Mhr_Divisions.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                   i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                                   i_Division_Id       => v_Id,
                                   i_Name              => r.Name,
                                   i_Parent_Id         => null,
                                   i_Division_Group_Id => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                                   i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department_Type,
                                                                                   i_Old_Id     => r.Dept_Type_Id),
                                   i_Opened_Date       => r.Open_Date,
                                   i_Closed_Date       => r.End_Date,
                                   i_State             => r.State,
                                   i_Code              => r.Code);
      
        z_Hrm_Divisions.Insert_One(i_Company_Id           => Hr5_Migr_Pref.g_Company_Id,
                                   i_Filial_Id            => Hr5_Migr_Pref.g_Filial_Id,
                                   i_Division_Id          => v_Id,
                                   i_Parent_Department_Id => null,
                                   i_Is_Department        => 'Y');
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department,
                                i_Old_Id     => r.Department_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Departments',
                                 i_Key_Id        => r.Department_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    -- department groups
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Department_Groups q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department_Group
               and Uk.Old_Id = q.Group_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Department_Groups q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department_Group
                         and Uk.Old_Id = q.Group_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Division_Structures',
                                       'inserted ' || (r.Rownum - 1) ||
                                       ' Department Group(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Parent_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department,
                                                i_Old_Id     => r.Department_Id,
                                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        if v_Parent_Id is null then
          b.Raise_Error('Migr_Division_Structures: new division_id is not found for department of department group, department_id=$1, new_filial_id=$2',
                        r.Department_Id,
                        Hr5_Migr_Pref.g_Filial_Id);
        end if;
      
        v_Id := Mhr_Next.Division_Id;
      
        -- todo order_no
        z_Mhr_Divisions.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                                   i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                                   i_Division_Id       => v_Id,
                                   i_Name              => Name_Fix(v_Id, r.Name, v_Parent_Id),
                                   i_Parent_Id         => v_Parent_Id,
                                   i_Division_Group_Id => null,
                                   i_Opened_Date       => Trunc(sysdate),
                                   i_Closed_Date       => null,
                                   i_State             => r.State,
                                   i_Code              => null);
      
        z_Hrm_Divisions.Insert_One(i_Company_Id           => Hr5_Migr_Pref.g_Company_Id,
                                   i_Filial_Id            => Hr5_Migr_Pref.g_Filial_Id,
                                   i_Division_Id          => v_Id,
                                   i_Parent_Department_Id => v_Parent_Id,
                                   i_Is_Department        => 'N');
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department_Group,
                                i_Old_Id     => r.Group_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Department_Groups',
                                 i_Key_Id        => r.Group_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    -- commented out, because it makes departments children
    -- that is incorrect because previous departments didn't have parent_id
    /* -- departments parent updatable
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Departments q
     where q.Filial_Id = Hr5_Migr_Pref.g_Old_Filial_Id
       and exists (select 1
              from Hr5_Hr_Ref_Dept_Group_Binds Gb
             where Gb.Department_Id = q.Department_Id)
       and exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department
               and Uk.Old_Id = q.Department_Id)
       and exists (select 1
              from Hr5_Migr_Keys_Store_Two Ks
             where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Ref_Department
               and Ks.Old_Id = q.Department_Id
               and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
               and exists (select 1
                      from Mhr_Divisions d
                     where d.Company_Id = Hr5_Migr_Pref.g_Company_Id
                       and d.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                       and d.Division_Id = Ks.New_Id
                       and d.Parent_Id is null));
    
    for r in (select q.*,
                     (select Ks.New_Id
                        from Hr5_Migr_Keys_Store_Two Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                         and Ks.Old_Id = q.Department_Id
                         and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id) as New_Division_Id,
                     (select Gb.Group_Id
                        from Hr5_Hr_Ref_Dept_Group_Binds Gb
                       where Gb.Department_Id = q.Department_Id
                         and Rownum = 1) as Group_Id,
                     Rownum
                from Hr5_Hr_Ref_Departments q
               where q.Filial_Id = Hr5_Migr_Pref.g_Old_Filial_Id
                 and exists (select 1
                        from Hr5_Hr_Ref_Dept_Group_Binds Gb
                       where Gb.Department_Id = q.Department_Id)
                 and exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                         and Uk.Old_Id = q.Department_Id)
                 and exists
               (select 1
                        from Hr5_Migr_Keys_Store_Two Ks
                       where Ks.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Ks.Key_Name = Hr5_Migr_Pref.c_Ref_Department
                         and Ks.Old_Id = q.Department_Id
                         and Ks.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                         and exists (select 1
                                from Mhr_Divisions d
                               where d.Company_Id = Hr5_Migr_Pref.g_Company_Id
                                 and d.Filial_Id = Hr5_Migr_Pref.g_Filial_Id
                                 and d.Division_Id = Ks.New_Id
                                 and d.Parent_Id is null)))
    loop
      Dbms_Application_Info.Set_Module('Migr_Division_Structures',
                                       'updated ' || (r.Rownum - 1) ||
                                       ' Division Parent(s) out of ' || v_Total);
    
      begin
        savepoint Try_Catch;
      
        v_Parent_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department_Group,
                                                i_Old_Id     => r.Group_Id,
                                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      
        if v_Parent_Id is null then
          b.Raise_Error('Migr_Division_Structures: new division_id is not found for department group, group_id=$1, department_id=$2, new_filial_id=$3',
                        r.Group_Id,
                        r.Department_Id,
                        Hr5_Migr_Pref.g_Filial_Id);
        end if;
      
        z_Mhr_Divisions.Update_One(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                   i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                   i_Division_Id => r.New_Division_Id,
                                   i_Parent_Id   => Option_Number(v_Parent_Id));
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Department_Groups',
                                 i_Key_Id        => r.Group_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;*/
  
    Dbms_Application_Info.Set_Module('Migr_Division_Structures',
                                     'finished Migr_Division_Structures');
  end;

  ----------------------------------------------------------------------------------------------------
  -- jobs
  Procedure Migr_Posts is
    v_Total       number;
    v_Id          number;
    v_Coa_Id      number;
    v_Division_Id number;
  begin
    Dbms_Application_Info.Set_Module('Migr_Posts', 'started Migr_Posts');
  
    -- total count
    select count(*)
      into v_Total
      from Hr5_Hr_Ref_Posts q
     where not exists (select 1
              from Hr5_Migr_Used_Keys Uk
             where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Post
               and Uk.Old_Id = q.Post_Id);
  
    for r in (select q.*, Rownum
                from Hr5_Hr_Ref_Posts q
               where not exists (select 1
                        from Hr5_Migr_Used_Keys Uk
                       where Uk.Company_Id = Hr5_Migr_Pref.g_Company_Id
                         and Uk.Key_Name = Hr5_Migr_Pref.c_Ref_Post
                         and Uk.Old_Id = q.Post_Id))
    loop
      Dbms_Application_Info.Set_Module('Migr_Posts',
                                       'inserted ' || (r.Rownum - 1) || ' Post(s) out of ' ||
                                       v_Total);
    
      begin
        savepoint Try_Catch;
      
        if r.Expense_Coa_Id is not null then
          begin
            select q.Coa_Id
              into v_Coa_Id
              from Mk_Coa q
             where q.Company_Id = Hr5_Migr_Pref.g_Company_Id
               and exists (select 1
                      from Hr5_Mk_Coa Mc
                     where Mc.Coa_Id = r.Expense_Coa_Id
                       and Mc.Code = q.Code);
          exception
            when No_Data_Found then
              b.Raise_Error('Migr_Posts: new coa id not found, expense_coa_id=$1, post_id=$2',
                            r.Expense_Coa_Id,
                            r.Post_Id);
          end;
        else
          v_Coa_Id := null;
        end if;
      
        if r.Group_Id is not null then
          v_Division_Id := Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                    i_Key_Name   => Hr5_Migr_Pref.c_Ref_Department_Group,
                                                    i_Old_Id     => r.Group_Id,
                                                    i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
        
          if v_Division_Id is null then
            b.Raise_Error('Migr_Posts: new division_id is not found for group_id, group_id=$1, post_id=$2, filial_id=$3',
                          r.Group_Id,
                          r.Post_Id,
                          Hr5_Migr_Pref.g_Filial_Id);
          end if;
        else
          v_Division_Id := null;
        end if;
      
        v_Id := Mhr_Next.Job_Id;
      
        z_Mhr_Jobs.Insert_One(i_Company_Id        => Hr5_Migr_Pref.g_Company_Id,
                              i_Job_Id            => v_Id,
                              i_Filial_Id         => Hr5_Migr_Pref.g_Filial_Id,
                              i_Name              => r.Name,
                              i_Job_Group_Id      => Hr5_Migr_Util.Get_New_Id(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                                                              i_Key_Name   => Hr5_Migr_Pref.c_Ref_Post_Type,
                                                                              i_Old_Id     => r.Post_Type_Id),
                              i_Expense_Coa_Id    => v_Coa_Id,
                              i_Expense_Ref_Set   => trim(r.Expense_Ref_Set),
                              i_State             => r.State,
                              i_Code              => r.Code,
                              i_c_Divisions_Exist => case
                                                       when v_Division_Id is not null then
                                                        'Y'
                                                       else
                                                        'N'
                                                     end);
      
        if v_Division_Id is not null then
          z_Mhr_Job_Divisions.Insert_Try(i_Company_Id  => Hr5_Migr_Pref.g_Company_Id,
                                         i_Filial_Id   => Hr5_Migr_Pref.g_Filial_Id,
                                         i_Job_Id      => v_Id,
                                         i_Division_Id => v_Division_Id);
        end if;
      
        Hr5_Migr_Api.Insert_Key(i_Company_Id => Hr5_Migr_Pref.g_Company_Id,
                                i_Key_Name   => Hr5_Migr_Pref.c_Ref_Post,
                                i_Old_Id     => r.Post_Id,
                                i_New_Id     => v_Id,
                                i_Filial_Id  => Hr5_Migr_Pref.g_Filial_Id);
      exception
        when others then
          rollback to Try_Catch;
        
          Hr5_Migr_Api.Log_Error(i_Company_Id    => Hr5_Migr_Pref.g_Company_Id,
                                 i_Table_Name    => 'Hr_Ref_Posts',
                                 i_Key_Id        => r.Post_Id,
                                 i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                    Dbms_Utility.Format_Error_Backtrace);
      end;
    
      if mod(r.Rownum, Hr5_Migr_Pref.c_Commit_Row_Count) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  
    Dbms_Application_Info.Set_Module('Migr_Posts', 'finished Migr_Posts');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr_Reference_Data(i_Company_Id number := Md_Pref.c_Migr_Company_Id) is
  begin
    Hr5_Migr_Util.Init(i_Company_Id);
  
    Migr_Personal_Documents;
    Migr_Education_Types;
    Migr_Institutions;
    Migr_Specialities;
    -- Migr_Professions;
    Migr_Languages;
    Migr_Lang_Levels;
    Migr_Marriage_Conds;
    Migr_Relationships;
    Migr_Reasons; -- dismissal reasons
    Migr_Post_Types; -- job groups
    Migr_Department_Types; -- division groups
    Migr_Rewards;
    Migr_Ranks;
    Migr_Business_Reasons; -- business trip reasons
    Migr_Division_Structures;
    Migr_Posts; -- job
  
    Hr5_Migr_Util.Clear;
  end;

end Hr5_Migr_Ref;
/
