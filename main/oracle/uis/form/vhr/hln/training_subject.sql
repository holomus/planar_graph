set define off
prompt PATH /vhr/hln/training_subject
begin
uis.route('/vhr/hln/training_subject+add:model','Ui_Vhr237.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hln/training_subject+add:save','Ui_Vhr237.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hln/training_subject+edit:model','Ui_Vhr237.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hln/training_subject+edit:save','Ui_Vhr237.Edit','M','M','A',null,null,null,null,null);

uis.path('/vhr/hln/training_subject','vhr237');
uis.form('/vhr/hln/training_subject+add','/vhr/hln/training_subject','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hln/training_subject+edit','/vhr/hln/training_subject','F','A','F','H','M','N',null,null,null);





uis.ready('/vhr/hln/training_subject+add','.model.');
uis.ready('/vhr/hln/training_subject+edit','.model.');

commit;
end;
/
