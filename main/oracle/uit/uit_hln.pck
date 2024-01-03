create or replace package Uit_Hln is
  ----------------------------------------------------------------------------------------------------
  Function Get_Testing_Count
  (
    i_Attestation_Id number,
    i_Status         varchar2
  ) return number;
end Uit_Hln;
/
create or replace package body Uit_Hln is
  ----------------------------------------------------------------------------------------------------
  Function Get_Testing_Count
  (
    i_Attestation_Id number,
    i_Status         varchar2
  ) return number is
    result number;
  begin
    select count(*)
      into result
      from Hln_Attestation_Testings q
      join Hln_Testings w
        on w.Company_Id = q.Company_Id
       and w.Testing_Id = q.Testing_Id
       and w.Status = i_Status
     where q.Company_Id = Ui.Company_Id
       and q.Attestation_Id = i_Attestation_Id;
  
    return result;
  end;

end Uit_Hln;
/
