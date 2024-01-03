set define off
prompt PATH /vhr/gen/facts
begin
uis.route('/vhr/gen/facts:devices','Ui_Vhr232.Query_Devices',null,'Q','A',null,null,null,null);
uis.route('/vhr/gen/facts:generate','Ui_Vhr232.Generate','M',null,'A',null,null,null,null);
uis.route('/vhr/gen/facts:get_schedule','Ui_Vhr232.Get_Schedule','M','L','A',null,null,null,null);
uis.route('/vhr/gen/facts:model','Ui_Vhr232.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/gen/facts:request_kinds','Ui_Vhr232.Query_Request_Kinds',null,'Q','A',null,null,null,null);
uis.route('/vhr/gen/facts:staffs','Ui_Vhr232.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/gen/facts','vhr232');
uis.form('/vhr/gen/facts','/vhr/gen/facts','F','A','F','H','M','Y',null,'N');



uis.action('/vhr/gen/facts','select_devices','F','/vhr/htt/device_list','D','O');
uis.action('/vhr/gen/facts','select_request_kind','F','/vhr/htt/request_kind_list','D','O');
uis.action('/vhr/gen/facts','select_staffs','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/gen/facts','.model.select_devices.select_request_kind.select_staffs.');

commit;
end;
/
