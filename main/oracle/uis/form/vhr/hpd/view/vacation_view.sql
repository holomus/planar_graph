set define off
prompt PATH /vhr/hpd/view/vacation_view
begin
uis.route('/vhr/hpd/view/vacation_view$post','Ui_Vhr593.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/vacation_view$unpost','Ui_Vhr593.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/vacation_view:model','Ui_Vhr593.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/vacation_view:table_vacation_audit','Ui_Vhr593.Query_Vacation_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/vacation_view','vhr593');
uis.form('/vhr/hpd/view/vacation_view','/vhr/hpd/view/vacation_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/vacation_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/vacation_view','audit_details','F','/vhr/hpd/audit/vacation_audit_details','S','O');
uis.action('/vhr/hpd/view/vacation_view','edit','F','/vhr/hpd/vacation+edit','S','O');
uis.action('/vhr/hpd/view/vacation_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/vacation_view','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/view/vacation_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/vacation_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/vacation_view','timeoff_audit','F','/vhr/hpd/audit/timeoff_audit','S','O');
uis.action('/vhr/hpd/view/vacation_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/vacation_view','.audit.audit_details.edit.journal_audit.model.page_audit.post.sign_document.timeoff_audit.unpost.');

commit;
end;
/
