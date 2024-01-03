set define off
prompt PATH /vhr/hpd/audit/contract_audit
begin
uis.route('/vhr/hpd/audit/contract_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/contract_audit:table_audit','Ui_Vhr191.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/contract_audit','vhr191');
uis.form('/vhr/hpd/audit/contract_audit','/vhr/hpd/audit/contract_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/contract_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');



uis.ready('/vhr/hpd/audit/contract_audit','.audit_details.model.');

commit;
end;
/
