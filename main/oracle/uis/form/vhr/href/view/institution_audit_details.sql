set define off
prompt PATH /vhr/href/view/institution_audit_details
begin
uis.route('/vhr/href/view/institution_audit_details:model','Ui_Vhr407.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/view/institution_audit_details','vhr407');
uis.form('/vhr/href/view/institution_audit_details','/vhr/href/view/institution_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/view/institution_audit_details','.model.');

commit;
end;
/
