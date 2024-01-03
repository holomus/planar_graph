set define off
declare
begin
delete md_non_subscription_forms t where t.project_code = 'vhr';
dbms_output.put_line('==== Non subscription form ====');
uis.non_subscription_form('vhr','/core/kl/license+add');
uis.non_subscription_form('vhr','/core/kl/license_balance_list');
uis.non_subscription_form('vhr','/core/kl/license_holder_list');
uis.non_subscription_form('vhr','/core/kl/license_list');
uis.non_subscription_form('vhr','/core/kl/license_user_list');
uis.non_subscription_form('vhr','/core/m');
uis.non_subscription_form('vhr','/core/md/change_password');
uis.non_subscription_form('vhr','/core/md/filial_list');
uis.non_subscription_form('vhr','/core/md/profile');
uis.non_subscription_form('vhr','/core/md/user_audit_details');
uis.non_subscription_form('vhr','/core/mf/file_manager');
uis.non_subscription_form('vhr','/core/ph/active_device');
uis.non_subscription_form('vhr','/core/s/');
uis.non_subscription_form('vhr','/vhr/hes/hikvision');
uis.non_subscription_form('vhr','/vhr/hes/staff');
uis.non_subscription_form('vhr','/vhr/hes/timepad');
uis.non_subscription_form('vhr','/vhr/hlic/employee_dismissal');
uis.non_subscription_form('vhr','/vhr/hlic/license_correction');
uis.non_subscription_form('vhr','/vhr/hlic/no_license');
uis.non_subscription_form('vhr','/vhr/intro/license_balance');
uis.non_subscription_form('vhr','/vx/es/timepad');
commit;
end;
/
