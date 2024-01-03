create or replace Function Hcr_Timeuuid
(
  i_Time varchar2,
  i_Sp1  varchar2,
  i_Sp2  varchar2
) return varchar2 is
  v_Key varchar2(100) := '3685cbd~L$BQkoPtZx71%d38baQI*45T}k82~aO{0e9a88%f$?Li7zgAv%fTec791M?Pyt$xE%W3a98AV$n~Mce335B}j?lR9c';
begin
  return Lower(Fazo.Hash_Sha1(i_Time || v_Key || i_Sp1 || i_Sp2));
end Hcr_Timeuuid;
/
