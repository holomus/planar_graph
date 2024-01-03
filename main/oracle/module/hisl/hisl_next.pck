create or replace package Hisl_Next is
  ----------------------------------------------------------------------------------------------------
  Function Log_Id return number;
end Hisl_Next;
/
create or replace package body Hisl_Next is
  ----------------------------------------------------------------------------------------------------
  Function Log_Id return number is
  begin
    return Hisl_Logs_Sq.Nextval;
  end;

end Hisl_Next;
/
