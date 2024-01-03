set define off
prompt PATH /vhr/hrec/reject_reason
begin
uis.route('/vhr/hrec/reject_reason+add:code_is_unique','Ui_Vhr569.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/reject_reason+add:model','Ui_Vhr569.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrec/reject_reason+add:name_is_unique','Ui_Vhr569.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/reject_reason+add:save','Ui_Vhr569.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hrec/reject_reason+edit:code_is_unique','Ui_Vhr569.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/reject_reason+edit:model','Ui_Vhr569.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrec/reject_reason+edit:name_is_unique','Ui_Vhr569.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrec/reject_reason+edit:save','Ui_Vhr569.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hrec/reject_reason','vhr569');
uis.form('/vhr/hrec/reject_reason+add','/vhr/hrec/reject_reason','A','A','F','H','M','N',null,null);
uis.form('/vhr/hrec/reject_reason+edit','/vhr/hrec/reject_reason','A','A','F','H','M','N',null,null);





uis.ready('/vhr/hrec/reject_reason+add','.model.');
uis.ready('/vhr/hrec/reject_reason+edit','.model.');

commit;
end;
/
