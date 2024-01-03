set define off
prompt PATH /vhr/hrm/robot_migr
begin
uis.route('/vhr/hrm/robot_migr:get_hidden_salary_job','Ui_Vhr258.Get_Hidden_Salary_Job','M','V','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:get_indicators','Ui_Vhr258.Get_Indicators','M','L','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:get_org_units','Ui_Vhr258.Get_Org_Units','M','M','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:jobs','Ui_Vhr258.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:labor_functions','Ui_Vhr258.Query_Labor_Functions',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:model','Ui_Vhr258.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrm/robot_migr:oper_types','Ui_Vhr258.Query_Oper_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:ranks','Ui_Vhr258.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:robot_groups','Ui_Vhr258.Query_Robot_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:save','Ui_Vhr258.Save','M',null,'A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:schedules','Ui_Vhr258.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/robot_migr:wage_scales','Ui_Vhr258.Query_Wage_Scales',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrm/robot_migr','vhr258');
uis.form('/vhr/hrm/robot_migr','/vhr/hrm/robot_migr','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrm/robot_migr','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hrm/robot_migr','add_labor_function','F','/vhr/href/labor_function+add','D','O');
uis.action('/vhr/hrm/robot_migr','add_oper_type','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hrm/robot_migr','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hrm/robot_migr','add_robot_group','F','/anor/mr/robot_group+add','D','O');
uis.action('/vhr/hrm/robot_migr','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hrm/robot_migr','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hrm/robot_migr','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hrm/robot_migr','select_labor_function','F','/vhr/href/labor_function_list','D','O');
uis.action('/vhr/hrm/robot_migr','select_oper_type','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hrm/robot_migr','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hrm/robot_migr','select_robot_group','F','/anor/mr/robot_group_list','D','O');
uis.action('/vhr/hrm/robot_migr','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hrm/robot_migr','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');


uis.ready('/vhr/hrm/robot_migr','.add_job.add_labor_function.add_oper_type.add_rank.add_robot_group.add_schedule.add_wage_scale.model.select_job.select_labor_function.select_oper_type.select_rank.select_robot_group.select_schedule.select_wage_scale.');

commit;
end;
/
