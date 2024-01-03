create or replace package Hln_Next is
  ----------------------------------------------------------------------------------------------------
  Function Question_Group_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Question_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Question_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Question_Option_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Exam_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Pattern_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Testing_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Attestation_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Subject_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Training_Id return number;
  ----------------------------------------------------------------------------------------------------  
  Function Training_Subject_Group_Id return number;
end Hln_Next;
/
create or replace package body Hln_Next is
  ----------------------------------------------------------------------------------------------------
  Function Question_Group_Id return number is
  begin
    return Hln_Question_Groups_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Question_Type_Id return number is
  begin
    return Hln_Question_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Question_Id return number is
  begin
    return Hln_Questions_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Question_Option_Id return number is
  begin
    return Hln_Question_Options_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Exam_Id return number is
  begin
    return Hln_Exams_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Pattern_Id return number is
  begin
    return Hln_Exam_Patterns_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Testing_Id return number is
  begin
    return Hln_Testings_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Attestation_Id return number is
  begin
    return Hln_Attestations_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Subject_Id return number is
  begin
    return Hln_Training_Subjects_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Training_Id return number is
  begin
    return Hln_Trainings_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Training_Subject_Group_Id return number is
  begin
    return Hln_Training_Subject_Groups_Sq.Nextval;
  end;

end Hln_Next;
/
