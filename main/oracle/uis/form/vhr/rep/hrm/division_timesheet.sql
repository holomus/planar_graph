set define off
prompt PATH /vhr/rep/hrm/division_timesheet
begin
uis.route('/vhr/rep/hrm/division_timesheet:division_groups','Ui_Vhr459.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hrm/division_timesheet:model','Ui_Vhr459.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hrm/division_timesheet:run','Ui_Vhr459.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/hrm/division_timesheet:save_preferences','Ui_Vhr459.Save_Preferences','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hrm/division_timesheet','vhr459');
uis.form('/vhr/rep/hrm/division_timesheet','/vhr/rep/hrm/division_timesheet','F','A','R','H','M','N',null,'N');



uis.action('/vhr/rep/hrm/division_timesheet','select_division_group','F','/anor/mhr/division_group_list','D','O');


uis.ready('/vhr/rep/hrm/division_timesheet','.model.select_division_group.');

commit;
end;
/
