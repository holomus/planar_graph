declare
v_Company_Head number := Md_Pref.Company_Head;
begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Head);

  Href_Api.Create_Timepad_User(v_Company_Head);

  Biruni_Route.Context_End;

  commit;
end;
/
