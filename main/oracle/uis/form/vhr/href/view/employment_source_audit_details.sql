set define off
prompt PATH /vhr/href/view/employment_source_audit_details
begin
uis.route('/vhr/href/view/employment_source_audit_details:model','Ui_Vhr401.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/view/employment_source_audit_details','vhr401');
uis.form('/vhr/href/view/employment_source_audit_details','/vhr/href/view/employment_source_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/view/employment_source_audit_details','.model.');

commit;
end;
/
