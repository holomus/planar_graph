create or replace package Hr5_Migr_Pref is
  ----------------------------------------------------------------------------------------------------
  c_Commit_Row_Count constant number := 100;
  ----------------------------------------------------------------------------------------------------
  -- md module
  ----------------------------------------------------------------------------------------------------
  c_Md_Person constant Hr5_Migr_Used_Keys.Key_Name%type := 'md_person';
  c_Md_Filial constant Hr5_Migr_Used_Keys.Key_Name%type := 'md_filial';
  ----------------------------------------------------------------------------------------------------
  -- mr module
  ----------------------------------------------------------------------------------------------------
  c_Mr_Region constant Hr5_Migr_Used_Keys.Key_Name%type := 'mr_region';
  ----------------------------------------------------------------------------------------------------
  -- ref module
  ----------------------------------------------------------------------------------------------------
  c_Ref_Personal_Document constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_personal_document';
  c_Ref_Education_Type    constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_education_type';
  c_Ref_Institution       constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_institution';
  c_Ref_Speciality        constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_speciality';
  c_Ref_Profession        constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_profession';
  c_Ref_Language          constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_language';
  c_Ref_Lang_Level        constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_lang_level';
  c_Ref_Marriage_Cond     constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_marriage_cond';
  c_Ref_Relationship      constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_relationship';
  c_Ref_Reason            constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_reason'; -- dismissal reasons
  c_Ref_Post_Type         constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_post_type'; -- job group
  c_Ref_Department_Type   constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_department_type'; -- division group
  c_Ref_Reward            constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_reward';
  c_Ref_Rank              constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_rank';
  c_Ref_Business_Reason   constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_business_reason'; -- business trip reasons
  c_Ref_Post              constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_post'; -- job
  c_Ref_Department        constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_department'; -- division
  c_Ref_Department_Group  constant Hr5_Migr_Used_Keys.Key_Name%type := 'ref_department_group'; -- division
  ----------------------------------------------------------------------------------------------------
  -- staff module
  ----------------------------------------------------------------------------------------------------
  c_Staff_Personal_Document constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_personal_document';
  c_Staff_Relationship      constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_relationship';
  c_Staff_Education         constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_education';
  c_Staff_Profession        constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_profession';
  c_Staff_Speciality        constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_speciality';
  c_Staff_Language          constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_language';
  c_Staff_Card              constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_card';
  c_Staff_Candidate         constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_candidate';
  c_Staff_Type_Bind         constant Hr5_Migr_Used_Keys.Key_Name%type := 'staff_type_bind';
  ----------------------------------------------------------------------------------------------------
  -- robot module 
  ----------------------------------------------------------------------------------------------------
  c_Robot                      constant Hr5_Migr_Used_Keys.Key_Name%type := 'robot';
  c_Robot_Assignment           constant Hr5_Migr_Used_Keys.Key_Name%type := 'robot_assignment';
  c_Robot_Assignment_Dismissal constant Hr5_Migr_Used_Keys.Key_Name%type := 'robot_assignment_dismissal';
  c_Unemployeed_Robot          constant Hr5_Migr_Used_Keys.Key_Name%type := 'unemployeed_robot';
  c_Rank_Change                constant Hr5_Migr_Used_Keys.Key_Name%type := 'rank_change';
  c_Leave_Doc                  constant Hr5_Migr_Used_Keys.Key_Name%type := 'leave_doc';
  c_Business_Trip              constant Hr5_Migr_Used_Keys.Key_Name%type := 'business_trip';
  c_Schedule_Registry_Part1    constant Hr5_Migr_Used_Keys.Key_Name%type := 'schedule_registry_part1';
  c_Schedule_Registry_Part2    constant Hr5_Migr_Used_Keys.Key_Name%type := 'schedule_registry_part2';
  c_Schedule_Registry_Part3    constant Hr5_Migr_Used_Keys.Key_Name%type := 'schedule_registry_part3';
  c_Timesheet_Adjust_Doc       constant Hr5_Migr_Used_Keys.Key_Name%type := 'timesheet_adjust_doc';
  ----------------------------------------------------------------------------------------------------
  -- learn module 
  ----------------------------------------------------------------------------------------------------
  c_Learn_Question constant Hr5_Migr_Used_Keys.Key_Name%type := 'learn_question';
  c_Learn_Option   constant Hr5_Migr_Used_Keys.Key_Name%type := 'learn_option';
  c_Learn_Train    constant Hr5_Migr_Used_Keys.Key_Name%type := 'learn_train';
  c_Learn_Test     constant Hr5_Migr_Used_Keys.Key_Name%type := 'learn_test';
  c_Learn_Testing  constant Hr5_Migr_Used_Keys.Key_Name%type := 'learn_testing';
  c_Learn_Category constant Hr5_Migr_Used_Keys.Key_Name%type := 'learn_category';
  c_Learn_Subject  constant Hr5_Migr_Used_Keys.Key_Name%type := 'learn_subject';
  ----------------------------------------------------------------------------------------------------
  c_Temp_Question_Group_Code constant varchar2(20) := 'MIGR:1';
  c_Default_Passing_Percent  constant number := 80;
  ----------------------------------------------------------------------------------------------------
  -- hrt module
  ----------------------------------------------------------------------------------------------------
  c_Hrt_Checkpoint    constant Hr5_Migr_Used_Keys.Key_Name%type := 'hrt_checkpoint';
  c_Hrt_Zktime_Device constant Hr5_Migr_Used_Keys.Key_Name%type := 'hrt_zktime_device';
  c_Hrt_Track         constant Hr5_Migr_Used_Keys.Key_Name%type := 'hrt_track';
  ----------------------------------------------------------------------------------------------------
  -- cv module
  ----------------------------------------------------------------------------------------------------
  c_Cv_Contract      constant Hr5_Migr_Used_Keys.Key_Name%type := 'cv_contract';
  c_Cv_Contract_Item constant Hr5_Migr_Used_Keys.Key_Name%type := 'cv_contract_item';
  c_Cv_Fact          constant Hr5_Migr_Used_Keys.Key_Name%type := 'cv_fact';
  c_Cv_Fact_Item     constant Hr5_Migr_Used_Keys.Key_Name%type := 'cv_fact_item';
  ----------------------------------------------------------------------------------------------------
  -- default data
  ----------------------------------------------------------------------------------------------------
  c_Default_Latlng   constant varchar2(100) := '41.31208104969048,69.25974369049074,12';
  c_Default_Accuracy constant number := 50;
  ----------------------------------------------------------------------------------------------------
  -- storing data
  ----------------------------------------------------------------------------------------------------
  g_Hr5_Migr_Keys_Store_One Fazo.Number_Code_Aat;
  g_Hr5_Migr_Keys_Store_Two Fazo.Number_Code_Aat;

  g_Inited        boolean := false;
  g_Company_Id    number;
  g_Filial_Head   number;
  g_User_System   number;
  g_Filial_Id     number;
  g_Old_Filial_Id number;
  g_Begin_Date    date := Add_Months(Trunc(sysdate, 'mon'), -2);
  g_End_Date      date := Trunc(sysdate, 'mon');
end Hr5_Migr_Pref;
/
create or replace package body Hr5_Migr_Pref is
end Hr5_Migr_Pref;
/
