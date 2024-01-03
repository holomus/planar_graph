set define off
prompt PATH /vhr/hper/audit/staff_plan_audit_details
begin
uis.route('/vhr/hper/audit/staff_plan_audit_details:model','Ui_Vhr203.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hper/audit/staff_plan_audit_details','vhr203');
uis.form('/vhr/hper/audit/staff_plan_audit_details','/vhr/hper/audit/staff_plan_audit_details','F','A','F','H','M','N',null,'N');






uis.ready('/vhr/hper/audit/staff_plan_audit_details','.model.');

commit;
end;
/
