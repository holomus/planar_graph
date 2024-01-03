prompt adding schedule actions
----------------------------------------------------------------------------------------------------
declare
  v_Role_Id number;
begin
  for r in (select *
              from Md_Companies)
  loop
    Biruni_Route.Context_Begin;
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => r.Company_Id, i_Pcode => Href_Pref.c_Pcode_Role_Hr);
  
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_list',
                             i_Action_Key => 'custom');
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_list',
                             i_Action_Key => 'flexible');
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_list',
                             i_Action_Key => 'hourly');
  
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_registry_list+robot',
                             i_Action_Key => 'custom');
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_registry_list+robot',
                             i_Action_Key => 'flexible');
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_registry_list+robot',
                             i_Action_Key => 'hourly');
  
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_registry_list+staff',
                             i_Action_Key => 'custom');
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_registry_list+staff',
                             i_Action_Key => 'flexible');
    Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                             i_Role_Id    => v_Role_Id,
                             i_Form       => '/vhr/htt/schedule_registry_list+staff',
                             i_Action_Key => 'hourly');
  
    Biruni_Route.Context_End;
  
    commit;
  end loop;
end;
/

---------------------------------------------------------------------------------------------------- 
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

exec fazo_z.run('x_hpd');
