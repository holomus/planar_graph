set define off
prompt PATH /vhr/href/view/specialty_audit_details
begin
uis.route('/vhr/href/view/specialty_audit_details:model','Ui_Vhr368.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/view/specialty_audit_details','vhr368');
uis.form('/vhr/href/view/specialty_audit_details','/vhr/href/view/specialty_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/view/specialty_audit_details','.model.');

commit;
end;
/
