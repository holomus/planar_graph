set define off
prompt PATH /vhr/hac/dss_device_list
begin
uis.route('/vhr/hac/dss_device_list$delete','Ui_Vhr506.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_device_list$sync_devices','Ui_Vhr506.Sync_Devices','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_device_list:get_access_groups','Ui_Vhr506.Get_Access_Groups','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_device_list:get_device_info','Ui_Vhr506.Get_Device_Info','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_device_list:get_devices','Ui_Vhr506.Get_Devices','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_device_list:get_ex_device_codes','Ui_Vhr506.Get_Ex_Device_Codes','M','M','A',null,null,null,null);
uis.route('/vhr/hac/dss_device_list:load_tracks','Ui_Vhr506.Load_Tracks','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_device_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/dss_device_list:table','Ui_Vhr506.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/dss_device_list','vhr506');
uis.form('/vhr/hac/dss_device_list','/vhr/hac/dss_device_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/dss_device_list','add','A','/vhr/hac/dss_device+add','S','O');
uis.action('/vhr/hac/dss_device_list','delete','A',null,null,'A');
uis.action('/vhr/hac/dss_device_list','edit','A','/vhr/hac/dss_device+edit','S','O');
uis.action('/vhr/hac/dss_device_list','sync_all','A',null,null,'G');
uis.action('/vhr/hac/dss_device_list','sync_devices','A',null,null,'A');
uis.action('/vhr/hac/dss_device_list','view','A','/vhr/hac/dss_device_view','S','O');


uis.ready('/vhr/hac/dss_device_list','.add.delete.edit.model.sync_all.sync_devices.view.');

commit;
end;
/
