set define off
prompt PATH /vhr/hpd/audit/sick_leave_audit
begin
uis.route('/vhr/hpd/audit/sick_leave_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/sick_leave_audit:table_audit','Ui_Vhr199.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/sick_leave_audit','vhr199');
uis.form('/vhr/hpd/audit/sick_leave_audit','/vhr/hpd/audit/sick_leave_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/sick_leave_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/audit/sick_leave_audit','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/audit/sick_leave_audit','timeoff_audit','F','/vhr/hpd/audit/timeoff_audit','S','O');



uis.ready('/vhr/hpd/audit/sick_leave_audit','.audit_details.journal_audit.model.timeoff_audit.');

commit;
end;
/
