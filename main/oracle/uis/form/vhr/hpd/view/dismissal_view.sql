set define off
prompt PATH /vhr/hpd/view/dismissal_view
begin
uis.route('/vhr/hpd/view/dismissal_view$post','Ui_Vhr429.Post','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/view/dismissal_view$unpost','Ui_Vhr429.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/dismissal_view:model','Ui_Vhr429.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/dismissal_view:process_cos_response','Ui_Vhr429.Process_Cos_Response','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/dismissal_view:table_dismissal_audit','Ui_Vhr429.Query_Dismissal_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/dismissal_view','vhr429');
uis.form('/vhr/hpd/view/dismissal_view','/vhr/hpd/view/dismissal_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/dismissal_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/dismissal_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/dismissal_view','edit','F','/vhr/hpd/dismissal+edit','S','O');
uis.action('/vhr/hpd/view/dismissal_view','edit_multiple','F','/vhr/hpd/dismissal+multiple_edit','S','O');
uis.action('/vhr/hpd/view/dismissal_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/dismissal_view','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/view/dismissal_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/dismissal_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/dismissal_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/dismissal_view','.audit.audit_details.edit.edit_multiple.journal_audit.model.page_audit.post.sign_document.unpost.');

commit;
end;
/
