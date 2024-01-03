prompt verifix_hr license
declare
  v_Project_Code varchar2(10) := Verifix.Project_Code;

  --------------------------------------------------
  Procedure License
  (
    i_License_Code varchar2,
    i_Name         varchar2,
    i_Kind         varchar2,
    i_Module_Code  varchar2 := null,
    i_Setting_Form varchar2 := null,
    i_Procedures   Array_Varchar2 := Array_Varchar2()
  ) is
  begin
    z_Md_Licenses.Insert_Try(i_License_Code => i_License_Code,
                             i_Name         => i_Name,
                             i_Project_Code => v_Project_Code,
                             i_Kind         => i_Kind,
                             i_Module_Code  => i_Module_Code,
                             i_Setting_Form => i_Setting_Form);
  end;

  --------------------------------------------------
  Procedure Licensing_Setting_Save(i_License_Code varchar2) is
  begin
    z_Kl_Licensing_Settings.Save_One(i_License_Code   => i_License_Code, --
                                     i_Licensing_Type => Kl_Pref.c_Lt_Plan);
  end;
begin
  License(Hlic_Pref.c_License_Code_Hrm_Full, 'HRM Full', 'G', null, null);
  License(Hlic_Pref.c_License_Code_Hrm_Limited, 'HRM Limeted', 'G', null, null);
  License(Hlic_Pref.c_License_Code_Hrm_Base, 'HRM Base', 'C', null, null);

  Licensing_Setting_Save(Hlic_Pref.c_License_Code_Hrm_Full);
  Licensing_Setting_Save(Hlic_Pref.c_License_Code_Hrm_Limited);

  commit;
end;
/
