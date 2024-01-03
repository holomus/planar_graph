set define off
prompt PATH /vhr/htt/staff_requests
begin
uis.route('/vhr/htt/staff_requests$approve','Ui_Vhr332.Request_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_requests$complete','Ui_Vhr332.Request_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_requests$delete','Ui_Vhr332.Request_Delete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_requests$deny','Ui_Vhr332.Request_Deny','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_requests$reset','Ui_Vhr332.Request_Reset','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:add','Ui_Vhr332.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:add_request','Ui_Vhr332.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:edit','Ui_Vhr332.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:get_request_info','Ui_Vhr332.Get_Request_Info','M','M','A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:load_request_limits','Ui_Vhr332.Load_Request_Limits','M','L','A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:model','Ui_Vhr332.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/staff_requests:personal_requests_checked','Ui_Vhr332.Query_Checked','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:personal_requests_unchecked','Ui_Vhr332.Query_Unchecked','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:request_kind_accruals','Ui_Vhr332.Query_Accruals','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:request_kinds','Ui_Vhr332.Query_Request_Kinds','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/staff_requests:run','Ui_Vhr332.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/htt/staff_requests','vhr332');
uis.form('/vhr/htt/staff_requests','/vhr/htt/staff_requests','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/staff_requests','add_request','F','/vhr/htt/request+add_personal','S','O');
uis.action('/vhr/htt/staff_requests','approve','F',null,null,'A');
uis.action('/vhr/htt/staff_requests','complete','F',null,null,'A');
uis.action('/vhr/htt/staff_requests','delete','F',null,null,'A');
uis.action('/vhr/htt/staff_requests','deny','F',null,null,'A');
uis.action('/vhr/htt/staff_requests','edit','F','/vhr/htt/request+edit_personal','S','O');
uis.action('/vhr/htt/staff_requests','reset','F',null,null,'A');
uis.action('/vhr/htt/staff_requests','select_request_kind','F','/vhr/htt/request_kind_list','S','O');
uis.action('/vhr/htt/staff_requests','view','F','/vhr/htt/request_view+view','S','O');
uis.action('/vhr/htt/staff_requests','view_personal','F','/vhr/htt/request_view+view_personal','S','O');


uis.ready('/vhr/htt/staff_requests','.add_request.approve.complete.delete.deny.edit.model.reset.select_request_kind.view.view_personal.');

commit;
end;
/
