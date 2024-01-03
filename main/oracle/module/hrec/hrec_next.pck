create or replace package Hrec_Next is
  ----------------------------------------------------------------------------------------------------
  Function Stage_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Funnel_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Reject_Reason_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Application_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Operation_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Group_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Type_Id return number;
end Hrec_Next;
/
create or replace package body Hrec_Next is
  ----------------------------------------------------------------------------------------------------
  Function Stage_Id return number is
  begin
    return Hrec_Stages_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Funnel_Id return number is
  begin
    return Hrec_Funnels_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Reject_Reason_Id return number is
  begin
    return Hrec_Reject_Reasons_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Id return number is
  begin
    return Hrec_Applications_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Vacancy_Id return number is
  begin
    return Hrec_Vacancies_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Operation_Id return number is
  begin
    return Hrec_Operations_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Group_Id return number is
  begin
    return Hrec_Vacancy_Groups_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Vacancy_Type_Id return number is
  begin
    return Hrec_Vacancy_Types_Sq.Nextval;
  end;

end Hrec_Next;
/
