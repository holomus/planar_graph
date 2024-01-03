set define off
prompt PATH /vhr/hpd/view/transfer_view
begin
uis.route('/vhr/hpd/view/transfer_view$post','Ui_Vhr410.Post','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/view/transfer_view$unpost','Ui_Vhr410.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/transfer_view:model','Ui_Vhr410.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/transfer_view:process_cos_response','Ui_Vhr410.Process_Cos_Response','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/transfer_view:table_transfer_audit','Ui_Vhr410.Query_Transfer_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/transfer_view','vhr410');
uis.form('/vhr/hpd/view/transfer_view','/vhr/hpd/view/transfer_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/transfer_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/transfer_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/transfer_view','contract_audit','F','/vhr/hpd/audit/contract_audit','S','O');
uis.action('/vhr/hpd/view/transfer_view','edit','F','/vhr/hpd/transfer+edit','S','O');
uis.action('/vhr/hpd/view/transfer_view','edit_multiple','F','/vhr/hpd/transfer+multiple_edit','S','O');
uis.action('/vhr/hpd/view/transfer_view','indicator_audit','F','/vhr/hpd/audit/indicator_audit','S','O');
uis.action('/vhr/hpd/view/transfer_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/transfer_view','oper_type_audit','F','/vhr/hpd/audit/oper_type_audit','S','O');
uis.action('/vhr/hpd/view/transfer_view','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/view/transfer_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/transfer_view','robot_audit','F','/vhr/hpd/audit/robot_audit','S','O');
uis.action('/vhr/hpd/view/transfer_view','schedule_audit','F','/vhr/hpd/audit/schedule_audit','S','O');
uis.action('/vhr/hpd/view/transfer_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/transfer_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/transfer_view','.audit.audit_details.contract_audit.edit.edit_multiple.indicator_audit.journal_audit.model.oper_type_audit.page_audit.post.robot_audit.schedule_audit.sign_document.unpost.');

commit;
end;
/
