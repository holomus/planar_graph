set define off
prompt PATH /vhr/hln/training_view
begin
uis.route('/vhr/hln/training_view:model','Ui_Vhr247.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/training_view:persons','Ui_Vhr247.Query_Persons','M','Q','A',null,null,null,null);

uis.path('/vhr/hln/training_view','vhr247');
uis.form('/vhr/hln/training_view','/vhr/hln/training_view','F','A','F','HM','M','N',null,'N');



uis.action('/vhr/hln/training_view','edit','F','/vhr/hln/training+edit','S','O');


uis.ready('/vhr/hln/training_view','.edit.model.');

commit;
end;
/
