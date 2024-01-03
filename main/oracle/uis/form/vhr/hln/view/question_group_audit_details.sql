set define off
prompt PATH /vhr/hln/view/question_group_audit_details
begin
uis.route('/vhr/hln/view/question_group_audit_details:model','Ui_Vhr441.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hln/view/question_group_audit_details','vhr441');
uis.form('/vhr/hln/view/question_group_audit_details','/vhr/hln/view/question_group_audit_details','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hln/view/question_group_audit_details','.model.');

commit;
end;
/
