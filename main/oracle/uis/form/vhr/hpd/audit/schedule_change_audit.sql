set define off
prompt PATH /vhr/hpd/audit/schedule_change_audit
begin
uis.route('/vhr/hpd/audit/schedule_change_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/schedule_change_audit:table_audit','Ui_Vhr198.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/schedule_change_audit','vhr198');
uis.form('/vhr/hpd/audit/schedule_change_audit','/vhr/hpd/audit/schedule_change_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/schedule_change_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/audit/schedule_change_audit','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/audit/schedule_change_audit','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/audit/schedule_change_audit','schedule_audit','F','/vhr/hpd/audit/schedule_audit','S','O');


uis.ready('/vhr/hpd/audit/schedule_change_audit','.audit_details.journal_audit.model.page_audit.schedule_audit.');

commit;
end;
/
