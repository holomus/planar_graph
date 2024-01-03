create or replace package Hes_Next is
  ---------------------------------------------------------------------------------------------------- 
  Function Sale_Id return number;
end Hes_Next;
/
create or replace package body Hes_Next is
  ---------------------------------------------------------------------------------------------------- 
  Function Sale_Id return number is
  begin
    return Hes_Billz_Consolidated_Sales_Sq.Nextval;
  end;

end Hes_Next;
/
