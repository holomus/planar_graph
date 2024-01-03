create or replace package Hface_Next is
  ----------------------------------------------------------------------------------------------------
  Function Calculated_Photo_Id return number;
end Hface_Next;
/
create or replace package body Hface_Next is
  ----------------------------------------------------------------------------------------------------
  Function Calculated_Photo_Id return number is
  begin
    return Hface_Calculated_Photos_Sq.Nextval;
  end;
end Hface_Next;
/
