set define off
prompt PATH /vhr/href/view/business_trip_reason_audit_details
begin
uis.route('/vhr/href/view/business_trip_reason_audit_details:model','Ui_Vhr395.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/view/business_trip_reason_audit_details','vhr395');
uis.form('/vhr/href/view/business_trip_reason_audit_details','/vhr/href/view/business_trip_reason_audit_details','A','A','F','H','M','N',null,'N');





uis.ready('/vhr/href/view/business_trip_reason_audit_details','.model.');

commit;
end;
/
