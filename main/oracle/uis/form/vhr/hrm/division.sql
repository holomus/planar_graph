set define off
prompt PATH /vhr/hrm/division
begin
uis.route('/vhr/hrm/division+add:code_is_unique','Ui_Vhr275.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrm/division+add:division_groups','Ui_Vhr275.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/division+add:model','Ui_Vhr275.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrm/division+add:name_is_unique','Ui_Vhr275.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrm/division+add:save','Ui_Vhr275.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hrm/division+add:schedules','Ui_Vhr275.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/division+add:subfilials','Ui_Vhr275.Query_Subfilials',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/division+edit:code_is_unique','Ui_Vhr275.Code_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrm/division+edit:division_groups','Ui_Vhr275.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/division+edit:managers','Ui_Vhr275.Query_Managers',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/division+edit:model','Ui_Vhr275.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrm/division+edit:name_is_unique','Ui_Vhr275.Name_Is_Unique','M','V','A',null,null,null,null);
uis.route('/vhr/hrm/division+edit:save','Ui_Vhr275.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hrm/division+edit:schedules','Ui_Vhr275.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/division+edit:staffs','Ui_Vhr275.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/division+edit:subfilials','Ui_Vhr275.Query_Subfilials',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrm/division','vhr275');
uis.form('/vhr/hrm/division+add','/vhr/hrm/division','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hrm/division+edit','/vhr/hrm/division','F','A','F','H','M','N',null,'N');

uis.override_form('/anor/mhr/division+add','vhr','/vhr/hrm/division+add');
uis.override_form('/anor/mhr/division+edit','vhr','/vhr/hrm/division+edit');


uis.action('/vhr/hrm/division+add','add_division_group','F','/anor/mhr/division_group+add','D','O');
uis.action('/vhr/hrm/division+add','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hrm/division+add','select_division_group','F','/anor/mhr/division_group_list','D','O');
uis.action('/vhr/hrm/division+add','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hrm/division+edit','add_division_group','F','/anor/mhr/division_group+add','D','O');
uis.action('/vhr/hrm/division+edit','add_manager','F','/vhr/hrm/robot+add','D','O');
uis.action('/vhr/hrm/division+edit','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hrm/division+edit','select_division_group','F','/anor/mhr/division_group_list','D','O');
uis.action('/vhr/hrm/division+edit','select_manager','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hrm/division+edit','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hrm/division+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hrm/division+add','.add_division_group.add_schedule.model.select_division_group.select_schedule.');
uis.ready('/vhr/hrm/division+edit','.add_division_group.add_manager.add_schedule.model.select_division_group.select_manager.select_schedule.select_staff.');

commit;
end;
/
