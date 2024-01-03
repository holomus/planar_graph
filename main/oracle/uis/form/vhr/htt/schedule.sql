set define off
prompt PATH /vhr/htt/schedule
begin
uis.route('/vhr/htt/schedule+add:calendars','Ui_Vhr31.Query_Calendars',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule+add:check_by_calendar_limit','Ui_Vhr31.Check_By_Calendar_Limit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule+add:get_calendar_days','Ui_Vhr31.Get_Calendar_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule+add:model','Ui_Vhr31.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/schedule+add:save','Ui_Vhr31.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule+edit:calendars','Ui_Vhr31.Query_Calendars',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule+edit:check_by_calendar_limit','Ui_Vhr31.Check_By_Calendar_Limit','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule+edit:get_calendar_days','Ui_Vhr31.Get_Calendar_Days','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule+edit:get_schedule_year','Ui_Vhr31.Get_Schedule_Year','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/schedule+edit:model','Ui_Vhr31.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/schedule+edit:save','Ui_Vhr31.Edit','M','M','A',null,null,null,null,null);

uis.path('/vhr/htt/schedule','vhr31');
uis.form('/vhr/htt/schedule+add','/vhr/htt/schedule','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/htt/schedule+edit','/vhr/htt/schedule','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htt/schedule+add','add_calendar','F','/vhr/htt/calendar+add','D','O');
uis.action('/vhr/htt/schedule+add','select_calendar','F','/vhr/htt/calendar_list','D','O');
uis.action('/vhr/htt/schedule+edit','add_calendar','F','/vhr/htt/calendar+add','D','O');
uis.action('/vhr/htt/schedule+edit','select_calendar','F','/vhr/htt/calendar_list','D','O');


uis.ready('/vhr/htt/schedule+add','.add_calendar.model.select_calendar.');
uis.ready('/vhr/htt/schedule+edit','.add_calendar.model.select_calendar.');

commit;
end;
/
