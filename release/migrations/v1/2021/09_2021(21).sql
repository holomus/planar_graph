prompt migr 21.09.2021
----------------------------------------------------------------------------------------------------
rename hrm_staffs_sq to href_staffs_sq;
----------------------------------------------------------------------------------------------------
exec fazo_z.Compile_Invalid_Objects;
----------------------------------------------------------------------------------------------------
declare
begin
  ui_context.Init_Migr(i_Company_Id   => md_pref.c_Company_Head,
                       i_Filial_Id    => md_pref.Filial_Head(md_pref.c_Company_Head),
                       i_User_Id      => md_pref.User_System(md_pref.c_Company_Head),
                       i_Project_Code => href_pref.c_Pc_Verifix_Hr);
  Ker_Core.Head_Template_Save(i_Form     => Hpd_Pref.c_Easy_Report_Form_Labor_Contract,
                              i_Name     => 'Трудовой договор',
                              i_Order_No => 7,
                              i_Pcode    => 'vhr:hpd:7');
  commit;
end;
/

