set define off
prompt PATH /vhr/htt/head_request_list
begin
uis.route('/vhr/htt/head_request_list$approve','Ui_Vhr627.Request_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_request_list$cancel','Ui_Vhr627.Request_Cancel','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_request_list$complete','Ui_Vhr627.Request_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_request_list$delete','Ui_Vhr627.Request_Delete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_request_list$deny','Ui_Vhr627.Request_Deny','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_request_list$reset','Ui_Vhr627.Request_Reset','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/head_request_list:available_requests','Ui_Vhr627.Query_Available_Requests',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/head_request_list:director_requests','Ui_Vhr627.Query_Director_Requests',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/head_request_list:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/htt/head_request_list:run','Ui_Vhr627.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/htt/head_request_list','vhr627');
uis.form('/vhr/htt/head_request_list','/vhr/htt/head_request_list','H','A','F','HM','M','N',null,'N');



uis.action('/vhr/htt/head_request_list','approve','H',null,null,'A');
uis.action('/vhr/htt/head_request_list','cancel','H',null,null,'A');
uis.action('/vhr/htt/head_request_list','complete','H',null,null,'A');
uis.action('/vhr/htt/head_request_list','delete','H',null,null,'A');
uis.action('/vhr/htt/head_request_list','deny','H',null,null,'A');
uis.action('/vhr/htt/head_request_list','reset','H',null,null,'A');
uis.action('/vhr/htt/head_request_list','view','H','/vhr/htt/request_view+view','S','O');


uis.ready('/vhr/htt/head_request_list','.approve.cancel.complete.delete.deny.model.reset.view.');

commit;
end;
/
