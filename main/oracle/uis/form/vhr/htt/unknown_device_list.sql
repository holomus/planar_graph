set define off
prompt PATH /vhr/htt/unknown_device_list
begin
uis.route('/vhr/htt/unknown_device_list$clear_tracks','Ui_Vhr355.Clear_Tracks','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/unknown_device_list$reliable','Ui_Vhr355.Reliable','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/unknown_device_list$unreliable','Ui_Vhr355.Unreliable','M','L','A',null,null,null,null);
uis.route('/vhr/htt/unknown_device_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/unknown_device_list:table','Ui_Vhr355.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/unknown_device_list','vhr355');
uis.form('/vhr/htt/unknown_device_list','/vhr/htt/unknown_device_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/unknown_device_list','clear_tracks','A',null,null,'A');
uis.action('/vhr/htt/unknown_device_list','reliable','A',null,null,'A');
uis.action('/vhr/htt/unknown_device_list','unreliable','A',null,null,'A');


uis.ready('/vhr/htt/unknown_device_list','.clear_tracks.model.reliable.unreliable.');

commit;
end;
/
