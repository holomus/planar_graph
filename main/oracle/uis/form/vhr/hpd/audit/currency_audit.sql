set define off
prompt PATH /vhr/hpd/audit/currency_audit
begin
uis.route('/vhr/hpd/audit/currency_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/currency_audit:table_audit','Ui_Vhr622.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/currency_audit','vhr622');
uis.form('/vhr/hpd/audit/currency_audit','/vhr/hpd/audit/currency_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/currency_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');


uis.ready('/vhr/hpd/audit/currency_audit','.audit_details.model.');

commit;
end;
/
