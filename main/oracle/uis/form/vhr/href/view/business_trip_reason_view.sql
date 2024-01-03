set define off
prompt PATH /vhr/href/view/business_trip_reason_view
begin
uis.route('/vhr/href/view/business_trip_reason_view:model','Ui_Vhr394.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/href/view/business_trip_reason_view:table_audit','Ui_Vhr394.Query_Reason_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/href/view/business_trip_reason_view','vhr394');
uis.form('/vhr/href/view/business_trip_reason_view','/vhr/href/view/business_trip_reason_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/view/business_trip_reason_view','audit','A',null,null,'G');
uis.action('/vhr/href/view/business_trip_reason_view','audit_details','A','/vhr/href/view/business_trip_reason_audit_details','S','O');
uis.action('/vhr/href/view/business_trip_reason_view','edit','A','/vhr/href/business_trip_reason+edit','S','O');


uis.ready('/vhr/href/view/business_trip_reason_view','.audit.audit_details.edit.model.');

commit;
end;
/
