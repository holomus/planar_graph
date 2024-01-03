create or replace package Hlic_Next is
  ----------------------------------------------------------------------------------------------------
  Function Interval_Id return number;
end Hlic_Next;
/
create or replace package body Hlic_Next is
  ----------------------------------------------------------------------------------------------------
  Function Interval_Id return number is
  begin
    return Hlic_Required_Intervals_Sq.Nextval;
  end;

end Hlic_Next;
/
