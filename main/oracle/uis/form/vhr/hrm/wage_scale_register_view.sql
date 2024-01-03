set define off
prompt PATH /vhr/hrm/wage_scale_register_view
begin
uis.route('/vhr/hrm/wage_scale_register_view:model','Ui_Vhr478.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hrm/wage_scale_register_view','vhr478');
uis.form('/vhr/hrm/wage_scale_register_view','/vhr/hrm/wage_scale_register_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hrm/wage_scale_register_view','edit','A','/vhr/hrm/wage_scale_register+edit','S','O');


uis.ready('/vhr/hrm/wage_scale_register_view','.edit.model.');

commit;
end;
/
