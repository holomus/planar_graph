set define off
prompt PATH /vhr/htt/change_view
begin
uis.route('/vhr/htt/change_view+view$approve','Ui_Vhr229.Change_Approve','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view$cancel','Ui_Vhr229.Change_Cancel','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view$complete','Ui_Vhr229.Change_Complete','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view$deny','Ui_Vhr229.Change_Deny','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view$reset','Ui_Vhr229.Change_Reset','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view:model','Ui_Vhr229.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/change_view+view:save_change_day_weights','Ui_Vhr229.Save_Change_Day_Weights','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view:table_change_audit','Ui_Vhr229.Query_Change_Audit','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view:table_change_days_audit','Ui_Vhr229.Query_Change_Days_Audit','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view_personal:model','Ui_Vhr229.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/change_view+view_personal:table_change_audit','Ui_Vhr229.Query_Change_Audit','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/change_view+view_personal:table_change_days_audit','Ui_Vhr229.Query_Change_Days_Audit','M','Q','A',null,null,null,null,null);

uis.path('/vhr/htt/change_view','vhr229');
uis.form('/vhr/htt/change_view+view','/vhr/htt/change_view','A','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/change_view+view_personal','/vhr/htt/change_view','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htt/change_view+view','approve','A',null,null,'A');
uis.action('/vhr/htt/change_view+view','audit','A',null,null,'G');
uis.action('/vhr/htt/change_view+view','audit_details','A','/vhr/htt/change_audit_details','S','O');
uis.action('/vhr/htt/change_view+view','cancel','A',null,null,'A');
uis.action('/vhr/htt/change_view+view','complete','A',null,null,'A');
uis.action('/vhr/htt/change_view+view','deny','A',null,null,'A');
uis.action('/vhr/htt/change_view+view','edit','F','/vhr/htt/change+edit','S','O');
uis.action('/vhr/htt/change_view+view','reset','A',null,null,'A');
uis.action('/vhr/htt/change_view+view_personal','audit','F',null,null,'G');
uis.action('/vhr/htt/change_view+view_personal','audit_details','F','/vhr/htt/change_audit_details','S','O');
uis.action('/vhr/htt/change_view+view_personal','edit','F','/vhr/htt/change+edit_personal','S','O');


uis.ready('/vhr/htt/change_view+view','.approve.audit.audit_details.cancel.complete.deny.edit.model.reset.');
uis.ready('/vhr/htt/change_view+view_personal','.audit.audit_details.edit.model.');

commit;
end;
/
