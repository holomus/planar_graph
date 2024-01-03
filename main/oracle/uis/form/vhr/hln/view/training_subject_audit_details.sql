set define off
prompt PATH /vhr/hln/view/training_subject_audit_details
begin
uis.route('/vhr/hln/view/training_subject_audit_details:model','Ui_Vhr448.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hln/view/training_subject_audit_details','vhr448');
uis.form('/vhr/hln/view/training_subject_audit_details','/vhr/hln/view/training_subject_audit_details','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hln/view/training_subject_audit_details','.model.');

commit;
end;
/
