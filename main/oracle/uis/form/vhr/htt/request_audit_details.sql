set define off
prompt PATH /vhr/htt/request_audit_details
begin
uis.route('/vhr/htt/request_audit_details:model','Ui_Vhr175.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/htt/request_audit_details','vhr175');
uis.form('/vhr/htt/request_audit_details','/vhr/htt/request_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/htt/request_audit_details','.model.');

commit;
end;
/
