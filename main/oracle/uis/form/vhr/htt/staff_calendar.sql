set define off
prompt PATH /vhr/htt/staff_calendar
begin
uis.route('/vhr/htt/staff_calendar$change_type','Ui_Vhr219.Change_Track_Type','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_calendar$delete','Ui_Vhr219.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_calendar$set_invalid','Ui_Vhr219.Set_Invalid','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_calendar$set_valid','Ui_Vhr219.Set_Valid','M',null,'A',null,null,null,null,null);
uis.route('/vhr/htt/staff_calendar:daily_tracks','Ui_Vhr219.Get_Daily_Track','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/staff_calendar:load_timesheets','Ui_Vhr219.Load_Timesheets','M','M','A',null,null,null,null,null);
uis.route('/vhr/htt/staff_calendar:model','Ui_Vhr219.Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/htt/staff_calendar:tracks','Ui_Vhr219.Query_Tracks','M','Q','A',null,null,null,null,null);

uis.path('/vhr/htt/staff_calendar','vhr219');
uis.form('/vhr/htt/staff_calendar','/vhr/htt/staff_calendar','A','A','F','H','M','N',null,'N',null);



uis.action('/vhr/htt/staff_calendar','add','F','/vhr/htt/track+add','S','O');
uis.action('/vhr/htt/staff_calendar','change_type','F',null,null,'A');
uis.action('/vhr/htt/staff_calendar','delete','F',null,null,'A');
uis.action('/vhr/htt/staff_calendar','set_invalid','F',null,null,'A');
uis.action('/vhr/htt/staff_calendar','set_valid','F',null,null,'A');
uis.action('/vhr/htt/staff_calendar','view','F','/vhr/htt/track_view','S','O');


uis.ready('/vhr/htt/staff_calendar','.add.change_type.delete.model.set_invalid.set_valid.view.');

commit;
end;
/
