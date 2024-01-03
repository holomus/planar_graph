set define off
prompt PATH /vhr/gen/journals
begin
uis.route('/vhr/gen/journals:dismissal_reasons','Ui_Vhr233.Query_Dismissal_Reasons',null,'Q','A',null,null,null,null);
uis.route('/vhr/gen/journals:divisions','Ui_Vhr233.Query_Divisions',null,'Q','A',null,null,null,null);
uis.route('/vhr/gen/journals:employees','Ui_Vhr233.Query_Employees','M','Q','A',null,null,null,null);
uis.route('/vhr/gen/journals:employment_sources','Ui_Vhr233.Query_Employment_Sources',null,'Q','A',null,null,null,null);
uis.route('/vhr/gen/journals:generate','Ui_Vhr233.Generate','M',null,'A',null,null,null,null);
uis.route('/vhr/gen/journals:get_indicators','Ui_Vhr233.Get_Indicators','M','L','A',null,null,null,null);
uis.route('/vhr/gen/journals:jobs','Ui_Vhr233.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/gen/journals:model','Ui_Vhr233.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/gen/journals:oper_types','Ui_Vhr233.Query_Oper_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/gen/journals:robots','Ui_Vhr233.Query_Robots','M','Q','A',null,null,null,null);
uis.route('/vhr/gen/journals:schedules','Ui_Vhr233.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/gen/journals:staffs','Ui_Vhr233.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/gen/journals','vhr233');
uis.form('/vhr/gen/journals','/vhr/gen/journals','F','A','F','H','M','Y',null,'N');



uis.action('/vhr/gen/journals','add_oper_type','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/gen/journals','select_dismissal_reasons','F','/vhr/href/dismissal_reason_list','D','O');
uis.action('/vhr/gen/journals','select_divisions','F','/vhr/hrm/division_list','D','O');
uis.action('/vhr/gen/journals','select_employees','F','/anor/mhr/employee_list','D','O');
uis.action('/vhr/gen/journals','select_employment_sources','F','/vhr/href/employment_source_list','D','O');
uis.action('/vhr/gen/journals','select_jobs','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/gen/journals','select_oper_type','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/gen/journals','select_robots','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/gen/journals','select_schedules','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/gen/journals','select_staffs','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/gen/journals','.add_oper_type.model.select_dismissal_reasons.select_divisions.select_employees.select_employment_sources.select_jobs.select_oper_type.select_robots.select_schedules.select_staffs.');

commit;
end;
/
