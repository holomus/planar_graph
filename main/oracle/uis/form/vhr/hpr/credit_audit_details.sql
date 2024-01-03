set define off
prompt PATH /vhr/hpr/credit_audit_details
begin
uis.route('/vhr/hpr/credit_audit_details:model','Ui_Vhr682.Model','M','M','A','Y',null,null,null,'S');

uis.path('/vhr/hpr/credit_audit_details','vhr682');
uis.form('/vhr/hpr/credit_audit_details','/vhr/hpr/credit_audit_details','F','A','F','H','M','N',null,'N','S');





uis.ready('/vhr/hpr/credit_audit_details','.model.');

commit;
end;
/
