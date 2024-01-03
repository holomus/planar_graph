set define off
prompt PATH /vhr/hes/person_setting_view
begin
uis.route('/vhr/hes/person_setting_view:model','Ui_Vhr155.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hes/person_setting_view','vhr155');
uis.form('/vhr/hes/person_setting_view','/vhr/hes/person_setting_view','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/hes/person_setting_view','.model.');

commit;
end;
/
