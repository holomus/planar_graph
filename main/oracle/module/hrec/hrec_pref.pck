create or replace package Hrec_Pref is
  ----------------------------------------------------------------------------------------------------
  -- Funnel
  ----------------------------------------------------------------------------------------------------
  type Funnel_Rt is record(
    Company_Id number,
    Funnel_Id  number,
    name       varchar2(200 char),
    State      varchar2(1),
    Code       varchar2(50),
    Stage_Ids  Array_Number);
  ----------------------------------------------------------------------------------------------------
  -- Application
  ----------------------------------------------------------------------------------------------------  
  type Application_Rt is record(
    Company_Id         number,
    Filial_Id          number,
    Application_Id     number,
    Application_Number varchar2(50 char),
    Division_Id        number,
    Job_Id             number,
    Quantity           number,
    Wage               number,
    Responsibilities   varchar2(4000 char),
    Requirements       varchar2(4000 char),
    Status             varchar2(1),
    Note               varchar2(300 char));
  ----------------------------------------------------------------------------------------------------  
  -- Vacancy Types
  ----------------------------------------------------------------------------------------------------  
  type Vacancy_Type_Rt is record(
    Vacancy_Group_Id number,
    Vacancy_Type_Ids Array_Number);
  type Vacancy_Type_Nt is table of Vacancy_Type_Rt;
  ----------------------------------------------------------------------------------------------------  
  -- Vacancy Langs
  ----------------------------------------------------------------------------------------------------  
  type Vacancy_Lang_Rt is record(
    Lang_Id       number,
    Lang_Level_Id number);
  type Vacancy_Lang_Nt is table of Vacancy_Lang_Rt;
  ----------------------------------------------------------------------------------------------------
  -- Vacancies
  ----------------------------------------------------------------------------------------------------
  type Vacancy_Rt is record(
    Company_Id          number,
    Filial_Id           number,
    Vacancy_Id          number,
    name                varchar2(100 char),
    Division_Id         number,
    Job_Id              number,
    Application_Id      number,
    Quantity            number,
    Opened_Date         date,
    Closed_Date         date,
    Scope               varchar2(1),
    Urgent              varchar2(1),
    Funnel_Id           number,
    Region_Id           number,
    Schedule_Id         number,
    Exam_Id             number,
    Deadline            date,
    Description         varchar2(4000),
    Description_In_Html varchar2(4000),
    Wage_From           number,
    Wage_To             number,
    Status              varchar2(1),
    Recruiter_Ids       Array_Number,
    Langs               Vacancy_Lang_Nt,
    Vacancy_Types       Vacancy_Type_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Candidate Change Stage
  ----------------------------------------------------------------------------------------------------
  type Candidate_Operation_Rt is record(
    Company_Id       number,
    Filial_Id        number,
    Operation_Id     number,
    Vacancy_Id       number,
    Candidate_Id     number,
    Operation_Kind   varchar2(1),
    To_Stage_Id      number,
    Reject_Reason_Id number,
    Note             varchar2(2000));
  ----------------------------------------------------------------------------------------------------  
  -- Head Hunter Integration    
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Job_Rt is record(
    Job_Code number,
    Job_Ids  Array_Number);
  type Hh_Integration_Job_Nt is table of Hh_Integration_Job_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Region_Rt is record(
    Region_Id   number,
    Region_Code number);
  type Hh_Integration_Region_Nt is table of Hh_Integration_Region_Rt;
  ----------------------------------------------------------------------------------------------------
  type Hh_Integration_Stage_Rt is record(
    Stage_Code varchar2(50 char),
    Stage_Ids  Array_Number);
  type Hh_Integration_Stage_Nt is table of Hh_Integration_Stage_Rt;
  ----------------------------------------------------------------------------------------------------
  type Hh_Integration_Experience_Rt is record(
    Vacancy_Type_Id number,
    Experience_Code varchar2(50));
  type Hh_Integration_Experience_Nt is table of Hh_Integration_Experience_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Employments_Rt is record(
    Vacancy_Type_Id number,
    Employment_Code varchar2(50));
  type Hh_Integration_Employments_Nt is table of Hh_Integration_Employments_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Driver_Licence_Rt is record(
    Vacancy_Type_Id number,
    Licence_Code    varchar2(50));
  type Hh_Integration_Driver_Licence_Nt is table of Hh_Integration_Driver_Licence_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Schedule_Rt is record(
    Schedule_Id   number,
    Schedule_Code varchar2(50));
  type Hh_Integration_Schedule_Nt is table of Hh_Integration_Schedule_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Lang_Rt is record(
    Lang_Id   number,
    Lang_Code varchar2(50));
  type Hh_Integration_Lang_Nt is table of Hh_Integration_Lang_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Hh_Integration_Lang_Level_Rt is record(
    Lang_Level_Id   number,
    Lang_Level_Code varchar2(50));
  type Hh_Integration_Lang_Level_Nt is table of Hh_Integration_Lang_Level_Rt;
  ----------------------------------------------------------------------------------------------------
  -- OLX Integration
  ----------------------------------------------------------------------------------------------------
  type Olx_Integration_Region_Rt is record(
    Region_Id     number,
    City_Code     number,
    District_Code number);
  type Olx_Integration_Region_Nt is table of Olx_Integration_Region_Rt;
  ----------------------------------------------------------------------------------------------------  
  type Olx_Attribute_Value_Rt is record(
    Code  varchar2(50),
    Label varchar2(100));
  type Olx_Attribute_Value_Nt is table of Olx_Attribute_Value_Rt;
  ----------------------------------------------------------------------------------------------------
  type Olx_Attribute_Rt is record(
    Company_Id               number,
    Category_Code            number,
    Attribute_Code           varchar2(50),
    Label                    varchar2(200),
    Validation_Type          varchar2(50),
    Is_Required              varchar2(1),
    Is_Number                varchar2(1),
    Min_Value                number,
    Max_Value                number,
    Is_Allow_Multiple_Values varchar2(1),
    Attribute_Values         Olx_Attribute_Value_Nt);
  ----------------------------------------------------------------------------------------------------  
  type Olx_Vacancy_Attributes_Rt is record(
    Category_Code number,
    Code          varchar2(50),
    value         varchar2(50));
  type Olx_Vacancy_Attributes_Nt is table of Olx_Vacancy_Attributes_Rt;
  ----------------------------------------------------------------------------------------------------
  type Olx_Published_Vacancy_Rt is record(
    Company_Id   number,
    Filial_Id    number,
    Vacancy_Id   number,
    Vacancy_Code number,
    Attributes   Olx_Vacancy_Attributes_Nt);
  ----------------------------------------------------------------------------------------------------
  -- Application Statuses
  ----------------------------------------------------------------------------------------------------
  c_Application_Status_Draft     constant varchar2(1) := 'D';
  c_Application_Status_Waiting   constant varchar2(1) := 'W';
  c_Application_Status_Approved  constant varchar2(1) := 'A';
  c_Application_Status_Complited constant varchar2(1) := 'O';
  c_Application_Status_Canceled  constant varchar2(1) := 'C';
  ---------------------------------------------------------------------------------------------------- 
  -- Vacancy
  ----------------------------------------------------------------------------------------------------  
  c_Vacancy_Scope_All           constant varchar2(1) := 'A';
  c_Vacancy_Scope_Employees     constant varchar2(1) := 'E';
  c_Vacancy_Scope_Non_Employees constant varchar2(1) := 'N';
  ----------------------------------------------------------------------------------------------------  
  c_Vacancy_Status_Open  constant varchar2(1) := 'O';
  c_Vacancy_Status_Close constant varchar2(1) := 'C';
  ----------------------------------------------------------------------------------------------------  
  -- Operation kinds
  ----------------------------------------------------------------------------------------------------  
  c_Operation_Kind_Comment constant varchar2(1) := 'N';
  c_Operation_Kind_Action  constant varchar2(1) := 'A';
  ----------------------------------------------------------------------------------------------------
  -- System Stages
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Stage_Todo     constant varchar2(50) := 'VHR:HREC:1';
  c_Pcode_Stage_Accepted constant varchar2(50) := 'VHR:HREC:2';
  c_Pcode_Stage_Rejected constant varchar2(50) := 'VHR:HREC:3';
  ----------------------------------------------------------------------------------------------------  
  -- System Funnels
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Funnel_All constant varchar2(50) := 'VHR:HREC:1';
  ----------------------------------------------------------------------------------------------------
  -- Head Hunter Integration Preferences
  ----------------------------------------------------------------------------------------------------  
  c_Head_Hunter_Api_Url        constant varchar2(100) := 'https://api.hh.ru';
  c_Head_Hunter_Service_Name   constant varchar2(100) := 'com.verifix.vhr.recruitment.HeadHunterRuntimeService';
  c_Save_Vacancy_Url           constant varchar2(50) := '/vacancies';
  c_Negotiations_Url           constant varchar2(50) := '/negotiations';
  c_Webhook_Subscriptions_Url  constant varchar2(50) := '/webhook/subscriptions';
  c_Load_Candidate_Resume_Url  constant varchar2(50) := '/resumes';
  c_Get_General_References_Url constant varchar2(50) := '/dictionaries';
  c_Get_Jobs_Url               constant varchar2(50) := '/professional_roles';
  c_Get_Regions_Url            constant varchar2(50) := '/areas';
  c_Get_Languages_Url          constant varchar2(50) := '/languages';
  ----------------------------------------------------------------------------------------------------  
  -- Head Hunter Dictionary Keys
  ----------------------------------------------------------------------------------------------------  
  c_Dictionary_Lang_Level_Key constant varchar2(50) := 'language_level';
  c_Dictionary_Schedule_Key   constant varchar2(50) := 'schedule';
  c_Dictionary_Experience_Key constant varchar2(50) := 'experience';
  c_Dictionary_Employment_Key constant varchar2(50) := 'employment';
  c_Dictionary_Driver_Licence constant varchar2(50) := 'driver_license_types';
  ----------------------------------------------------------------------------------------------------
  -- HH Auth error code
  ---------------------------------------------------------------------------------------------------- 
  c_Hh_Error_Bad_Authorization              constant varchar2(50) := 'bad_authorization';
  c_Hh_Error_Token_Expired                  constant varchar2(50) := 'token_expired';
  c_Hh_Error_Token_Revoked                  constant varchar2(50) := 'token_revoked';
  c_Hh_Error_Application_Not_Found          constant varchar2(50) := 'application_not_found';
  c_Hh_Error_Used_Manager_Account_Forbidden constant varchar2(50) := 'used_manager_account_forbidden';
  ----------------------------------------------------------------------------------------------------
  c_Hh_Todo_Stage_Code constant varchar2(50) := 'response';
  ----------------------------------------------------------------------------------------------------
  c_Hh_Event_Type_New_Negotiation constant varchar2(50) := 'NEW_NEGOTIATION_VACANCY';
  ----------------------------------------------------------------------------------------------------  
  -- Head Hunter Billing Types
  ----------------------------------------------------------------------------------------------------  
  c_Hh_Billing_Type_Standart      constant varchar2(20) := 'standard';
  c_Hh_Billing_Type_Free          constant varchar2(20) := 'free';
  c_Hh_Billing_Type_Standart_Plus constant varchar2(20) := 'standard_plus';
  c_Hh_Billing_Type_Premium       constant varchar2(20) := 'premium';
  ----------------------------------------------------------------------------------------------------  
  -- Head Hunter Vacancy Types
  ----------------------------------------------------------------------------------------------------  
  c_Hh_Vacancy_Type_Open      constant varchar2(20) := 'open';
  c_Hh_Vacancy_Type_Closed    constant varchar2(20) := 'closed';
  c_Hh_Vacancy_Type_Direct    constant varchar2(20) := 'direct'; -- TODO do not use this type for MVP
  c_Hh_Vacancy_Type_Anonymous constant varchar2(20) := 'anonymous'; -- TODO do not use this type for MVP
  ----------------------------------------------------------------------------------------------------
  c_Hh_Default_Page_Limit constant number := 50;
  ----------------------------------------------------------------------------------------------------
  c_Hh_Gender_Male   constant varchar2(10) := 'male';
  c_Hh_Gender_Female constant varchar2(10) := 'female';
  ----------------------------------------------------------------------------------------------------
  c_Hh_Contact_Type_Phone constant varchar2(10) := 'cell';
  c_Hh_Contact_Type_Email constant varchar2(10) := 'email';
  ----------------------------------------------------------------------------------------------------
  c_Hh_Event_Receiver_Path constant varchar2(50) := '/b/vhr/hrec/hh_event_receiver:event_handler';
  ---------------------------------------------------------------------------------------------------- 
  -- OLX Integration Constants
  ----------------------------------------------------------------------------------------------------
  c_Olx_Api_Url                  constant varchar2(100) := 'https://www.olx.uz';
  c_Olx_Service_Name             constant varchar2(100) := 'com.verifix.vhr.recruitment.OlxRuntimeService';
  c_Olx_Get_Regions_Url          constant varchar2(50) := '/api/partner/regions';
  c_Olx_Get_Cities_Url           constant varchar2(50) := '/api/partner/cities';
  c_Olx_Get_Districts_Url        constant varchar2(50) := '/api/partner/districts';
  c_Olx_Get_Categories_Url       constant varchar2(50) := '/api/partner/categories';
  c_Olx_Post_Adverts_Url         constant varchar2(50) := '/api/partner/adverts';
  c_Olx_Get_Thread_Url           constant varchar2(50) := '/api/partner/threads';
  v_Olx_Get_Users_Url            constant varchar2(50) := '/api/partner/users';
  c_Olx_Advertiser_Type_Private  constant varchar2(50) := 'private';
  c_Olx_Advertiser_Type_Businnes constant varchar2(50) := 'business';
  c_Olx_Salary_Type_Monthly      constant varchar2(50) := 'monthly';
  c_Olx_Salary_Type_Hourly       constant varchar2(50) := 'hourly';
  c_Olx_Job_Category_Code        constant number := 6; -- Code From Olx Server
  ----------------------------------------------------------------------------------------------------
  -- System Vacancy Groups
  ----------------------------------------------------------------------------------------------------
  c_Pcode_Vacancy_Group_Experience      constant varchar2(20) := 'VHR:HREC:1';
  c_Pcode_Vacancy_Group_Employments     constant varchar2(20) := 'VHR:HREC:2';
  c_Pcode_Vacancy_Group_Driver_Licences constant varchar2(20) := 'VHR:HREC:3';
  c_Pcode_Vacancy_Group_Key_Skills      constant varchar2(20) := 'VHR:HREC:4';
  ----------------------------------------------------------------------------------------------------  
  -- System Vacancy Types
  ----------------------------------------------------------------------------------------------------  
  -- Experience
  c_Pcode_Vacancy_Type_Experience_No_Experience   constant varchar2(20) := 'VHR:HREC:1';
  c_Pcode_Vacancy_Type_Experience_Between_1_And_3 constant varchar2(20) := 'VHR:HREC:2';
  c_Pcode_Vacancy_Type_Experience_Between_3_And_6 constant varchar2(20) := 'VHR:HREC:3';
  c_Pcode_Vacancy_Type_Experience_More_Than_6     constant varchar2(20) := 'VHR:HREC:4';
  -- Employments
  c_Pcode_Vacancy_Type_Employment_Full constant varchar2(20) := 'VHR:HREC:5';
  c_Pcode_Vacancy_Type_Employment_Part constant varchar2(20) := 'VHR:HREC:6';
  -- Driver Licence
  c_Pcode_Vacancy_Type_Driver_Licence_a constant varchar2(20) := 'VHR:HREC:7';
  c_Pcode_Vacancy_Type_Driver_Licence_b constant varchar2(20) := 'VHR:HREC:8';
  c_Pcode_Vacancy_Type_Driver_Licence_c constant varchar2(20) := 'VHR:HREC:9';
  -- Key Skills
  c_Pcode_Vacancy_Type_Key_Skill_Ambitious constant varchar2(20) := 'VHR:HREC:10';

end Hrec_Pref;
/
create or replace package body Hrec_Pref is
end Hrec_Pref;
/
