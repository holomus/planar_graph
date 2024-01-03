prompt migr from 15.11.2022 (4.dml)
----------------------------------------------------------------------------------------------------
prompt adding new licenses
----------------------------------------------------------------------------------------------------
declare
  v_Project_Code varchar2(10) := Href_Pref.c_Pc_Verifix_Hr;
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
  License(Hlic_Pref.c_License_Code_Hrm_Limited, 'HRM Limeted', 'G', null, null);
  License(Hlic_Pref.c_License_Code_Hrm_Base, 'HRM Base', 'C', null, null);

  Licensing_Setting_Save(Hlic_Pref.c_License_Code_Hrm_Limited);

  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt deleting HRM_EMPLOYEE license
----------------------------------------------------------------------------------------------------
alter trigger t_md_licenses_insert_only disable;

declare
begin
  update kl_licenses q
  set q.license_code = Hlic_Pref.c_License_Code_Hrm_Base
  where q.license_code = 'VHR:HRM_EMPLOYEE';

  update kl_licensing_settings q
  set q.license_code = Hlic_Pref.c_License_Code_Hrm_Base
  where q.license_code = 'VHR:HRM_EMPLOYEE';

  update kl_licensing_plans q
  set q.license_code = Hlic_Pref.c_License_Code_Hrm_Base
  where q.license_code = 'VHR:HRM_EMPLOYEE';

  update kl_license_balances q
  set q.license_code = Hlic_Pref.c_License_Code_Hrm_Base
  where q.license_code = 'VHR:HRM_EMPLOYEE';

  update kl_license_holders q
  set q.license_code = Hlic_Pref.c_License_Code_Hrm_Base
  where q.license_code = 'VHR:HRM_EMPLOYEE';
  
  
  delete from md_licenses q
  where q.license_code = 'VHR:HRM_EMPLOYEE';

  commit;
end;
/

alter trigger t_md_licenses_insert_only enable;

