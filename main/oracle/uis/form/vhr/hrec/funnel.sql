set define off
prompt PATH /vhr/hrec/funnel
begin
uis.route('/vhr/hrec/funnel+add:code_is_unique','Ui_Vhr574.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/funnel+add:model','Ui_Vhr574.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/funnel+add:name_is_unique','Ui_Vhr574.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/funnel+add:save','Ui_Vhr574.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/funnel+edit:code_is_unique','Ui_Vhr574.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/funnel+edit:model','Ui_Vhr574.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrec/funnel+edit:name_is_unique','Ui_Vhr574.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/funnel+edit:save','Ui_Vhr574.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hrec/funnel','vhr574');
uis.form('/vhr/hrec/funnel+add','/vhr/hrec/funnel','A','A','F','H','M','N',null,'N');
uis.form('/vhr/hrec/funnel+edit','/vhr/hrec/funnel','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/hrec/funnel+edit','.model.');
uis.ready('/vhr/hrec/funnel+add','.model.');

commit;
end;
/
