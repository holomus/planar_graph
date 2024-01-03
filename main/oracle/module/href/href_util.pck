create or replace package Href_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Person_New
  (
    o_Person               out Href_Pref.Person_Rt,
    i_Company_Id           number,
    i_Person_Id            number,
    i_First_Name           varchar2,
    i_Last_Name            varchar2,
    i_Middle_Name          varchar2,
    i_Gender               varchar2,
    i_Birthday             date,
    i_Nationality_Id       number,
    i_Photo_Sha            varchar2,
    i_Tin                  varchar2,
    i_Iapa                 varchar2,
    i_Npin                 varchar2,
    i_Region_Id            number,
    i_Main_Phone           varchar2,
    i_Email                varchar2,
    i_Address              varchar2,
    i_Legal_Address        varchar2,
    i_Key_Person           varchar2,
    i_Extra_Phone          varchar2 := null,
    i_Corporate_Email      varchar2 := null,
    i_Access_All_Employees varchar2 := null,
    i_Access_Hidden_Salary varchar2 := null,
    i_State                varchar2,
    i_Code                 varchar2,
    i_Note                 varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_New
  (
    o_Candidate        out Href_Pref.Candidate_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Candidate_Id     number,
    i_Person_Type_Id   number,
    i_Candidate_Kind   varchar2,
    i_First_Name       varchar2,
    i_Last_Name        varchar2,
    i_Middle_Name      varchar2,
    i_Gender           varchar2,
    i_Birthday         date,
    i_Photo_Sha        varchar2,
    i_Region_Id        number,
    i_Main_Phone       varchar2,
    i_Extra_Phone      varchar2,
    i_Email            varchar2,
    i_Address          varchar2,
    i_Legal_Address    varchar2,
    i_Source_Id        number,
    i_Wage_Expectation number,
    i_Cv_Sha           varchar2,
    i_Note             varchar2,
    i_Edu_Stages       Array_Number,
    i_Candidate_Jobs   Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Lang
  (
    p_Candidate     in out nocopy Href_Pref.Candidate_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Experience
  (
    p_Candidate            in out nocopy Href_Pref.Candidate_Rt,
    i_Person_Experience_Id number,
    i_Experience_Type_Id   number,
    i_Is_Working           varchar2,
    i_Start_Date           date,
    i_Num_Year             number,
    i_Num_Month            number,
    i_Num_Day              number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Recom
  (
    p_Candidate           in out nocopy Href_Pref.Candidate_Rt,
    i_Recommendation_Id   number,
    i_Sender_Name         varchar2,
    i_Sender_Phone_Number varchar2,
    i_Sender_Email        varchar2,
    i_File_Sha            varchar2,
    i_Order_No            number,
    i_Feedback            varchar2,
    i_Note                varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Add
  (
    p_Indicators      in out nocopy Href_Pref.Indicator_Nt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  );
  ----------------------------------------------------------------------------------------------------
  Function Load_Candidate_Form_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Href_Candidate_Ref_Settings%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Employee_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Date        date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Get_Division_Manager
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return Mrf_Robots%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Href_Pref.Staff_Licensed_Nt
    pipelined;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------
  Function Staff_Id_By_Staff_Number
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Number varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Doc_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Indicator_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Indicator_Group_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Fte_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Fte_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Nationality_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Random_Integer
  (
    i_Low  number,
    i_High number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Default_User_Login
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Template   varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Direct_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Child_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Parents          Array_Number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Manual_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Chief_Subordinates
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Direct_Divisions Array_Number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Is_Director
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    o_Subordinate_Chiefs out Array_Number,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Direct             boolean,
    i_Indirect           boolean,
    i_Manual             boolean,
    i_Gather_Chiefs      boolean,
    i_Employee_Id        number,
    i_Only_Departments   varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinates
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Direct_Employee varchar2,
    i_Employee_Id     number,
    i_Self            varchar2 := 'N'
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------  
  Function Company_Badge_Template_Id(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Col_Required_Settings(i_Company_Id number) return Href_Pref.Col_Required_Setting_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Name
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Name       varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Phone
  (
    i_Company_Id number,
    i_Person_Id  number := null,
    i_Phone      varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Setting(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Column(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return varchar2 Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Has_Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Request_Note_Is_Required(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Note_Limit(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Plan_Change_Note_Is_Required(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Change_Note_Limit(i_Company_Id number) return number;
  ----------------------------------------------------------------------------------------------------
  Function Load_Fte_Limit(i_Company_Id number) return Href_Pref.Fte_Limit_Rt;
  ----------------------------------------------------------------------------------------------------  
  Function Set_Photo_Templates return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Bank_Account_New
  (
    o_Bank_Account      out Href_Pref.Bank_Account_Rt,
    i_Company_Id        number,
    i_Bank_Account_Id   number,
    i_Bank_Id           number,
    i_Bank_Account_Code varchar2,
    i_Name              varchar2,
    i_Person_Id         number,
    i_Is_Main           varchar2,
    i_Currency_Id       number,
    i_Note              varchar2,
    i_Card_Number       varchar2,
    i_State             varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Function Convert_Number_To_Text
  (
    i_Value     number,
    i_Lang_Code varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind(i_Kind varchar2) return varchar2;
  Function Specialty_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status(i_Staff_Status varchar2) return varchar2;
  Function Staff_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind(i_Staff_Kind varchar2) return varchar2;
  Function Staff_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source(i_Source_Kind varchar2) return varchar2;
  Function Employment_Source_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_User_Acces_Level(i_Acces_Level varchar2) return varchar2;
  Function User_Acces_Levels return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used(i_Used varchar2) return varchar2;
  Function Indicator_Useds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind(i_Kind varchar2) return varchar2;
  Function Candidate_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type(i_Dismissal_Reasons_Type varchar2) return varchar2;
  Function Dismissal_Reasons_Type return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Custom_Fte_Name return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_From_To_Rule
  (
    i_From      number,
    i_To        number,
    i_Rule_Unit varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status(i_Status varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status(i_Status varchar2) return varchar2;
  Function Person_Document_Owe_Status return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column(i_Column varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Personal_Audit_Column_Names return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Employee_Contact_Audit_Column_Names return Matrix_Varchar2;
end Href_Util;
/
create or replace package body Href_Util is
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
  Procedure Person_New
  (
    o_Person               out Href_Pref.Person_Rt,
    i_Company_Id           number,
    i_Person_Id            number,
    i_First_Name           varchar2,
    i_Last_Name            varchar2,
    i_Middle_Name          varchar2,
    i_Gender               varchar2,
    i_Birthday             date,
    i_Nationality_Id       number,
    i_Photo_Sha            varchar2,
    i_Tin                  varchar2,
    i_Iapa                 varchar2,
    i_Npin                 varchar2,
    i_Region_Id            number,
    i_Main_Phone           varchar2,
    i_Email                varchar2,
    i_Address              varchar2,
    i_Legal_Address        varchar2,
    i_Key_Person           varchar2,
    i_Extra_Phone          varchar2 := null,
    i_Corporate_Email      varchar2 := null,
    i_Access_All_Employees varchar2 := null,
    i_Access_Hidden_Salary varchar2 := null,
    i_State                varchar2,
    i_Code                 varchar2,
    i_Note                 varchar2 := null
  ) is
  begin
    o_Person.Company_Id           := i_Company_Id;
    o_Person.Person_Id            := i_Person_Id;
    o_Person.First_Name           := i_First_Name;
    o_Person.Last_Name            := i_Last_Name;
    o_Person.Middle_Name          := i_Middle_Name;
    o_Person.Gender               := i_Gender;
    o_Person.Birthday             := i_Birthday;
    o_Person.Nationality_Id       := i_Nationality_Id;
    o_Person.Photo_Sha            := i_Photo_Sha;
    o_Person.Tin                  := i_Tin;
    o_Person.Iapa                 := i_Iapa;
    o_Person.Npin                 := i_Npin;
    o_Person.Region_Id            := i_Region_Id;
    o_Person.Main_Phone           := i_Main_Phone;
    o_Person.Email                := i_Email;
    o_Person.Address              := i_Address;
    o_Person.Legal_Address        := i_Legal_Address;
    o_Person.Key_Person           := i_Key_Person;
    o_Person.Extra_Phone          := i_Extra_Phone;
    o_Person.Corporate_Email      := i_Corporate_Email;
    o_Person.Access_All_Employees := i_Access_All_Employees;
    o_Person.Access_Hidden_Salary := i_Access_Hidden_Salary;
    o_Person.State                := i_State;
    o_Person.Code                 := i_Code;
    o_Person.Note                 := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_New
  (
    o_Candidate        out Href_Pref.Candidate_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Candidate_Id     number,
    i_Person_Type_Id   number,
    i_Candidate_Kind   varchar2,
    i_First_Name       varchar2,
    i_Last_Name        varchar2,
    i_Middle_Name      varchar2,
    i_Gender           varchar2,
    i_Birthday         date,
    i_Photo_Sha        varchar2,
    i_Region_Id        number,
    i_Main_Phone       varchar2,
    i_Extra_Phone      varchar2,
    i_Email            varchar2,
    i_Address          varchar2,
    i_Legal_Address    varchar2,
    i_Source_Id        number,
    i_Wage_Expectation number,
    i_Cv_Sha           varchar2,
    i_Note             varchar2,
    i_Edu_Stages       Array_Number,
    i_Candidate_Jobs   Array_Number
  ) is
  begin
    o_Candidate.Company_Id       := i_Company_Id;
    o_Candidate.Filial_Id        := i_Filial_Id;
    o_Candidate.Person_Type_Id   := i_Person_Type_Id;
    o_Candidate.Candidate_Kind   := i_Candidate_Kind;
    o_Candidate.Source_Id        := i_Source_Id;
    o_Candidate.Wage_Expectation := i_Wage_Expectation;
    o_Candidate.Cv_Sha           := i_Cv_Sha;
    o_Candidate.Note             := i_Note;
    o_Candidate.Extra_Phone      := i_Extra_Phone;
    o_Candidate.Edu_Stages       := i_Edu_Stages;
    o_Candidate.Candidate_Jobs   := i_Candidate_Jobs;
  
    o_Candidate.Person.Company_Id    := i_Company_Id;
    o_Candidate.Person.Person_Id     := i_Candidate_Id;
    o_Candidate.Person.First_Name    := i_First_Name;
    o_Candidate.Person.Last_Name     := i_Last_Name;
    o_Candidate.Person.Middle_Name   := i_Middle_Name;
    o_Candidate.Person.Gender        := i_Gender;
    o_Candidate.Person.Birthday      := i_Birthday;
    o_Candidate.Person.Photo_Sha     := i_Photo_Sha;
    o_Candidate.Person.Region_Id     := i_Region_Id;
    o_Candidate.Person.Main_Phone    := i_Main_Phone;
    o_Candidate.Person.Email         := i_Email;
    o_Candidate.Person.Address       := i_Address;
    o_Candidate.Person.Legal_Address := i_Legal_Address;
    o_Candidate.Person.State         := 'A';
  
    o_Candidate.Langs           := Href_Pref.Person_Lang_Nt();
    o_Candidate.Experiences     := Href_Pref.Person_Experience_Nt();
    o_Candidate.Recommendations := Href_Pref.Candidate_Recom_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Lang
  (
    p_Candidate     in out nocopy Href_Pref.Candidate_Rt,
    i_Lang_Id       number,
    i_Lang_Level_Id number
  ) is
    v_Lang Href_Pref.Person_Lang_Rt;
  begin
    v_Lang.Lang_Id       := i_Lang_Id;
    v_Lang.Lang_Level_Id := i_Lang_Level_Id;
  
    p_Candidate.Langs.Extend;
    p_Candidate.Langs(p_Candidate.Langs.Count) := v_Lang;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Experience
  (
    p_Candidate            in out nocopy Href_Pref.Candidate_Rt,
    i_Person_Experience_Id number,
    i_Experience_Type_Id   number,
    i_Is_Working           varchar2,
    i_Start_Date           date,
    i_Num_Year             number,
    i_Num_Month            number,
    i_Num_Day              number
  ) is
    v_Experience Href_Pref.Person_Experience_Rt;
  begin
    v_Experience.Person_Experience_Id := i_Person_Experience_Id;
    v_Experience.Experience_Type_Id   := i_Experience_Type_Id;
    v_Experience.Is_Working           := i_Is_Working;
    v_Experience.Start_Date           := i_Start_Date;
    v_Experience.Num_Year             := i_Num_Year;
    v_Experience.Num_Month            := i_Num_Month;
    v_Experience.Num_Day              := i_Num_Day;
  
    p_Candidate.Experiences.Extend;
    p_Candidate.Experiences(p_Candidate.Experiences.Count) := v_Experience;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Candidate_Add_Recom
  (
    p_Candidate           in out nocopy Href_Pref.Candidate_Rt,
    i_Recommendation_Id   number,
    i_Sender_Name         varchar2,
    i_Sender_Phone_Number varchar2,
    i_Sender_Email        varchar2,
    i_File_Sha            varchar2,
    i_Order_No            number,
    i_Feedback            varchar2,
    i_Note                varchar2
  ) is
    v_Recommendation Href_Pref.Candidate_Recom_Rt;
  begin
    v_Recommendation.Recommendation_Id   := i_Recommendation_Id;
    v_Recommendation.Sender_Name         := i_Sender_Name;
    v_Recommendation.Sender_Phone_Number := i_Sender_Phone_Number;
    v_Recommendation.Sender_Email        := i_Sender_Email;
    v_Recommendation.File_Sha            := i_File_Sha;
    v_Recommendation.Order_No            := i_Order_No;
    v_Recommendation.Feedback            := i_Feedback;
    v_Recommendation.Note                := i_Note;
  
    p_Candidate.Recommendations.Extend;
    p_Candidate.Recommendations(p_Candidate.Recommendations.Count) := v_Recommendation;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Add
  (
    p_Indicators      in out nocopy Href_Pref.Indicator_Nt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  ) is
    v_Indicator Href_Pref.Indicator_Rt;
  begin
    v_Indicator.Indicator_Id    := i_Indicator_Id;
    v_Indicator.Indicator_Value := i_Indicator_Value;
  
    p_Indicators.Extend;
    p_Indicators(p_Indicators.Count) := v_Indicator;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Candidate_Form_Settings
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Href_Candidate_Ref_Settings%rowtype is
    result Href_Candidate_Ref_Settings%rowtype;
  begin
    if not z_Href_Candidate_Ref_Settings.Exist(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               o_Row        => result) then
      Result.Company_Id     := i_Company_Id;
      Result.Filial_Id      := i_Filial_Id;
      Result.Region         := 'N';
      Result.Address        := 'N';
      Result.Experience     := 'N';
      Result.Source         := 'N';
      Result.Recommendation := 'N';
      Result.Cv             := 'N';
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Employee_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return number is
  begin
    return z_Href_Staffs.Take(i_Company_Id => i_Company_Id, --
                              i_Filial_Id  => i_Filial_Id, --
                              i_Staff_Id   => i_Staff_Id).Employee_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns last active staff id
  -- returns null if no staff found
  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return number is
    result number;
  begin
    select s.Staff_Id
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
     order by s.Hiring_Date desc
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Primary_Staff_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number,
    i_Date        date
  ) return number is
    result number;
  begin
    select s.Staff_Id
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date <= i_Date
     order by s.Hiring_Date desc
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns primary staff_id that was active on duration of period
  -- returns null if no such staff found
  Function Get_Primary_Staff_Id
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Id  number,
    i_Period_Begin date,
    i_Period_End   date
  ) return number is
    v_Staff_Id number;
  begin
    select s.Staff_Id
      into v_Staff_Id
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and s.Employee_Id = i_Employee_Id
       and s.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
       and s.State = 'A'
       and s.Hiring_Date <= i_Period_Begin
       and Nvl(s.Dismissal_Date, i_Period_End) >= i_Period_End;
  
    return v_Staff_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Get_Division_Manager
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return Mrf_Robots%rowtype is
    r_Division_Manager Mrf_Division_Managers%rowtype;
  begin
    r_Division_Manager := z_Mrf_Division_Managers.Take(i_Company_Id  => i_Company_Id,
                                                       i_Filial_Id   => i_Filial_Id,
                                                       i_Division_Id => i_Division_Id);
  
    return z_Mrf_Robots.Take(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Robot_Id   => r_Division_Manager.Manager_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return number is
    r_Robot       Mrf_Robots%rowtype;
    v_Division_Id number;
  begin
    v_Division_Id := z_Hrm_Robots.Take(i_Company_Id => i_Company_Id, --
                     i_Filial_Id => i_Filial_Id, --
                     i_Robot_Id => i_Robot_Id).Org_Unit_Id;
  
    r_Robot := Get_Division_Manager(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Division_Id => v_Division_Id);
  
    if r_Robot.Robot_Id = i_Robot_Id then
      v_Division_Id := z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
                       i_Filial_Id => i_Filial_Id, --
                       i_Division_Id => r_Robot.Division_Id).Parent_Id;
    
      r_Robot := Get_Division_Manager(i_Company_Id  => i_Company_Id,
                                      i_Filial_Id   => i_Filial_Id,
                                      i_Division_Id => v_Division_Id);
    end if;
  
    return r_Robot.Person_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    v_Manager_Id number;
    r_Staff      Href_Staffs%rowtype;
  begin
    r_Staff := z_Href_Staffs.Take(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    v_Manager_Id := Get_Manager_Id(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => r_Staff.Robot_Id);
  
    return z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, --
                                     i_Person_Id  => v_Manager_Id).Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manager_Name
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Employee_Id number
  ) return varchar2 is
    v_Staff_Id number;
  begin
    v_Staff_Id := Get_Primary_Staff_Id(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Employee_Id  => i_Employee_Id,
                                       i_Period_Begin => Trunc(sysdate),
                                       i_Period_End   => Trunc(sysdate));
  
    return Get_Manager_Name(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Staff_Id   => v_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    result Mr_Natural_Persons.Name%type;
  begin
    select (select w.Name
              from Mr_Natural_Persons w
             where w.Company_Id = q.Company_Id
               and w.Person_Id = q.Employee_Id)
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return varchar2 is
    result Mr_Natural_Persons.Name%type;
  begin
    select (select w.Code
              from Mr_Natural_Persons w
             where w.Company_Id = q.Company_Id
               and w.Person_Id = q.Employee_Id)
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Id_By_Staff_Number
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Number varchar2
  ) return number is
    result number;
  begin
    select q.Staff_Id
      into result
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and Upper(q.Staff_Number) = Upper(i_Staff_Number);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed_Period
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return Href_Pref.Staff_Licensed_Nt
    pipelined is
    r_Staff          Href_Staffs%rowtype;
    v_Staff_Licensed Href_Pref.Staff_Licensed_Rt;
    v_Begin_Date     date;
    v_End_Date       date;
  begin
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    v_Staff_Licensed.Staff_Id := i_Staff_Id;
    v_Begin_Date              := Greatest(r_Staff.Hiring_Date, i_Period_Begin);
    v_End_Date                := Least(Nvl(r_Staff.Dismissal_Date, i_Period_End), i_Period_End);
  
    for r in (select Dates.Period,
                     Nvl((select 'N'
                           from Hlic_Unlicensed_Employees Le
                          where Le.Company_Id = r_Staff.Company_Id
                            and Le.Employee_Id = r_Staff.Employee_Id
                            and Le.Licensed_Date = Dates.Period),
                         'Y') as Licensed
                from (select (v_Begin_Date + level - 1) as Period
                        from Dual
                      connect by level <= (v_End_Date - v_Begin_Date + 1)) Dates)
    loop
      v_Staff_Licensed.Period   := r.Period;
      v_Staff_Licensed.Licensed := r.Licensed;
    
      pipe row(v_Staff_Licensed);
    end loop;
  
    return;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) return varchar2 is
    v_Count number;
  begin
    select count(*)
      into v_Count
      from Staff_Licensed_Period(i_Company_Id   => i_Company_Id,
                                 i_Filial_Id    => i_Filial_Id,
                                 i_Staff_Id     => i_Staff_Id,
                                 i_Period_Begin => i_Period_Begin,
                                 i_Period_End   => i_Period_End) q
     where q.Licensed = 'N';
  
    if v_Count = 0 then
      return 'Y';
    else
      return 'N';
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Staff_Licensed
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Period_Begin date,
    i_Period_End   date
  ) is
  begin
    for r in (select q.Period
                from Staff_Licensed_Period(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_Staff_Id     => i_Staff_Id,
                                           i_Period_Begin => i_Period_Begin,
                                           i_Period_End   => i_Period_End) q
               where q.Licensed = 'N'
                 and Rownum = 1)
    loop
      Href_Error.Raise_018(i_Employee_Name  => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                    i_Filial_Id  => i_Filial_Id,
                                                                    i_Staff_Id   => i_Staff_Id),
                           i_Period_Begin   => i_Period_Begin,
                           i_Period_End     => i_Period_End,
                           i_Unlicensed_Day => r.Period);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number is
    result number;
  begin
    select q.Labor_Function_Id
      into result
      from Href_Labor_Functions q
     where q.Company_Id = i_Company_Id
       and q.Code = i_Code;
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_019(i_Labor_Function_Code => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Labor_Function_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Labor_Function_Id
      into result
      from Href_Labor_Functions q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_020(i_Labor_Function_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Code
  (
    i_Company_Id number,
    i_Code       varchar2
  ) return number is
    result number;
  begin
    select q.Fixed_Term_Base_Id
      into result
      from Href_Fixed_Term_Bases q
     where q.Company_Id = i_Company_Id
       and q.Code = i_Code;
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_021(i_Fixed_Term_Base_Code => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fixed_Term_Base_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Fixed_Term_Base_Id
      into result
      from Href_Fixed_Term_Bases q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      Href_Error.Raise_022(i_Fixed_Term_Base_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Doc_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select q.Doc_Type_Id
      into result
      from Href_Document_Types q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache is
    result number;
  begin
    select Indicator_Id
      into result
      from Href_Indicators
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Group_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache is
    result number;
  begin
    select Indicator_Group_Id
      into result
      from Href_Indicator_Groups
     where Company_Id = i_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fte_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Fte_Id
      into result
      from Href_Ftes q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_023(i_Fte_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fte_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    result number;
  begin
    select q.Fte_Id
      into result
      from Href_Ftes q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_024(i_Fte_Pcode => i_Pcode);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Nationality_Id_By_Name
  (
    i_Company_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Nationality_Id
      into result
      from Href_Nationalities q
     where q.Company_Id = i_Company_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  
  exception
    when No_Data_Found then
      Href_Error.Raise_029(i_Nationality_Name => i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  -- returns randoms integer in [low, high] interval
  ----------------------------------------------------------------------------------------------------
  Function Random_Integer
  (
    i_Low  number,
    i_High number
  ) return number is
  begin
    return Trunc(Dbms_Random.Value(i_Low, i_High + 1));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Default_User_Login
  (
    i_Company_Id number,
    i_Person_Id  number,
    i_Template   varchar2
  ) return varchar2 is
    r_Person Mr_Natural_Persons%rowtype;
    v_Login  varchar2(100);
  begin
    r_Person := z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => i_Person_Id);
  
    v_Login := Regexp_Replace(i_Template, 'first_name', r_Person.First_Name);
    v_Login := Regexp_Replace(v_Login, 'last_name', r_Person.Last_Name);
    v_Login := Md_Util.Login_Fixer(v_Login);
  
    return Regexp_Replace(v_Login, '@', '');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Direct_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Rd.Division_Id
      bulk collect
      into result
      from Mrf_Robots r
      join Hrm_Robot_Divisions Rd
        on Rd.Company_Id = r.Company_Id
       and Rd.Filial_Id = r.Filial_Id
       and Rd.Robot_Id = r.Robot_Id
       and Rd.Access_Type = Hrm_Pref.c_Access_Type_Structural
      join Hrm_Divisions Dv
        on Dv.Company_Id = Rd.Company_Id
       and Dv.Filial_Id = Rd.Filial_Id
       and Dv.Division_Id = Rd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where r.Company_Id = i_Company_Id
       and r.Filial_Id = i_Filial_Id
       and r.Person_Id = i_Employee_Id;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Child_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Parents          Array_Number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Pd.Division_Id
      bulk collect
      into result
      from Mhr_Parent_Divisions Pd
      join Hrm_Divisions Dv
        on Dv.Company_Id = Pd.Company_Id
       and Dv.Filial_Id = Pd.Filial_Id
       and Dv.Division_Id = Pd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where Pd.Company_Id = i_Company_Id
       and Pd.Filial_Id = i_Filial_Id
       and Pd.Parent_Id member of i_Parents;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Manual_Divisions
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Employee_Id      number,
    i_Only_Departments varchar2 := 'N'
  ) return Array_Number is
    result Array_Number;
  begin
    select Rd.Division_Id
      bulk collect
      into result
      from Mrf_Robots r
      join Hrm_Robot_Divisions Rd
        on Rd.Company_Id = r.Company_Id
       and Rd.Filial_Id = r.Filial_Id
       and Rd.Robot_Id = r.Robot_Id
       and Rd.Access_Type = Hrm_Pref.c_Access_Type_Manual
      join Hrm_Divisions Dv
        on Dv.Company_Id = Rd.Company_Id
       and Dv.Filial_Id = Rd.Filial_Id
       and Dv.Division_Id = Rd.Division_Id
       and (i_Only_Departments = 'N' or Dv.Is_Department = 'Y')
     where r.Company_Id = i_Company_Id
       and r.Filial_Id = i_Filial_Id
       and r.Person_Id = i_Employee_Id;
  
    result := result multiset union
              Get_Child_Divisions(i_Company_Id       => i_Company_Id,
                                  i_Filial_Id        => i_Filial_Id,
                                  i_Only_Departments => i_Only_Departments,
                                  i_Parents          => result);
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Chief_Subordinates
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Direct_Divisions Array_Number
  ) return Array_Number is
    result Array_Number;
  begin
    select Rb.Person_Id
      bulk collect
      into result
      from Mhr_Parent_Divisions Pd
      join Mrf_Division_Managers p
        on p.Company_Id = Pd.Company_Id
       and p.Filial_Id = Pd.Filial_Id
       and p.Division_Id = Pd.Division_Id
      join Mrf_Robots Rb
        on Rb.Company_Id = p.Company_Id
       and Rb.Filial_Id = p.Filial_Id
       and Rb.Robot_Id = p.Manager_Id
     where Pd.Company_Id = i_Company_Id
       and Pd.Filial_Id = i_Filial_Id
       and Pd.Parent_Id member of i_Direct_Divisions
       and Pd.Lvl = 1;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinate_Divisions
  (
    o_Subordinate_Chiefs out Array_Number,
    i_Company_Id         number,
    i_Filial_Id          number,
    i_Direct             boolean,
    i_Indirect           boolean,
    i_Manual             boolean,
    i_Gather_Chiefs      boolean,
    i_Employee_Id        number,
    i_Only_Departments   varchar2 := 'N'
  ) return Array_Number is
    v_Direct_Divisions Array_Number;
    result             Array_Number := Array_Number();
  begin
    v_Direct_Divisions := Get_Direct_Divisions(i_Company_Id       => i_Company_Id,
                                               i_Filial_Id        => i_Filial_Id,
                                               i_Employee_Id      => i_Employee_Id,
                                               i_Only_Departments => i_Only_Departments);
  
    o_Subordinate_Chiefs := Array_Number();
  
    if i_Direct then
      result := v_Direct_Divisions;
    
      if i_Gather_Chiefs then
        o_Subordinate_Chiefs := Get_Chief_Subordinates(i_Company_Id       => i_Company_Id,
                                                       i_Filial_Id        => i_Filial_Id,
                                                       i_Direct_Divisions => v_Direct_Divisions);
      end if;
    end if;
  
    if i_Indirect then
      result := result multiset union
                Get_Child_Divisions(i_Company_Id       => i_Company_Id,
                                    i_Filial_Id        => i_Filial_Id,
                                    i_Parents          => v_Direct_Divisions,
                                    i_Only_Departments => i_Only_Departments);
    end if;
  
    if i_Manual then
      result := result multiset union
                Get_Manual_Divisions(i_Company_Id       => i_Company_Id,
                                     i_Filial_Id        => i_Filial_Id,
                                     i_Employee_Id      => i_Employee_Id,
                                     i_Only_Departments => i_Only_Departments);
    end if;
  
    return set(result);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Director
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) return boolean is
    v_Dummy varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and exists (select 1
              from Mrf_Division_Managers m
              join Mhr_Divisions d
                on d.Company_Id = m.Company_Id
               and d.Filial_Id = m.Filial_Id
               and d.Division_Id = m.Division_Id
               and d.Parent_Id is null
             where m.Company_Id = q.Company_Id
               and m.Filial_Id = q.Filial_Id
               and m.Manager_Id = q.Robot_Id);
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Subordinates
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Direct_Employee varchar2,
    i_Employee_Id     number,
    i_Self            varchar2 := 'N'
  ) return Array_Number is
    v_Current_Date date := Trunc(Htt_Util.Get_Current_Date(i_Company_Id => i_Company_Id,
                                                           i_Filial_Id  => i_Filial_Id));
  
    v_Division_Ids       Array_Number;
    v_Subordinate_Chiefs Array_Number;
  
    result Array_Number := Array_Number();
  begin
    if i_Direct_Employee is null or i_Direct_Employee <> 'Y' and i_Direct_Employee <> 'N' then
      b.Raise_Not_Implemented;
    end if;
  
    v_Division_Ids := Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                i_Company_Id         => i_Company_Id,
                                                i_Filial_Id          => i_Filial_Id,
                                                i_Direct             => true,
                                                i_Indirect           => i_Direct_Employee = 'N',
                                                i_Manual             => false,
                                                i_Gather_Chiefs      => true,
                                                i_Employee_Id        => i_Employee_Id);
  
    select s.Staff_Id
      bulk collect
      into result
      from Href_Staffs s
     where s.Company_Id = i_Company_Id
       and s.Filial_Id = i_Filial_Id
       and (i_Self = 'Y' or s.Employee_Id <> i_Employee_Id)
       and s.State = 'A'
       and v_Current_Date between s.Hiring_Date and Nvl(s.Dismissal_Date, Href_Pref.c_Max_Date)
       and (s.Org_Unit_Id member of v_Division_Ids or --
            s.Employee_Id member of v_Subordinate_Chiefs or --
            i_Self = 'Y' and s.Employee_Id = i_Employee_Id);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Company_Badge_Template_Id(i_Company_Id number) return number is
  begin
    return to_number(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                  i_Code       => Href_Pref.c_Pref_Badge_Template_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Col_Required_Settings(i_Company_Id number) return Href_Pref.Col_Required_Setting_Rt is
    result Href_Pref.Col_Required_Setting_Rt;
  
    --------------------------------------------------
    Function Load_Pref(i_Code varchar2) return varchar2 is
    begin
      return Md_Pref.Load(i_Company_Id => i_Company_Id,
                          i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                          i_Code       => i_Code);
    end;
  begin
    Result.Last_Name              := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Last_Name), 'N');
    Result.Middle_Name            := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Middle_Name), 'N');
    Result.Birthday               := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Birthday), 'N');
    Result.Phone_Number           := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Phone_Number), 'N');
    Result.Email                  := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Email), 'N');
    Result.Region                 := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Region), 'N');
    Result.Address                := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Address), 'N');
    Result.Legal_Address          := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Legal_Address), 'N');
    Result.Passport               := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Passport), 'N');
    Result.Npin                   := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Npin), 'N');
    Result.Iapa                   := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Iapa), 'N');
    Result.Request_Note           := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Request_Note), 'N');
    Result.Request_Note_Limit     := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Request_Note_Limit), 0);
    Result.Plan_Change_Note       := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note), 'N');
    Result.Plan_Change_Note_Limit := Nvl(Load_Pref(Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit), 0);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------                 
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2 is
    v_Dummy number;
  begin
    execute immediate 'select 1 from ' || i_Table.Name ||
                      ' where company_id = :1 and filial_id = :2 and ' || --
                      case
                        when i_Check_Case = 'Y' then
                         'lower(' || i_Column || ') = lower(:3)'
                        else
                         i_Column || ' = :3'
                      end
      into v_Dummy
      using i_Company_Id, i_Filial_Id, i_Column_Value;
  
    return 'N';
  
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------                 
  Function Check_Unique
  (
    i_Company_Id   number,
    i_Table        Fazo_Schema.w_Table_Name,
    i_Column       varchar2,
    i_Column_Value varchar2,
    i_Check_Case   varchar2 := 'N'
  ) return varchar2 is
    v_Dummy number;
  begin
    execute immediate 'select 1 from ' || i_Table.Name || --
                      ' where company_id = :1 and ' || --
                      case
                        when i_Check_Case = 'Y' then
                         'lower(' || i_Column || ') = lower(:2)'
                        else
                         i_Column || ' = :2'
                      end
      into v_Dummy
      using i_Company_Id, i_Column_Value;
  
    return 'N';
  
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Code,
                        i_Column_Value => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Code       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Filial_Id    => i_Filial_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Code,
                        i_Column_Value => i_Code);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Name
  (
    i_Company_Id number,
    i_Table      Fazo_Schema.w_Table_Name,
    i_Name       varchar2
  ) return varchar2 is
  begin
    return Check_Unique(i_Company_Id   => i_Company_Id,
                        i_Table        => i_Table,
                        i_Column       => z.Name,
                        i_Column_Value => i_Name,
                        i_Check_Case   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Check_Unique_Phone
  (
    i_Company_Id number,
    i_Person_Id  number := null,
    i_Phone      varchar2
  ) return varchar2 is
    v_Dummy varchar2(1);
    v_Phone varchar2(25) := Regexp_Replace(i_Phone, '\D', '');
  begin
    select 'x'
      into v_Dummy
      from Md_Persons q
     where q.Company_Id = i_Company_Id
       and (i_Person_Id is null or q.Person_Id <> i_Person_Id)
       and q.Phone = v_Phone
       and q.State = 'A';
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Setting(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Vpu_Setting),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Verify_Person_Uniqueness_Column(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Vpu_Column),
               Href_Pref.c_Vpu_Column_Passport_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return varchar2 Result_Cache Relies_On(Href_Person_Details) is
  begin
    if i_User_Id = Md_Pref.User_Admin(i_Company_Id) then
      return 'Y';
    else
      return Nvl(z_Href_Person_Details.Take(i_Company_Id => i_Company_Id, i_Person_Id => i_User_Id).Access_Hidden_Salary,
                 'N');
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Access_Hidden_Salary
  (
    i_Company_Id number,
    i_User_Id    number := Md_Env.User_Id
  ) return boolean is
  begin
    return Access_Hidden_Salary(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id) = 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Request_Note_Is_Required(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Request_Note),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Request_Note_Limit(i_Company_Id number) return number is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Request_Note_Limit),
               0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Change_Note_Is_Required(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Plan_Change_Note),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Plan_Change_Note_Limit(i_Company_Id number) return number is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Href_Pref.c_Pref_Crs_Plan_Change_Note_Limit),
               0);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Fte_Limit(i_Company_Id number) return Href_Pref.Fte_Limit_Rt is
    v_Setting Href_Pref.Fte_Limit_Rt;
  begin
    v_Setting.Fte_Limit_Setting := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                                    i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                                    i_Code       => Href_Pref.c_Fte_Limit_Setting),
                                       'N');
  
    if v_Setting.Fte_Limit_Setting = 'Y' then
      v_Setting.Fte_Limit := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                                              i_Code       => Href_Pref.c_Fte_Limit),
                                 Href_Pref.c_Fte_Limit_Default);
    end if;
  
    return v_Setting;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Set_Photo_Templates return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Set_Photo_Template_Fl,
                                          Href_Pref.c_Set_Photo_Template_Lf,
                                          Href_Pref.c_Set_Photo_Template_Fl_Id,
                                          Href_Pref.c_Set_Photo_Template_Lf_Id,
                                          Href_Pref.c_Set_Photo_Template_Fl_Employee_Number,
                                          Href_Pref.c_Set_Photo_Template_Lf_Employee_Number,
                                          Href_Pref.c_Set_Photo_Template_Flm,
                                          Href_Pref.c_Set_Photo_Template_Lfm,
                                          Href_Pref.c_Set_Photo_Template_Flm_Id,
                                          Href_Pref.c_Set_Photo_Template_Lfm_Id,
                                          Href_Pref.c_Set_Photo_Template_Flm_Employee_Number,
                                          Href_Pref.c_Set_Photo_Template_Lfm_Employee_Number),
                           Array_Varchar2(t('set_photo_template:first_name.last_name'),
                                          t('set_photo_template:last_name.first_name'),
                                          t('set_photo_template:first_name.last_name.#ID'),
                                          t('set_photo_template:last_name.first_name.#ID'),
                                          t('set_photo_template:first_name.last_name.#Employee_Number'),
                                          t('set_photo_template:last_name.first_name.#Employee_Number'),
                                          t('set_photo_template:first_name.last_name.middle_name'),
                                          t('set_photo_template:last_name.first_name.middle_name'),
                                          t('set_photo_template:first_name.last_name.middle_name.#ID'),
                                          t('set_photo_template:last_name.first_name.middle_name.#ID'),
                                          t('set_photo_template:first_name.last_name.middle_name.#Employee_Number'),
                                          t('set_photo_template:last_name.first_name.middle_name.#Employee_Number')));
  end;

  ----------------------------------------------------------------------------------------------------                                          
  Procedure Bank_Account_New
  (
    o_Bank_Account      out Href_Pref.Bank_Account_Rt,
    i_Company_Id        number,
    i_Bank_Account_Id   number,
    i_Bank_Id           number,
    i_Bank_Account_Code varchar2,
    i_Name              varchar2,
    i_Person_Id         number,
    i_Is_Main           varchar2,
    i_Currency_Id       number,
    i_Note              varchar2,
    i_Card_Number       varchar2,
    i_State             varchar2
  ) is
  begin
    o_Bank_Account.Company_Id        := i_Company_Id;
    o_Bank_Account.Bank_Account_Id   := i_Bank_Account_Id;
    o_Bank_Account.Bank_Id           := i_Bank_Id;
    o_Bank_Account.Bank_Account_Code := i_Bank_Account_Code;
    o_Bank_Account.Name              := i_Name;
    o_Bank_Account.Person_Id         := i_Person_Id;
    o_Bank_Account.Is_Main           := i_Is_Main;
    o_Bank_Account.Currency_Id       := i_Currency_Id;
    o_Bank_Account.Note              := i_Note;
    o_Bank_Account.Card_Number       := i_Card_Number;
    o_Bank_Account.State             := i_State;
  end;

  -- the function returns the literals for integers whose absolute value is less than 1e15
  -- if the number is large, that number itself will be returned
  ---------------------------------------------------------------------------------------------------- 
  Function Convert_Number_To_Text
  (
    i_Value     number,
    i_Lang_Code varchar2
  ) return varchar2 is
    v_Text           varchar2(1000);
    v_Powers_Of_Ten  number := 1000000000000;
    v_Value          number := Abs(i_Value);
    v_Part_Of_Number number;
    v_Suffix         varchar2(50);
    v_Hundreds       Array_Varchar2;
    v_Teens          Array_Varchar2;
    v_Tens           Array_Varchar2;
    v_Units          Array_Varchar2;
    v_Suffixes       Matrix_Varchar2;
    --------------------------------------------------
    Function Make_Number_Text
    (
      i_Val    number,
      i_Suffix varchar
    ) return varchar2 is
      v_Text varchar2(100);
      v_Val  number := i_Val;
    begin
      if v_Val > 99 then
        v_Text := v_Text || v_Hundreds(Trunc(v_Val / 100)) || ' ';
        v_Val  := mod(v_Val, 100);
      end if;
    
      if v_Val > 10 and v_Val < 20 then
        v_Text := v_Text || v_Teens(v_Val - 10) || ' ';
        v_Val  := 0;
      elsif v_Val > 9 then
        v_Text := v_Text || v_Tens(Trunc(v_Val / 10)) || ' ';
        v_Val  := mod(v_Val, 10);
      end if;
    
      if v_Val > 0 then
        if v_Powers_Of_Ten = 1000 and v_Val = 1 and i_Lang_Code = 'ru' then
          v_Text := v_Text || 'одна ';
        elsif v_Powers_Of_Ten = 1000 and v_Val = 2 and i_Lang_Code = 'ru' then
          v_Text := v_Text || 'две ';
        else
          v_Text := v_Text || v_Units(v_Val) || ' ';
        end if;
      end if;
    
      if i_Val > 0 then
        v_Text := v_Text || i_Suffix || ' ';
      end if;
    
      return v_Text;
    end;
  begin
    if v_Value >= 1000 * v_Powers_Of_Ten then
      return i_Value;
    end if;
  
    if i_Value < 0 then
      if i_Lang_Code = 'en' then
        v_Text := v_Text || 'minus ';
      elsif i_Lang_Code = 'uz' then
        v_Text := v_Text || 'minus ';
      else
        v_Text := v_Text || 'минус ';
      end if;
    end if;
  
    if i_Value = 0 then
      if i_Lang_Code = 'en' then
        return 'zero';
      elsif i_Lang_Code = 'uz' then
        return 'nol';
      else
        return 'нуль';
      end if;
    end if;
  
    if i_Lang_Code = 'en' then
      v_Hundreds := Array_Varchar2('one hundred',
                                   'two hundred',
                                   'three hundred',
                                   'four hundred',
                                   'five hundred',
                                   'six hundred',
                                   'seven hundred',
                                   'eight hundred',
                                   'nine hundred');
      v_Teens    := Array_Varchar2('eleven',
                                   'twelve',
                                   'thirteen',
                                   'fourteen',
                                   'fifteen',
                                   'sixteen',
                                   'seventeen',
                                   'eighteen',
                                   'nineteen');
      v_Tens     := Array_Varchar2('ten',
                                   'twenty',
                                   'thirty',
                                   'forty',
                                   'fifty',
                                   'sixty',
                                   'seventy',
                                   'eighty',
                                   'ninety');
      v_Units    := Array_Varchar2('one',
                                   'two',
                                   'three',
                                   'four',
                                   'five',
                                   'six',
                                   'seven',
                                   'eight',
                                   'nine');
      v_Suffixes := Matrix_Varchar2(Array_Varchar2('trillion'),
                                    Array_Varchar2('billion'),
                                    Array_Varchar2('million'),
                                    Array_Varchar2('thousand'),
                                    Array_Varchar2(''));
    elsif i_Lang_Code = 'uz' then
      v_Hundreds := Array_Varchar2('bir yuz',
                                   'ikki yuz',
                                   'uch yuz',
                                   'to''rt yuz',
                                   'besh yuz',
                                   'olti yuz',
                                   'yetti yuz',
                                   'sakkiz yuz',
                                   'to''qqiz yuz');
      v_Teens    := Array_Varchar2('o''n bir',
                                   'o''n ikki',
                                   'o''n uch',
                                   'o''n to''rt',
                                   'o''n besh',
                                   'o''n olti',
                                   'o''n yetti',
                                   'o''n sakkiz',
                                   'o''n to''qqiz');
      v_Tens     := Array_Varchar2('o''n',
                                   'yigirma',
                                   'o''ttiz',
                                   'qirq',
                                   'ellik',
                                   'oltmish',
                                   'yetmish',
                                   'sakson',
                                   'to''qson');
      v_Units    := Array_Varchar2('bir',
                                   'ikki',
                                   'uch',
                                   'to''rt',
                                   'besh',
                                   'olti',
                                   'yetti',
                                   'sakkiz',
                                   'to''qqiz');
      v_Suffixes := Matrix_Varchar2(Array_Varchar2('trillion'),
                                    Array_Varchar2('milliard'),
                                    Array_Varchar2('million'),
                                    Array_Varchar2('ming'),
                                    Array_Varchar2(''));
    else
      v_Hundreds := Array_Varchar2('сто',
                                   'двести',
                                   'триста',
                                   'четыреста',
                                   'пятьсот',
                                   'шестьсот',
                                   'семьсот',
                                   'восемьсот',
                                   'девятьсот');
      v_Teens    := Array_Varchar2('одиннадцать',
                                   'двенадцать',
                                   'тринадцать',
                                   'четырнадцать',
                                   'пятнадцать',
                                   'шестнадцать',
                                   'семнадцать',
                                   'восемнадцать',
                                   'девятнадцать');
      v_Tens     := Array_Varchar2('десять',
                                   'двадцать',
                                   'тридцать',
                                   'сорок',
                                   'пятьдесят',
                                   'шестьдесят',
                                   'семьдесят',
                                   'восемьдесят',
                                   'девяносто');
      v_Units    := Array_Varchar2('один',
                                   'два',
                                   'три',
                                   'четыре',
                                   'пять',
                                   'шесть',
                                   'семь',
                                   'восемь',
                                   'девять');
      v_Suffixes := Matrix_Varchar2(Array_Varchar2('триллион',
                                                   'триллиона',
                                                   'триллионов'),
                                    Array_Varchar2('миллиар',
                                                   'миллионов',
                                                   'миллиардов'),
                                    Array_Varchar2('миллион',
                                                   'миллиона',
                                                   'миллионов'),
                                    Array_Varchar2('тысяча', 'тысячи', 'тысяч'),
                                    Array_Varchar2('', '', ''));
    end if;
  
    for i in 1 .. 5
    loop
      v_Part_Of_Number := Trunc(v_Value / v_Powers_Of_Ten);
      if i_Lang_Code = 'ru' then
        if mod(v_Part_Of_Number, 10) = 1 then
          v_Suffix := v_Suffixes(i) (1);
        elsif mod(v_Part_Of_Number, 10) in (2, 3, 4) then
          v_Suffix := v_Suffixes(i) (2);
        else
          v_Suffix := v_Suffixes(i) (3);
        end if;
      else
        v_Suffix := v_Suffixes(i) (1);
      end if;
    
      v_Text          := v_Text || Make_Number_Text(v_Part_Of_Number, v_Suffix);
      v_Value         := mod(v_Value, v_Powers_Of_Ten);
      v_Powers_Of_Ten := v_Powers_Of_Ten / 1000;
    end loop;
  
    return v_Text;
  end;

  ----------------------------------------------------------------------------------------------------
  -- specialty kind
  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind_Group return varchar2 is
  begin
    return t('specialty_kind:group');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind_Specialty return varchar2 is
  begin
    return t('specialty_kind:specialty');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Specialty_Kind(i_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Kind --
    when Href_Pref.c_Specialty_Kind_Group then t_Specialty_Kind_Group --
    when Href_Pref.c_Specialty_Kind_Specialty then t_Specialty_Kind_Specialty --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Specialty_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Specialty_Kind_Group,
                                          Href_Pref.c_Specialty_Kind_Specialty),
                           Array_Varchar2(t_Specialty_Kind_Group, t_Specialty_Kind_Specialty));
  end;

  ----------------------------------------------------------------------------------------------------
  -- staff status
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Working return varchar2 is
  begin
    return t('staff_status:working');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Dismissed return varchar2 is
  begin
    return t('staff_status:dismissed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status_Unknown return varchar2 is
  begin
    return t('staff_status:unknown');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Status(i_Staff_Status varchar2) return varchar2 is
  begin
    return --
    case i_Staff_Status --
    when Href_Pref.c_Staff_Status_Working then t_Staff_Status_Working --
    when Href_Pref.c_Staff_Status_Dismissed then t_Staff_Status_Dismissed --
    when Href_Pref.c_Staff_Status_Unknown then t_Staff_Status_Unknown --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Staff_Status_Working,
                                          Href_Pref.c_Staff_Status_Dismissed,
                                          Href_Pref.c_Staff_Status_Unknown),
                           Array_Varchar2(t_Staff_Status_Working,
                                          t_Staff_Status_Dismissed,
                                          t_Staff_Status_Unknown));
  
  end;
  ----------------------------------------------------------------------------------------------------
  -- staff kind
  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind_Primary return varchar2 is
  begin
    return t('staff_kind:primary');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind_Secondary return varchar2 is
  begin
    return t('staff_kind:secondary');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Staff_Kind(i_Staff_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Staff_Kind --
    when Href_Pref.c_Staff_Kind_Primary then t_Staff_Kind_Primary --
    when Href_Pref.c_Staff_Kind_Secondary then t_Staff_Kind_Secondary --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Staff_Kind_Primary,
                                          Href_Pref.c_Staff_Kind_Secondary),
                           Array_Varchar2(t_Staff_Kind_Primary, t_Staff_Kind_Secondary));
  end;

  ----------------------------------------------------------------------------------------------------
  -- employment source kind
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Hiring return varchar2 is
  begin
    return t('employment_source_kind:hiring');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Dismissal return varchar2 is
  begin
    return t('employment_source_kind:dismissal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source_Kind_Both return varchar2 is
  begin
    return t('employment_source_kind:both');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Source(i_Source_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Source_Kind --
    when Href_Pref.c_Employment_Source_Kind_Hiring then t_Employment_Source_Kind_Hiring --
    when Href_Pref.c_Employment_Source_Kind_Dismissal then t_Employment_Source_Kind_Dismissal --
    when Href_Pref.c_Employment_Source_Kind_Both then t_Employment_Source_Kind_Both --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employment_Source_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Employment_Source_Kind_Hiring,
                                          Href_Pref.c_Employment_Source_Kind_Dismissal,
                                          Href_Pref.c_Employment_Source_Kind_Both),
                           Array_Varchar2(t_Employment_Source_Kind_Hiring,
                                          t_Employment_Source_Kind_Dismissal,
                                          t_Employment_Source_Kind_Both));
  end;

  ----------------------------------------------------------------------------------------------------
  -- user access level
  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Personal return varchar2 is
  begin
    return t('user_access_level: personal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Direct_Employee return varchar2 is
  begin
    return t('user_access_level: direct employee');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Undirect_Employee return varchar2 is
  begin
    return t('user_access_level: undirect employee');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Manual return varchar2 is
  begin
    return t('user_access_level: manual');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Access_Level_Other return varchar2 is
  begin
    return t('user_access_level: other');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_User_Acces_Level(i_Acces_Level varchar2) return varchar2 is
  begin
    return --
    case i_Acces_Level --
    when Href_Pref.c_User_Access_Level_Personal then t_User_Access_Level_Personal --
    when Href_Pref.c_User_Access_Level_Direct_Employee then t_User_Access_Level_Direct_Employee --
    when Href_Pref.c_User_Access_Level_Undirect_Employee then t_User_Access_Level_Undirect_Employee --
    when Href_Pref.c_User_Access_Level_Manual then t_User_Access_Level_Manual --
    when Href_Pref.c_User_Access_Level_Other then t_User_Access_Level_Other --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Acces_Levels return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_User_Access_Level_Personal,
                                          Href_Pref.c_User_Access_Level_Direct_Employee,
                                          Href_Pref.c_User_Access_Level_Undirect_Employee,
                                          Href_Pref.c_User_Access_Level_Manual,
                                          Href_Pref.c_User_Access_Level_Other),
                           Array_Varchar2(t_User_Access_Level_Personal,
                                          t_User_Access_Level_Direct_Employee,
                                          t_User_Access_Level_Undirect_Employee,
                                          t_User_Access_Level_Manual,
                                          t_User_Access_Level_Other));
  end;

  ----------------------------------------------------------------------------------------------------
  -- indicator used
  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used_Constantly return varchar2 is
  begin
    return t('indicator_used:constantly');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used_Automatically return varchar2 is
  begin
    return t('indicator_used:automatically');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Indicator_Used(i_Used varchar2) return varchar2 is
  begin
    return --
    case i_Used --
    when Href_Pref.c_Indicator_Used_Constantly then t_Indicator_Used_Constantly --
    when Href_Pref.c_Indicator_Used_Automatically then t_Indicator_Used_Automatically --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Indicator_Useds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Indicator_Used_Constantly,
                                          Href_Pref.c_Indicator_Used_Automatically),
                           Array_Varchar2(t_Indicator_Used_Constantly,
                                          t_Indicator_Used_Automatically));
  end;

  ----------------------------------------------------------------------------------------------------
  -- candidate kind
  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind_New return varchar is
  begin
    return t('candidate_kind: new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Candidate_Kind(i_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Kind --
    when Href_Pref.c_Candidate_Kind_New then t_Candidate_Kind_New --
    when Href_Pref.c_Staff_Status_Unknown then t_Staff_Status_Unknown --
    when Href_Pref.c_Staff_Status_Working then t_Staff_Status_Working --
    when Href_Pref.c_Staff_Status_Dismissed then t_Staff_Status_Dismissed --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Candidate_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Candidate_Kind_New,
                                          Href_Pref.c_Staff_Status_Unknown,
                                          Href_Pref.c_Staff_Status_Working,
                                          Href_Pref.c_Staff_Status_Dismissed),
                           Array_Varchar2(t_Candidate_Kind_New,
                                          t_Staff_Status_Unknown,
                                          t_Staff_Status_Working,
                                          t_Staff_Status_Dismissed));
  end;

  ----------------------------------------------------------------------------------------------------
  -- dismissal reasons type
  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type_Positive return varchar2 is
  begin
    return t('dismissal_reasons_type: positive');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type_Negative return varchar2 is
  begin
    return t('dismissal_reasons_type: negative');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Dismissal_Reasons_Type(i_Dismissal_Reasons_Type varchar2) return varchar2 is
  begin
    return --
    case i_Dismissal_Reasons_Type --
    when Href_Pref.c_Dismissal_Reasons_Type_Positive then t_Dismissal_Reasons_Type_Positive --
    when Href_Pref.c_Dismissal_Reasons_Type_Negative then t_Dismissal_Reasons_Type_Negative --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Dismissal_Reasons_Type return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Dismissal_Reasons_Type_Positive,
                                          Href_Pref.c_Dismissal_Reasons_Type_Negative),
                           Array_Varchar2(t_Dismissal_Reasons_Type_Positive, --
                                          t_Dismissal_Reasons_Type_Negative));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Custom_Fte_Name return varchar2 is
  begin
    return t('custom fte name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_From_To_Rule
  (
    i_From      number,
    i_To        number,
    i_Rule_Unit varchar2
  ) return varchar2 is
    v_t_From varchar2(100 char);
    v_t_To   varchar2(100 char);
  begin
    if i_From is not null or i_To is null then
      v_t_From := t('from_to_rule:from $1{from_value} $2{rule_unit}', Nvl(i_From, 0), i_Rule_Unit);
    end if;
  
    if i_To is not null then
      v_t_To := t('from_to_rule:to $1{to_value} $2{rule_unit}', i_To, i_Rule_Unit);
    end if;
  
    return trim(v_t_From || ' ' || v_t_To);
  end;

  ----------------------------------------------------------------------------------------------------
  -- person document status
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_New return varchar2 is
  begin
    return t('person_document_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_Approved return varchar2 is
  begin
    return t('person_document_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status_Rejected return varchar2 is
  begin
    return t('person_document_status:rejected');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Href_Pref.c_Person_Document_Status_New then t_Person_Document_Status_New --
    when Href_Pref.c_Person_Document_Status_Approved then t_Person_Document_Status_Approved --
    when Href_Pref.c_Person_Document_Status_Rejected then t_Person_Document_Status_Rejected --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  -- person document owe status
  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Complete return varchar2 is
  begin
    return t('person_document_owe_status:complete');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Partial return varchar2 is
  begin
    return t('person_document_owe_status:partial');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status_Exempt return varchar2 is
  begin
    return t('person_document_owe_status:exempt');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Person_Document_Owe_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Href_Pref.c_Person_Document_Owe_Status_Complete then t_Person_Document_Owe_Status_Complete --
    when Href_Pref.c_Person_Document_Owe_Status_Partial then t_Person_Document_Owe_Status_Partial --
    when Href_Pref.c_Person_Document_Owe_Status_Exempt then t_Person_Document_Owe_Status_Exempt --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Person_Document_Owe_Status return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Href_Pref.c_Person_Document_Owe_Status_Complete,
                                          Href_Pref.c_Person_Document_Owe_Status_Partial,
                                          Href_Pref.c_Person_Document_Owe_Status_Exempt),
                           Array_Varchar2(t_Person_Document_Owe_Status_Complete,
                                          t_Person_Document_Owe_Status_Partial,
                                          t_Person_Document_Owe_Status_Exempt));
  end;

  ----------------------------------------------------------------------------------------------------
  -- verify person uniqueness
  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Name return varchar2 is
  begin
    return t('verify_person_uniqueness_column:name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Passport_Number return varchar2 is
  begin
    return t('verify_person_uniqueness_column:passport_number');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column_Npin return varchar2 is
  begin
    return t('verify_person_uniqueness_column:npin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Verify_Person_Uniqueness_Column(i_Column varchar2) return varchar2 is
  begin
    return --
    case i_Column --
    when Href_Pref.c_Vpu_Column_Name then t_Verify_Person_Uniqueness_Column_Name --
    when Href_Pref.c_Vpu_Column_Passport_Number then t_Verify_Person_Uniqueness_Column_Passport_Number --
    when Href_Pref.c_Vpu_Column_Npin then t_Verify_Person_Uniqueness_Column_Npin --
    end;
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- employee personal audit column names
  ----------------------------------------------------------------------------------------------------
  Function t_First_Name return varchar2 is
  begin
    return t('first name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Last_Name return varchar2 is
  begin
    return t('last name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Middle_Name return varchar2 is
  begin
    return t('middle name');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Nationality return varchar2 is
  begin
    return t('nationality');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Birthday return varchar2 is
  begin
    return t('birthday');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Gender return varchar2 is
  begin
    return t('gender');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Npin return varchar2 is
  begin
    return t('npin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Iapa return varchar2 is
  begin
    return t('iapa');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Tin return varchar2 is
  begin
    return t('tin');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Note return varchar2 is
  begin
    return t('note');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Personal_Audit_Column_Names return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(z.First_Name,
                                          z.Last_Name,
                                          z.Middle_Name,
                                          z.Nationality,
                                          z.Birthday,
                                          z.Gender,
                                          z.Npin,
                                          z.Iapa,
                                          z.Tin,
                                          z.Note),
                           Array_Varchar2(t_First_Name,
                                          t_Last_Name,
                                          t_Middle_Name,
                                          t_Nationality,
                                          t_Birthday,
                                          t_Gender,
                                          t_Npin,
                                          t_Iapa,
                                          t_Tin,
                                          t_Note));
  end;

  ---------------------------------------------------------------------------------------------------- 
  -- employee contact audit column names
  ----------------------------------------------------------------------------------------------------
  Function t_Main_Phone return varchar2 is
  begin
    return t('main phone');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Extra_Phone return varchar2 is
  begin
    return t('extra phone');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Email return varchar2 is
  begin
    return t('email');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Corporate_Email return varchar2 is
  begin
    return t('corporate email');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Region return varchar2 is
  begin
    return t('region');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Address return varchar2 is
  begin
    return t('address');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Legal_Address return varchar2 is
  begin
    return t('legal address');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employee_Contact_Audit_Column_Names return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(z.Main_Phone,
                                          z.Extra_Phone,
                                          z.Email,
                                          z.Corporate_Email,
                                          z.Region,
                                          z.Address,
                                          z.Legal_Address),
                           Array_Varchar2(t_Main_Phone,
                                          t_Extra_Phone,
                                          t_Email,
                                          t_Corporate_Email,
                                          t_Region,
                                          t_Address,
                                          t_Legal_Address));
  end;

end Href_Util;
/
