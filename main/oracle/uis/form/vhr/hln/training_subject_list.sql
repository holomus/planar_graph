set define off
prompt PATH /vhr/hln/training_subject_list
begin
uis.route('/vhr/hln/training_subject_list$delete','Ui_Vhr238.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hln/training_subject_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hln/training_subject_list:table','Ui_Vhr238.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hln/training_subject_list','vhr238');
uis.form('/vhr/hln/training_subject_list','/vhr/hln/training_subject_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/training_subject_list','add','F','/vhr/hln/training_subject+add','S','O');
uis.action('/vhr/hln/training_subject_list','delete','F',null,null,'A');
uis.action('/vhr/hln/training_subject_list','edit','F','/vhr/hln/training_subject+edit','S','O');
uis.action('/vhr/hln/training_subject_list','view','F','/vhr/hln/view/training_subject_view','S','O');


uis.ready('/vhr/hln/training_subject_list','.add.delete.edit.model.view.');

commit;
end;
/
