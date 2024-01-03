set define off
prompt PATH /vhr/hac/hik_listening_devices_list
begin
uis.route('/vhr/hac/hik_listening_devices_list$delete','Ui_Vhr665.Del','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/hac/hik_listening_devices_list:model','Ui_Vhr665.Model',null,'M','A','Y',null,null,null,'S');
uis.route('/vhr/hac/hik_listening_devices_list:table','Ui_Vhr665.Query',null,'Q','A',null,null,null,null,'S');

uis.path('/vhr/hac/hik_listening_devices_list','vhr665');
uis.form('/vhr/hac/hik_listening_devices_list','/vhr/hac/hik_listening_devices_list','A','A','F','H','M','Y',null,'N','S');



uis.action('/vhr/hac/hik_listening_devices_list','add','A','/vhr/hac/hik_listening_device+add','S','O');
uis.action('/vhr/hac/hik_listening_devices_list','copy_route','A',null,null,'G');
uis.action('/vhr/hac/hik_listening_devices_list','delete','A',null,null,'A');


uis.ready('/vhr/hac/hik_listening_devices_list','.add.copy_route.delete.model.');

commit;
end;
/
