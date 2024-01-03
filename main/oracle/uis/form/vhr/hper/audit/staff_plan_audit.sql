set define off
prompt PATH /vhr/hper/audit/staff_plan_audit
begin
uis.route('/vhr/hper/audit/staff_plan_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hper/audit/staff_plan_audit:table_audit','Ui_Vhr202.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hper/audit/staff_plan_audit','vhr202');
uis.form('/vhr/hper/audit/staff_plan_audit','/vhr/hper/audit/staff_plan_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hper/audit/staff_plan_audit','audit_details','F','/vhr/hper/audit/staff_plan_audit_details','S','O');
uis.action('/vhr/hper/audit/staff_plan_audit','staff_plan_item_audit','F','/vhr/hper/audit/staff_plan_item_audit','S','O');
uis.action('/vhr/hper/audit/staff_plan_audit','staff_plan_part_audit','F','/vhr/hper/audit/staff_plan_part_audit','S','O');
uis.action('/vhr/hper/audit/staff_plan_audit','staff_plan_rule_audit','F','/vhr/hper/audit/staff_plan_rule_audit','S','O');



uis.ready('/vhr/hper/audit/staff_plan_audit','.audit_details.model.staff_plan_item_audit.staff_plan_part_audit.staff_plan_rule_audit.');

commit;
end;
/
