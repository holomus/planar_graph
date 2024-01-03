prompt migr from 10.05.2022
----------------------------------------------------------------------------------------------------
declare
  v_Company_Head number := Md_Pref.Company_Head;
  v_Dummy        varchar2(1);
begin
  select 'X'
    into v_Dummy
    from Htt_Pin_Locks q
   where q.Company_Id = v_Company_Head;
exception
  when No_Data_Found then
    insert into Htt_Pin_Locks
      (Company_Id)
    values
      (v_Company_Head);
  
    commit;
end;
/
