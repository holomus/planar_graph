set define off
prompt PATH /vhr/hrm/wage_scale
begin
uis.route('/vhr/hrm/wage_scale+add:model','Ui_Vhr253.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrm/wage_scale+add:save','Ui_Vhr253.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hrm/wage_scale+edit:model','Ui_Vhr253.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrm/wage_scale+edit:save','Ui_Vhr253.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hrm/wage_scale','vhr253');
uis.form('/vhr/hrm/wage_scale+add','/vhr/hrm/wage_scale','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hrm/wage_scale+edit','/vhr/hrm/wage_scale','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hrm/wage_scale+add','.model.');
uis.ready('/vhr/hrm/wage_scale+edit','.model.');

commit;
end;
/
