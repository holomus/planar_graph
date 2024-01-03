create or replace package Href_Audit is
  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Start(i_Company_Id number);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Edu_Stage_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Award_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Award_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Stop(i_Company_Id number);
end Href_Audit;
/
create or replace package body Href_Audit is
  ----------------------------------------------------------------------------------------------------
  Procedure Edu_Stage_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_EDU_STAGES',
                           i_Column_List => 'EDU_STAGE_ID,NAME,STATE,CODE,ORDER_NO');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_EDU_STAGES_I1',
                              i_Table_Name  => 'HREF_EDU_STAGES',
                              i_Column_List => 'T_COMPANY_ID,EDU_STAGE_ID,T_CONTEXT_ID');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Edu_Stage_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_EDU_STAGES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_SCIENCE_BRANCHES',
                           i_Column_List => 'SCIENCE_BRANCH_ID,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_SCIENCE_BRANCHES_I1',
                              i_Table_Name  => 'HREF_SCIENCE_BRANCHES',
                              i_Column_List => 'T_COMPANY_ID,SCIENCE_BRANCH_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Science_Branch_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_SCIENCE_BRANCHES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_INSTITUTIONS',
                           i_Column_List => 'INSTITUTION_ID,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_INSTITUTIONS_I1',
                              i_Table_Name  => 'HREF_INSTITUTIONS',
                              i_Column_List => 'T_COMPANY_ID,INSTITUTION_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Institution_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_ACAD_TITLES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_SPECIALTIES',
                           i_Column_List => 'SPECIALTY_ID,PARENT_ID,KIND,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_SPECIALTIES_I1',
                              i_Table_Name  => 'HREF_SPECIALTIES',
                              i_Column_List => 'T_COMPANY_ID,SPECIALTY_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Specialty_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_SPECIALTIES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_LANGS',
                           i_Column_List => 'LANG_ID,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_LANGS_I1',
                              i_Table_Name  => 'HREF_LANGS',
                              i_Column_List => 'T_COMPANY_ID,LANG_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_LANGS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_LANG_LEVELS',
                           i_Column_List => 'LANG_LEVEL_ID,NAME,STATE,ORDER_NO,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_LANG_LEVELS_I1',
                              i_Table_Name  => 'HREF_LANG_LEVELS',
                              i_Column_List => 'T_COMPANY_ID,LANG_LEVEL_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Lang_Level_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_LANGS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_DOCUMENT_TYPES',
                           i_Column_List => 'DOC_TYPE_ID,NAME,IS_REQUIRED,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_DOCUMENT_TYPES_I1',
                              i_Table_Name  => 'HREF_DOCUMENT_TYPES',
                              i_Column_List => 'T_COMPANY_ID,DOC_TYPE_ID,T_CONTEXT_ID');
  
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_EXCLUDED_DOCUMENT_TYPES',
                           i_Column_List => 'DIVISION_ID,JOB_ID,DOC_TYPE_ID',
                           i_Parent_Name => 'HREF_DOCUMENT_TYPES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Document_Type_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_DOCUMENT_TYPES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HREF_EXCLUDED_DOCUMENT_TYPES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_REFERENCE_TYPES',
                           i_Column_List => 'REFERENCE_TYPE_ID,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_REFERENCE_TYPES_I1',
                              i_Table_Name  => 'HREF_REFERENCE_TYPES',
                              i_Column_List => 'T_COMPANY_ID,REFERENCE_TYPE_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Reference_Type_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_REFERENCE_TYPES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_RELATION_DEGREES',
                           i_Column_List => 'RELATION_DEGREE_ID,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_RELATION_DEGREES_I1',
                              i_Table_Name  => 'HREF_RELATION_DEGREES',
                              i_Column_List => 'T_COMPANY_ID,RELATION_DEGREE_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Relation_Degree_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_RELATION_DEGREES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_MARITAL_STATUSES',
                           i_Column_List => 'MARITAL_STATUS_ID,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_MARITAL_STATUSES_I1',
                              i_Table_Name  => 'HREF_MARITAL_STATUSES',
                              i_Column_List => 'T_COMPANY_ID,MARITAL_STATUS_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Marital_Status_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_MARITAL_STATUSES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_EXPERIENCE_TYPES',
                           i_Column_List => 'EXPERIENCE_TYPE_ID,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_EXPERIENCE_TYPES_I1',
                              i_Table_Name  => 'HREF_EXPERIENCE_TYPES',
                              i_Column_List => 'T_COMPANY_ID,EXPERIENCE_TYPE_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Experience_Type_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_EXPERIENCE_TYPES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Award_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_AWARDS',
                           i_Column_List => 'AWARD_ID,NAME,STATE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_AWARDS_I1',
                              i_Table_Name  => 'HREF_AWARDS',
                              i_Column_List => 'T_COMPANY_ID,AWARD_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Award_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_AWARDS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_LABOR_FUNCTIONS',
                           i_Column_List => 'LABOR_FUNCTION_ID,NAME,DESCRIPTION,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_LABOR_FUNCTIONS_I1',
                              i_Table_Name  => 'HREF_LABOR_FUNCTIONS',
                              i_Column_List => 'T_COMPANY_ID,LABOR_FUNCTION_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Labor_Function_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_LABOR_FUNCTIONS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_SICK_LEAVE_REASONS',
                           i_Column_List => 'REASON_ID,NAME,COEFFICIENT,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_SICK_LEAVE_REASONS_I1',
                              i_Table_Name  => 'HREF_SICK_LEAVE_REASONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,REASON_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Reason_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_SICK_LEAVE_REASONS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_BUSINESS_TRIP_REASONS',
                           i_Column_List => 'REASON_ID,NAME,STATE,CODE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_BUSINESS_TRIP_REASONS_I1',
                              i_Table_Name  => 'HREF_BUSINESS_TRIP_REASONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,REASON_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Reason_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HREF_BUSINESS_TRIP_REASONS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_DISMISSAL_REASONS',
                           i_Column_List => 'DISMISSAL_REASON_ID,NAME,DESCRIPTION,REASON_TYPE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_DISMISSAL_REASONS_I1',
                              i_Table_Name  => 'HREF_DISMISSAL_REASONS',
                              i_Column_List => 'T_COMPANY_ID,DISMISSAL_REASON_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Reason_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_DISMISSAL_REASONS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_WAGES',
                           i_Column_List => 'WAGE_ID,JOB_ID,RANK_ID,WAGE_BEGIN,WAGE_END');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_WAGES_I1',
                              i_Table_Name  => 'HREF_WAGES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,WAGE_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_WAGES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_EMPLOYMENT_SOURCES',
                           i_Column_List => 'SOURCE_ID,NAME,KIND,ORDER_NO,STATE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_EMPLOYMENT_SOURCES_I1',
                              i_Table_Name  => 'HREF_EMPLOYMENT_SOURCES',
                              i_Column_List => 'T_COMPANY_ID,SOURCE_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Employment_Source_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_EMPLOYMENT_SOURCES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_INDICATORS',
                           i_Column_List => 'INDICATOR_ID,NAME,SHORT_NAME,IDENTIFIER,USED,STATE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_INDICATORS_I1',
                              i_Table_Name  => 'HREF_INDICATORS',
                              i_Column_List => 'T_COMPANY_ID,INDICATOR_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_INDICATORS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_FTES',
                           i_Column_List => 'FTE_ID,NAME,FTE_VALUE,ORDER_NO');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_FTES_I1',
                              i_Table_Name  => 'HREF_FTES',
                              i_Column_List => 'T_COMPANY_ID,FTE_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fte_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_FTES');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HREF_PERSON_DETAILS',
                           i_Column_List => 'PERSON_ID,EXTRA_PHONE,IAPA,NPIN,CORPORATE_EMAIL,NATIONALITY_ID,KEY_PERSON,ACCESS_ALL_EMPLOYEES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HREF_PERSON_DETAILS_I1',
                              i_Table_Name  => 'HREF_PERSON_DETAILS',
                              i_Column_List => 'T_COMPANY_ID,PERSON_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Person_Detail_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HREF_PERSON_DETAILS');
  end;

end Href_Audit;
/
