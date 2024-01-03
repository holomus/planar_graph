PL/SQL Developer Test script 3.0
35
-- Created on 9/21/2023 by ADHAM.TOSHKANOV 
declare
  -- Local variables here
  i          integer;
  v_Password varchar2(64);
  v_Pass     varchar2(64);
  v_Cnt      number := 1;
begin
  -- Test statements here
  for r in (select (select w.Code
                      from Md_Companies w
                     where w.Company_Id = q.Company_Id) Company_Code,
                   q.*
              from Md_Users q
             where q.User_Id = Md_Pref.User_Admin(q.Company_Id)
               and q.Password = Fazo.Hash_Sha1('greenwhite')
               and exists (select *
                      from Md_Companies w
                     where w.Company_Id = q.Company_Id
                       and w.State = 'A'))
  loop
    Biruni_Route.Context_Begin;
    Ui_Auth.Logon_As_System(r.Company_Id);
  
    v_Pass     := Dbms_Random.String('a', 12);
    v_Password := Fazo.Hash_Sha1(v_Pass);
    Dbms_Output.Put_Line(Rpad(v_Cnt, 2) || '. ' || Rpad(r.Company_Code, 20) || ' - ' || v_Pass);
    v_Cnt := v_Cnt + 1;
    update Md_Users q
       set q.Password = v_Password
     where q.User_Id = r.User_Id;
  
    Biruni_Route.Context_End;
  end loop;
end;
0
0
