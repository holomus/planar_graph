set define off
prompt PATH /vhr/hln/person_trainings
begin
uis.route('/vhr/hln/person_trainings:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hln/person_trainings:testings','Ui_Vhr242.Query_Testings','M','Q','A',null,null,null,null);
uis.route('/vhr/hln/person_trainings:trainings','Ui_Vhr242.Query_Trainings','M','Q','A',null,null,null,null);

uis.path('/vhr/hln/person_trainings','vhr242');
uis.form('/vhr/hln/person_trainings','/vhr/hln/person_trainings','A','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/person_trainings','testing_view','F','/vhr/hln/testing_view','D','O');
uis.action('/vhr/hln/person_trainings','training_view','F','/vhr/hln/training_view','D','O');


uis.ready('/vhr/hln/person_trainings','.model.testing_view.training_view.');

commit;
end;
/
