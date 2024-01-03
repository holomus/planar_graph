set define off
prompt PATH /vhr/href/view/labor_function_audit_details
begin
uis.route('/vhr/href/view/labor_function_audit_details:model','Ui_Vhr390.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/view/labor_function_audit_details','vhr390');
uis.form('/vhr/href/view/labor_function_audit_details','/vhr/href/view/labor_function_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/view/labor_function_audit_details','.model.');

commit;
end;
/
