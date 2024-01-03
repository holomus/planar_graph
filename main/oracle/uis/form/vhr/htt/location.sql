set define off
prompt PATH /vhr/htt/location
begin
uis.route('/vhr/htt/location+add:location_types','Ui_Vhr79.Query_Location_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/location+add:model','Ui_Vhr79.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/location+add:save','Ui_Vhr79.Add','M','M','A',null,null,null,null);
uis.route('/vhr/htt/location+add:timezones','Ui_Vhr79.Query_Timezones',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/location+edit:location_types','Ui_Vhr79.Query_Location_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/location+edit:model','Ui_Vhr79.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/location+edit:save','Ui_Vhr79.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/htt/location+edit:timezones','Ui_Vhr79.Query_Timezones',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/location','vhr79');
uis.form('/vhr/htt/location+add','/vhr/htt/location','A','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/location+edit','/vhr/htt/location','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/location+add','add_location_type','A','/vhr/htt/location_type+add','D','O');
uis.action('/vhr/htt/location+add','select_location_type','A','/vhr/htt/location_type_list','D','O');
uis.action('/vhr/htt/location+edit','add_location_type','A','/vhr/htt/location_type+add','D','O');
uis.action('/vhr/htt/location+edit','select_location_type','A','/vhr/htt/location_type_list','D','O');


uis.ready('/vhr/htt/location+add','.add_location_type.model.select_location_type.');
uis.ready('/vhr/htt/location+edit','.add_location_type.model.select_location_type.');

commit;
end;
/
