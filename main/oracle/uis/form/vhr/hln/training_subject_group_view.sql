set define off
prompt PATH /vhr/hln/training_subject_group_view
begin
uis.route('/vhr/hln/training_subject_group_view:model','Ui_Vhr675.Model','M','M','A','Y',null,null,null,null);

uis.path('/vhr/hln/training_subject_group_view','vhr675');
uis.form('/vhr/hln/training_subject_group_view','/vhr/hln/training_subject_group_view','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hln/training_subject_group_view','edit','F','/vhr/hln/training_subject_group+edit','S','O');


uis.ready('/vhr/hln/training_subject_group_view','.edit.model.');

commit;
end;
/
