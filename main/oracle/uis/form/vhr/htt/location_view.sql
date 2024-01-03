set define off
prompt PATH /vhr/htt/location_view
begin
uis.route('/vhr/htt/location_view$attach_division','Ui_Vhr93.Attach_Division','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_view$attach_person','Ui_Vhr93.Attach_Person','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_view$detach_division','Ui_Vhr93.Detach_Division','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_view$detach_person','Ui_Vhr93.Detach_Person','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_view$sync_device','Ui_Vhr93.Sync_Device','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_view$sync_person','Ui_Vhr93.Sync_Person','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_view:model','Ui_Vhr93.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/location_view:table_audit','Ui_Vhr93.Query_Location_Audit','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/location_view:table_devices','Ui_Vhr93.Query_Devices','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/location_view:table_divisions','Ui_Vhr93.Query_Divisions','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/location_view:table_location_person_audit','Ui_Vhr93.Query_Location_Person_Audit','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/location_view:table_persons','Ui_Vhr93.Query_Persons','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/location_view','vhr93');
uis.form('/vhr/htt/location_view','/vhr/htt/location_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/location_view','attach_division','F',null,null,'A');
uis.action('/vhr/htt/location_view','attach_person','F',null,null,'A');
uis.action('/vhr/htt/location_view','audit','A',null,null,'G');
uis.action('/vhr/htt/location_view','audit_details','A','/vhr/htt/view/location_audit_details','D','O');
uis.action('/vhr/htt/location_view','detach_division','F',null,null,'A');
uis.action('/vhr/htt/location_view','detach_person','F',null,null,'A');
uis.action('/vhr/htt/location_view','edit','A','/vhr/htt/location+edit','S','O');
uis.action('/vhr/htt/location_view','sync_device','A',null,null,'A');
uis.action('/vhr/htt/location_view','sync_person','F',null,null,'A');
uis.action('/vhr/htt/location_view','view','A','/vhr/htt/device_view','S','O');


uis.ready('/vhr/htt/location_view','.attach_division.attach_person.audit.audit_details.detach_division.detach_person.edit.model.sync_device.sync_person.view.');

commit;
end;
/
