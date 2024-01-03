set define off
prompt PATH /vhr/hpd/view/overtime_view
begin
uis.route('/vhr/hpd/view/overtime_view$post','Ui_Vhr605.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/overtime_view$unpost','Ui_Vhr605.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/overtime_view:model','Ui_Vhr605.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/overtime_view:table_overtime_audit','Ui_Vhr605.Query','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/view/overtime_view:table_overtime_day_audit','Ui_Vhr605.Query_Overtime_Day_Audits','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/overtime_view','vhr605');
uis.form('/vhr/hpd/view/overtime_view','/vhr/hpd/view/overtime_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/overtime_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/overtime_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/overtime_view','edit','F','/vhr/hpd/overtime+edit','S','O');
uis.action('/vhr/hpd/view/overtime_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/overtime_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/overtime_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/overtime_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/overtime_view','.audit.audit_details.edit.journal_audit.model.post.sign_document.unpost.');

commit;
end;
/
