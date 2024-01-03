set define off
prompt PATH /vhr/rep/htt/timesheet_with_transfer
begin
uis.route('/vhr/rep/htt/timesheet_with_transfer:check_filters','Ui_Vhr468.Check_Template_Filters','M','M','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet_with_transfer:division_groups','Ui_Vhr468.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet_with_transfer:jobs','Ui_Vhr468.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet_with_transfer:locations','Ui_Vhr468.Query_Locations',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet_with_transfer:model','Ui_Vhr468.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/htt/timesheet_with_transfer:run','Ui_Vhr468.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet_with_transfer:save_preferences','Ui_Vhr468.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet_with_transfer:staffs','Ui_Vhr468.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/rep/htt/timesheet_with_transfer','vhr468');
uis.form('/vhr/rep/htt/timesheet_with_transfer','/vhr/rep/htt/timesheet_with_transfer','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/htt/timesheet_with_transfer','select_division_group','F','/anor/mhr/division_group_list','D','O');
uis.action('/vhr/rep/htt/timesheet_with_transfer','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/rep/htt/timesheet_with_transfer','.model.select_division_group.select_staff.');

commit;
end;
/
