set define off
prompt PATH /vhr/hln/training_list
begin
uis.route('/vhr/hln/training_list$delete','Ui_Vhr241.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hln/training_list$execute','Ui_Vhr241.Execute','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hln/training_list$finish','Ui_Vhr241.Finish','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hln/training_list$return_execute','Ui_Vhr241.Execute','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hln/training_list$set_new','Ui_Vhr241.Set_New','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hln/training_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,null);
uis.route('/vhr/hln/training_list:table','Ui_Vhr241.Query',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hln/training_list','vhr241');
uis.form('/vhr/hln/training_list','/vhr/hln/training_list','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hln/training_list','add','F','/vhr/hln/training+add','S','O');
uis.action('/vhr/hln/training_list','assess','F','/vhr/hln/assess_list','S','O');
uis.action('/vhr/hln/training_list','delete','F',null,null,'A');
uis.action('/vhr/hln/training_list','edit','F','/vhr/hln/training+edit','S','O');
uis.action('/vhr/hln/training_list','execute','F',null,null,'A');
uis.action('/vhr/hln/training_list','finish','F',null,null,'A');
uis.action('/vhr/hln/training_list','return_execute','F',null,null,'A');
uis.action('/vhr/hln/training_list','set_new','F',null,null,'A');
uis.action('/vhr/hln/training_list','view','F','/vhr/hln/training_view','S','O');

uis.form_sibling('vhr','/vhr/hln/training_list','/vhr/hln/training_subject_list',1);
uis.form_sibling('vhr','/vhr/hln/training_list','/vhr/hln/training_subject_group_list',2);

uis.ready('/vhr/hln/training_list','.add.assess.delete.edit.execute.finish.model.return_execute.set_new.view.');

commit;
end;
/
