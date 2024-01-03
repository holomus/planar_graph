set define off
prompt PATH /vhr/hpd/audit/wage_change_audit
begin
uis.route('/vhr/hpd/audit/wage_change_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/wage_change_audit:table_audit','Ui_Vhr197.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/wage_change_audit','vhr197');
uis.form('/vhr/hpd/audit/wage_change_audit','/vhr/hpd/audit/wage_change_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/wage_change_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/audit/wage_change_audit','currency_audit','F','/vhr/hpd/audit/currency_audit','S','O');
uis.action('/vhr/hpd/audit/wage_change_audit','indicator_audit','F','/vhr/hpd/audit/indicator_audit','S','O');
uis.action('/vhr/hpd/audit/wage_change_audit','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/audit/wage_change_audit','oper_type_audit','F','/vhr/hpd/audit/oper_type_audit','S','O');
uis.action('/vhr/hpd/audit/wage_change_audit','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');


uis.ready('/vhr/hpd/audit/wage_change_audit','.audit_details.currency_audit.indicator_audit.journal_audit.model.oper_type_audit.page_audit.');

commit;
end;
/
