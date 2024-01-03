set define off
prompt PATH /vhr/hln/question_group
begin
uis.route('/vhr/hln/question_group+add:model','Ui_Vhr208.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hln/question_group+add:save','Ui_Vhr208.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hln/question_group+edit:model','Ui_Vhr208.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/question_group+edit:save','Ui_Vhr208.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hln/question_group','vhr208');
uis.form('/vhr/hln/question_group+add','/vhr/hln/question_group','F','A','F','H','M','N',null,null);
uis.form('/vhr/hln/question_group+edit','/vhr/hln/question_group','F','A','F','H','M','N',null,null);





uis.ready('/vhr/hln/question_group+add','.model.');
uis.ready('/vhr/hln/question_group+edit','.model.');

commit;
end;
/
