set define off
prompt PATH /vhr/hpd/view/hiring_view
begin
uis.route('/vhr/hpd/view/hiring_view$post','Ui_Vhr399.Post','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/view/hiring_view$unpost','Ui_Vhr399.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/hiring_view:model','Ui_Vhr399.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/hiring_view:process_cos_response','Ui_Vhr399.Process_Cos_Response','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/hiring_view:table_hiring_audit','Ui_Vhr399.Query_Hiring_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/hiring_view','vhr399');
uis.form('/vhr/hpd/view/hiring_view','/vhr/hpd/view/hiring_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/hiring_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/hiring_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/hiring_view','contract_audit','F','/vhr/hpd/audit/contract_audit','S','O');
uis.action('/vhr/hpd/view/hiring_view','edit','F','/vhr/hpd/hiring+edit','S','O');
uis.action('/vhr/hpd/view/hiring_view','edit_multiple','F','/vhr/hpd/hiring+multiple_edit','S','O');
uis.action('/vhr/hpd/view/hiring_view','indicator_audit','F','/vhr/hpd/audit/indicator_audit','S','O');
uis.action('/vhr/hpd/view/hiring_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/hiring_view','oper_type_audit','F','/vhr/hpd/audit/oper_type_audit','S','O');
uis.action('/vhr/hpd/view/hiring_view','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/view/hiring_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/hiring_view','robot_audit','F','/vhr/hpd/audit/robot_audit','S','O');
uis.action('/vhr/hpd/view/hiring_view','schedule_audit','F','/vhr/hpd/audit/schedule_audit','S','O');
uis.action('/vhr/hpd/view/hiring_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/hiring_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/hiring_view','.audit.audit_details.contract_audit.edit.edit_multiple.indicator_audit.journal_audit.model.oper_type_audit.page_audit.post.robot_audit.schedule_audit.sign_document.unpost.');

commit;
end;
/
