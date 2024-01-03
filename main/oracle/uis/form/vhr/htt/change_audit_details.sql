set define off
prompt PATH /vhr/htt/change_audit_details
begin
uis.route('/vhr/htt/change_audit_details:model','Ui_Vhr230.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/htt/change_audit_details','vhr230');
uis.form('/vhr/htt/change_audit_details','/vhr/htt/change_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/htt/change_audit_details','.model.');

commit;
end;
/
