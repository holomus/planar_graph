set define off
prompt PATH /vhr/rep/htt/timesheet
begin
uis.route('/vhr/rep/htt/timesheet:check_filters','Ui_Vhr101.Check_Template_Filters','M','M','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:division_groups','Ui_Vhr101.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:filials','Ui_Vhr101.Query_Filials',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:jobs','Ui_Vhr101.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:locations','Ui_Vhr101.Query_Locations',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:model','Ui_Vhr101.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/htt/timesheet:query_telegram_staffs','Ui_Vhr101.Query_Telegram_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:run','Ui_Vhr101.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:run_telegram','Ui_Vhr101.Run_Telegram','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:save_preferences','Ui_Vhr101.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:staffs','Ui_Vhr101.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:telegram_model','Ui_Vhr101.Telegram_Model',null,'M','A',null,null,null,null);
uis.route('/vhr/rep/htt/timesheet:time_kinds','Ui_Vhr101.Query_Time_Kinds',null,'Q','A',null,null,null,null);

uis.path('/vhr/rep/htt/timesheet','vhr101');
uis.form('/vhr/rep/htt/timesheet','/vhr/rep/htt/timesheet','A','A','R','HT','M','N',null,'N');



uis.action('/vhr/rep/htt/timesheet','select_division_group','A','/anor/mhr/division_group_list','D','O');
uis.action('/vhr/rep/htt/timesheet','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/rep/htt/timesheet','.model.select_division_group.select_staff.');

commit;
end;
/
