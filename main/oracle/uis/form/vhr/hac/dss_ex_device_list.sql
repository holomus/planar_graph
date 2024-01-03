set define off
prompt PATH /vhr/hac/dss_ex_device_list
begin
uis.route('/vhr/hac/dss_ex_device_list$delete','Ui_Vhr519.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_device_list:get_device_info','Ui_Vhr519.Get_Device_Info','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_device_list:get_devices','Ui_Vhr519.Get_Devices','M','R','A',null,null,null,null);
uis.route('/vhr/hac/dss_ex_device_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/dss_ex_device_list:table','Ui_Vhr519.Query_Devices','M','Q','A',null,null,null,null);

uis.path('/vhr/hac/dss_ex_device_list','vhr519');
uis.form('/vhr/hac/dss_ex_device_list','/vhr/hac/dss_ex_device_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/dss_ex_device_list','delete','A',null,null,'A');


uis.ready('/vhr/hac/dss_ex_device_list','.delete.model.');

commit;
end;
/
