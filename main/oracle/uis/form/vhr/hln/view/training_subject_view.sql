set define off
prompt PATH /vhr/hln/view/training_subject_view
begin
uis.route('/vhr/hln/view/training_subject_view:model','Ui_Vhr447.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/view/training_subject_view:table_audit','Ui_Vhr447.Query_Subject_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/hln/view/training_subject_view','vhr447');
uis.form('/vhr/hln/view/training_subject_view','/vhr/hln/view/training_subject_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/view/training_subject_view','audit','F',null,null,'G');
uis.action('/vhr/hln/view/training_subject_view','audit_details','F','/vhr/hln/view/training_subject_audit_details','S','O');
uis.action('/vhr/hln/view/training_subject_view','edit','F','/vhr/hln/training_subject+edit','S','O');


uis.ready('/vhr/hln/view/training_subject_view','.audit.audit_details.edit.model.');

commit;
end;
/
