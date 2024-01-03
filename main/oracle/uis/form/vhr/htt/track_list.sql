set define off
prompt PATH /vhr/htt/track_list
begin
uis.route('/vhr/htt/track_list$add','Ui_Vhr76.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/track_list$delete','Ui_Vhr76.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/track_list$set_invalid','Ui_Vhr76.Set_Invalid','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/track_list$set_valid','Ui_Vhr76.Set_Valid','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/track_list:change_track_type','Ui_Vhr76.Change_Track_Type','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/track_list:locations','Ui_Vhr76.Query_Locations',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/track_list:model','Ui_Vhr76.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/htt/track_list:persons','Ui_Vhr76.Query_Persons',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/track_list:table','Ui_Vhr76.Query',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/htt/track_list','vhr76');
uis.form('/vhr/htt/track_list','/vhr/htt/track_list','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htt/track_list','add','F',null,null,'A');
uis.action('/vhr/htt/track_list','add_location','F','/vhr/htt/location+add','D','O');
uis.action('/vhr/htt/track_list','add_person','F','/vhr/href/person/person_add','D','O');
uis.action('/vhr/htt/track_list','copy_tracks_to_filial','F','/vhr/htt/copy_tracks_to_filial','S','O');
uis.action('/vhr/htt/track_list','delete','F',null,null,'A');
uis.action('/vhr/htt/track_list','select_location','F','/vhr/htt/location_list','D','O');
uis.action('/vhr/htt/track_list','select_person','F','/vhr/href/person/person_list','D','O');
uis.action('/vhr/htt/track_list','set_invalid','F',null,null,'A');
uis.action('/vhr/htt/track_list','set_valid','F',null,null,'A');
uis.action('/vhr/htt/track_list','track_type_check','F',null,null,'G');
uis.action('/vhr/htt/track_list','track_type_input','F',null,null,'G');
uis.action('/vhr/htt/track_list','track_type_output','F',null,null,'G');
uis.action('/vhr/htt/track_list','view','F','/vhr/htt/track_view','S','O');

uis.form_sibling('vhr','/vhr/htt/track_list','/vhr/htt/tracking',1);
uis.form_sibling('vhr','/vhr/htt/track_list','/vhr/htt/gps_tracking',2);
uis.form_sibling('vhr','/vhr/htt/track_list','/vhr/hac/problem_tracks_list',3);

uis.ready('/vhr/htt/track_list','.add.add_location.add_person.copy_tracks_to_filial.delete.model.select_location.select_person.set_invalid.set_valid.track_type_check.track_type_input.track_type_output.view.');

commit;
end;
/
