set define off
prompt PATH /vhr/htt/track
begin
uis.route('/vhr/htt/track+add:locations','Ui_Vhr77.Query_Locations',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/track+add:model','Ui_Vhr77.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/track+add:persons','Ui_Vhr77.Query_Persons',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/track+add:save','Ui_Vhr77.Add','M',null,'A',null,null,null,null);

uis.path('/vhr/htt/track','vhr77');
uis.form('/vhr/htt/track+add','/vhr/htt/track','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/track+add','add_location','F','/vhr/htt/location+add','D','O');
uis.action('/vhr/htt/track+add','add_person','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/htt/track+add','select_location','F','/vhr/htt/location_list','D','O');
uis.action('/vhr/htt/track+add','select_person','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/htt/track+add','track_type_check','F',null,null,'G');
uis.action('/vhr/htt/track+add','track_type_input','F',null,null,'G');
uis.action('/vhr/htt/track+add','track_type_output','F',null,null,'G');


uis.ready('/vhr/htt/track+add','.add_location.add_person.model.select_location.select_person.track_type_check.track_type_input.track_type_output.');

commit;
end;
/
