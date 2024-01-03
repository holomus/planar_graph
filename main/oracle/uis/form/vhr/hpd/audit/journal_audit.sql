set define off
prompt PATH /vhr/hpd/audit/journal_audit
begin
uis.route('/vhr/hpd/audit/journal_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/journal_audit:table_audit','Ui_Vhr188.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/journal_audit','vhr188');
uis.form('/vhr/hpd/audit/journal_audit','/vhr/hpd/audit/journal_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/journal_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');



uis.ready('/vhr/hpd/audit/journal_audit','.audit_details.model.');

commit;
end;
/
