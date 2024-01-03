set define off
prompt PATH /vhr/hpd/view/timebook_adjustment_view
begin
uis.route('/vhr/hpd/view/timebook_adjustment_view$post','Ui_Vhr607.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/timebook_adjustment_view$unpost','Ui_Vhr607.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/timebook_adjustment_view:model','Ui_Vhr607.Model','JO','JO','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/timebook_adjustment_view:table_timebook_adjustment_audit','Ui_Vhr607.Query_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/timebook_adjustment_view','vhr607');
uis.form('/vhr/hpd/view/timebook_adjustment_view','/vhr/hpd/view/timebook_adjustment_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/timebook_adjustment_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/timebook_adjustment_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/timebook_adjustment_view','edit','F','/vhr/hpd/timebook_adjustment+edit','S','O');
uis.action('/vhr/hpd/view/timebook_adjustment_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/timebook_adjustment_view','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/view/timebook_adjustment_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/timebook_adjustment_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/timebook_adjustment_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/timebook_adjustment_view','.audit.audit_details.edit.journal_audit.model.page_audit.post.sign_document.unpost.');

commit;
end;
/
