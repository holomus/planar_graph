set define off
prompt PATH /vhr/hpd/audit/schedule_audit
begin
uis.route('/vhr/hpd/audit/schedule_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/schedule_audit:table_audit','Ui_Vhr192.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/schedule_audit','vhr192');
uis.form('/vhr/hpd/audit/schedule_audit','/vhr/hpd/audit/schedule_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/schedule_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');



uis.ready('/vhr/hpd/audit/schedule_audit','.audit_details.model.');

commit;
end;
/
