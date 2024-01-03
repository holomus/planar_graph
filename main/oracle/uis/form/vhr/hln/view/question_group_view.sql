set define off
prompt PATH /vhr/hln/view/question_group_view
begin
uis.route('/vhr/hln/view/question_group_view:model','Ui_Vhr440.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/view/question_group_view:table_audit','Ui_Vhr440.Query_Question_Group_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/hln/view/question_group_view','vhr440');
uis.form('/vhr/hln/view/question_group_view','/vhr/hln/view/question_group_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/view/question_group_view','audit','A',null,null,'G');
uis.action('/vhr/hln/view/question_group_view','audit_details','A','/vhr/hln/view/question_group_audit_details','S','O');
uis.action('/vhr/hln/view/question_group_view','edit','A','/vhr/hln/question_group+edit','S','O');


uis.ready('/vhr/hln/view/question_group_view','.audit.audit_details.edit.model.');

commit;
end;
/
