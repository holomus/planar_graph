create or replace package Hper_Audit is
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Audit_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Audit_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Group_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Group_Stop(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Start(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Stop(i_Company_Id number);
end Hper_Audit;
/
create or replace package body Hper_Audit is
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Plan_Audit_Start(i_Company_Id number) is
  begin
    -- staff_plans
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPER_STAFF_PLANS',
                           i_Column_List => 'STAFF_PLAN_ID,STAFF_ID,PLAN_DATE,MAIN_CALC_TYPE,EXTRA_CALC_TYPE,MONTH_BEGIN_DATE,MONTH_END_DATE,JOURNAL_PAGE_ID,DIVISION_ID,JOB_ID,RANK_ID,EMPLOYMENT_TYPE,BEGIN_DATE,END_DATE,MAIN_PLAN_AMOUNT,EXTRA_PLAN_AMOUNT,MAIN_FACT_AMOUNT,EXTRA_FACT_AMOUNT,MAIN_FACT_PERCENT,EXTRA_FACT_PERCENT,C_MAIN_FACT_PERCENT,C_EXTRA_FACT_PERCENT,STATUS,NOTE');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_STAFF_PLANS_I1',
                              i_Table_Name  => 'HPER_STAFF_PLANS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,STAFF_PLAN_ID,T_CONTEXT_ID');
    -- staff_plan_items
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPER_STAFF_PLAN_ITEMS',
                           i_Column_List => 'STAFF_PLAN_ID,PLAN_TYPE_ID,PLAN_TYPE,PLAN_VALUE,PLAN_AMOUNT,FACT_VALUE,FACT_PERCENT,FACT_AMOUNT,CALC_KIND,NOTE,FACT_NOTE',
                           i_Parent_Name => 'HPER_STAFF_PLANS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_STAFF_PLAN_ITEMS_I1',
                              i_Table_Name  => 'HPER_STAFF_PLAN_ITEMS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,STAFF_PLAN_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_STAFF_PLAN_ITEMS_I2',
                              i_Table_Name  => 'HPER_STAFF_PLAN_ITEMS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,STAFF_PLAN_ID,PLAN_TYPE_ID,T_TIMESTAMP');
    -- staff_plan_rules
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPER_STAFF_PLAN_RULES',
                           i_Column_List => 'STAFF_PLAN_ID,PLAN_TYPE_ID,FROM_PERCENT,TO_PERCENT,FACT_AMOUNT',
                           i_Parent_Name => 'HPER_STAFF_PLANS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_STAFF_PLAN_RULES_I1',
                              i_Table_Name  => 'HPER_STAFF_PLAN_RULES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,STAFF_PLAN_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_STAFF_PLAN_RULES_I2',
                              i_Table_Name  => 'HPER_STAFF_PLAN_RULES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,STAFF_PLAN_ID,PLAN_TYPE_ID,FROM_PERCENT,T_TIMESTAMP');
    -- staff_plan_parts
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPER_STAFF_PLAN_PARTS',
                           i_Column_List => 'PART_ID,STAFF_PLAN_ID,PLAN_TYPE_ID,PART_DATE,AMOUNT,NOTE',
                           i_Parent_Name => 'HPER_STAFF_PLANS');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_STAFF_PLAN_PARTS_I1',
                              i_Table_Name  => 'HPER_STAFF_PLAN_PARTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,STAFF_PLAN_ID,T_CONTEXT_ID');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_STAFF_PLAN_PARTS_I2',
                              i_Table_Name  => 'HPER_STAFF_PLAN_PARTS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PART_ID,T_TIMESTAMP');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Staff_Plan_Audit_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPER_STAFF_PLANS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPER_STAFF_PLAN_ITEMS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPER_STAFF_PLAN_RULES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPER_STAFF_PLAN_PARTS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Group_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPER_PLAN_GROUPS',
                           i_Column_List => 'PLAN_GROUP_ID,NAME,STATE,ORDER_NO');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_PLAN_GROUPS_I1',
                              i_Table_Name  => 'HPER_PLAN_GROUPS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PLAN_GROUP_ID ,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Group_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPER_PLAN_GROUPS');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Start(i_Company_Id number) is
  begin
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPER_PLAN_TYPES',
                           i_Column_List => 'PLAN_TYPE_ID,NAME,PLAN_GROUP_ID,CALC_KIND,WITH_PART,STATE,CODE,ORDER_NO');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_PLAN_TYPES_I1',
                              i_Table_Name  => 'HPER_PLAN_TYPES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PLAN_TYPE_ID,T_CONTEXT_ID');
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPER_PLAN_TYPE_DIVISIONS',
                           i_Column_List => 'PLAN_TYPE_ID,DIVISION_ID',
                           i_Parent_Name => 'HPER_PLAN_TYPES');      
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_PLAN_TYPE_DIVISIONS_I1',
                              i_Table_Name  => 'HPER_PLAN_TYPE_DIVISIONS',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PLAN_TYPE_ID,T_CONTEXT_ID');
    Md_Api.Audit_Start_One(i_Company_Id  => i_Company_Id,
                           i_Table_Name  => 'HPER_PLAN_TYPE_TASK_TYPES',
                           i_Column_List => 'PLAN_TYPE_ID,TASK_TYPE_ID',
                           i_Parent_Name => 'HPER_PLAN_TYPES');
    Md_Api.Audit_Create_Index(i_Index_Name  => 'HPER_PLAN_TYPE_TASK_TYPES_I1',
                              i_Table_Name  => 'HPER_PLAN_TYPE_TASK_TYPES',
                              i_Column_List => 'T_COMPANY_ID,T_FILIAL_ID,PLAN_TYPE_ID,T_CONTEXT_ID');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Plan_Type_Stop(i_Company_Id number) is
  begin
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPER_PLAN_TYPES');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id, i_Table_Name => 'HPER_PLAN_TYPE_DIVISIONS');
    Md_Api.Audit_Stop_One(i_Company_Id => i_Company_Id,
                          i_Table_Name => 'HPER_PLAN_TYPE_TASK_TYPES');
  end;

end Hper_Audit;
/
