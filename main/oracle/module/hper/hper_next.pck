create or replace package Hper_Next is
  ----------------------------------------------------------------------------------------------------
  Function Plan_Group_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Plan_Type_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Plan_Id return number;
  ----------------------------------------------------------------------------------------------------
  Function Part_Id return number;
end Hper_Next;
/
create or replace package body Hper_Next is
  ----------------------------------------------------------------------------------------------------
  Function Plan_Group_Id return number is
  begin
    return Hper_Plan_Groups_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Type_Id return number is
  begin
    return Hper_Plan_Types_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Plan_Id return number is
  begin
    return Hper_Staff_Plans_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Plan_Id return number is
  begin
    return Hper_Plans_Sq.Nextval;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Part_Id return number is
  begin
    return Hper_Staff_Plan_Parts_Sq.Nextval;
  end;

end Hper_Next;
/
