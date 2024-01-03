set define off
prompt PATH /vhr/htt/new_devices_list
begin
uis.route('/vhr/htt/new_devices_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/new_devices_list:table','Ui_Vhr632.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/htt/new_devices_list','vhr632');
uis.form('/vhr/htt/new_devices_list','/vhr/htt/new_devices_list','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/new_devices_list','add_device','A','/vhr/htt/device+add','S','O');


uis.ready('/vhr/htt/new_devices_list','.add_device.model.');

commit;
end;
/
