set define off
prompt PATH /vhr/hper/view/plan_type_audit_details
begin
uis.route('/vhr/hper/view/plan_type_audit_details:model','Ui_Vhr437.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hper/view/plan_type_audit_details','vhr437');
uis.form('/vhr/hper/view/plan_type_audit_details','/vhr/hper/view/plan_type_audit_details','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hper/view/plan_type_audit_details','.model.');

commit;
end;
/
