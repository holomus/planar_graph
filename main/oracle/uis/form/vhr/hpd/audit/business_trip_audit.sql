set define off
prompt PATH /vhr/hpd/audit/business_trip_audit
begin
uis.route('/vhr/hpd/audit/business_trip_audit:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hpd/audit/business_trip_audit:table_audit','Ui_Vhr201.Query','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/audit/business_trip_audit:table_regions','Ui_Vhr201.Query_Business_Trip_Regions','M','Q','A',null,null,null,null);

uis.path('/vhr/hpd/audit/business_trip_audit','vhr201');
uis.form('/vhr/hpd/audit/business_trip_audit','/vhr/hpd/audit/business_trip_audit','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/audit/business_trip_audit','audit_details','F','/vhr/hpd/audit/journal_audit_details','S','O');
uis.action('/vhr/hpd/audit/business_trip_audit','journal_audit','F','/vhr/hpd/audit/journal_audit','S','O');
uis.action('/vhr/hpd/audit/business_trip_audit','timeoff_audit','F','/vhr/hpd/audit/timeoff_audit','S','O');


uis.ready('/vhr/hpd/audit/business_trip_audit','.audit_details.journal_audit.model.timeoff_audit.');

commit;
end;
/
