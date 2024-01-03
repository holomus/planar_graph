set define off
prompt PATH /vhr/hrm/job_bonus_type_settings
begin
uis.route('/vhr/hrm/job_bonus_type_settings$save','Ui_Vhr481.Save','L',null,'A',null,null,null,null);
uis.route('/vhr/hrm/job_bonus_type_settings:model','Ui_Vhr481.Model',null,'M','A','Y',null,null,null);

uis.path('/vhr/hrm/job_bonus_type_settings','vhr481');
uis.form('/vhr/hrm/job_bonus_type_settings','/vhr/hrm/job_bonus_type_settings','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrm/job_bonus_type_settings','save','F',null,null,'A');


uis.ready('/vhr/hrm/job_bonus_type_settings','.model.save.');

commit;
end;
/
