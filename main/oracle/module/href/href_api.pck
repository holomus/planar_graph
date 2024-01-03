create or replace package Href_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timepad_User(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Save
  (
    i_Candidate              Href_Pref.Candidate_Rt,
    i_Check_Required_Columns boolean := true
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Setting_Save(i_Settings Href_Candidate_Ref_Settings%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Langs_Save
  (
    i_Company_Id number,
    i_Fillial_Id number,
    i_Lang_Ids   Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Edu_Stages_Save
  (
    i_Company_Id    number,
    i_Fillial_Id    number,
    i_Edu_Stage_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Save(i_Employee Href_Pref.Employee_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Employee_Update
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Save(i_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Delete
  (
    i_Company_Id         number,
    i_Fixed_Term_Base_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Save(i_Edu_Stage Href_Edu_Stages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Delete
  (
    i_Company_Id   number,
    i_Edu_Stage_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Save(i_Science_Branch Href_Science_Branches%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Delete
  (
    i_Company_Id        number,
    i_Science_Branch_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Save(i_Institution Href_Institutions%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Delete
  (
    i_Company_Id     number,
    i_Institution_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Save(i_Specialty Href_Specialties%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Delete
  (
    i_Company_Id   number,
    i_Specialty_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Save(i_Lang Href_Langs%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Delete
  (
    i_Company_Id number,
    i_Lang_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Save(i_Lang_Level Href_Lang_Levels%rowtype);
  ------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Delete
  (
    i_Company_Id    number,
    i_Lang_Level_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Save(i_Document_Type Href_Document_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Update_Is_Required
  (
    i_Company_Id  number,
    i_Doc_Type_Id number,
    i_Is_Required varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Delete
  (
    i_Company_Id  number,
    i_Doc_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Division_Id  number,
    i_Job_Id       number,
    i_Doc_Type_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Save(i_Reference_Type Href_Reference_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Delete
  (
    i_Company_Id        number,
    i_Reference_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Save(i_Relation_Degree Href_Relation_Degrees%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Delete
  (
    i_Company_Id         number,
    i_Relation_Degree_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Save(i_Marital_Status Href_Marital_Statuses%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Delete
  (
    i_Company_Id        number,
    i_Marital_Status_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Save(i_Experience_Type Href_Experience_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Delete
  (
    i_Company_Id         number,
    i_Experience_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Save(i_Nationality Href_Nationalities%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Delete
  (
    i_Company_Id     number,
    i_Nationality_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Award_Save(i_Award Href_Awards%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Award_Delete
  (
    i_Company_Id number,
    i_Award_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Save(i_Inventory_Type Href_Inventory_Types%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Delete
  (
    i_Company_Id        number,
    i_Inventory_Type_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save
  (
    i_Person                 Href_Pref.Person_Rt,
    i_Only_Natural           boolean := false,
    i_Check_Required_Columns boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Delete
  (
    i_Company_Id number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Save
  (
    i_Person_Detail Href_Person_Details%rowtype,
    i_Requirable    boolean := true
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Save(i_Person_Edu_Stage Href_Person_Edu_Stages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Save
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Save(i_Person_Lang Href_Person_Langs%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Delete
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Lang_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Save(i_Person_Reference Href_Person_References%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Delete
  (
    i_Company_Id          number,
    i_Person_Reference_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Save(i_Person_Family_Member Href_Person_Family_Members%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Delete
  (
    i_Company_Id              number,
    i_Person_Family_Member_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Save(i_Person_Marital_Status Href_Person_Marital_Statuses%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Delete
  (
    i_Company_Id               number,
    i_Person_Marital_Status_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Save(i_Person_Experience Href_Person_Experiences%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Delete
  (
    i_Company_Id           number,
    i_Person_Experience_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Save(i_Person_Award Href_Person_Awards%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Delete
  (
    i_Company_Id      number,
    i_Person_Award_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Save(i_Person_Work_Place Href_Person_Work_Places%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Delete
  (
    i_Company_Id           number,
    i_Person_Work_Place_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Save(i_Document Href_Person_Documents%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_New
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Rejected
  (
    i_Company_Id    number,
    i_Document_Id   number,
    i_Rejected_Note varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_Delete
  (
    i_Company_Id  number,
    i_Document_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_File_Save
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Person_Document_File_Delete
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Save(i_Person_Inventory Href_Person_Inventories%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Delete
  (
    i_Company_Id          number,
    i_Person_Inventory_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Hidden_Salary_Job_Groups_Save
  (
    i_Company_Id    number,
    i_Person_Id     number,
    i_Job_Group_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Save(i_Labor_Function Href_Labor_Functions%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Delete
  (
    i_Company_Id        number,
    i_Labor_Function_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Sick_Leave_Reason_Save(i_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype);
  ----------------------------------------------------------------------------------------------------  
  Procedure Sick_Leave_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Save(i_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype);

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Save(i_Dismissal_Reason Href_Dismissal_Reasons%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Delete
  (
    i_Company_Id          number,
    i_Dismissal_Reason_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Save(i_Wage Href_Wages%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Wage_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Save(i_Employment_Source Href_Employment_Sources%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Delete
  (
    i_Company_Id number,
    i_Source_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Save(i_Indicator Href_Indicators%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Delete
  (
    i_Company_Id   number,
    i_Indicator_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Save(i_Fte Href_Ftes%rowtype);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Fte_Delete
  (
    i_Company_Id number,
    i_Fte_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Col_Required_Setting_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Col_Required_Setting_Rt
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Badge_Template_Save(i_Badge_Template Href_Badge_Templates%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Delete(i_Badge_Template_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Setting_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Column_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Limit_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Fte_Limit_Rt
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Bank_Account_Save(i_Bank_Account Href_Pref.Bank_Account_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Bank_Account_Delete
  (
    i_Company_Id      number,
    i_Bank_Account_Id number
  );
end Href_Api;
/
create or replace package body Href_Api is
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
    return b.Translate('HREF:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timepad_User(i_Company_Id number) is
    v_Person_Id   number := Md_Next.Person_Id;
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
  begin
    z_Md_Persons.Insert_One(i_Company_Id  => i_Company_Id,
                            i_Person_Id   => v_Person_Id,
                            i_Name        => 'Timepad Virtual user',
                            i_Person_Kind => Md_Pref.c_Pk_Virtual,
                            i_Email       => null,
                            i_Photo_Sha   => null,
                            i_State       => 'A',
                            i_Code        => null,
                            i_Phone       => null);
  
    z_Md_Users.Insert_One(i_Company_Id               => i_Company_Id,
                          i_User_Id                  => v_Person_Id,
                          i_Name                     => 'Timepad Virtual user',
                          i_Login                    => null,
                          i_Password                 => null,
                          i_State                    => 'A',
                          i_User_Kind                => Md_Pref.c_Uk_Virtual,
                          i_Gender                   => null,
                          i_Manager_Id               => null,
                          i_Timezone_Code            => null,
                          i_Two_Factor_Verification  => Md_Pref.c_Two_Step_Verification_Disabled,
                          i_Password_Changed_On      => null,
                          i_Password_Change_Required => null,
                          i_Order_No                 => null);
  
    z_Href_Timepad_Users.Insert_One(i_Company_Id => i_Company_Id, i_User_Id => v_Person_Id);
  
    -- attach timepad role for virtual user 
    Md_Api.Role_Grant(i_Company_Id => i_Company_Id,
                      i_User_Id    => v_Person_Id,
                      i_Filial_Id  => v_Filial_Head,
                      i_Role_Id    => Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                                      i_Pcode      => Href_Pref.c_Pcode_Role_Timepad));
  
    -- attach user to filial
    Md_Api.User_Add_Filial(i_Company_Id => i_Company_Id,
                           i_User_Id    => v_Person_Id,
                           i_Filial_Id  => v_Filial_Head);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Save
  (
    i_Candidate              Href_Pref.Candidate_Rt,
    i_Check_Required_Columns boolean := true
  ) is
    v_Exists            boolean := false;
    r_Candidate         Href_Candidates%rowtype;
    r_Person_Exp        Href_Person_Experiences%rowtype;
    r_Edu_Stage         Href_Person_Edu_Stages%rowtype;
    v_Lang_Ids          Array_Number := Array_Number();
    v_Lang              Href_Pref.Person_Lang_Rt;
    v_Exp_Ids           Array_Number;
    v_Exp               Href_Pref.Person_Experience_Rt;
    v_Recom_Ids         Array_Number;
    v_Recom             Href_Pref.Candidate_Recom_Rt;
    v_New_Edu_Stage_Ids Array_Number := Array_Number();
    v_Person_Edu_Stages Array_Number := Array_Number();
  begin
    if z_Href_Candidates.Exist(i_Company_Id   => i_Candidate.Company_Id,
                               i_Filial_Id    => i_Candidate.Filial_Id,
                               i_Candidate_Id => i_Candidate.Person.Person_Id,
                               o_Row          => r_Candidate) then
      v_Exists := true;
    else
      r_Candidate.Company_Id   := i_Candidate.Company_Id;
      r_Candidate.Filial_Id    := i_Candidate.Filial_Id;
      r_Candidate.Candidate_Id := i_Candidate.Person.Person_Id;
    end if;
  
    Person_Save(i_Person                 => i_Candidate.Person, --
                i_Only_Natural           => true,
                i_Check_Required_Columns => i_Check_Required_Columns);
  
    if not v_Exists then
      Mrf_Api.Filial_Add_Person(i_Company_Id => r_Candidate.Company_Id,
                                i_Filial_Id  => r_Candidate.Filial_Id,
                                i_Person_Id  => r_Candidate.Candidate_Id,
                                i_State      => 'A');
    end if;
  
    if i_Candidate.Person_Type_Id is not null then
      Mr_Api.Person_Add_Type_Bind(i_Company_Id      => r_Candidate.Company_Id,
                                  i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(r_Candidate.Company_Id),
                                  i_Person_Id       => r_Candidate.Candidate_Id,
                                  i_Person_Type_Id  => i_Candidate.Person_Type_Id);
    else
      Mr_Api.Person_Remove_Type_Bind(i_Company_Id      => r_Candidate.Company_Id,
                                     i_Person_Group_Id => Mr_Pref.Pg_Natural_Category(r_Candidate.Company_Id),
                                     i_Person_Id       => r_Candidate.Candidate_Id);
    end if;
  
    r_Candidate.Candidate_Kind   := i_Candidate.Candidate_Kind;
    r_Candidate.Source_Id        := i_Candidate.Source_Id;
    r_Candidate.Wage_Expectation := i_Candidate.Wage_Expectation;
    r_Candidate.Cv_Sha           := i_Candidate.Cv_Sha;
    r_Candidate.Note             := i_Candidate.Note;
  
    if v_Exists then
      z_Href_Candidates.Update_Row(r_Candidate);
    else
      z_Href_Candidates.Insert_Row(r_Candidate);
    end if;
  
    -- person details
    if i_Candidate.Extra_Phone is not null then
      z_Href_Person_Details.Save_One(i_Company_Id           => r_Candidate.Company_Id,
                                     i_Person_Id            => r_Candidate.Candidate_Id,
                                     i_Key_Person           => 'N',
                                     i_Access_All_Employees => 'N',
                                     i_Extra_Phone          => i_Candidate.Extra_Phone,
                                     i_Access_Hidden_Salary => 'N');
    else
      z_Href_Person_Details.Delete_One(i_Company_Id => r_Candidate.Company_Id,
                                       i_Person_Id  => r_Candidate.Candidate_Id);
    end if;
  
    -- candidate languages
    v_Lang_Ids := Array_Number();
    v_Lang_Ids.Extend(i_Candidate.Langs.Count);
  
    for i in 1 .. i_Candidate.Langs.Count
    loop
      v_Lang := i_Candidate.Langs(i);
      v_Lang_Ids(i) := v_Lang.Lang_Id;
    
      z_Href_Person_Langs.Save_One(i_Company_Id    => r_Candidate.Company_Id,
                                   i_Person_Id     => r_Candidate.Candidate_Id,
                                   i_Lang_Id       => v_Lang.Lang_Id,
                                   i_Lang_Level_Id => v_Lang.Lang_Level_Id);
    end loop;
  
    delete from Href_Person_Langs t
     where t.Company_Id = r_Candidate.Company_Id
       and t.Person_Id = r_Candidate.Candidate_Id
       and t.Lang_Id not member of v_Lang_Ids;
  
    -- candidate experience
    v_Exp_Ids := Array_Number();
    v_Exp_Ids.Extend(i_Candidate.Experiences.Count);
  
    for i in 1 .. i_Candidate.Experiences.Count
    loop
      v_Exp := i_Candidate.Experiences(i);
      v_Exp_Ids(i) := v_Exp.Person_Experience_Id;
    
      z_Href_Person_Experiences.Init(p_Row                  => r_Person_Exp,
                                     i_Company_Id           => r_Candidate.Company_Id,
                                     i_Person_Experience_Id => v_Exp.Person_Experience_Id,
                                     i_Person_Id            => r_Candidate.Candidate_Id,
                                     i_Experience_Type_Id   => v_Exp.Experience_Type_Id,
                                     i_Is_Working           => v_Exp.Is_Working,
                                     i_Start_Date           => v_Exp.Start_Date,
                                     i_Num_Year             => v_Exp.Num_Year,
                                     i_Num_Month            => v_Exp.Num_Month,
                                     i_Num_Day              => v_Exp.Num_Day);
    
      Person_Experience_Save(r_Person_Exp);
    end loop;
  
    delete from Href_Person_Experiences e
     where e.Company_Id = r_Candidate.Company_Id
       and e.Person_Id = r_Candidate.Candidate_Id
       and e.Person_Experience_Id not member of v_Exp_Ids;
  
    -- candidate recommendations
    v_Recom_Ids := Array_Number();
    v_Recom_Ids.Extend(i_Candidate.Recommendations.Count);
  
    for i in 1 .. i_Candidate.Recommendations.Count
    loop
      v_Recom := i_Candidate.Recommendations(i);
      v_Recom_Ids(i) := v_Recom.Recommendation_Id;
    
      z_Href_Candidate_Recoms.Save_One(i_Company_Id          => r_Candidate.Company_Id,
                                       i_Filial_Id           => r_Candidate.Filial_Id,
                                       i_Recommendation_Id   => v_Recom.Recommendation_Id,
                                       i_Candidate_Id        => r_Candidate.Candidate_Id,
                                       i_Sender_Name         => v_Recom.Sender_Name,
                                       i_Sender_Phone_Number => v_Recom.Sender_Phone_Number,
                                       i_Sender_Email        => v_Recom.Sender_Email,
                                       i_File_Sha            => v_Recom.File_Sha,
                                       i_Order_No            => v_Recom.Order_No,
                                       i_Feedback            => v_Recom.Feedback,
                                       i_Note                => v_Recom.Note);
    end loop;
  
    delete from Href_Candidate_Recoms t
     where t.Company_Id = r_Candidate.Company_Id
       and t.Filial_Id = r_Candidate.Filial_Id
       and t.Candidate_Id = r_Candidate.Candidate_Id
       and t.Recommendation_Id not member of v_Recom_Ids;
  
    -- candidate possibly jobs
    delete from Href_Candidate_Jobs j
     where j.Company_Id = r_Candidate.Company_Id
       and j.Filial_Id = r_Candidate.Filial_Id
       and j.Candidate_Id = r_Candidate.Candidate_Id
       and j.Job_Id not member of i_Candidate.Candidate_Jobs;
  
    for i in 1 .. i_Candidate.Candidate_Jobs.Count
    loop
      z_Href_Candidate_Jobs.Insert_Try(i_Company_Id   => r_Candidate.Company_Id,
                                       i_Filial_Id    => r_Candidate.Filial_Id,
                                       i_Candidate_Id => r_Candidate.Candidate_Id,
                                       i_Job_Id       => i_Candidate.Candidate_Jobs(i));
    end loop;
  
    -- candidate edu stages
    if v_Exists then
      select distinct e.Edu_Stage_Id
        bulk collect
        into v_Person_Edu_Stages
        from Href_Person_Edu_Stages e
       where e.Company_Id = r_Candidate.Company_Id
         and e.Person_Id = r_Candidate.Candidate_Id;
    end if;
  
    v_New_Edu_Stage_Ids := i_Candidate.Edu_Stages multiset Except v_Person_Edu_Stages;
  
    for i in 1 .. v_New_Edu_Stage_Ids.Count
    loop
      r_Edu_Stage.Company_Id          := r_Candidate.Company_Id;
      r_Edu_Stage.Person_Edu_Stage_Id := Href_Next.Person_Edu_Stage_Id;
      r_Edu_Stage.Person_Id           := r_Candidate.Candidate_Id;
      r_Edu_Stage.Edu_Stage_Id        := v_New_Edu_Stage_Ids(i);
    
      Person_Edu_Stage_Save(r_Edu_Stage);
    end loop;
  
    delete from Href_Person_Edu_Stages e
     where e.Company_Id = r_Candidate.Company_Id
       and e.Person_Id = r_Candidate.Candidate_Id
       and e.Edu_Stage_Id not member of i_Candidate.Edu_Stages;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Delete
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  ) is
  begin
    z_Href_Candidates.Delete_One(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Candidate_Id => i_Candidate_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  -- candidate form settings
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Setting_Save(i_Settings Href_Candidate_Ref_Settings%rowtype) is
  begin
    z_Href_Candidate_Ref_Settings.Save_Row(i_Settings);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Langs_Save
  (
    i_Company_Id number,
    i_Fillial_Id number,
    i_Lang_Ids   Array_Number
  ) is
    r_Candidate_Lang Href_Candidate_Langs%rowtype;
  begin
    delete from Href_Candidate_Langs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Fillial_Id
       and q.Lang_Id not member of i_Lang_Ids;
  
    r_Candidate_Lang.Company_Id := i_Company_Id;
    r_Candidate_Lang.Filial_Id  := i_Fillial_Id;
  
    for i in 1 .. i_Lang_Ids.Count
    loop
      r_Candidate_Lang.Lang_Id  := i_Lang_Ids(i);
      r_Candidate_Lang.Order_No := i;
    
      z_Href_Candidate_Langs.Save_Row(r_Candidate_Lang);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Edu_Stages_Save
  (
    i_Company_Id    number,
    i_Fillial_Id    number,
    i_Edu_Stage_Ids Array_Number
  ) is
    r_Candidate_Es Href_Candidate_Edu_Stages%rowtype;
  begin
    delete from Href_Candidate_Edu_Stages q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Fillial_Id
       and q.Edu_Stage_Id not member of i_Edu_Stage_Ids;
  
    r_Candidate_Es.Company_Id := i_Company_Id;
    r_Candidate_Es.Filial_Id  := i_Fillial_Id;
  
    for i in 1 .. i_Edu_Stage_Ids.Count
    loop
      r_Candidate_Es.Edu_Stage_Id := i_Edu_Stage_Ids(i);
      r_Candidate_Es.Order_No     := i;
    
      z_Href_Candidate_Edu_Stages.Save_Row(r_Candidate_Es);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Save(i_Employee Href_Pref.Employee_Rt) is
    r_Employee Mhr_Employees%rowtype;
    v_Exists   boolean := false;
  begin
    if z_Md_Persons.Exist_Lock(i_Company_Id => i_Employee.Person.Company_Id,
                               i_Person_Id  => i_Employee.Person.Person_Id) then
      v_Exists := true;
    end if;
  
    if Md_Pref.c_Migr_Company_Id != i_Employee.Person.Company_Id then
      Person_Save(i_Employee.Person);
    end if;
  
    if not v_Exists then
      Mrf_Api.Filial_Add_Person(i_Company_Id => i_Employee.Person.Company_Id,
                                i_Filial_Id  => i_Employee.Filial_Id,
                                i_Person_Id  => i_Employee.Person.Person_Id,
                                i_State      => 'A');
    end if;
  
    if not z_Mhr_Employees.Exist_Lock(i_Company_Id  => i_Employee.Person.Company_Id,
                                      i_Filial_Id   => i_Employee.Filial_Id,
                                      i_Employee_Id => i_Employee.Person.Person_Id,
                                      o_Row         => r_Employee) then
      r_Employee.Company_Id  := i_Employee.Person.Company_Id;
      r_Employee.Filial_Id   := i_Employee.Filial_Id;
      r_Employee.Employee_Id := i_Employee.Person.Person_Id;
    end if;
  
    r_Employee.State := i_Employee.State;
  
    Mhr_Api.Employee_Save(r_Employee);
  
    if Htt_Util.Location_Sync_Global_Load(i_Company_Id => r_Employee.Company_Id,
                                          i_Filial_Id  => r_Employee.Filial_Id) = 'Y' then
      Htt_Core.Person_Sync_Locations(i_Company_Id => r_Employee.Company_Id,
                                     i_Filial_Id  => r_Employee.Filial_Id,
                                     i_Person_Id  => r_Employee.Employee_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Update
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number
  ) is
  begin
    z_Mhr_Employees.Update_One(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Employee_Id => i_Employee_Id,
                               i_Division_Id => Option_Number(i_Division_Id),
                               i_Job_Id      => Option_Number(i_Job_Id),
                               i_Rank_Id     => Option_Number(i_Rank_Id));
  
    -- person update for update modified_id on z package  
    z_Md_Persons.Update_One(i_Company_Id => i_Company_Id, --
                            i_Person_Id  => i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employee_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) is
  begin
    Mhr_Api.Employee_Delete(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Employee_Id => i_Employee_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Save(i_Fixed_Term_Base Href_Fixed_Term_Bases%rowtype) is
  begin
    z_Href_Fixed_Term_Bases.Save_Row(i_Fixed_Term_Base);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fixed_Term_Base_Delete
  (
    i_Company_Id         number,
    i_Fixed_Term_Base_Id number
  ) is
  begin
    z_Href_Fixed_Term_Bases.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Fixed_Term_Base_Id => i_Fixed_Term_Base_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Save(i_Edu_Stage Href_Edu_Stages%rowtype) is
  begin
    z_Href_Edu_Stages.Save_Row(i_Edu_Stage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Delete
  (
    i_Company_Id   number,
    i_Edu_Stage_Id number
  ) is
  begin
    z_Href_Edu_Stages.Delete_One(i_Company_Id => i_Company_Id, i_Edu_Stage_Id => i_Edu_Stage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Save(i_Science_Branch Href_Science_Branches%rowtype) is
  begin
    z_Href_Science_Branches.Save_Row(i_Science_Branch);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Delete
  (
    i_Company_Id        number,
    i_Science_Branch_Id number
  ) is
  begin
    z_Href_Science_Branches.Delete_One(i_Company_Id        => i_Company_Id,
                                       i_Science_Branch_Id => i_Science_Branch_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Save(i_Institution Href_Institutions%rowtype) is
  begin
    z_Href_Institutions.Save_Row(i_Institution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Delete
  (
    i_Company_Id     number,
    i_Institution_Id number
  ) is
  begin
    z_Href_Institutions.Delete_One(i_Company_Id     => i_Company_Id,
                                   i_Institution_Id => i_Institution_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Save(i_Specialty Href_Specialties%rowtype) is
    r_Specialty Href_Specialties%rowtype;
  begin
    if z_Href_Specialties.Exist_Lock(i_Company_Id   => i_Specialty.Company_Id,
                                     i_Specialty_Id => i_Specialty.Specialty_Id,
                                     o_Row          => r_Specialty) then
      if i_Specialty.Kind <> r_Specialty.Kind then
        Href_Error.Raise_001(i_Specialty_Id   => i_Specialty.Specialty_Id,
                             i_Specialty_Name => i_Specialty.Name);
      end if;
    end if;
  
    if i_Specialty.Parent_Id is not null then
      r_Specialty := z_Href_Specialties.Lock_Load(i_Company_Id   => i_Specialty.Company_Id,
                                                  i_Specialty_Id => i_Specialty.Parent_Id);
    
      if r_Specialty.Kind <> Href_Pref.c_Specialty_Kind_Group then
        Href_Error.Raise_002(i_Specialty_Id   => i_Specialty.Specialty_Id,
                             i_Specialty_Name => i_Specialty.Name,
                             i_Parent_Name    => r_Specialty.Name);
      end if;
    end if;
  
    z_Href_Specialties.Save_Row(i_Specialty);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Delete
  (
    i_Company_Id   number,
    i_Specialty_Id number
  ) is
  begin
    z_Href_Specialties.Delete_One(i_Company_Id => i_Company_Id, i_Specialty_Id => i_Specialty_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Save(i_Lang Href_Langs%rowtype) is
  begin
    z_Href_Langs.Save_Row(i_Lang);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Delete
  (
    i_Company_Id number,
    i_Lang_Id    number
  ) is
  begin
    z_Href_Langs.Delete_One(i_Company_Id => i_Company_Id, i_Lang_Id => i_Lang_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Save(i_Lang_Level Href_Lang_Levels%rowtype) is
  begin
    z_Href_Lang_Levels.Save_Row(i_Lang_Level);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Delete
  (
    i_Company_Id    number,
    i_Lang_Level_Id number
  ) is
  begin
    z_Href_Lang_Levels.Delete_One(i_Company_Id => i_Company_Id, i_Lang_Level_Id => i_Lang_Level_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Save(i_Document_Type Href_Document_Types%rowtype) is
    r_Document_Type Href_Document_Types%rowtype;
  begin
    if z_Href_Document_Types.Exist_Lock(i_Company_Id  => i_Document_Type.Company_Id,
                                        i_Doc_Type_Id => i_Document_Type.Doc_Type_Id,
                                        o_Row         => r_Document_Type) then
      if r_Document_Type.Pcode is not null then
        Href_Error.Raise_003(i_Document_Type_Id   => i_Document_Type.Doc_Type_Id,
                             i_Document_Type_Name => i_Document_Type.Name);
      end if;
    end if;
  
    z_Href_Document_Types.Save_Row(i_Document_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Update_Is_Required
  (
    i_Company_Id  number,
    i_Doc_Type_Id number,
    i_Is_Required varchar2
  ) is
  begin
    z_Href_Document_Types.Update_One(i_Company_Id  => i_Company_Id,
                                     i_Doc_Type_Id => i_Doc_Type_Id,
                                     i_Is_Required => Option_Varchar2(i_Is_Required));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Delete
  (
    i_Company_Id  number,
    i_Doc_Type_Id number
  ) is
    r_Document_Type Href_Document_Types%rowtype;
  begin
    if z_Href_Document_Types.Exist(i_Company_Id  => i_Company_Id,
                                   i_Doc_Type_Id => i_Doc_Type_Id,
                                   o_Row         => r_Document_Type) then
      if r_Document_Type.Pcode is not null then
        Href_Error.Raise_004(i_Document_Type_Id   => r_Document_Type.Doc_Type_Id,
                             i_Document_Type_Name => r_Document_Type.Name);
      end if;
    end if;
  
    z_Href_Document_Types.Delete_One(i_Company_Id => i_Company_Id, i_Doc_Type_Id => i_Doc_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Save
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Division_Id  number,
    i_Job_Id       number,
    i_Doc_Type_Ids Array_Number
  ) is
  begin
    for i in 1 .. i_Doc_Type_Ids.Count
    loop
      z_Href_Excluded_Document_Types.Insert_Try(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Division_Id => i_Division_Id,
                                                i_Job_Id      => i_Job_Id,
                                                i_Doc_Type_Id => i_Doc_Type_Ids(i));
    end loop;
  
    delete from Href_Excluded_Document_Types t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Division_Id = i_Division_Id
       and t.Job_Id = i_Job_Id
       and t.Doc_Type_Id not member of i_Doc_Type_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Excluded_Document_Type_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  ) is
  begin
    Excluded_Document_Type_Save(i_Company_Id   => i_Company_Id,
                                i_Filial_Id    => i_Filial_Id,
                                i_Division_Id  => i_Division_Id,
                                i_Job_Id       => i_Job_Id,
                                i_Doc_Type_Ids => Array_Number());
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Save(i_Reference_Type Href_Reference_Types%rowtype) is
  begin
    z_Href_Reference_Types.Save_Row(i_Reference_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Delete
  (
    i_Company_Id        number,
    i_Reference_Type_Id number
  ) is
  begin
    z_Href_Reference_Types.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Reference_Type_Id => i_Reference_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Save(i_Relation_Degree Href_Relation_Degrees%rowtype) is
  begin
    z_Href_Relation_Degrees.Save_Row(i_Relation_Degree);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Delete
  (
    i_Company_Id         number,
    i_Relation_Degree_Id number
  ) is
  begin
    z_Href_Relation_Degrees.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Relation_Degree_Id => i_Relation_Degree_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Save(i_Marital_Status Href_Marital_Statuses%rowtype) is
  begin
    z_Href_Marital_Statuses.Save_Row(i_Marital_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Delete
  (
    i_Company_Id        number,
    i_Marital_Status_Id number
  ) is
  begin
    z_Href_Marital_Statuses.Delete_One(i_Company_Id        => i_Company_Id,
                                       i_Marital_Status_Id => i_Marital_Status_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Save(i_Experience_Type Href_Experience_Types%rowtype) is
  begin
    z_Href_Experience_Types.Save_Row(i_Experience_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Delete
  (
    i_Company_Id         number,
    i_Experience_Type_Id number
  ) is
  begin
    z_Href_Experience_Types.Delete_One(i_Company_Id         => i_Company_Id,
                                       i_Experience_Type_Id => i_Experience_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Save(i_Nationality Href_Nationalities%rowtype) is
  begin
    z_Href_Nationalities.Save_Row(i_Nationality);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Nationality_Delete
  (
    i_Company_Id     number,
    i_Nationality_Id number
  ) is
  begin
    z_Href_Nationalities.Delete_One(i_Company_Id     => i_Company_Id,
                                    i_Nationality_Id => i_Nationality_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Award_Save(i_Award Href_Awards%rowtype) is
  begin
    z_Href_Awards.Save_Row(i_Award);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Award_Delete
  (
    i_Company_Id number,
    i_Award_Id   number
  ) is
  begin
    z_Href_Awards.Delete_One(i_Company_Id => i_Company_Id, i_Award_Id => i_Award_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Save(i_Inventory_Type Href_Inventory_Types%rowtype) is
  begin
    z_Href_Inventory_Types.Save_Row(i_Inventory_Type);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Inventory_Type_Delete
  (
    i_Company_Id        number,
    i_Inventory_Type_Id number
  ) is
  begin
    z_Href_Inventory_Types.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Inventory_Type_Id => i_Inventory_Type_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Save
  (
    i_Person                 Href_Pref.Person_Rt,
    i_Only_Natural           boolean := false,
    i_Check_Required_Columns boolean := true
  ) is
    r_Natural_Person Mr_Natural_Persons%rowtype;
    r_Person_Detail  Mr_Person_Details%rowtype;
    r_Detail         Href_Person_Details%rowtype;
    v_Phone          varchar2(25) := Regexp_Replace(i_Person.Main_Phone, '\D', '');
  
    --------------------------------------------------
    Procedure Check_Required_Columns is
      v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
    begin
      if not i_Check_Required_Columns then
        return;
      end if;
    
      v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(i_Person.Company_Id);
    
      if v_Col_Required_Settings.Last_Name = 'Y' and trim(i_Person.Last_Name) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Last_Name);
      end if;
    
      if v_Col_Required_Settings.Middle_Name = 'Y' and trim(i_Person.Middle_Name) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Middle_Name);
      end if;
    
      if v_Col_Required_Settings.Birthday = 'Y' and i_Person.Birthday is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Birthday);
      end if;
    
      if v_Col_Required_Settings.Phone_Number = 'Y' and trim(v_Phone) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Phone_Number);
      end if;
    
      if v_Col_Required_Settings.Email = 'Y' and trim(i_Person.Email) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Email);
      end if;
    
      if v_Col_Required_Settings.Region = 'Y' and i_Person.Region_Id is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Region);
      end if;
    
      if v_Col_Required_Settings.Address = 'Y' and trim(i_Person.Address) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Address);
      end if;
    
      if v_Col_Required_Settings.Legal_Address = 'Y' and trim(i_Person.Legal_Address) is null then
        Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Legal_Address);
      end if;
    end;
  begin
    -- check required columns
    Check_Required_Columns;
  
    -- natural person save
    r_Natural_Person := z_Mr_Natural_Persons.Take(i_Company_Id => i_Person.Company_Id,
                                                  i_Person_Id  => i_Person.Person_Id);
  
    r_Natural_Person.Company_Id  := i_Person.Company_Id;
    r_Natural_Person.Person_Id   := i_Person.Person_Id;
    r_Natural_Person.First_Name  := i_Person.First_Name;
    r_Natural_Person.Last_Name   := i_Person.Last_Name;
    r_Natural_Person.Middle_Name := i_Person.Middle_Name;
    r_Natural_Person.Gender      := i_Person.Gender;
    r_Natural_Person.Birthday    := i_Person.Birthday;
    r_Natural_Person.State       := i_Person.State;
    r_Natural_Person.Code        := i_Person.Code;
  
    Mr_Api.Natural_Person_Save(r_Natural_Person);
  
    Md_Api.Person_Update(i_Company_Id => r_Natural_Person.Company_Id,
                         i_Person_Id  => r_Natural_Person.Person_Id,
                         i_Email      => Option_Varchar2(i_Person.Email),
                         i_Phone      => Option_Varchar2(v_Phone),
                         i_Photo_Sha  => Option_Varchar2(i_Person.Photo_Sha));
  
    -- person detail save
    r_Person_Detail := z_Mr_Person_Details.Take(i_Company_Id => i_Person.Company_Id,
                                                i_Person_Id  => i_Person.Person_Id);
  
    r_Person_Detail.Company_Id     := i_Person.Company_Id;
    r_Person_Detail.Person_Id      := i_Person.Person_Id;
    r_Person_Detail.Tin            := i_Person.Tin;
    r_Person_Detail.Main_Phone     := i_Person.Main_Phone;
    r_Person_Detail.Address        := i_Person.Address;
    r_Person_Detail.Legal_Address  := i_Person.Legal_Address;
    r_Person_Detail.Region_Id      := i_Person.Region_Id;
    r_Person_Detail.Note           := i_Person.Note;
    r_Person_Detail.Is_Budgetarian := 'Y';
  
    Mr_Api.Person_Detail_Save(r_Person_Detail);
  
    r_Detail := z_Href_Person_Details.Take(i_Company_Id => i_Person.Company_Id,
                                           i_Person_Id  => i_Person.Person_Id);
  
    if not i_Only_Natural then
      if i_Person.Access_All_Employees is not null then
        r_Detail.Access_All_Employees := i_Person.Access_All_Employees;
      else
        r_Detail.Access_All_Employees := Nvl(r_Detail.Access_All_Employees, 'N');
      end if;
    
      r_Detail.Company_Id           := i_Person.Company_Id;
      r_Detail.Person_Id            := i_Person.Person_Id;
      r_Detail.Iapa                 := i_Person.Iapa;
      r_Detail.Npin                 := i_Person.Npin;
      r_Detail.Nationality_Id       := i_Person.Nationality_Id;
      r_Detail.Key_Person           := i_Person.Key_Person;
      r_Detail.Extra_Phone          := i_Person.Extra_Phone;
      r_Detail.Corporate_Email      := i_Person.Corporate_Email;
      r_Detail.Access_All_Employees := r_Detail.Access_All_Employees;
      r_Detail.Access_Hidden_Salary := Coalesce(i_Person.Access_Hidden_Salary,
                                                r_Detail.Access_Hidden_Salary,
                                                'N');
    
      Person_Detail_Save(r_Detail);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Delete
  (
    i_Company_Id number,
    i_Person_Id  number
  ) is
  begin
    Md_Api.User_Delete(i_Company_Id => i_Company_Id, i_User_Id => i_Person_Id);
    Mr_Api.Natural_Person_Delete(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Save
  (
    i_Person_Detail Href_Person_Details%rowtype,
    i_Requirable    boolean := true
  ) is
    r_Person_Detail         Href_Person_Details%rowtype := i_Person_Detail;
    v_Col_Required_Settings Href_Pref.Col_Required_Setting_Rt;
  begin
    v_Col_Required_Settings := Href_Util.Load_Col_Required_Settings(r_Person_Detail.Company_Id);
  
    if i_Requirable and v_Col_Required_Settings.Npin = 'Y' and trim(r_Person_Detail.Npin) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Npin);
    end if;
  
    if i_Requirable and v_Col_Required_Settings.Iapa = 'Y' and trim(r_Person_Detail.Iapa) is null then
      Href_Error.Raise_028(Href_Pref.c_Pref_Crs_Iapa);
    end if;
  
    r_Person_Detail.Key_Person           := Nvl(r_Person_Detail.Key_Person, 'N');
    r_Person_Detail.Access_All_Employees := Nvl(r_Person_Detail.Access_All_Employees, 'N');
    r_Person_Detail.Access_Hidden_Salary := Nvl(r_Person_Detail.Access_Hidden_Salary, 'N');
  
    z_Href_Person_Details.Save_Row(r_Person_Detail);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Save(i_Person_Edu_Stage Href_Person_Edu_Stages%rowtype) is
    r_Person_Edu_Stage Href_Person_Edu_Stages%rowtype;
  begin
    if z_Href_Person_Edu_Stages.Exist_Lock(i_Company_Id          => i_Person_Edu_Stage.Company_Id,
                                           i_Person_Edu_Stage_Id => i_Person_Edu_Stage.Person_Edu_Stage_Id,
                                           o_Row                 => r_Person_Edu_Stage) then
      if r_Person_Edu_Stage.Person_Id <> i_Person_Edu_Stage.Person_Id then
        Href_Error.Raise_005(i_Person_Edu_Stage_Id => i_Person_Edu_Stage.Person_Edu_Stage_Id);
      end if;
    end if;
  
    z_Href_Person_Edu_Stages.Save_Row(i_Person_Edu_Stage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number
  ) is
  begin
    z_Href_Person_Edu_Stages.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Save
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
    
  ) is
  begin
    z_Href_Person_Edu_Stage_Files.Insert_Try(i_Company_Id          => i_Company_Id,
                                             i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id,
                                             i_Sha                 => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Edu_Stage_File_Delete
  (
    i_Company_Id          number,
    i_Person_Edu_Stage_Id number,
    i_Sha                 varchar2
  ) is
  begin
    z_Href_Person_Edu_Stage_Files.Delete_One(i_Company_Id          => i_Company_Id,
                                             i_Person_Edu_Stage_Id => i_Person_Edu_Stage_Id,
                                             i_Sha                 => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Save(i_Person_Lang Href_Person_Langs%rowtype) is
  begin
    z_Href_Person_Langs.Save_Row(i_Person_Lang);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Lang_Delete
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Lang_Id    number
  ) is
  begin
    z_Href_Person_Langs.Delete_One(i_Company_Id => i_Company_Id,
                                   i_Person_Id  => i_Person_Id,
                                   i_Lang_Id    => i_Lang_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Save(i_Person_Reference Href_Person_References%rowtype) is
    r_Person_Reference Href_Person_References%rowtype;
  begin
    if z_Href_Person_References.Exist_Lock(i_Company_Id          => i_Person_Reference.Company_Id,
                                           i_Person_Reference_Id => i_Person_Reference.Person_Reference_Id,
                                           o_Row                 => r_Person_Reference) then
      if r_Person_Reference.Person_Id <> i_Person_Reference.Person_Id then
        Href_Error.Raise_009(i_Person_Reference_Id => i_Person_Reference.Person_Reference_Id);
      end if;
    end if;
  
    z_Href_Person_References.Save_Row(i_Person_Reference);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Reference_Delete
  (
    i_Company_Id          number,
    i_Person_Reference_Id number
  ) is
  begin
    z_Href_Person_References.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Person_Reference_Id => i_Person_Reference_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Save(i_Person_Family_Member Href_Person_Family_Members%rowtype) is
    r_Person_Family_Member Href_Person_Family_Members%rowtype;
  begin
    if z_Href_Person_Family_Members.Exist_Lock(i_Company_Id              => i_Person_Family_Member.Company_Id,
                                               i_Person_Family_Member_Id => i_Person_Family_Member.Person_Family_Member_Id,
                                               o_Row                     => r_Person_Family_Member) then
      if r_Person_Family_Member.Person_Id <> i_Person_Family_Member.Person_Id then
        Href_Error.Raise_010(i_Person_Family_Member_Id => i_Person_Family_Member.Person_Family_Member_Id);
      end if;
    end if;
  
    z_Href_Person_Family_Members.Save_Row(i_Person_Family_Member);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Family_Member_Delete
  (
    i_Company_Id              number,
    i_Person_Family_Member_Id number
  ) is
  begin
    z_Href_Person_Family_Members.Delete_One(i_Company_Id              => i_Company_Id,
                                            i_Person_Family_Member_Id => i_Person_Family_Member_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Save(i_Person_Marital_Status Href_Person_Marital_Statuses%rowtype) is
    r_Person_Marital_Status Href_Person_Marital_Statuses%rowtype;
  begin
    if z_Href_Person_Marital_Statuses.Exist_Lock(i_Company_Id               => i_Person_Marital_Status.Company_Id,
                                                 i_Person_Marital_Status_Id => i_Person_Marital_Status.Person_Marital_Status_Id,
                                                 o_Row                      => r_Person_Marital_Status) then
      if r_Person_Marital_Status.Person_Id <> i_Person_Marital_Status.Person_Id then
        Href_Error.Raise_011(i_Person_Marital_Status_Id => i_Person_Marital_Status.Person_Marital_Status_Id);
      end if;
    end if;
  
    z_Href_Person_Marital_Statuses.Save_Row(i_Person_Marital_Status);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Marital_Status_Delete
  (
    i_Company_Id               number,
    i_Person_Marital_Status_Id number
  ) is
  begin
    z_Href_Person_Marital_Statuses.Delete_One(i_Company_Id               => i_Company_Id,
                                              i_Person_Marital_Status_Id => i_Person_Marital_Status_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Save(i_Person_Experience Href_Person_Experiences%rowtype) is
    r_Person_Experience Href_Person_Experiences%rowtype;
  begin
    if z_Href_Person_Experiences.Exist_Lock(i_Company_Id           => i_Person_Experience.Company_Id,
                                            i_Person_Experience_Id => i_Person_Experience.Person_Experience_Id,
                                            o_Row                  => r_Person_Experience) then
      if r_Person_Experience.Person_Id <> i_Person_Experience.Person_Id then
        Href_Error.Raise_012(i_Person_Experience_Id => i_Person_Experience.Person_Experience_Id);
      end if;
    end if;
  
    r_Person_Experience.Company_Id           := i_Person_Experience.Company_Id;
    r_Person_Experience.Person_Experience_Id := i_Person_Experience.Person_Experience_Id;
    r_Person_Experience.Person_Id            := i_Person_Experience.Person_Id;
    r_Person_Experience.Experience_Type_Id   := i_Person_Experience.Experience_Type_Id;
    r_Person_Experience.Is_Working           := i_Person_Experience.Is_Working;
    r_Person_Experience.Start_Date           := i_Person_Experience.Start_Date;
  
    if r_Person_Experience.Is_Working = 'N' then
      r_Person_Experience.Num_Year  := Nvl(i_Person_Experience.Num_Year, 0);
      r_Person_Experience.Num_Month := Nvl(i_Person_Experience.Num_Month, 0);
      r_Person_Experience.Num_Day   := Nvl(i_Person_Experience.Num_Day, 0);
    else
      r_Person_Experience.Num_Year  := null;
      r_Person_Experience.Num_Month := null;
      r_Person_Experience.Num_Day   := null;
    end if;
  
    z_Href_Person_Experiences.Save_Row(r_Person_Experience);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Experience_Delete
  (
    i_Company_Id           number,
    i_Person_Experience_Id number
  ) is
  begin
    z_Href_Person_Experiences.Delete_One(i_Company_Id           => i_Company_Id,
                                         i_Person_Experience_Id => i_Person_Experience_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Save(i_Person_Award Href_Person_Awards%rowtype) is
    r_Person_Award Href_Person_Awards%rowtype;
  begin
    if z_Href_Person_Awards.Exist_Lock(i_Company_Id      => i_Person_Award.Company_Id,
                                       i_Person_Award_Id => i_Person_Award.Person_Award_Id,
                                       o_Row             => r_Person_Award) then
      if r_Person_Award.Person_Id <> i_Person_Award.Person_Id then
        Href_Error.Raise_013(i_Person_Award_Id => i_Person_Award.Person_Award_Id);
      end if;
    end if;
  
    z_Href_Person_Awards.Save_Row(i_Person_Award);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Award_Delete
  (
    i_Company_Id      number,
    i_Person_Award_Id number
  ) is
  begin
    z_Href_Person_Awards.Delete_One(i_Company_Id      => i_Company_Id,
                                    i_Person_Award_Id => i_Person_Award_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Save(i_Person_Work_Place Href_Person_Work_Places%rowtype) is
    r_Person_Work_Place Href_Person_Work_Places%rowtype;
  begin
    if z_Href_Person_Work_Places.Exist_Lock(i_Company_Id           => i_Person_Work_Place.Company_Id,
                                            i_Person_Work_Place_Id => i_Person_Work_Place.Person_Work_Place_Id,
                                            o_Row                  => r_Person_Work_Place) then
      if r_Person_Work_Place.Person_Id <> i_Person_Work_Place.Person_Id then
        Href_Error.Raise_014(i_Person_Work_Place_Id => i_Person_Work_Place.Person_Work_Place_Id);
      end if;
    end if;
  
    z_Href_Person_Work_Places.Save_Row(i_Person_Work_Place);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Work_Place_Delete
  (
    i_Company_Id           number,
    i_Person_Work_Place_Id number
  ) is
  begin
    z_Href_Person_Work_Places.Delete_One(i_Company_Id           => i_Company_Id,
                                         i_Person_Work_Place_Id => i_Person_Work_Place_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Save(i_Document Href_Person_Documents%rowtype) is
    r_Doc Href_Person_Documents%rowtype;
  begin
    if z_Href_Person_Documents.Exist_Lock(i_Company_Id  => i_Document.Company_Id,
                                          i_Document_Id => i_Document.Document_Id,
                                          o_Row         => r_Doc) then
      if r_Doc.Person_Id <> i_Document.Person_Id then
        Href_Error.Raise_015(i_Document_Id => i_Document.Document_Id);
      end if;
    end if;
  
    z_Href_Person_Documents.Save_Row(i_Document);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_New
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_New),
                                       i_Rejected_Note => Option_Varchar2(''));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Approved
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_Approved),
                                       i_Rejected_Note => Option_Varchar2(''));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Status_Rejected
  (
    i_Company_Id    number,
    i_Document_Id   number,
    i_Rejected_Note varchar2
  ) is
  begin
    z_Href_Person_Documents.Update_One(i_Company_Id    => i_Company_Id,
                                       i_Document_Id   => i_Document_Id,
                                       i_Status        => Option_Varchar2(Href_Pref.c_Person_Document_Status_Rejected),
                                       i_Rejected_Note => Option_Varchar2(i_Rejected_Note));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_Delete
  (
    i_Company_Id  number,
    i_Document_Id number
  ) is
  begin
    z_Href_Person_Documents.Delete_One(i_Company_Id  => i_Company_Id,
                                       i_Document_Id => i_Document_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_File_Save
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  ) is
  begin
    z_Href_Person_Document_Files.Insert_Try(i_Company_Id  => i_Company_Id,
                                            i_Document_Id => i_Document_Id,
                                            i_Sha         => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Document_File_Delete
  (
    i_Company_Id  number,
    i_Document_Id number,
    i_Sha         varchar2
  ) is
  begin
    z_Href_Person_Document_Files.Delete_One(i_Company_Id  => i_Company_Id,
                                            i_Document_Id => i_Document_Id,
                                            i_Sha         => i_Sha);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Save(i_Person_Inventory Href_Person_Inventories%rowtype) is
  begin
    z_Href_Person_Inventories.Save_Row(i_Person_Inventory);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Inventory_Delete
  (
    i_Company_Id          number,
    i_Person_Inventory_Id number
  ) is
  begin
    z_Href_Person_Inventories.Delete_One(i_Company_Id          => i_Company_Id,
                                         i_Person_Inventory_Id => i_Person_Inventory_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Hidden_Salary_Job_Groups_Save
  (
    i_Company_Id    number,
    i_Person_Id     number,
    i_Job_Group_Ids Array_Number
  ) is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, --
                                       i_Filial_Id  => Md_Env.Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      for i in 1 .. i_Job_Group_Ids.Count
      loop
        z_Href_Person_Hidden_Salary_Job_Groups.Insert_Try(i_Company_Id   => i_Company_Id,
                                                          i_Person_Id    => i_Person_Id,
                                                          i_Job_Group_Id => i_Job_Group_Ids(i));
      end loop;
    
      delete Href_Person_Hidden_Salary_Job_Groups q
       where q.Company_Id = i_Company_Id
         and q.Person_Id = i_Person_Id
         and q.Job_Group_Id not member of i_Job_Group_Ids;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Save(i_Labor_Function Href_Labor_Functions%rowtype) is
  begin
    z_Href_Labor_Functions.Save_Row(i_Labor_Function);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Delete
  (
    i_Company_Id        number,
    i_Labor_Function_Id number
  ) is
  begin
    z_Href_Labor_Functions.Delete_One(i_Company_Id        => i_Company_Id,
                                      i_Labor_Function_Id => i_Labor_Function_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Save(i_Sick_Leave_Reason Href_Sick_Leave_Reasons%rowtype) is
  begin
    z_Href_Sick_Leave_Reasons.Save_Row(i_Sick_Leave_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  ) is
  begin
    z_Href_Sick_Leave_Reasons.Delete_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Reason_Id  => i_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Save(i_Business_Trip_Reason Href_Business_Trip_Reasons%rowtype) is
  begin
    z_Href_Business_Trip_Reasons.Save_Row(i_Business_Trip_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Reason_Id  number
  ) is
  begin
    z_Href_Business_Trip_Reasons.Delete_One(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Reason_Id  => i_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Save(i_Dismissal_Reason Href_Dismissal_Reasons%rowtype) is
  begin
    z_Href_Dismissal_Reasons.Save_Row(i_Dismissal_Reason);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Delete
  (
    i_Company_Id          number,
    i_Dismissal_Reason_Id number
  ) is
  begin
    z_Href_Dismissal_Reasons.Delete_One(i_Company_Id          => i_Company_Id,
                                        i_Dismissal_Reason_Id => i_Dismissal_Reason_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Save(i_Wage Href_Wages%rowtype) is
  begin
    z_Href_Wages.Save_Row(i_Wage);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Wage_Id    number
  ) is
  begin
    z_Href_Wages.Delete_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Wage_Id    => i_Wage_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Save(i_Employment_Source Href_Employment_Sources%rowtype) is
  begin
    z_Href_Employment_Sources.Save_Row(i_Employment_Source);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Delete
  (
    i_Company_Id number,
    i_Source_Id  number
  ) is
  begin
    z_Href_Employment_Sources.Delete_One(i_Company_Id => i_Company_Id, i_Source_Id => i_Source_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Save(i_Indicator Href_Indicators%rowtype) is
  begin
    Href_Core.Indicator_Save(i_Indicator);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Delete
  (
    i_Company_Id   number,
    i_Indicator_Id number
  ) is
    r_Indicator Href_Indicators%rowtype;
  begin
    r_Indicator := z_Href_Indicators.Load(i_Company_Id   => i_Company_Id,
                                          i_Indicator_Id => i_Indicator_Id);
  
    if r_Indicator.Pcode is not null then
      Href_Error.Raise_016(i_Indicator_Id   => r_Indicator.Indicator_Id,
                           i_Indicator_Name => r_Indicator.Name);
    end if;
  
    z_Href_Indicators.Delete_One(i_Company_Id => i_Company_Id, i_Indicator_Id => i_Indicator_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Save(i_Fte Href_Ftes%rowtype) is
    r_Fte       Href_Ftes%rowtype;
    v_Pcode     Href_Ftes.Pcode%type;
    v_Fte_Value number := i_Fte.Fte_Value;
  begin
    if z_Href_Ftes.Exist_Lock(i_Company_Id => i_Fte.Company_Id,
                              i_Fte_Id     => i_Fte.Fte_Id,
                              o_Row        => r_Fte) and r_Fte.Pcode is not null then
      v_Fte_Value := r_Fte.Fte_Value;
      v_Pcode     := r_Fte.Pcode;
    end if;
  
    r_Fte           := i_Fte;
    r_Fte.Fte_Value := v_Fte_Value;
    r_Fte.Pcode     := v_Pcode;
  
    z_Href_Ftes.Save_Row(r_Fte);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Delete
  (
    i_Company_Id number,
    i_Fte_Id     number
  ) is
    r_Fte Href_Ftes%rowtype;
  begin
    if z_Href_Ftes.Exist_Lock(i_Company_Id => i_Company_Id, i_Fte_Id => i_Fte_Id, o_Row => r_Fte) then
      if r_Fte.Pcode is not null then
        Href_Error.Raise_017(i_Fte_Id => r_Fte.Fte_Id, i_Fte_Name => r_Fte.Name);
      end if;
    
      z_Href_Ftes.Delete_One(i_Company_Id => i_Company_Id, i_Fte_Id => i_Fte_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Col_Required_Setting_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Col_Required_Setting_Rt
  ) is
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
  
    --------------------------------------------------
    Procedure Save_Pref
    (
      i_Code  varchar2,
      i_Value varchar2
    ) is
    begin
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => v_Filial_Head,
                             i_Code       => i_Code,
                             i_Value      => i_Value);
    end;
  begin
    if i_Setting.Request_Note = 'Y' and
       (i_Setting.Request_Note_Limit > 300 or i_Setting.Request_Note_Limit < 1) then
      Href_Error.Raise_034(i_Setting.Request_Note_Limit);
    end if;
  
    if i_Setting.Plan_Change_Note = 'Y' and
       (i_Setting.Plan_Change_Note_Limit > 300 or i_Setting.Plan_Change_Note_Limit < 1) then
      Href_Error.Raise_035(i_Setting.Plan_Change_Note_Limit);
    end if;
  
    Save_Pref(Href_Pref.c_Pref_Crs_Last_Name, i_Setting.Last_Name);
    Save_Pref(Href_Pref.c_Pref_Crs_Middle_Name, i_Setting.Middle_Name);
    Save_Pref(Href_Pref.c_Pref_Crs_Birthday, i_Setting.Birthday);
    Save_Pref(Href_Pref.c_Pref_Crs_Phone_Number, i_Setting.Phone_Number);
    Save_Pref(Href_Pref.c_Pref_Crs_Email, i_Setting.Email);
    Save_Pref(Href_Pref.c_Pref_Crs_Region, i_Setting.Region);
    Save_Pref(Href_Pref.c_Pref_Crs_Address, i_Setting.Address);
    Save_Pref(Href_Pref.c_Pref_Crs_Legal_Address, i_Setting.Legal_Address);
    Save_Pref(Href_Pref.c_Pref_Crs_Passport, i_Setting.Passport);
    Save_Pref(Href_Pref.c_Pref_Crs_Npin, i_Setting.Npin);
    Save_Pref(Href_Pref.c_Pref_Crs_Iapa, i_Setting.Iapa);
    Save_Pref(Href_Pref.c_Pref_Crs_Request_Note, i_Setting.Request_Note);
    Save_Pref(Href_Pref.c_Pref_Crs_Request_Note_Limit, i_Setting.Request_Note_Limit);
    Save_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note, i_Setting.Plan_Change_Note);
    Save_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit, i_Setting.Plan_Change_Note_Limit);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Save(i_Badge_Template Href_Badge_Templates%rowtype) is
  begin
    z_Href_Badge_Templates.Save_Row(i_Badge_Template);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Badge_Template_Delete(i_Badge_Template_Id number) is
  begin
    z_Href_Badge_Templates.Delete_One(i_Badge_Template_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Setting_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Href_Error.Raise_031;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Pref_Vpu_Setting,
                           i_Value      => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Verify_Person_Uniqueness_Column_Save
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in (Href_Pref.c_Vpu_Column_Name,
                       Href_Pref.c_Vpu_Column_Passport_Number,
                       Href_Pref.c_Vpu_Column_Npin) then
      Href_Error.Raise_032;
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Pref_Vpu_Column,
                           i_Value      => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Limit_Save
  (
    i_Company_Id number,
    i_Setting    Href_Pref.Fte_Limit_Rt
  ) is
  begin
    if i_Setting.Fte_Limit < 0 then
      Href_Error.Raise_036(i_Setting.Fte_Limit);
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Href_Pref.c_Fte_Limit_Setting,
                           i_Value      => Nvl(i_Setting.Fte_Limit_Setting, 'N'));
  
    if i_Setting.Fte_Limit_Setting = 'Y' then
      Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                             i_Code       => Href_Pref.c_Fte_Limit,
                             i_Value      => Nvl(i_Setting.Fte_Limit, Href_Pref.c_Fte_Limit_Default));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Bank_Account_Save(i_Bank_Account Href_Pref.Bank_Account_Rt) is
    r_Bank_Account Mkcs_Bank_Accounts%rowtype;
  begin
    r_Bank_Account.Company_Id        := i_Bank_Account.Company_Id;
    r_Bank_Account.Bank_Account_Id   := i_Bank_Account.Bank_Account_Id;
    r_Bank_Account.Bank_Id           := i_Bank_Account.Bank_Id;
    r_Bank_Account.Bank_Account_Code := i_Bank_Account.Bank_Account_Code;
    r_Bank_Account.Name              := i_Bank_Account.Name;
    r_Bank_Account.Person_Id         := i_Bank_Account.Person_Id;
    r_Bank_Account.Is_Main           := i_Bank_Account.Is_Main;
    r_Bank_Account.Currency_Id       := i_Bank_Account.Currency_Id;
    r_Bank_Account.Note              := i_Bank_Account.Note;
    r_Bank_Account.State             := i_Bank_Account.State;
  
    Mkcs_Api.Bank_Account_Save(r_Bank_Account);
  
    z_Href_Bank_Accounts.Save_One(i_Company_Id      => r_Bank_Account.Company_Id,
                                  i_Bank_Account_Id => r_Bank_Account.Bank_Account_Id,
                                  i_Card_Number     => i_Bank_Account.Card_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Bank_Account_Delete
  (
    i_Company_Id      number,
    i_Bank_Account_Id number
  ) is
  begin
    Mkcs_Api.Bank_Account_Delete(i_Company_Id      => i_Company_Id,
                                 i_Bank_Account_Id => i_Bank_Account_Id);
  end;

end Href_Api;
/
