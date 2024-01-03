set define off
prompt PATH /vhr/htt/request_view
begin
uis.route('/vhr/htt/request_view+view$approve','Ui_Vhr172.Request_Approve','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_view+view$cancel','Ui_Vhr172.Request_Cancel','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_view+view$complete','Ui_Vhr172.Request_Complete','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_view+view$deny','Ui_Vhr172.Request_Deny','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_view+view$reset','Ui_Vhr172.Request_Reset','M',null,'A',null,null,null,null);
uis.route('/vhr/htt/request_view+view:model','Ui_Vhr172.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/request_view+view:table_audit','Ui_Vhr172.Query_Request_Audit','M','Q','A',null,null,null,null);
uis.route('/vhr/htt/request_view+view_personal:model','Ui_Vhr172.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/request_view+view_personal:table_audit','Ui_Vhr172.Query_Request_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/request_view','vhr172');
uis.form('/vhr/htt/request_view+view','/vhr/htt/request_view','A','A','F','H','M','N',null,'N');
uis.form('/vhr/htt/request_view+view_personal','/vhr/htt/request_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/request_view+view','approve','A',null,null,'A');
uis.action('/vhr/htt/request_view+view','audit','A',null,null,'G');
uis.action('/vhr/htt/request_view+view','audit_details','A','/vhr/htt/request_audit_details','S','O');
uis.action('/vhr/htt/request_view+view','cancel','A',null,null,'A');
uis.action('/vhr/htt/request_view+view','complete','A',null,null,'A');
uis.action('/vhr/htt/request_view+view','deny','A',null,null,'A');
uis.action('/vhr/htt/request_view+view','edit','F','/vhr/htt/request+edit','S','O');
uis.action('/vhr/htt/request_view+view','reset','A',null,null,'A');
uis.action('/vhr/htt/request_view+view_personal','audit','F',null,null,'G');
uis.action('/vhr/htt/request_view+view_personal','audit_details','F','/vhr/htt/request_audit_details','S','O');
uis.action('/vhr/htt/request_view+view_personal','edit','F','/vhr/htt/request+edit_personal','S','O');


uis.ready('/vhr/htt/request_view+view','.approve.audit.audit_details.cancel.complete.deny.edit.model.reset.');
uis.ready('/vhr/htt/request_view+view_personal','.audit.audit_details.edit.model.');

commit;
end;
/
