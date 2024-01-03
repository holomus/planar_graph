set define off
prompt PATH /vhr/htt/schedule_registry
begin
uis.route('/vhr/htt/schedule_registry+robot_add:calendars','Ui_Vhr446.Query_Calendars',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:check_by_calendar_limit','Ui_Vhr446.Check_By_Calendar_Limit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:get_calendar_days','Ui_Vhr446.Get_Calendar_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:get_staff_name','Ui_Vhr446.Get_Staff_Name','M','V','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:import','Ui_Vhr446.Import','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:load_preferences','Ui_Vhr446.Load_Preferences',null,'M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:load_robots','Ui_Vhr446.Load_Robots','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:model','Ui_Vhr446.Robot_Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:robots','Ui_Vhr446.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:save','Ui_Vhr446.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:save_preferences','Ui_Vhr446.Save_Preferences','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_add:template','Ui_Vhr446.Template','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:calendars','Ui_Vhr446.Query_Calendars',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:check_by_calendar_limit','Ui_Vhr446.Check_By_Calendar_Limit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:get_calendar_days','Ui_Vhr446.Get_Calendar_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:get_staff_name','Ui_Vhr446.Get_Staff_Name','M','V','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:import','Ui_Vhr446.Import','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:load_preferences','Ui_Vhr446.Load_Preferences',null,'M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:load_robots','Ui_Vhr446.Load_Robots','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:model','Ui_Vhr446.Robot_Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:robots','Ui_Vhr446.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:save','Ui_Vhr446.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:save_preferences','Ui_Vhr446.Save_Preferences','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+robot_edit:template','Ui_Vhr446.Template','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:calendars','Ui_Vhr446.Query_Calendars',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:check_by_calendar_limit','Ui_Vhr446.Check_By_Calendar_Limit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:get_calendar_days','Ui_Vhr446.Get_Calendar_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:get_robot_name','Ui_Vhr446.Get_Robot_Name','M','V','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:import','Ui_Vhr446.Import','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:load_preferences','Ui_Vhr446.Load_Preferences',null,'M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:load_staffs','Ui_Vhr446.Load_Staffs','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:model','Ui_Vhr446.Staff_Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:save','Ui_Vhr446.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:save_preferences','Ui_Vhr446.Save_Preferences','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:staffs','Ui_Vhr446.Query_Staffs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_add:template','Ui_Vhr446.Template','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:calendars','Ui_Vhr446.Query_Calendars',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:check_by_calendar_limit','Ui_Vhr446.Check_By_Calendar_Limit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:get_calendar_days','Ui_Vhr446.Get_Calendar_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:get_robot_name','Ui_Vhr446.Get_Robot_Name','M','V','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:import','Ui_Vhr446.Import','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:load_preferences','Ui_Vhr446.Load_Preferences',null,'M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:load_staffs','Ui_Vhr446.Load_Staffs','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:model','Ui_Vhr446.Staff_Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:save','Ui_Vhr446.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:save_preferences','Ui_Vhr446.Save_Preferences','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:staffs','Ui_Vhr446.Query_Staffs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule_registry+staff_edit:template','Ui_Vhr446.Template','M',null,'A',null,null,null,null,null);

uis.path('/vhr/htt/schedule_registry','vhr446');
uis.form('/vhr/htt/schedule_registry+robot_add','/vhr/htt/schedule_registry','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/schedule_registry+robot_edit','/vhr/htt/schedule_registry','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/schedule_registry+staff_add','/vhr/htt/schedule_registry','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/schedule_registry+staff_edit','/vhr/htt/schedule_registry','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htt/schedule_registry+robot_add','add_calendar','F','/vhr/htt/calendar+add','D','O');
uis.action('/vhr/htt/schedule_registry+robot_add','select_calendar','F','/vhr/htt/calendar_list','D','O');
uis.action('/vhr/htt/schedule_registry+robot_add','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/htt/schedule_registry+robot_edit','add_calendar','F','/vhr/htt/calendar+add','D','O');
uis.action('/vhr/htt/schedule_registry+robot_edit','select_calendar','F','/vhr/htt/calendar_list','D','O');
uis.action('/vhr/htt/schedule_registry+robot_edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/htt/schedule_registry+staff_add','add_calendar','F','/vhr/htt/calendar+add','D','O');
uis.action('/vhr/htt/schedule_registry+staff_add','select_calendar','F','/vhr/htt/calendar_list','D','O');
uis.action('/vhr/htt/schedule_registry+staff_add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/htt/schedule_registry+staff_edit','add_calendar','F','/vhr/htt/calendar+add','D','O');
uis.action('/vhr/htt/schedule_registry+staff_edit','select_calendar','F','/vhr/htt/calendar_list','D','O');
uis.action('/vhr/htt/schedule_registry+staff_edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/htt/schedule_registry+robot_add','.add_calendar.model.select_calendar.select_robot.');
uis.ready('/vhr/htt/schedule_registry+robot_edit','.add_calendar.model.select_calendar.select_staff.');
uis.ready('/vhr/htt/schedule_registry+staff_add','.add_calendar.model.select_calendar.select_staff.');
uis.ready('/vhr/htt/schedule_registry+staff_edit','.add_calendar.model.select_calendar.select_staff.');

commit;
end;
/
