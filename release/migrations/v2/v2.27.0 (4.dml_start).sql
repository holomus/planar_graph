prompt restarting audit for journals
----------------------------------------------------------------------------------------------------
begin
  for r in (select *
              from Md_Companies)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Hpd_Audit.Journal_Stop(r.Company_Id);
    Hpd_Audit.Journal_Start(r.Company_Id);
    
    commit;
  end loop;
end;
/
