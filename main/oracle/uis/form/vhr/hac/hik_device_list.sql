set define off
prompt PATH /vhr/hac/hik_device_list
begin
uis.route('/vhr/hac/hik_device_list$delete','Ui_Vhr523.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_device_list$sync','Ui_Vhr523.Sync','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_device_list:get_access_levels','Ui_Vhr523.Get_Access_Levels','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_device_list:get_devices','Ui_Vhr523.Get_Devices','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_device_list:get_doors','Ui_Vhr523.Get_Doors','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_device_list:get_events','Ui_Vhr523.Get_Events','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_device_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/hik_device_list:table','Ui_Vhr523.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/hik_device_list','vhr523');
uis.form('/vhr/hac/hik_device_list','/vhr/hac/hik_device_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_device_list','add','A','/vhr/hac/hik_device+add','S','O');
uis.action('/vhr/hac/hik_device_list','delete','A',null,null,'A');
uis.action('/vhr/hac/hik_device_list','edit','A','/vhr/hac/hik_device+edit','S','O');
uis.action('/vhr/hac/hik_device_list','get_events','A',null,null,'G');
uis.action('/vhr/hac/hik_device_list','sync','A',null,null,'A');
uis.action('/vhr/hac/hik_device_list','sync_all','A',null,null,'G');
uis.action('/vhr/hac/hik_device_list','view','A','/vhr/hac/hik_device_view','S','O');


uis.ready('/vhr/hac/hik_device_list','.add.delete.edit.get_events.model.sync.sync_all.view.');

commit;
end;
/
