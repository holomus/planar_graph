set define off
prompt PATH /vhr/hlic/no_license
begin
uis.route('/vhr/hlic/no_license:model','Ui_Vhr336.Model',null,'M','S','Y',null,null,null);

uis.path('/vhr/hlic/no_license','vhr336');
uis.form('/vhr/hlic/no_license','/vhr/hlic/no_license','A','S','F','H','M','N',null,'N');



uis.action('/vhr/hlic/no_license','buy_license','A',null,null,'G');
uis.action('/vhr/hlic/no_license','correct_license','A','/vhr/hlic/license_correction','S','O');
uis.action('/vhr/hlic/no_license','dashboard','A','/vhr/intro/dashboard','S','O');


uis.ready('/vhr/hlic/no_license','.buy_license.correct_license.dashboard.model.');

commit;
end;
/
