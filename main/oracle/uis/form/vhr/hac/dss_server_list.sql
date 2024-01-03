set define off
prompt PATH /vhr/hac/dss_server_list
begin
uis.route('/vhr/hac/dss_server_list$delete','Ui_Vhr503.Del','M',null,'A',null,null,null,null);
uis.route('/vhr/hac/dss_server_list$get_service_tokens','Ui_Vhr503.Get_Service_Tokens',null,'R','A',null,null,null,null);
uis.route('/vhr/hac/dss_server_list$start_notification','Ui_Vhr503.Start_Notification',null,'R','A',null,null,null,null);
uis.route('/vhr/hac/dss_server_list$stop_notification','Ui_Vhr503.Stop_Notification',null,'R','A',null,null,null,null);
uis.route('/vhr/hac/dss_server_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/hac/dss_server_list:table','Ui_Vhr503.Query',null,'Q','A',null,null,null,null);

uis.path('/vhr/hac/dss_server_list','vhr503');
uis.form('/vhr/hac/dss_server_list','/vhr/hac/dss_server_list','A','A','F','H','M','Y',null,'N');



uis.action('/vhr/hac/dss_server_list','add','A','/vhr/hac/dss_server+add','S','O');
uis.action('/vhr/hac/dss_server_list','delete','A',null,null,'A');
uis.action('/vhr/hac/dss_server_list','edit','A','/vhr/hac/dss_server+edit','S','O');
uis.action('/vhr/hac/dss_server_list','get_service_tokens','A',null,null,'A');
uis.action('/vhr/hac/dss_server_list','start_notification','A',null,null,'A');
uis.action('/vhr/hac/dss_server_list','stop_notification','A',null,null,'A');
uis.action('/vhr/hac/dss_server_list','view','A','/vhr/hac/dss_server_view','S','O');


uis.ready('/vhr/hac/dss_server_list','.add.delete.edit.get_service_tokens.model.start_notification.stop_notification.view.');

commit;
end;
/
