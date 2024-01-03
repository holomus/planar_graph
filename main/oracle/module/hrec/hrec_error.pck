create or replace package Hrec_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003(i_Stage_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Stage_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005(i_Funnel_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Vacancy_Id number,
    i_State_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Candidate_Id number,
    i_Stage_Name   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014(i_Funnel_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Operation_Id   number,
    i_Operation_Kind varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016(i_Stage_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Vacancy_Id  number,
    i_Closed_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019(i_Error_Code varchar2);
  ----------------------------------------------------------------------------------------------------  
  Procedure Raise_020(i_Job_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021(i_Region_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023(i_Vacancy_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024(i_Vacancy_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025(i_Vacancy_Name varchar2);
  ----------------------------------------------------------------------------------------------------    
  Procedure Raise_026;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Vacancy_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028(i_Region_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Vacancy_Name varchar2);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_030(i_Error_Title varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031(i_Vacancy_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Group_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Group_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036(i_Type_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_037(i_Type_Name varchar2);
end Hrec_Error;
/
create or replace package body Hrec_Error is
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
    b.Raise_Extended(i_Code    => Verifix.Hrec_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message:for save application status must be draft or waiting, application id: $1{application_id}, current status: $2{status_name}',
                         i_Application_Id,
                         i_Status_Name),
          i_Title   => t('001:title:status must be draft'),
          i_S1      => t('001:solution:change application status to draft or waiting and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:for delete application status must be draft or waiting, application id: $1{application_id}, current status: $2{status_name}',
                         i_Application_Id,
                         i_Status_Name),
          i_Title   => t('002:title:status must be draft or waiting'),
          i_S1      => t('002:solution:change application status to draft or waiting and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003(i_Stage_Name varchar2) is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:this stage $1{stage_name} is system entity, you can not delete it',
                         i_Stage_Name),
          i_Title   => t('003:title:system entities cannot delete'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Stage_Name varchar2) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:for save stage pcode must be null, stage name: $1{stage_name}',
                         i_Stage_Name),
          i_Title   => t('003:title:pcode must be null'),
          i_S1      => t('004:solution:please delete pcode and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005(i_Funnel_Name varchar2) is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message:this funnel $1{stage_name} is system entity, you can not delete it',
                         i_Funnel_Name),
          i_Title   => t('005:title:system entities cannot delete'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:for save application status must be draft or waiting, application id: $1{application_id}, current status: $2{status_name}',
                         i_Application_Id,
                         i_Status_Name),
          i_Title   => t('006:title:status must be draft'),
          i_S1      => t('006:solution:change application status to draft or waiting and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Vacancy_Id number,
    i_State_Name varchar2
  ) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message:for save vacancy status must be opened, current state: $1{state_name}, vacancy id: $2{vacancy_id}',
                         i_State_Name,
                         i_Vacancy_Id),
          i_Title   => t('007:title:state must be opend'),
          i_S1      => t('007:solution:change vacancy state to opened and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Candidate_Id number,
    i_Stage_Name   varchar2
  ) is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message:for remove candidate, stage must be todo, cancidate id: $1{candidate_id}, current stage: $2{stage_name}',
                         i_Candidate_Id,
                         i_Stage_Name),
          i_Title   => t('008:title:current stage must be todo'),
          i_S1      => t('008:solution:change stage todo and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message:for change application status to draft current status must be canceled, application id: $1{application_id}, current status: $2{status_name}',
                         i_Application_Id,
                         i_Status_Name),
          i_Title   => t('009:title:status must be canceled'),
          i_S1      => t('009:solution:change status to canceled and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message:for change application status to waiting current status must be draft, application id: $1{application_id}, current status: $2{status_name}',
                         i_Application_Id,
                         i_Status_Name),
          i_Title   => t('010:title:status must be draft'),
          i_S1      => t('010:solution:change status to draft and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '011',
          i_Message => t('011:message:for change application status to approved current status must be waiting, application id: $1{application_id}, current status: $2{status_name}',
                         i_Application_Id,
                         i_Status_Name),
          i_Title   => t('011:title:status must be waiting'),
          i_S1      => t('011:solution:change status to waiting and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '012',
          i_Message => t('012:message:for change application status to complited current status must be approved, application id: $1{application_id}, current status: $2{status_name}',
                         i_Application_Id,
                         i_Status_Name),
          i_Title   => t('012:title:status must be approved'),
          i_S1      => t('012:solution:change status to approved and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Application_Id number,
    i_Status_Name    varchar2
  ) is
  begin
    Error(i_Code    => '013',
          i_Message => t('013:message:for change application status to complited canceled status must be waiting, application id: $1{application_id}, current status: $2{status_name}',
                         i_Application_Id,
                         i_Status_Name),
          i_Title   => t('013:title:status must be waiting'),
          i_S1      => t('013:solution:change status to waiting and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014(i_Funnel_Name varchar2) is
  begin
    Error(i_Code    => '014',
          i_Message => t('014:message:you can not edit system funnel, funnel name: $1{funnel_name}',
                         i_Funnel_Name),
          i_Title   => t('014:title:system entity can not edit'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Operation_Id   number,
    i_Operation_Kind varchar2
  ) is
  begin
    Error(i_Code    => '015',
          i_Message => t('015:message:you can delete only comment operation, not action operation, operation id: $1{operation_id}, operation kind: $2{operation_kind}',
                         i_Operation_Id,
                         i_Operation_Kind),
          i_Title   => t('015:title:you can delete only comment operation'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016(i_Stage_Name varchar2) is
  begin
    Error(i_Code    => '016',
          i_Message => t('016:message:you can not make a passive, in this stage $1{stage_name} has a candidates',
                         i_Stage_Name),
          i_Title   => t('016:title:you can not make a passive'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Vacancy_Id  number,
    i_Closed_Date date
  ) is
  begin
    Error(i_Code    => '017',
          i_Message => t('017:message:vacancy is already closed, vacancy id: $1{vacancy_id}, closed date: $2{closed_date}',
                         i_Vacancy_Id,
                         i_Closed_Date),
          i_Title   => t('017:title:you can close vacancy'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018 is
  begin
    Error(i_Code    => '018',
          i_Message => t('018:message:you must be auth to hh.ru'),
          i_Title   => t('018:title:no access'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019(i_Error_Code varchar2) is
    --------------------------------------------------
    Function Error_Message(i_Error_Code varchar2) return varchar2 is
    begin
      case i_Error_Code
        when Hrec_Pref.c_Hh_Error_Bad_Authorization then
          return t('019:message:access token invalid or does not exist');
        when Hrec_Pref.c_Hh_Error_Token_Expired then
          return t('019:message:access token lifetime exprired');
        when Hrec_Pref.c_Hh_Error_Token_Revoked then
          return t('019:message:access token was revoked');
        when Hrec_Pref.c_Hh_Error_Application_Not_Found then
          return t('019:message:your hh application was deleted');
        when Hrec_Pref.c_Hh_Error_Used_Manager_Account_Forbidden then
          return t('019:message:your manager account was blocked');
        else
          null;
      end case;
    
      return i_Error_Code;
    end;
  
  begin
    Error(i_Code    => '019',
          i_Message => Error_Message(i_Error_Code),
          i_Title   => t('019:title:hh error'),
          i_S1      => t('019:solution:try reloggin to hh'),
          i_S2      => t('019:solution:contact your admin to see if your hh application was not deleted'),
          i_S3      => t('019:solution:contact your admin to see if your hh account was not blocked'));
  end;
  ----------------------------------------------------------------------------------------------------  
  Procedure Raise_020(i_Job_Name varchar2) is
  begin
    Error(i_Code    => '020',
          i_Message => t('020:message:for this job connect with head hunter not found, job name: $1{job_name}',
                         i_Job_Name),
          i_Title   => t('020:title:connect not found'),
          i_S1      => t('020:solution:set data map with head hunter for this job and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021(i_Region_Name varchar2) is
  begin
    Error(i_Code    => '021',
          i_Message => t('021:message:for this region connect with head hunter not found, region name: $1{region_name}',
                         i_Region_Name),
          i_Title   => t('021:title:connect not found'),
          i_S1      => t('021:solution:set data map with head hunter for this region and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023(i_Vacancy_Name varchar2) is
  begin
    Error(i_Code    => '023',
          i_Message => t('023:message:this vacancy is already published to Head Hunter, vacancy name: $1{vacancy_name}',
                         i_Vacancy_Name),
          i_Title   => t('023:title:vacancy already published'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024(i_Vacancy_Name varchar2) is
  begin
    Error(i_Code    => '024',
          i_Message => t('024:message:this vacancy is already published to Head Hunter, vacancy name: $1{vacancy_name}',
                         i_Vacancy_Name),
          i_Title   => t('024:title:vacancy already published'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025(i_Vacancy_Name varchar2) is
  begin
    Error(i_Code    => '025',
          i_Message => t('025:message:this vacancy is already published to Head Hunter, vacancy name: $1{vacancy_name}',
                         i_Vacancy_Name),
          i_Title   => t('025:title:vacancy already published'));
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Raise_026 is
  begin
    Error(i_Code    => '026',
          i_Message => t('026:message:you must be auth to olx.uz'),
          i_Title   => t('026:title:no access'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Vacancy_Name varchar2) is
  begin
    Error(i_Code    => '027',
          i_Message => t('027:message:this vacancy is already published to Olx, vacancy name: $1{vacancy_name}',
                         i_Vacancy_Name),
          i_Title   => t('027:title:vacancy already published'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028(i_Region_Name varchar2) is
  begin
    Error(i_Code    => '028',
          i_Message => t('028:message:you must be integrate system region to Olx region, system region name: $1{region_name}',
                         i_Region_Name),
          i_Title   => t('028:title:region is not integrated'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Vacancy_Name varchar2) is
  begin
    Error(i_Code    => '029',
          i_Message => t('029:message:this vacancy is already published to Olx, vacancy name: $1{vacancy_name}',
                         i_Vacancy_Name),
          i_Title   => t('029:title:vacancy already published'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_030(i_Error_Title varchar2) is
  begin
    Error(i_Code    => '030',
          i_Message => t('030:message:$1{error_title}', i_Error_Title),
          i_Title   => t('030:title:error in publish vacancy to olx'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031(i_Vacancy_Name varchar2) is
  begin
    Error(i_Code    => '031',
          i_Message => t('031:message:this vacancy is already published to Olx, vacancy name: $1{vacancy_name}',
                         i_Vacancy_Name),
          i_Title   => t('031:title:vacancy already published'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032 is
  begin
    Error(i_Code    => '032',
          i_Message => t('032:message:find some problems in olx serve, please wait'),
          i_Title   => t('032:title:find problem in OLX server'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033 is
  begin
    Error(i_Code    => '033',
          i_Message => t('033:message:error in load, candidate info, plase try again'),
          i_Title   => t('033:title:error in load candidate info'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Group_Name varchar2) is
  begin
    Error(i_Code    => '034',
          i_Message => t('034:message:you can not change system pcode, vacancy group name: $1',
                         i_Group_Name),
          i_Title   => t('034:title:you can not change'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Group_Name varchar2) is
  begin
    Error(i_Code    => '035',
          i_Message => t('035:message:you can not delete system vacancy group, vacancy group name: $1',
                         i_Group_Name),
          i_Title   => t('035:title:you can not delete'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036(i_Type_Name varchar2) is
  begin
    Error(i_Code    => '036',
          i_Message => t('036:message:you can not change system pcode, vacancy type name: $1',
                         i_Type_Name),
          i_Title   => t('036:title:you can not change'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_037(i_Type_Name varchar2) is
  begin
    Error(i_Code    => '037',
          i_Message => t('037:message:you can not delete system vacancy type, vacancy type name: $1',
                         i_Type_Name),
          i_Title   => t('037:title:you can not delete'));
  end;

end Hrec_Error;
/
