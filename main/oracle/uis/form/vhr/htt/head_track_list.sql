set define off
prompt PATH /vhr/htt/head_track_list
begin
uis.route('/vhr/htt/head_track_list$add','Ui_Vhr482.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_track_list$delete','Ui_Vhr482.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_track_list$set_invalid','Ui_Vhr482.Set_Invalid','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_track_list$set_valid','Ui_Vhr482.Set_Valid','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_track_list:filials','Ui_Vhr482.Query_Filial',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/head_track_list:locations','Ui_Vhr482.Query_Locations','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/head_track_list:model','Ui_Vhr482.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/head_track_list:persons','Ui_Vhr482.Query_Persons','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/head_track_list:table','Ui_Vhr482.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/head_track_list','vhr482');
uis.form('/vhr/htt/head_track_list','/vhr/htt/head_track_list','H','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/head_track_list','add','H',null,null,'A');
uis.action('/vhr/htt/head_track_list','add_location','H','/vhr/htt/location+add','D','O');
uis.action('/vhr/htt/head_track_list','delete','H',null,null,'A');
uis.action('/vhr/htt/head_track_list','select_filial','H','/anor/mr/filial_list','D','O');
uis.action('/vhr/htt/head_track_list','select_location','H','/vhr/htt/location_list','D','O');
uis.action('/vhr/htt/head_track_list','select_person','H','/vhr/href/person/person_list','D','O');
uis.action('/vhr/htt/head_track_list','set_invalid','H',null,null,'A');
uis.action('/vhr/htt/head_track_list','set_valid','H',null,null,'A');
uis.action('/vhr/htt/head_track_list','track_type_check','H',null,null,'G');
uis.action('/vhr/htt/head_track_list','track_type_input','H',null,null,'G');
uis.action('/vhr/htt/head_track_list','track_type_output','H',null,null,'G');
uis.action('/vhr/htt/head_track_list','view','H','/vhr/htt/track_view','S','O');

uis.form_sibling('vhr','/vhr/htt/head_track_list','/vhr/hac/problem_tracks_list',1);

uis.ready('/vhr/htt/head_track_list','.add.add_location.delete.model.select_filial.select_location.select_person.set_invalid.set_valid.track_type_check.track_type_input.track_type_output.view.');

commit;
end;
/
