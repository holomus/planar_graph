set define off
prompt PATH /vhr/hper/audit/staff_plan_rule_audit
begin
uis.route('/vhr/hper/audit/staff_plan_rule_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hper/audit/staff_plan_rule_audit:table_audit','Ui_Vhr206.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hper/audit/staff_plan_rule_audit','vhr206');
uis.form('/vhr/hper/audit/staff_plan_rule_audit','/vhr/hper/audit/staff_plan_rule_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hper/audit/staff_plan_rule_audit','audit_details','F','/vhr/hper/audit/staff_plan_audit_details','S','O');



uis.ready('/vhr/hper/audit/staff_plan_rule_audit','.audit_details.model.');

commit;
end;
/
