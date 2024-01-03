set define off
prompt PATH /vhr/htt/view/location_audit_details
begin
uis.route('/vhr/htt/view/location_audit_details:model','Ui_Vhr414.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/htt/view/location_audit_details','vhr414');
uis.form('/vhr/htt/view/location_audit_details','/vhr/htt/view/location_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/htt/view/location_audit_details','.model.');

commit;
end;
/
