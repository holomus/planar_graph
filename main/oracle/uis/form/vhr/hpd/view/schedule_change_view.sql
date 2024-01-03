set define off
prompt PATH /vhr/hpd/view/schedule_change_view
begin
uis.route('/vhr/hpd/view/schedule_change_view$post','Ui_Vhr606.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/schedule_change_view$unpost','Ui_Vhr606.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/schedule_change_view:model','Ui_Vhr606.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/schedule_change_view:table_schedule_change_audit','Ui_Vhr606.Query_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/schedule_change_view','vhr606');
uis.form('/vhr/hpd/view/schedule_change_view','/vhr/hpd/view/schedule_change_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/schedule_change_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/schedule_change_view','edit','F','/vhr/hpd/schedule_change+edit','S','O');
uis.action('/vhr/hpd/view/schedule_change_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/schedule_change_view','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/view/schedule_change_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/schedule_change_view','schedule_audit','F','/vhr/hpd/audit/schedule_audit','S','O');
uis.action('/vhr/hpd/view/schedule_change_view','schedule_change_audit','F',null,null,'A');
uis.action('/vhr/hpd/view/schedule_change_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/schedule_change_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/schedule_change_view','.audit_details.edit.journal_audit.model.page_audit.post.schedule_audit.schedule_change_audit.sign_document.unpost.');

commit;
end;
/
