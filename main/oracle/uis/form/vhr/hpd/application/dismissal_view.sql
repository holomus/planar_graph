set define off
prompt PATH /vhr/hpd/application/dismissal_view
begin
uis.route('/vhr/hpd/application/dismissal_view:approved_to_in_progress','Ui_Vhr545.Change_Status_To_In_Progress','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:approved_to_waiting','Ui_Vhr545.Change_Status_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:bind_journal','Ui_Vhr545.Application_Bind_Journal','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:canceled_to_waiting','Ui_Vhr545.Change_Status_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:completed_to_in_progress','Ui_Vhr545.Change_Status_To_In_Progress','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:in_progress_to_approved','Ui_Vhr545.Change_Status_From_In_Progress_To_Approved','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:in_progress_to_completed','Ui_Vhr545.Change_Status_To_Completed','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:model','Ui_Vhr545.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:new_to_waiting','Ui_Vhr545.Change_Status_From_New_To_Waiting','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:waiting_to_approved','Ui_Vhr545.Change_Status_From_Waiting_To_Approved','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:waiting_to_canceled','Ui_Vhr545.Change_Status_To_Canceled','M',null,'A',null,null,null,null);
uis.route('/vhr/hpd/application/dismissal_view:waiting_to_new','Ui_Vhr545.Change_Status_To_New','M',null,'A',null,null,null,null);

uis.path('/vhr/hpd/application/dismissal_view','vhr545');
uis.form('/vhr/hpd/application/dismissal_view','/vhr/hpd/application/dismissal_view','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/application/dismissal_view','add_journal','F','/vhr/hpd/dismissal+add','D','O');
uis.action('/vhr/hpd/application/dismissal_view','edit','F','/vhr/hpd/application/dismissal+edit','S','O');
uis.action('/vhr/hpd/application/dismissal_view','view_employee','F','/vhr/href/employee/employee_edit','S','O');
uis.action('/vhr/hpd/application/dismissal_view','view_journal','F','/vhr/hpd/view/dismissal_view','S','O');


uis.ready('/vhr/hpd/application/dismissal_view','.add_journal.edit.model.view_employee.view_journal.');

commit;
end;
/
