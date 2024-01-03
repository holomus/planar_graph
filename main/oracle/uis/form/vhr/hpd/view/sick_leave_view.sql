set define off
prompt PATH /vhr/hpd/view/sick_leave_view
begin
uis.route('/vhr/hpd/view/sick_leave_view$post','Ui_Vhr596.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/sick_leave_view$unpost','Ui_Vhr596.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/sick_leave_view:model','Ui_Vhr596.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/sick_leave_view:table_sick_leave_audit','Ui_Vhr596.Query_Sick_Leave_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/sick_leave_view','vhr596');
uis.form('/vhr/hpd/view/sick_leave_view','/vhr/hpd/view/sick_leave_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/sick_leave_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/sick_leave_view','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/view/sick_leave_view','edit','F','/vhr/hpd/sick_leave+edit','S','O');
uis.action('/vhr/hpd/view/sick_leave_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/sick_leave_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/sick_leave_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/sick_leave_view','timeoff_audit','F','/vhr/hpd/audit/timeoff_audit','S','O');
uis.action('/vhr/hpd/view/sick_leave_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/sick_leave_view','.audit.audit_details.edit.journal_audit.model.post.sign_document.timeoff_audit.unpost.');

commit;
end;
/
