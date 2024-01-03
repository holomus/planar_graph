set define off
prompt PATH /vhr/htt/staff_changes
begin
uis.route('/vhr/htt/staff_changes$approve','Ui_Vhr335.Change_Approve','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes$complete','Ui_Vhr335.Change_Complete','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes$delete','Ui_Vhr335.Change_Delete','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes$deny','Ui_Vhr335.Change_Deny','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes$reset','Ui_Vhr335.Change_Reset','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes:add','Ui_Vhr335.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes:edit','Ui_Vhr335.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes:load_change','Ui_Vhr335.Load_Change','M','L','A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes:load_timesheet','Ui_Vhr335.Load_Timesheet','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes:model','Ui_Vhr335.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/staff_changes:monthly_limits','Ui_Vhr335.Query_Monthly_Limits','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes:personal_changes_checked','Ui_Vhr335.Query_Checked','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/staff_changes:personal_changes_unchecked','Ui_Vhr335.Query_Unchecked','M','Q','A',null,null,null,null,null);

uis.path('/vhr/htt/staff_changes','vhr335');
uis.form('/vhr/htt/staff_changes','/vhr/htt/staff_changes','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htt/staff_changes','approve','F',null,null,'A');
uis.action('/vhr/htt/staff_changes','complete','F',null,null,'A');
uis.action('/vhr/htt/staff_changes','delete','F',null,null,'A');
uis.action('/vhr/htt/staff_changes','deny','F',null,null,'A');
uis.action('/vhr/htt/staff_changes','edit','F','/vhr/htt/change+edit_personal','S','O');
uis.action('/vhr/htt/staff_changes','reset','F',null,null,'A');
uis.action('/vhr/htt/staff_changes','view','F','/vhr/htt/change_view+view','S','O');
uis.action('/vhr/htt/staff_changes','view_personal','F','/vhr/htt/change_view+view_personal','S','O');


uis.ready('/vhr/htt/staff_changes','.approve.complete.delete.deny.edit.model.reset.view.view_personal.');

commit;
end;
/
