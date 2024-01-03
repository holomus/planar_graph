create or replace package Hrm_Audit is
  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Audit_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Audit_Stop(i_Company_Id number);
end Hrm_Audit;
/
create or replace package body Hrm_Audit is
  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Audit_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HRM_ROBOTS',
                           i_Column_List => 'ROBOT_ID,ORG_UNIT_ID,OPENED_DATE,CLOSED_DATE,SCHEDULE_ID,RANK_ID,LABOR_FUNCTION_ID,DESCRIPTION,HIRING_CONDITION,CONTRACTUAL_WAGE,WAGE_SCALE_ID,ACCESS_HIDDEN_SALARY,POSITION_EMPLOYMENT_KIND,CURRENCY_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HRM_ROBOTS_I1',
                              i_Table_Name  => 'HRM_ROBOTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,ROBOT_ID,T_CONTEXT_ID');
  
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HRM_ROBOT_DIVISIONS',
                           i_Column_List => 'ROBOT_ID,DIVISION_ID,ACCESS_TYPE',
                           i_Parent_Name => 'HRM_ROBOTS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HRM_ROBOT_DIVISIONS_I1',
                              i_Table_Name  => 'HRM_ROBOT_DIVISIONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,ROBOT_ID,T_CONTEXT_ID');
  
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HRM_ROBOT_OPER_TYPES',
                           i_Column_List => 'ROBOT_ID,OPER_TYPE_ID',
                           i_Parent_Name => 'HRM_ROBOTS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HRM_ROBOT_OPER_TYPES_I1',
                              i_Table_Name  => 'HRM_ROBOT_OPER_TYPES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,ROBOT_ID,T_CONTEXT_ID');
  
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HRM_ROBOT_INDICATORS',
                           i_Column_List => 'ROBOT_ID,INDICATOR_ID,INDICATOR_VALUE',
                           i_Parent_Name => 'HRM_ROBOTS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HRM_ROBOT_INDICATORS_I1',
                              i_Table_Name  => 'HRM_ROBOT_INDICATORS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,ROBOT_ID,T_CONTEXT_ID');
  
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HRM_OPER_TYPE_INDICATORS',
                           i_Column_List => 'ROBOT_ID,OPER_TYPE_ID,INDICATOR_ID',
                           i_Parent_Name => 'HRM_ROBOTS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HRM_OPER_TYPE_INDICATORS_I1',
                              i_Table_Name  => 'HRM_OPER_TYPE_INDICATORS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,ROBOT_ID,T_CONTEXT_ID');
  
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HRM_ROBOT_VACATION_LIMITS',
                           i_Column_List => 'ROBOT_ID,DAYS_LIMIT',
                           i_Parent_Name => 'HRM_ROBOTS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HRM_ROBOT_VACATION_LIMITS_I1',
                              i_Table_Name  => 'HRM_ROBOT_VACATION_LIMITS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,ROBOT_ID,T_CONTEXT_ID');
  
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HRM_ROBOT_HIDDEN_SALARY_JOB_GROUPS',
                           i_Column_List => 'ROBOT_ID,JOB_GROUP_ID',
                           i_Parent_Name => 'HRM_ROBOTS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HRM_ROBOT_HIDDEN_SALARY_JOB_GROUPS_I1',
                              i_Table_Name  => 'HRM_ROBOT_HIDDEN_SALARY_JOB_GROUPS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,ROBOT_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Audit_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HRM_ROBOTS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HRM_ROBOT_DIVISIONS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HRM_ROBOT_OPER_TYPES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HRM_ROBOT_INDICATORS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HRM_OPER_TYPE_INDICATORS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HRM_ROBOT_VACATION_LIMITS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HRM_ROBOT_HIDDEN_SALARY_JOB_GROUPS');
  end;

end Hrm_Audit;
/
