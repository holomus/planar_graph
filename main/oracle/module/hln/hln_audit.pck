create or replace package Hln_Audit is
  ----------------------------------------------------------------------------------------------------  
  Procedure Question_Group_Start(i_Company_Id number);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Question_Group_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Question_Type_Start(i_Company_Id number);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Question_Type_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Training_Subject_Start(i_Company_Id number);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Training_Subject_Stop(i_Company_Id number);
end Hln_Audit;
/
create or replace package body Hln_Audit is
  ----------------------------------------------------------------------------------------------------  
  Procedure Question_Group_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HLN_QUESTION_GROUPS',
                           i_Column_List => 'QUESTION_GROUP_ID,NAME,CODE,IS_REQUIRED,ORDER_NO,STATE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HLN_QUESTION_GROUPS_I1',
                              i_Table_Name  => 'HLN_QUESTION_GROUPS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,QUESTION_GROUP_ID,T_CONTEXT_ID');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Question_Group_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HLN_QUESTION_GROUPS');
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Question_Type_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HLN_QUESTION_TYPES',
                           i_Column_List => 'QUESTION_TYPE_ID,QUESTION_GROUP_ID,NAME,CODE,ORDER_NO,STATE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HLN_QUESTION_TYPES_I1',
                              i_Table_Name  => 'HLN_QUESTION_TYPES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,QUESTION_TYPE_ID,T_CONTEXT_ID');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Question_Type_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HLN_QUESTION_TYPES');
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Training_Subject_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HLN_TRAINING_SUBJECTS',
                           i_Column_List => 'SUBJECT_ID,NAME,CODE,STATE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HLN_TRAINING_SUBJECTS_I1',
                              i_Table_Name  => 'HLN_TRAINING_SUBJECTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,SUBJECT_ID,T_CONTEXT_ID');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Training_Subject_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HLN_TRAINING_SUBJECTS');
  end;

end Hln_Audit;
/
