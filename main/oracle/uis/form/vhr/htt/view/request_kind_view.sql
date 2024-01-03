set define off
prompt PATH /vhr/htt/view/request_kind_view
begin
uis.route('/vhr/htt/view/request_kind_view:model','Ui_Vhr430.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/htt/view/request_kind_view:table_audit','Ui_Vhr430.Query_Request_Kind_Audit','M','Q','A',null,null,null,null);

uis.path('/vhr/htt/view/request_kind_view','vhr430');
uis.form('/vhr/htt/view/request_kind_view','/vhr/htt/view/request_kind_view','A','A','F','H','M','N',null,'N');



uis.action('/vhr/htt/view/request_kind_view','audit','A',null,null,'G');
uis.action('/vhr/htt/view/request_kind_view','audit_details','A','/vhr/htt/view/request_kind_audit_details','S','O');
uis.action('/vhr/htt/view/request_kind_view','edit','A','/vhr/htt/request_kind+edit','S','O');


uis.ready('/vhr/htt/view/request_kind_view','.audit.audit_details.edit.model.');

commit;
end;
/
