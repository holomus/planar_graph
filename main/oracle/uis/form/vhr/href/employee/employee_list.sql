set define off
prompt PATH /vhr/href/employee/employee_list
begin
uis.route('/vhr/href/employee/employee_list$block_employee_tracking','Ui_Vhr333.Block_Employee_Tracking','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list$change_employee_activation','Ui_Vhr333.Change_Employee_Activation','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list$change_user_activation','Ui_Vhr333.Change_User_Activation','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list$delete','Ui_Vhr333.Del','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list$edit_org_unit','Ui_Vhr333.Change_Org_Unit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list$schedule_change','Ui_Vhr333.Change_Schedule','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list$unblock_employee_tracking','Ui_Vhr333.Unblock_Employee_Tracking','M',null,'A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list:get_org_units','Ui_Vhr333.Get_Org_Units','M','M','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list:model','Ui_Vhr333.Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/href/employee/employee_list:schedules','Ui_Vhr333.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/href/employee/employee_list:table','Ui_Vhr333.Query','M','Q','A',null,null,null,null,null);

uis.path('/vhr/href/employee/employee_list','vhr333');
uis.form('/vhr/href/employee/employee_list','/vhr/href/employee/employee_list','F','A','F','HM','M','N',null,'N',null);

uis.override_form('/anor/mhr/employee_list','vhr','/vhr/href/employee/employee_list');


uis.action('/vhr/href/employee/employee_list','add','F','/vhr/href/employee/employee_add','S','O');
uis.action('/vhr/href/employee/employee_list','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/href/employee/employee_list','attach','F','/vhr/href/person/person_list+attach_employee','S','O');
uis.action('/vhr/href/employee/employee_list','block_employee_tracking','F',null,null,'A');
uis.action('/vhr/href/employee/employee_list','change_employee_activation','F',null,null,'A');
uis.action('/vhr/href/employee/employee_list','change_user_activation','F',null,null,'A');
uis.action('/vhr/href/employee/employee_list','delete','F',null,null,'A');
uis.action('/vhr/href/employee/employee_list','edit_org_unit','F',null,null,'A');
uis.action('/vhr/href/employee/employee_list','import_pro','F','/vhr/href/employee/employee_import','S','O');
uis.action('/vhr/href/employee/employee_list','import_start','F','/vhr/href/start/employee_import','S','O');
uis.action('/vhr/href/employee/employee_list','schedule_change','F',null,null,'A');
uis.action('/vhr/href/employee/employee_list','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/href/employee/employee_list','unblock_employee_tracking','F',null,null,'A');
uis.action('/vhr/href/employee/employee_list','view','F','/vhr/href/employee/employee_edit','S','O');

uis.form_sibling('vhr','/vhr/href/employee/employee_list','/vhr/rep/href/organizational_structure',1);
uis.form_sibling('vhr','/vhr/href/employee/employee_list','/vhr/href/person/person_list',2);

uis.ready('/vhr/href/employee/employee_list','.add.add_schedule.attach.block_employee_tracking.change_employee_activation.change_user_activation.delete.edit_org_unit.import_pro.import_start.model.schedule_change.select_schedule.unblock_employee_tracking.view.');

commit;
end;
/
