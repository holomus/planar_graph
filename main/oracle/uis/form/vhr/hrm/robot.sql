set define off
prompt PATH /vhr/hrm/robot
begin
uis.route('/vhr/hrm/robot+add:allowed_divisions','Ui_Vhr257.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:divisions','Ui_Vhr257.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:get_indicators','Ui_Vhr257.Get_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:get_job_roles','Ui_Vhr257.Get_Job_Roles','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:get_org_units','Ui_Vhr257.Get_Org_Units','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:get_template','Ui_Vhr257.Get_Template','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:get_wage_scale_indicator_ids','Ui_Vhr257.Get_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:job_groups','Ui_Vhr257.Query_Job_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:jobs','Ui_Vhr257.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:labor_functions','Ui_Vhr257.Query_Labor_Functions',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:model','Ui_Vhr257.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/robot+add:oper_types','Ui_Vhr257.Query_Oper_Types',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:ranks','Ui_Vhr257.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:robot_groups','Ui_Vhr257.Query_Robot_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:roles','Ui_Vhr257.Query_Roles',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:save','Ui_Vhr257.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:schedules','Ui_Vhr257.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+add:wage_scales','Ui_Vhr257.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:allowed_divisions','Ui_Vhr257.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:divisions','Ui_Vhr257.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:get_indicators','Ui_Vhr257.Get_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:get_job_roles','Ui_Vhr257.Get_Job_Roles','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:get_org_units','Ui_Vhr257.Get_Org_Units','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:get_template','Ui_Vhr257.Get_Template','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:get_wage_scale_indicator_ids','Ui_Vhr257.Get_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:job_groups','Ui_Vhr257.Query_Job_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:jobs','Ui_Vhr257.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:labor_functions','Ui_Vhr257.Query_Labor_Functions',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:model','Ui_Vhr257.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hrm/robot+edit:oper_types','Ui_Vhr257.Query_Oper_Types',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:ranks','Ui_Vhr257.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:robot_groups','Ui_Vhr257.Query_Robot_Groups',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:roles','Ui_Vhr257.Query_Roles',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:save','Ui_Vhr257.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:schedules','Ui_Vhr257.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hrm/robot+edit:wage_scales','Ui_Vhr257.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hrm/robot','vhr257');
uis.form('/vhr/hrm/robot+add','/vhr/hrm/robot','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hrm/robot+edit','/vhr/hrm/robot','F','A','F','H','M','N',null,null,null);

uis.override_form('/anor/mrf/robot+add','vhr','/vhr/hrm/robot+add');
uis.override_form('/anor/mrf/robot+edit','vhr','/vhr/hrm/robot+edit');


uis.action('/vhr/hrm/robot+add','add_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hrm/robot+add','add_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hrm/robot+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hrm/robot+add','add_labor_function','F','/vhr/href/labor_function+add','D','O');
uis.action('/vhr/hrm/robot+add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hrm/robot+add','add_robot_group','F','/anor/mr/robot_group+add','D','O');
uis.action('/vhr/hrm/robot+add','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hrm/robot+add','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hrm/robot+add','restrict_hidden_salary','F',null,null,'G');
uis.action('/vhr/hrm/robot+add','select_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hrm/robot+add','select_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hrm/robot+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hrm/robot+add','select_job_group','F','/anor/mhr/job_group_list','S','O');
uis.action('/vhr/hrm/robot+add','select_labor_function','F','/vhr/href/labor_function_list','D','O');
uis.action('/vhr/hrm/robot+add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hrm/robot+add','select_robot_group','F','/anor/mr/robot_group_list','D','O');
uis.action('/vhr/hrm/robot+add','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hrm/robot+add','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');
uis.action('/vhr/hrm/robot+edit','add_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hrm/robot+edit','add_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hrm/robot+edit','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hrm/robot+edit','add_labor_function','F','/vhr/href/labor_function+add','D','O');
uis.action('/vhr/hrm/robot+edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hrm/robot+edit','add_robot_group','F','/anor/mr/robot_group+add','D','O');
uis.action('/vhr/hrm/robot+edit','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hrm/robot+edit','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hrm/robot+edit','restrict_hidden_salary','F',null,null,'G');
uis.action('/vhr/hrm/robot+edit','select_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hrm/robot+edit','select_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hrm/robot+edit','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hrm/robot+edit','select_job_group','F','/anor/mhr/job_group_list','S','O');
uis.action('/vhr/hrm/robot+edit','select_labor_function','F','/vhr/href/labor_function_list','D','O');
uis.action('/vhr/hrm/robot+edit','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hrm/robot+edit','select_robot_group','F','/anor/mr/robot_group_list','D','O');
uis.action('/vhr/hrm/robot+edit','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hrm/robot+edit','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');


uis.ready('/vhr/hrm/robot+add','.add_accrual_oper_type.add_deduction_oper_type.add_job.add_labor_function.add_rank.add_robot_group.add_schedule.add_wage_scale.model.restrict_hidden_salary.select_accrual_oper_type.select_deduction_oper_type.select_job.select_job_group.select_labor_function.select_rank.select_robot_group.select_schedule.select_wage_scale.');
uis.ready('/vhr/hrm/robot+edit','.add_accrual_oper_type.add_deduction_oper_type.add_job.add_labor_function.add_rank.add_robot_group.add_schedule.add_wage_scale.model.restrict_hidden_salary.select_accrual_oper_type.select_deduction_oper_type.select_job.select_job_group.select_labor_function.select_rank.select_robot_group.select_schedule.select_wage_scale.');

commit;
end;
/
