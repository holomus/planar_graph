set define off
prompt PATH /vhr/hper/plan_group
begin
uis.route('/vhr/hper/plan_group+add:model','Ui_Vhr131.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hper/plan_group+add:save','Ui_Vhr131.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hper/plan_group+edit:model','Ui_Vhr131.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hper/plan_group+edit:save','Ui_Vhr131.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hper/plan_group','vhr131');
uis.form('/vhr/hper/plan_group+add','/vhr/hper/plan_group','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hper/plan_group+edit','/vhr/hper/plan_group','F','A','F','H','M','N',null,'N');






uis.ready('/vhr/hper/plan_group+edit','.model.');
uis.ready('/vhr/hper/plan_group+add','.model.');

commit;
end;
/
