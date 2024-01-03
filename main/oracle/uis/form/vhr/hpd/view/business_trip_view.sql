set define off
prompt PATH /vhr/hpd/view/business_trip_view
begin
uis.route('/vhr/hpd/view/business_trip_view$post','Ui_Vhr594.Post','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/business_trip_view$unpost','Ui_Vhr594.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/view/business_trip_view:model','Ui_Vhr594.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/view/business_trip_view:table_bt_region_audit','Ui_Vhr594.Query_Bt_Region_Audit','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/view/business_trip_view:table_business_trip_audit','Ui_Vhr594.Query_Business_Trip_Audit','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/view/business_trip_view:table_regions','Ui_Vhr594.Query_Bt_Region_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/view/business_trip_view','vhr594');
uis.form('/vhr/hpd/view/business_trip_view','/vhr/hpd/view/business_trip_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/view/business_trip_view','audit','F',null,null,'G');
uis.action('/vhr/hpd/view/business_trip_view','audit_details','F','/vhr/hpd/audit/timeoff_audit','S','O');
uis.action('/vhr/hpd/view/business_trip_view','business_trip_audit','F','/vhr/hpd/audit/business_trip_audit','S','O');
uis.action('/vhr/hpd/view/business_trip_view','edit','F','/vhr/hpd/business_trip+edit','S','O');
uis.action('/vhr/hpd/view/business_trip_view','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/view/business_trip_view','post','F',null,null,'A');
uis.action('/vhr/hpd/view/business_trip_view','sign_document','F','/vhr/hpd/sign_document','S','O');
uis.action('/vhr/hpd/view/business_trip_view','timeoff_audit','F','/vhr/hpd/audit/timeoff_audit','S','O');
uis.action('/vhr/hpd/view/business_trip_view','unpost','F',null,null,'A');


uis.ready('/vhr/hpd/view/business_trip_view','.audit.audit_details.business_trip_audit.edit.journal_audit.model.post.sign_document.timeoff_audit.unpost.');

commit;
end;
/
