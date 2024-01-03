create or replace package Href_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Specialty_Id   number,
    i_Specialty_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Specialty_Id   number,
    i_Specialty_Name varchar2,
    i_Parent_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Document_Type_Id   number,
    i_Document_Type_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004
  (
    i_Document_Type_Id   number,
    i_Document_Type_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005(i_Person_Edu_Stage_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Person_Reference_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010(i_Person_Family_Member_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011(i_Person_Marital_Status_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012(i_Person_Experience_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013(i_Person_Award_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014(i_Person_Work_Place_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015(i_Document_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016
  (
    i_Indicator_Id   number,
    i_Indicator_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Fte_Id   number,
    i_Fte_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018
  (
    i_Employee_Name  varchar2,
    i_Period_Begin   date,
    i_Period_End     date,
    i_Unlicensed_Day date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019(i_Labor_Function_Code varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020(i_Labor_Function_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021(i_Fixed_Term_Base_Code varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022(i_Fixed_Term_Base_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023(i_Fte_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024(i_Fte_Pcode varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026
  (
    i_Employee_Name varchar2,
    i_All           boolean,
    i_Direct        boolean,
    i_Undirect      boolean,
    i_Manual        boolean,
    i_Division_Name varchar2,
    i_Parent_Name   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028(i_Column varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Nationality_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030(i_User_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033(i_Division_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Limit number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Limit number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036(i_Value number);
end Href_Error;
/
create or replace package body Href_Error is
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
  Procedure Error
  (
    i_Code    varchar2,
    i_Message varchar2,
    i_Title   varchar2 := null,
    i_S1      varchar2 := null,
    i_S2      varchar2 := null,
    i_S3      varchar2 := null,
    i_S4      varchar2 := null,
    i_S5      varchar2 := null
  ) is
  begin
    b.Raise_Extended(i_Code    => verifix.Href_Error_Code   || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Column_Name(i_Column_Name varchar2) return varchar2 is
  begin
    case i_Column_Name
      when Href_Pref.c_Pref_Crs_Last_Name then
        return t('column_name: last_name');
      when Href_Pref.c_Pref_Crs_Middle_Name then
        return t('column_name: middle_name');
      when Href_Pref.c_Pref_Crs_Birthday then
        return t('column_name: birthday');
      when Href_Pref.c_Pref_Crs_Phone_Number then
        return t('column_name: phone_number');
      when Href_Pref.c_Pref_Crs_Email then
        return t('column_name: email');
      when Href_Pref.c_Pref_Crs_Region then
        return t('column_name: region');
      when Href_Pref.c_Pref_Crs_Address then
        return t('column_name: address');
      when Href_Pref.c_Pref_Crs_Legal_Address then
        return t('column_name: legal_address');
      when Href_Pref.c_Pref_Crs_Passport then
        return t('column_name:', 'passport');
      when Href_Pref.c_Pref_Crs_Iapa then
        return t('column_name: iapa');
      when Href_Pref.c_Pref_Crs_Npin then
        return t('column_name: npin');
      else
        b.Raise_Not_Implemented;
    end case;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Specialty_Id   number,
    i_Specialty_Name varchar2
  ) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message: the specialty kind of $1{specialty_name} cannot be changed, specialty_id: $1',
                         i_Specialty_Name,
                         i_Specialty_Id),
          i_Title   => t('001:title: specialty kind can not be changed'),
          i_S1      => t('001:solution: restore old specilaty kind'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Specialty_Id   number,
    i_Specialty_Name varchar2,
    i_Parent_Name    varchar2
  ) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message: the specialty kind of $1{parent_specialty_name} (parent of $2{specialty_name}) is not group, specialty_id: $3',
                         i_Parent_Name,
                         i_Specialty_Name,
                         i_Specialty_Id),
          i_Title   => t('002:title: parent specialty kind must be group'),
          i_S1      => t('002:solution: change parent which specialty kind is the group'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Document_Type_Id   number,
    i_Document_Type_Name varchar2
  ) is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message: $1{document_type_name} is system document type, it cannot be changed, document_type_id: $2',
                         i_Document_Type_Name,
                         i_Document_Type_Id),
          i_Title   => t('003:title: system document type is readonly'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004
  (
    i_Document_Type_Id   number,
    i_Document_Type_Name varchar2
  ) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message: $1{document_type_name} is system document type, it cannot be deleted, document_type_id: $2',
                         i_Document_Type_Name,
                         i_Document_Type_Id),
          i_Title   => t('004:title: system document type is readonly'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005(i_Person_Edu_Stage_Id number) is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message: the person of person edu stage cannot be changed, person_edu_stage_id: $1',
                         i_Person_Edu_Stage_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Person_Reference_Id number) is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message: the person of person reference cannot be changed, person_reference_id: $1',
                         i_Person_Reference_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010(i_Person_Family_Member_Id number) is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message: the person of person family member cannot be changed, person_family_member_id: $1',
                         i_Person_Family_Member_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011(i_Person_Marital_Status_Id number) is
  begin
    Error(i_Code    => '011',
          i_Message => t('011:message: the person of person marital status cannot be changed, person_marital_status_id: $1',
                         i_Person_Marital_Status_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012(i_Person_Experience_Id number) is
  begin
    Error(i_Code    => '012',
          i_Message => t('012:message: the person of person experience cannot be changed, person_experience_id: $1',
                         i_Person_Experience_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013(i_Person_Award_Id number) is
  begin
    Error(i_Code    => '013',
          i_Message => t('013:message: the person of person award cannot be changed, person_award_id: $1',
                         i_Person_Award_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014(i_Person_Work_Place_Id number) is
  begin
    Error(i_Code    => '014',
          i_Message => t('014:message: the person of person work place cannot be changed, person_work_place_id: $1',
                         i_Person_Work_Place_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015(i_Document_Id number) is
  begin
    Error(i_Code    => '015',
          i_Message => t('015:message: the person of document cannot be changed, document_id: $1',
                         i_Document_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016
  (
    i_Indicator_Id   number,
    i_Indicator_Name varchar2
  ) is
  begin
    Error(i_Code    => '016',
          i_Message => t('016:message: $1{indicator_name} is system indicator, it cannot be deleted, indicator_id: $2',
                         i_Indicator_Name,
                         i_Indicator_Id),
          i_Title   => t('016:title: system indicator cannot be deleted'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Fte_Id   number,
    i_Fte_Name varchar2
  ) is
  begin
    Error(i_Code    => '017',
          i_Message => t('017:message: $1{fte_name} is system fte, it cannot be deleted, fte_id: $2',
                         i_Fte_Name,
                         i_Fte_Id),
          i_Title   => t('017:title: system fte cannot be deleted'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018
  (
    i_Employee_Name  varchar2,
    i_Period_Begin   date,
    i_Period_End     date,
    i_Unlicensed_Day date
  ) is
  begin
    Error(i_Code    => '018',
          i_Message => t('018:message: $1{day} is unlicensed day for $2{employee_name}, period_begin: $3, period_end: $4',
                         i_Unlicensed_Day,
                         i_Employee_Name,
                         i_Period_Begin,
                         i_Period_End),
          i_Title   => t('018:title: unlicensed day is found in a given period'),
          i_S1      => t('018:solution: tell the admin that need to buy a license and put it in the system, and try this action'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019(i_Labor_Function_Code varchar2) is
  begin
    Error(i_Code    => '019',
          i_Message => t('019:message: labor function is not found by given $1{code} code',
                         i_Labor_Function_Code),
          i_Title   => t('019:title: labor function is not found by given code'),
          i_S1      => t('019:solution: try another code'),
          i_S2      => t('019:solution: create labor function by setting the code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020(i_Labor_Function_Name varchar2) is
  begin
    Error(i_Code    => '020',
          i_Message => t('020:message: labor function is not found by given $1{name} name',
                         i_Labor_Function_Name),
          i_Title   => t('020:title: labor function is not found by given name'),
          i_S1      => t('020:solution: try another name'),
          i_S2      => t('020:solution: create labor function by setting the name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021(i_Fixed_Term_Base_Code varchar2) is
  begin
    Error(i_Code    => '021',
          i_Message => t('021:message: fixed term base is not found by given $1{code} code',
                         i_Fixed_Term_Base_Code),
          i_Title   => t('021:title: fixed term base is not found by given code'),
          i_S1      => t('021:solution: try another code'),
          i_S2      => t('021:solution: create fixed term base by setting the code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022(i_Fixed_Term_Base_Name varchar2) is
  begin
    Error(i_Code    => '022',
          i_Message => t('022:message: fixed term base is not found by given $1{name} name',
                         i_Fixed_Term_Base_Name),
          i_Title   => t('022:title: fixed term base is not found by given name'),
          i_S1      => t('022:solution: try another name'),
          i_S2      => t('022:solution: create fixed term base by setting the name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023(i_Fte_Name varchar2) is
  begin
    Error(i_Code    => '023',
          i_Message => t('023:message: fte is not found by given $1{name} name', i_Fte_Name),
          i_Title   => t('023:title: fte is not found by given name'),
          i_S1      => t('023:solution: try another name'),
          i_S2      => t('023:solution: create fte by setting the name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024(i_Fte_Pcode varchar2) is
  begin
    Error(i_Code    => '024',
          i_Message => t('024:message: fte is not found by given $1{pcode} pcode', i_Fte_Pcode),
          i_Title   => t('024:title: fte is not found by given pcode'),
          i_S1      => t('024:solution: tell developers'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025 is
  begin
    Error(i_Code    => '025',
          i_Message => t('025:message: the user has no acces to all employee'),
          i_Title   => t('025:title: no acces to all employee'),
          i_S1      => t('025:solution: enable access all employee for this user'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026
  (
    i_Employee_Name varchar2,
    i_All           boolean,
    i_Direct        boolean,
    i_Undirect      boolean,
    i_Manual        boolean,
    i_Division_Name varchar2,
    i_Parent_Name   varchar2
  ) is
    v_S1 varchar2(4000 char);
    v_S2 varchar2(4000 char);
    v_S3 varchar2(4000 char);
    v_S4 varchar2(4000 char);
  begin
    if i_All then
      v_S1 := t('026:solution: enable access all employee for this user');
    end if;
  
    if i_Direct and i_Division_Name is not null then
      v_S2 := t('026:solution: be manager of the division $1{division_name}', i_Division_Name);
    end if;
  
    if i_Undirect and i_Parent_Name is not null then
      v_S3 := t('026:solution: be master manager of the division $1{parent_division_name}',
                i_Parent_Name);
    end if;
  
    if i_Manual and i_Division_Name is not null then
      v_S4 := t('026:solution: be manual manager of the division $1{division_name}',
                i_Division_Name);
    end if;
  
    Error(i_Code    => '026',
          i_Message => t('026:message: user has no access to $1{employee_name}', i_Employee_Name),
          i_Title   => t('026:title: no acces to employee'),
          i_S1      => v_S1,
          i_S2      => v_S2,
          i_S3      => v_S3,
          i_S4      => v_S4);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027 is
  begin
    Error(i_Code    => '027',
          i_Message => t('027:message: the user has no direct employees'),
          i_Title   => t('027:title: no direct employees'),
          i_S1      => t('027:solution: admin has access to all employee'),
          i_S2      => t('027:solution: the user must be manager to at least one direct employee'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_028(i_Column varchar2) is
  begin
    Error(i_Code    => '028',
          i_Message => t('028:message: $1{column_name} not found', t_Column_Name(i_Column)),
          i_Title   => t('028:title: required column not found'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Nationality_Name varchar2) is
  begin
    Error(i_Code    => '029',
          i_Message => t('029:message: nationality is not found by given $1{name} name',
                         i_Nationality_Name),
          i_Title   => t('029:title: nationality is not found by given name'),
          i_S1      => t('029:solution: try another name'),
          i_S2      => t('029:solution: create nationality by setting the name'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030(i_User_Name varchar2) is
  begin
    Error(i_Code    => '030',
          i_Message => t('030:message: $1{user name} is passive user. passive user can not get system access',
                         i_User_Name),
          i_Title   => t('030:title: user state is passive'),
          i_S1      => t('030:solution:change user state to active'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031 is
  begin
    Error(i_Code    => '031',
          i_Message => t('031:message:verify person uniqueness setting must be in (Y, N)'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032 is
  begin
    Error(i_Code    => '032',
          i_Message => t('032:message:verify person uniqueness column must be in ($1, $2, $3)',
                         Href_Util.t_Verify_Person_Uniqueness_Column(Href_Pref.c_Vpu_Column_Name),
                         Href_Util.t_Verify_Person_Uniqueness_Column(Href_Pref.c_Vpu_Column_Passport_Number),
                         Href_Util.t_Verify_Person_Uniqueness_Column(Href_Pref.c_Vpu_Column_Npin)));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033(i_Division_Name varchar2) is
  begin
    Error(i_Code    => '033',
          i_Message => t('033:message: user has no access to division $1{division_name}',
                         i_Division_Name),
          i_Title   => t('033:title: no acces to division'),
          i_S1      => t('033:solution: change division to other division that user has access'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Limit number) is
  begin
    Error(i_Code    => '034',
          i_Message => t('035:message:request note limit must be less than 300 and at least 1, limit: $1{limit}',
                         i_Limit));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Limit number) is
  begin
    Error(i_Code    => '035',
          i_Message => t('035:message:plan change note limit must be less than 300 and at least 1, limit: $1{limit}',
                         i_Limit));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036(i_Value number) is
  begin
    Error(i_Code    => '036',
          i_Message => t('036:message:fte limit must be positive, current_value: $1', i_Value));
  end;

end Href_Error;
/
