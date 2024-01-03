set define off
prompt PATH /vhr/hln/question_type
begin
uis.route('/vhr/hln/question_type+add:model','Ui_Vhr210.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/question_type+add:save','Ui_Vhr210.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hln/question_type+edit:model','Ui_Vhr210.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/question_type+edit:save','Ui_Vhr210.Edit','M','M','A',null,null,null,null);

uis.path('/vhr/hln/question_type','vhr210');
uis.form('/vhr/hln/question_type+add','/vhr/hln/question_type','F','A','F','H','M','N',null,null);
uis.form('/vhr/hln/question_type+edit','/vhr/hln/question_type','F','A','F','H','M','N',null,null);





uis.ready('/vhr/hln/question_type+add','.model.');
uis.ready('/vhr/hln/question_type+edit','.model.');

commit;
end;
/
