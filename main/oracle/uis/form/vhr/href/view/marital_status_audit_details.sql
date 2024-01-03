set define off
prompt PATH /vhr/href/view/marital_status_audit_details
begin
uis.route('/vhr/href/view/marital_status_audit_details:model','Ui_Vhr384.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/view/marital_status_audit_details','vhr384');
uis.form('/vhr/href/view/marital_status_audit_details','/vhr/href/view/marital_status_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/view/marital_status_audit_details','.model.');

commit;
end;
/
