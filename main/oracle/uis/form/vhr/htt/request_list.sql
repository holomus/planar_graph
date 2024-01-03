set define off
prompt PATH /vhr/htt/request_list
begin
uis.route('/vhr/htt/request_list$approve','Ui_Vhr122.Request_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list$cancel','Ui_Vhr122.Request_Cancel','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list$change_approve','Ui_Vhr122.Request_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list$complete','Ui_Vhr122.Request_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list$delete','Ui_Vhr122.Request_Delete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list$delete_personal','Ui_Vhr122.Request_Delete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list$deny','Ui_Vhr122.Request_Deny','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list$reset','Ui_Vhr122.Request_Reset','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list$return','Ui_Vhr122.Request_Reset','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_list:available_requests','Ui_Vhr122.Query_Available_Requests',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/request_list:model','Ui_Vhr122.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/htt/request_list:personal_requests','Ui_Vhr122.Query_Personal_Requests',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/request_list:run','Ui_Vhr122.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/htt/request_list','vhr122');
uis.form('/vhr/htt/request_list','/vhr/htt/request_list','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/request_list','add','F','/vhr/htt/request+add','S','O');
uis.action('/vhr/htt/request_list','add_personal','F','/vhr/htt/request+add_personal','S','O');
uis.action('/vhr/htt/request_list','approve','F',null,null,'A');
uis.action('/vhr/htt/request_list','cancel','F',null,null,'A');
uis.action('/vhr/htt/request_list','complete','F',null,null,'A');
uis.action('/vhr/htt/request_list','delete','F',null,null,'A');
uis.action('/vhr/htt/request_list','deny','F',null,null,'A');
uis.action('/vhr/htt/request_list','edit','F','/vhr/htt/request+edit','S','O');
uis.action('/vhr/htt/request_list','edit_personal','F','/vhr/htt/request+edit_personal','S','O');
uis.action('/vhr/htt/request_list','reset','F',null,null,'A');
uis.action('/vhr/htt/request_list','view','F','/vhr/htt/request_view+view','S','O');
uis.action('/vhr/htt/request_list','view_personal','F','/vhr/htt/request_view+view_personal','S','O');

uis.form_sibling('vhr','/vhr/htt/request_list','/vhr/htt/request_kind_list',1);

uis.ready('/vhr/htt/request_list','.add.add_personal.approve.cancel.complete.delete.deny.edit.edit_personal.model.reset.view.view_personal.');

commit;
end;
/
