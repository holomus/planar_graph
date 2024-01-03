set define off
prompt PATH /vhr/htt/device_list
begin
uis.route('/vhr/htt/device_list$delete','Ui_Vhr80.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/device_list$load_tracks','Ui_Vhr80.Load_Tracks','M','R','A',null,null,null,null,null);
uis.route('/vhr/htt/device_list:model','Ui_Vhr80.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/device_list:table','Ui_Vhr80.Query','M','Q','A',null,null,null,null,null);

uis.path('/vhr/htt/device_list','vhr80');
uis.form('/vhr/htt/device_list','/vhr/htt/device_list','A','A','F','HM','M','N',null,'N',null);



uis.action('/vhr/htt/device_list','add','A','/vhr/htt/device+add','S','O');
uis.action('/vhr/htt/device_list','command','A','/vhr/hzk/command_list','D','O');
uis.action('/vhr/htt/device_list','delete','A',null,null,'A');
uis.action('/vhr/htt/device_list','edit','A','/vhr/htt/device+edit','S','O');
uis.action('/vhr/htt/device_list','error','A','/vhr/hzk/attlog_error_list','D','O');
uis.action('/vhr/htt/device_list','load_tracks','A',null,null,'A');
uis.action('/vhr/htt/device_list','tracks','A','/vhr/htt/acms_track_list','S','O');
uis.action('/vhr/htt/device_list','unknown_devices','A','/vhr/htt/unknown_device_list','S','O');
uis.action('/vhr/htt/device_list','view','A','/vhr/htt/device_view','S','O');

uis.form_sibling('vhr','/vhr/htt/device_list','/vhr/htt/new_devices_list',1);

uis.ready('/vhr/htt/device_list','.add.command.delete.edit.error.load_tracks.model.tracks.unknown_devices.view.');

commit;
end;
/
