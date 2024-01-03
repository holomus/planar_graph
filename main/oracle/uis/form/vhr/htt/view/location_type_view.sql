set define off
prompt PATH /vhr/htt/view/location_type_view
begin
uis.route('/vhr/htt/view/location_type_view:model','Ui_Vhr411.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/view/location_type_view:table_audit','Ui_Vhr411.Query_Location_Type_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/view/location_type_view','vhr411');
uis.form('/vhr/htt/view/location_type_view','/vhr/htt/view/location_type_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/view/location_type_view','audit','A',null,null,'G');
uis.action('/vhr/htt/view/location_type_view','audit_details','A','/vhr/htt/view/location_type_audit_details','S','O');
uis.action('/vhr/htt/view/location_type_view','edit','A','/vhr/htt/location_type+edit','S','O');


uis.ready('/vhr/htt/view/location_type_view','.audit.audit_details.edit.model.');

commit;
end;
/
