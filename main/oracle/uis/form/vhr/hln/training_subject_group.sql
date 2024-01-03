set define off
prompt PATH /vhr/hln/training_subject_group
begin
uis.route('/vhr/hln/training_subject_group+add:model','Ui_Vhr674.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hln/training_subject_group+add:name_is_unique','Ui_Vhr674.Name_Is_Unique','M','V','A',null,null,null,null,null);
uis.route('/vhr/hln/training_subject_group+add:save','Ui_Vhr674.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hln/training_subject_group+add:training_subjects','Ui_Vhr674.Training_Subject_Query',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hln/training_subject_group+edit:model','Ui_Vhr674.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hln/training_subject_group+edit:name_is_unique','Ui_Vhr674.Name_Is_Unique','M','V','A',null,null,null,null,'S');
uis.route('/vhr/hln/training_subject_group+edit:save','Ui_Vhr674.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hln/training_subject_group+edit:training_subjects','Ui_Vhr674.Training_Subject_Query',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hln/training_subject_group','vhr674');
uis.form('/vhr/hln/training_subject_group+add','/vhr/hln/training_subject_group','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hln/training_subject_group+edit','/vhr/hln/training_subject_group','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hln/training_subject_group+add','add_training_subject','F','/vhr/hln/training_subject+add','D','O');
uis.action('/vhr/hln/training_subject_group+add','view_training_subject','F','/vhr/hln/training_subject_list','D','O');
uis.action('/vhr/hln/training_subject_group+edit','add_training_subject','F','/vhr/hln/training_subject+add','D','O');
uis.action('/vhr/hln/training_subject_group+edit','view_training_subject','F','/vhr/hln/training_subject_list','D','O');


uis.ready('/vhr/hln/training_subject_group+add','.add_training_subject.model.view_training_subject.');
uis.ready('/vhr/hln/training_subject_group+edit','.add_training_subject.model.view_training_subject.');

commit;
end;
/
