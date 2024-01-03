set define off
prompt PATH /vhr/hac/hik_ex_device_list
begin
uis.route('/vhr/hac/hik_ex_device_list$delete','Ui_Vhr512.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_device_list:get_devices','Ui_Vhr512.Get_Devices','M','R','A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_device_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/hik_ex_device_list:servers','Ui_Vhr512.Query_Servers',null,null,'A',null,null,null,null);
uis.route('/vhr/hac/hik_ex_device_list:table','Ui_Vhr512.Query','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/hik_ex_device_list','vhr512');
uis.form('/vhr/hac/hik_ex_device_list','/vhr/hac/hik_ex_device_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/hik_ex_device_list','delete','A',null,null,'A');


uis.ready('/vhr/hac/hik_ex_device_list','.delete.model.');

commit;
end;
/
