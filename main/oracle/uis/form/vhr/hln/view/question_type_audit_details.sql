set define off
prompt PATH /vhr/hln/view/question_type_audit_details
begin
uis.route('/vhr/hln/view/question_type_audit_details:model','Ui_Vhr444.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hln/view/question_type_audit_details','vhr444');
uis.form('/vhr/hln/view/question_type_audit_details','/vhr/hln/view/question_type_audit_details','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hln/view/question_type_audit_details','.model.');

commit;
end;
/
