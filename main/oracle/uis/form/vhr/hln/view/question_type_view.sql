set define off
prompt PATH /vhr/hln/view/question_type_view
begin
uis.route('/vhr/hln/view/question_type_view:model','Ui_Vhr443.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hln/view/question_type_view:table_audit','Ui_Vhr443.Query_Question_Type_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/hln/view/question_type_view','vhr443');
uis.form('/vhr/hln/view/question_type_view','/vhr/hln/view/question_type_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hln/view/question_type_view','audit','F',null,null,'G');
uis.action('/vhr/hln/view/question_type_view','audit_details','F','/vhr/hln/view/question_type_audit_details','S','O');
uis.action('/vhr/hln/view/question_type_view','edit','F','/vhr/hln/question_type+edit','S','O');


uis.ready('/vhr/hln/view/question_type_view','.audit.audit_details.edit.model.');

commit;
end;
/
