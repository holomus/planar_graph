set define off
prompt PATH /vhr/hpd/audit/hiring_audit
begin
uis.route('/vhr/hpd/audit/hiring_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/hiring_audit:table_audit','Ui_Vhr184.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/hiring_audit','vhr184');
uis.form('/vhr/hpd/audit/hiring_audit','/vhr/hpd/audit/hiring_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/hiring_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/audit/hiring_audit','contract_audit','F','/vhr/hpd/audit/contract_audit','S','O');
uis.action('/vhr/hpd/audit/hiring_audit','indicator_audit','F','/vhr/hpd/audit/indicator_audit','S','O');
uis.action('/vhr/hpd/audit/hiring_audit','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/audit/hiring_audit','oper_type_audit','F','/vhr/hpd/audit/oper_type_audit','S','O');
uis.action('/vhr/hpd/audit/hiring_audit','page_audit','F','/vhr/hpd/audit/journal_page_audit','S','O');
uis.action('/vhr/hpd/audit/hiring_audit','robot_audit','F','/vhr/hpd/audit/robot_audit','S','O');
uis.action('/vhr/hpd/audit/hiring_audit','schedule_audit','F','/vhr/hpd/audit/schedule_audit','S','O');


uis.ready('/vhr/hpd/audit/hiring_audit','.audit_details.contract_audit.indicator_audit.journal_audit.model.oper_type_audit.page_audit.robot_audit.schedule_audit.');

commit;
end;
/
