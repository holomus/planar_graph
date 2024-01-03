create or replace package Href_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Fixed_Term_Base_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Edu_Stage_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Science_Branch_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Institution_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Specialty_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Lang_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Lang_Level_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Document_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Reference_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Relation_Degree_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Marital_Status_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Experience_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Nationality_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Award_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Inventory_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Edu_Stage_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Reference_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Family_Member_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Marital_Status_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Experience_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Award_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Work_Place_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Person_Document_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Person_Inventory_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Reason_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Sick_Leave_Reason_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Business_Trip_Reason_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Wage_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Employment_Source_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Staff_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Indicator_Group_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Indicator_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Fte_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Recommendation_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Badge_Template_Id return number;
end Href_Next;
/
create or replace package body Href_Next is
  ----------------------------------------------------------------------------------------------------  
  Function Fixed_Term_Base_Id return number is
  begin
    return Href_Fixed_Term_Bases_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Edu_Stage_Id return number is
  begin
    return Href_Edu_Stages_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Science_Branch_Id return number is
  begin
    return Href_Science_Branches_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Institution_Id return number is
  begin
    return Href_Institutions_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Specialty_Id return number is
  begin
    return Href_Specialties_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Lang_Id return number is
  begin
    return Href_Langs_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Lang_Level_Id return number is
  begin
    return Href_Lang_Levels_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Document_Type_Id return number is
  begin
    return Href_Document_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Reference_Type_Id return number is
  begin
    return Href_Reference_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Relation_Degree_Id return number is
  begin
    return Href_Relation_Degrees_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Marital_Status_Id return number is
  begin
    return Href_Marital_Statuses_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Experience_Type_Id return number is
  begin
    return Href_Experience_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Nationality_Id return number is
  begin
    return Href_Nationalities_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Award_Id return number is
  begin
    return Href_Awards_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Inventory_Type_Id return number is
  begin
    return Href_Inventory_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Edu_Stage_Id return number is
  begin
    return Href_Person_Edu_Stages_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Reference_Id return number is
  begin
    return Href_Person_References_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Family_Member_Id return number is
  begin
    return Href_Person_Family_Members_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Marital_Status_Id return number is
  begin
    return Href_Person_Marital_Statuses_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Experience_Id return number is
  begin
    return Href_Person_Experiences_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Award_Id return number is
  begin
    return Href_Person_Awards_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Work_Place_Id return number is
  begin
    return Href_Person_Work_Places_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Person_Document_Id return number is
  begin
    return Href_Person_Documents_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Inventory_Id return number is
  begin
    return Href_Person_Inventories_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id return number is
  begin
    return Href_Labor_Functions_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Reason_Id return number is
  begin
    return Href_Dismissal_Reasons_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Sick_Leave_Reason_Id return number is
  begin
    return Href_Sick_Leave_Reasons_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Business_Trip_Reason_Id return number is
  begin
    return Href_Business_Trip_Reasons_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_Id return number is
  begin
    return Href_Wages_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employment_Source_Id return number is
  begin
    return Href_Employment_Sources_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Staff_Id return number is
  begin
    return Href_Staffs_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Group_Id return number is
  begin
    return Href_Indicator_Groups_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Id return number is
  begin
    return Href_Indicators_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fte_Id return number is
  begin
    return Href_Ftes_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Recommendation_Id return number is
  begin
    return Href_Candidate_Recoms_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Badge_Template_Id return number is
  begin
    return Href_Badge_Templates_Sq.Nextval;
  end;

end Href_Next;
/
