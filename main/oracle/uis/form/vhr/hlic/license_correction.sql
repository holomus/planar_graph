set define off
prompt PATH /vhr/hlic/license_correction
begin
uis.route('/vhr/hlic/license_correction:load_license_monthly_barchart','Ui_Vhr351.Load_License_Monthly_Barchart',null,'M','A',null,null,null,null);
uis.route('/vhr/hlic/license_correction:model','Ui_Vhr351.Model',null,'M','A','Y',null,null,null);

uis.path('/vhr/hlic/license_correction','vhr351');
uis.form('/vhr/hlic/license_correction','/vhr/hlic/license_correction','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hlic/license_correction','buy_license','A',null,null,'G');
uis.action('/vhr/hlic/license_correction','employee_dismissal','A','/vhr/hlic/employee_dismissal','S','O');


uis.ready('/vhr/hlic/license_correction','.buy_license.employee_dismissal.model.');

commit;
end;
/
