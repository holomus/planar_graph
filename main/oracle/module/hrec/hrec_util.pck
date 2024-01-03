create or replace package Hrec_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Application_New
  (
    o_Application        out Hrec_Pref.Application_Rt,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Application_Id     number,
    i_Application_Number varchar2,
    i_Division_Id        number,
    i_Job_Id             number,
    i_Quantity           number,
    i_Wage               number,
    i_Responsibilities   varchar2,
    i_Requirements       varchar2,
    i_Status             varchar2,
    i_Note               varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_New
  (
    o_Vacancy             out Hrec_Pref.Vacancy_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Vacancy_Id          number,
    i_Name                varchar2,
    i_Division_Id         number,
    i_Job_Id              number,
    i_Application_Id      number,
    i_Quantity            number,
    i_Opened_Date         date,
    i_Closed_Date         date,
    i_Scope               varchar2,
    i_Urgent              varchar2,
    i_Funnel_Id           number,
    i_Region_Id           number,
    i_Schedule_Id         number,
    i_Exam_Id             number,
    i_Deadline            date,
    i_Wage_From           number,
    i_Wage_To             number,
    i_Description         varchar2,
    i_Description_In_Html varchar2,
    i_Status              varchar2,
    i_Recruiter_Ids       Array_Number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Add_Lang
  (
    o_Vacancy       in out nocopy Hrec_Pref.Vacancy_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Add_Vacancy_Types
  (
    o_Vacancy          in out nocopy Hrec_Pref.Vacancy_Rt,
    i_Vacancy_Group_Id number,
    i_Vacancy_Type_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Funnel_New
  (
    o_Funnel     out Hrec_Pref.Funnel_Rt,
    i_Company_Id number,
    i_Funnel_Id  number,
    i_Name       varchar2,
    i_State      varchar2,
    i_Code       varchar2,
    i_Stage_Ids  Array_Number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Operation_Fill
  (
    o_Operation        out Hrec_Pref.Candidate_Operation_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Operation_Id     number,
    i_Vacancy_Id       number,
    i_Candidate_Id     number,
    i_Operation_Kind   varchar2,
    i_To_Stage_Id      number,
    i_Reject_Reason_Id number,
    i_Note             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Stage_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Funnel_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Group_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Type_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Company_Id_By_Employer_Code(i_Employer_Code varchar2) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Published_Vacancy
  (
    i_Company_Id   number,
    i_Vacancy_Code varchar2
  ) return Hrec_Hh_Published_Vacancies%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Subscription_User_Id(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Region_Id
  (
    i_Company_Id number,
    i_Area_Code  varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Resume_Code
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Topic_Code
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Vacancy_Code varchar2,
    i_Resume_Code  varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Auth_Response_Errors(i_Data Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_New
  (
    o_Attribute                out Hrec_Pref.Olx_Attribute_Rt,
    i_Company_Id               number,
    i_Category_Code            number,
    i_Attribute_Code           varchar2,
    i_Label                    varchar2,
    i_Validation_Type          varchar2,
    i_Is_Required              varchar2,
    i_Is_Number                varchar2,
    i_Min_Value                number,
    i_Max_Value                number,
    i_Is_Allow_Multiple_Values varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Olx_Attribute_Add_Value
  (
    o_Attribute in out nocopy Hrec_Pref.Olx_Attribute_Rt,
    i_Code      varchar2,
    i_Label     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Take_Telegram_Candidate
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Contact_Code number
  ) return Hrec_Telegram_Candidates%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Wage_From_To_Message
  (
    i_Wage_From number,
    i_Wage_To   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Application_Statuses return Matrix_Varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function t_Vacancy_Scope(i_Scope varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Scopes return Matrix_Varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function t_Vacancy_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Statuses return Matrix_Varchar2;
  ---------------------------------------------------------------------------------------------------- 
  Function t_Operation_Kind(i_Kind varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Operation_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Billing_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Vacancy_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Olx_Advertiser_Types return Matrix_Varchar2;
end Hrec_Util;
/
create or replace package body Hrec_Util is
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
    return b.Translate('HREC:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_New
  (
    o_Application        out Hrec_Pref.Application_Rt,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Application_Id     number,
    i_Application_Number varchar2,
    i_Division_Id        number,
    i_Job_Id             number,
    i_Quantity           number,
    i_Wage               number,
    i_Responsibilities   varchar2,
    i_Requirements       varchar2,
    i_Status             varchar2,
    i_Note               varchar2
  ) is
  begin
    o_Application.Company_Id         := i_Company_Id;
    o_Application.Filial_Id          := i_Filial_Id;
    o_Application.Application_Id     := i_Application_Id;
    o_Application.Application_Number := i_Application_Number;
    o_Application.Division_Id        := i_Division_Id;
    o_Application.Job_Id             := i_Job_Id;
    o_Application.Quantity           := i_Quantity;
    o_Application.Wage               := i_Wage;
    o_Application.Responsibilities   := i_Responsibilities;
    o_Application.Requirements       := i_Requirements;
    o_Application.Status             := i_Status;
    o_Application.Note               := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Vacancy_New
  (
    o_Vacancy             out Hrec_Pref.Vacancy_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Vacancy_Id          number,
    i_Name                varchar2,
    i_Division_Id         number,
    i_Job_Id              number,
    i_Application_Id      number,
    i_Quantity            number,
    i_Opened_Date         date,
    i_Closed_Date         date,
    i_Scope               varchar2,
    i_Urgent              varchar2,
    i_Funnel_Id           number,
    i_Region_Id           number,
    i_Schedule_Id         number,
    i_Exam_Id             number,
    i_Deadline            date,
    i_Wage_From           number,
    i_Wage_To             number,
    i_Description         varchar2,
    i_Description_In_Html varchar2,
    i_Status              varchar2,
    i_Recruiter_Ids       Array_Number
  ) is
  begin
    o_Vacancy.Company_Id          := i_Company_Id;
    o_Vacancy.Filial_Id           := i_Filial_Id;
    o_Vacancy.Vacancy_Id          := i_Vacancy_Id;
    o_Vacancy.Name                := i_Name;
    o_Vacancy.Division_Id         := i_Division_Id;
    o_Vacancy.Job_Id              := i_Job_Id;
    o_Vacancy.Application_Id      := i_Application_Id;
    o_Vacancy.Quantity            := i_Quantity;
    o_Vacancy.Opened_Date         := i_Opened_Date;
    o_Vacancy.Closed_Date         := i_Closed_Date;
    o_Vacancy.Scope               := i_Scope;
    o_Vacancy.Urgent              := i_Urgent;
    o_Vacancy.Funnel_Id           := i_Funnel_Id;
    o_Vacancy.Region_Id           := i_Region_Id;
    o_Vacancy.Schedule_Id         := i_Schedule_Id;
    o_Vacancy.Exam_Id             := i_Exam_Id;
    o_Vacancy.Deadline            := i_Deadline;
    o_Vacancy.Wage_From           := i_Wage_From;
    o_Vacancy.Wage_To             := i_Wage_To;
    o_Vacancy.Description         := i_Description;
    o_Vacancy.Description_In_Html := i_Description_In_Html;
    o_Vacancy.Status              := i_Status;
    o_Vacancy.Recruiter_Ids       := i_Recruiter_Ids;
  
    o_Vacancy.Langs         := Hrec_Pref.Vacancy_Lang_Nt();
    o_Vacancy.Vacancy_Types := Hrec_Pref.Vacancy_Type_Nt();
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Add_Lang
  (
    o_Vacancy       in out nocopy Hrec_Pref.Vacancy_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  ) is
    v_Lang Hrec_Pref.Vacancy_Lang_Rt;
  begin
    v_Lang.Lang_Id       := i_Lang_Id;
    v_Lang.Lang_Level_Id := i_Lang_Level_Id;
  
    o_Vacancy.Langs.Extend();
    o_Vacancy.Langs(o_Vacancy.Langs.Count) := v_Lang;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Vacancy_Add_Vacancy_Types
  (
    o_Vacancy          in out nocopy Hrec_Pref.Vacancy_Rt,
    i_Vacancy_Group_Id number,
    i_Vacancy_Type_Ids Array_Number
  ) is
    v_Type Hrec_Pref.Vacancy_Type_Rt;
  begin
    v_Type.Vacancy_Group_Id := i_Vacancy_Group_Id;
    v_Type.Vacancy_Type_Ids := i_Vacancy_Type_Ids;
  
    o_Vacancy.Vacancy_Types.Extend();
    o_Vacancy.Vacancy_Types(o_Vacancy.Vacancy_Types.Count) := v_Type;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Funnel_New
  (
    o_Funnel     out Hrec_Pref.Funnel_Rt,
    i_Company_Id number,
    i_Funnel_Id  number,
    i_Name       varchar2,
    i_State      varchar2,
    i_Code       varchar2,
    i_Stage_Ids  Array_Number
  ) is
  begin
    o_Funnel.Company_Id := i_Company_Id;
    o_Funnel.Funnel_Id  := i_Funnel_Id;
    o_Funnel.Name       := i_Name;
    o_Funnel.State      := i_State;
    o_Funnel.Code       := i_Code;
    o_Funnel.Stage_Ids  := i_Stage_Ids;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Candidate_Operation_Fill
  (
    o_Operation        out Hrec_Pref.Candidate_Operation_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Operation_Id     number,
    i_Vacancy_Id       number,
    i_Candidate_Id     number,
    i_Operation_Kind   varchar2,
    i_To_Stage_Id      number,
    i_Reject_Reason_Id number,
    i_Note             varchar2
  ) is
  begin
    o_Operation.Company_Id       := i_Company_Id;
    o_Operation.Filial_Id        := i_Filial_Id;
    o_Operation.Operation_Id     := i_Operation_Id;
    o_Operation.Vacancy_Id       := i_Vacancy_Id;
    o_Operation.Candidate_Id     := i_Candidate_Id;
    o_Operation.Operation_Kind   := i_Operation_Kind;
    o_Operation.To_Stage_Id      := i_To_Stage_Id;
    o_Operation.Reject_Reason_Id := i_Reject_Reason_Id;
    o_Operation.Note             := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Stage_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Stage_Id number;
  begin
    select q.Stage_Id
      into v_Stage_Id
      from Hrec_Stages q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Stage_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Funnel_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Funnel_Id number;
  begin
    select q.Funnel_Id
      into v_Funnel_Id
      from Hrec_Funnels q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Funnel_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Group_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Group_Id number;
  begin
    select q.Vacancy_Group_Id
      into v_Group_Id
      from Hrec_Vacancy_Groups q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Group_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Type_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Type_Id number;
  begin
    select q.Vacancy_Type_Id
      into v_Type_Id
      from Hrec_Vacancy_Types q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Type_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Company_Id_By_Employer_Code(i_Employer_Code varchar2) return number is
    v_Company_Id number;
  begin
    select t.Company_Id
      into v_Company_Id
      from Hrec_Hh_Employer_Ids t
     where t.Employer_Id = i_Employer_Code;
  
    return v_Company_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Published_Vacancy
  (
    i_Company_Id   number,
    i_Vacancy_Code varchar2
  ) return Hrec_Hh_Published_Vacancies%rowtype is
    r_Vacancy Hrec_Hh_Published_Vacancies%rowtype;
  begin
    select t.*
      into r_Vacancy
      from Hrec_Hh_Published_Vacancies t
     where t.Company_Id = i_Company_Id
       and t.Vacancy_Code = i_Vacancy_Code;
  
    return r_Vacancy;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Subscription_User_Id(i_Company_Id number) return number is
    v_User_Id number;
  begin
    select t.Created_By
      into v_User_Id
      from Hrec_Hh_Subscriptions t
     where t.Company_Id = i_Company_Id;
  
    return v_User_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Region_Id
  (
    i_Company_Id number,
    i_Area_Code  varchar2
  ) return number is
    result number;
  begin
    select q.Region_Id
      into result
      from Hrec_Hh_Integration_Regions q
     where q.Company_Id = i_Company_Id
       and q.Region_Code = i_Area_Code
       and Rownum = 1;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Resume_Code
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Candidate_Id number
  ) return varchar2 is
    result varchar2(100);
  begin
    select q.Resume_Code
      into result
      from Hrec_Hh_Resumes q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Candidate_Id = i_Candidate_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Topic_Code
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Vacancy_Code varchar2,
    i_Resume_Code  varchar2
  ) return varchar2 is
    result varchar2(100);
  begin
    select q.Topic_Code
      into result
      from Hrec_Hh_Negotiations q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Vacancy_Code = i_Vacancy_Code
       and q.Resume_Code = i_Resume_Code;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Auth_Response_Errors(i_Data Hashmap) is
    v_Errors     Arraylist := i_Data.o_Arraylist('errors');
    v_Error      Hashmap;
    v_Error_Code varchar2(50);
  begin
    if v_Errors is null or v_Errors.Count = 0 then
      return;
    end if;
  
    for i in 1 .. v_Errors.Count
    loop
      v_Error := Treat(v_Errors.r_Hashmap(i) as Hashmap);
    
      v_Error_Code := v_Error.r_Varchar2('value');
    
      if v_Error_Code in (Hrec_Pref.c_Hh_Error_Bad_Authorization,
                          Hrec_Pref.c_Hh_Error_Token_Expired,
                          Hrec_Pref.c_Hh_Error_Token_Revoked,
                          Hrec_Pref.c_Hh_Error_Application_Not_Found,
                          Hrec_Pref.c_Hh_Error_Used_Manager_Account_Forbidden) then
        Hrec_Error.Raise_019(v_Error_Code);
      end if;
    end loop;
  
    if v_Error_Code is not null then
      Hrec_Error.Raise_019(v_Error_Code);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_New
  (
    o_Attribute                out Hrec_Pref.Olx_Attribute_Rt,
    i_Company_Id               number,
    i_Category_Code            number,
    i_Attribute_Code           varchar2,
    i_Label                    varchar2,
    i_Validation_Type          varchar2,
    i_Is_Required              varchar2,
    i_Is_Number                varchar2,
    i_Min_Value                number,
    i_Max_Value                number,
    i_Is_Allow_Multiple_Values varchar2
  ) is
  begin
    o_Attribute.Company_Id               := i_Company_Id;
    o_Attribute.Category_Code            := i_Category_Code;
    o_Attribute.Attribute_Code           := i_Attribute_Code;
    o_Attribute.Label                    := i_Label;
    o_Attribute.Validation_Type          := i_Validation_Type;
    o_Attribute.Is_Required              := i_Is_Required;
    o_Attribute.Is_Number                := i_Is_Number;
    o_Attribute.Min_Value                := i_Min_Value;
    o_Attribute.Max_Value                := i_Max_Value;
    o_Attribute.Is_Allow_Multiple_Values := i_Is_Allow_Multiple_Values;
  
    o_Attribute.Attribute_Values := Hrec_Pref.Olx_Attribute_Value_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Olx_Attribute_Add_Value
  (
    o_Attribute in out nocopy Hrec_Pref.Olx_Attribute_Rt,
    i_Code      varchar2,
    i_Label     varchar2
  ) is
    v_Attribute_Value Hrec_Pref.Olx_Attribute_Value_Rt;
  begin
    v_Attribute_Value.Code  := i_Code;
    v_Attribute_Value.Label := i_Label;
  
    o_Attribute.Attribute_Values.Extend();
    o_Attribute.Attribute_Values(o_Attribute.Attribute_Values.Count) := v_Attribute_Value;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Telegram_Candidate
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Contact_Code number
  ) return Hrec_Telegram_Candidates%rowtype is
    result Hrec_Telegram_Candidates%rowtype;
  begin
    select q.*
      into result
      from Hrec_Telegram_Candidates q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Contact_Code = i_Contact_Code;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Wage_From_To_Message
  (
    i_Wage_From number,
    i_Wage_To   number
  ) return varchar2 is
    result varchar2(500 char);
  begin
    if i_Wage_From is not null then
      result := t('wage from $1', i_Wage_From);
    end if;
  
    if i_Wage_To is not null then
      result := t('wage to $1', i_Wage_To);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Draft return varchar2 is
  begin
    return t('application_status:draft');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Waiting return varchar2 is
  begin
    return t('application_status:waiting');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Approved return varchar2 is
  begin
    return t('application_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Complited return varchar2 is
  begin
    return t('application_status:completed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Canceled return varchar2 is
  begin
    return t('application_status:canceled');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hrec_Pref.c_Application_Status_Draft then t_Application_Status_Draft --
    when Hrec_Pref.c_Application_Status_Waiting then t_Application_Status_Waiting --
    when Hrec_Pref.c_Application_Status_Approved then t_Application_Status_Approved --
    when Hrec_Pref.c_Application_Status_Complited then t_Application_Status_Complited --
    when Hrec_Pref.c_Application_Status_Canceled then t_Application_Status_Canceled --   
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Application_Status_Draft,
                                          Hrec_Pref.c_Application_Status_Waiting,
                                          Hrec_Pref.c_Application_Status_Approved,
                                          Hrec_Pref.c_Application_Status_Complited,
                                          Hrec_Pref.c_Application_Status_Canceled),
                           Array_Varchar2(t_Application_Status_Draft,
                                          t_Application_Status_Waiting,
                                          t_Application_Status_Approved,
                                          t_Application_Status_Complited,
                                          t_Application_Status_Canceled));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Scope_All return varchar2 is
  begin
    return t('vacancy_scope:all');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Scope_Employees return varchar2 is
  begin
    return t('vacancy_scope:employees');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Scope_Non_Employees return varchar2 is
  begin
    return t('vacancy_scope:non employees');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Vacancy_Scope(i_Scope varchar2) return varchar2 is
  begin
    return --
    case i_Scope --
    when Hrec_Pref.c_Vacancy_Scope_All then t_Vacancy_Scope_All --
    when Hrec_Pref.c_Vacancy_Scope_Employees then t_Vacancy_Scope_Employees --
    when Hrec_Pref.c_Vacancy_Scope_Non_Employees then t_Vacancy_Scope_Non_Employees --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Scopes return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Vacancy_Scope_All,
                                          Hrec_Pref.c_Vacancy_Scope_Employees,
                                          Hrec_Pref.c_Vacancy_Scope_Non_Employees),
                           Array_Varchar2(t_Vacancy_Scope_All,
                                          t_Vacancy_Scope_Employees,
                                          t_Vacancy_Scope_Non_Employees));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Status_Open return varchar2 is
  begin
    return t('vacancy_status:open');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Vacancy_Status_Close return varchar2 is
  begin
    return t('vacancy_status:closed');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Vacancy_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hrec_Pref.c_Vacancy_Status_Open then t_Vacancy_Status_Open --
    when Hrec_Pref.c_Vacancy_Status_Close then t_Vacancy_Status_Close --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Vacancy_Status_Open,
                                          Hrec_Pref.c_Vacancy_Status_Close),
                           Array_Varchar2(t_Vacancy_Status_Open, t_Vacancy_Status_Close));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Operation_Kind_Action return varchar2 is
  begin
    return t('operation_kind:action');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Operation_Kind_Comment return varchar2 is
  begin
    return t('operation_kind:comment');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Operation_Kind(i_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Kind --
    when Hrec_Pref.c_Operation_Kind_Action then t_Operation_Kind_Action --
    when Hrec_Pref.c_Operation_Kind_Comment then t_Operation_Kind_Comment --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Operation_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Operation_Kind_Action,
                                          Hrec_Pref.c_Operation_Kind_Comment),
                           Array_Varchar2(t_Operation_Kind_Action, t_Operation_Kind_Comment));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Vacancy_Type_Open return varchar2 is
  begin
    return t('vacancy_type:open');
  end;

  ----------------------------------------------------------------------------------------------------  
  Function t_Vacancy_Type_Closed return varchar2 is
  begin
    return t('vacancy_type:closed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Billing_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Hh_Billing_Type_Standart,
                                          Hrec_Pref.c_Hh_Billing_Type_Free,
                                          Hrec_Pref.c_Hh_Billing_Type_Standart_Plus,
                                          Hrec_Pref.c_Hh_Billing_Type_Premium),
                           Array_Varchar2(t('billing_type:standard'),
                                          t('billing_type:free'),
                                          t('billing_type:standart plus'),
                                          t('billing_type:premium')));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Head_Hunter_Vacancy_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Hh_Vacancy_Type_Open,
                                          Hrec_Pref.c_Hh_Vacancy_Type_Closed),
                           Array_Varchar2(t_Vacancy_Type_Open, t_Vacancy_Type_Closed));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Olx_Advertiser_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrec_Pref.c_Olx_Advertiser_Type_Private,
                                          Hrec_Pref.c_Olx_Advertiser_Type_Businnes),
                           Array_Varchar2(t('olx_advertiser_type:private'),
                                          t('olx_advertiser_type:businnes')));
  end;

end Hrec_Util;
/
