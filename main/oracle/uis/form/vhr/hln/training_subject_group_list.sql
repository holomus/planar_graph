set define off
prompt PATH /vhr/hln/training_subject_group_list
begin
uis.route('/vhr/hln/training_subject_group_list$delete','Ui_Vhr673.Del','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hln/training_subject_group_list:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/hln/training_subject_group_list:table','Ui_Vhr673.Query',null,'Q','A',null,null,null,null,'S');

uis.path('/vhr/hln/training_subject_group_list','vhr673');
uis.form('/vhr/hln/training_subject_group_list','/vhr/hln/training_subject_group_list','F','A','F','H','M','N',null,'N','S');



uis.action('/vhr/hln/training_subject_group_list','add','F','/vhr/hln/training_subject_group+add','S','O');
uis.action('/vhr/hln/training_subject_group_list','delete','F',null,null,'A');
uis.action('/vhr/hln/training_subject_group_list','edit','F','/vhr/hln/training_subject_group+edit','S','O');
uis.action('/vhr/hln/training_subject_group_list','view','F','/vhr/hln/training_subject_group_view','S','O');


uis.ready('/vhr/hln/training_subject_group_list','.add.delete.edit.model.view.');

commit;
end;
/
