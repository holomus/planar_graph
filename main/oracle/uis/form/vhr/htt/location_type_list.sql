set define off
prompt PATH /vhr/htt/location_type_list
begin
uis.route('/vhr/htt/location_type_list$delete','Ui_Vhr162.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/location_type_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/location_type_list:table','Ui_Vhr162.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/location_type_list','vhr162');
uis.form('/vhr/htt/location_type_list','/vhr/htt/location_type_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/location_type_list','add','A','/vhr/htt/location_type+add','S','O');
uis.action('/vhr/htt/location_type_list','delete','A',null,null,'A');
uis.action('/vhr/htt/location_type_list','edit','A','/vhr/htt/location_type+edit','S','O');
uis.action('/vhr/htt/location_type_list','view','A','/vhr/htt/view/location_type_view','S','O');


uis.ready('/vhr/htt/location_type_list','.add.delete.edit.model.view.');

commit;
end;
/
