set define off
prompt PATH /vhr/hrm/job_template
begin
uis.route('/vhr/hrm/job_template+add:get_hidden_salary_job','Ui_Vhr278.Get_Hidden_Salary_Job','M','V','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+add:get_indicators','Ui_Vhr278.Get_Indicators','M','L','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+add:jobs','Ui_Vhr278.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+add:model','Ui_Vhr278.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hrm/job_template+add:oper_types','Ui_Vhr278.Query_Oper_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+add:ranks','Ui_Vhr278.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+add:save','Ui_Vhr278.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hrm/job_template+add:schedules','Ui_Vhr278.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+add:wage_scales','Ui_Vhr278.Query_Wage_Scales',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+edit:get_hidden_salary_job','Ui_Vhr278.Get_Hidden_Salary_Job','M','V','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+edit:get_indicators','Ui_Vhr278.Get_Indicators','M','L','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+edit:jobs','Ui_Vhr278.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+edit:model','Ui_Vhr278.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hrm/job_template+edit:oper_types','Ui_Vhr278.Query_Oper_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+edit:ranks','Ui_Vhr278.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+edit:save','Ui_Vhr278.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/hrm/job_template+edit:schedules','Ui_Vhr278.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/hrm/job_template+edit:wage_scales','Ui_Vhr278.Query_Wage_Scales',null,'Q','A',null,null,null,null);

uis.path('/vhr/hrm/job_template','vhr278');
uis.form('/vhr/hrm/job_template+add','/vhr/hrm/job_template','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hrm/job_template+edit','/vhr/hrm/job_template','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hrm/job_template+add','add_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hrm/job_template+add','add_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hrm/job_template+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hrm/job_template+add','add_oper_type','F','/anor/mpr/oper_type+add_accrual','D','O');
uis.action('/vhr/hrm/job_template+add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hrm/job_template+add','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hrm/job_template+add','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hrm/job_template+add','select_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hrm/job_template+add','select_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hrm/job_template+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hrm/job_template+add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hrm/job_template+add','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hrm/job_template+add','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');
uis.action('/vhr/hrm/job_template+edit','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hrm/job_template+edit','add_oper_type','F','/anor/mpr/oper_type+add_accrual','D','O');
uis.action('/vhr/hrm/job_template+edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hrm/job_template+edit','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hrm/job_template+edit','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hrm/job_template+edit','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hrm/job_template+edit','select_oper_type','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hrm/job_template+edit','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hrm/job_template+edit','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hrm/job_template+edit','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');


uis.ready('/vhr/hrm/job_template+add','.add_accrual_oper_type.add_deduction_oper_type.add_job.add_oper_type.add_rank.add_schedule.add_wage_scale.model.select_accrual_oper_type.select_deduction_oper_type.select_job.select_rank.select_schedule.select_wage_scale.');
uis.ready('/vhr/hrm/job_template+edit','.add_job.add_oper_type.add_rank.add_schedule.add_wage_scale.model.select_job.select_oper_type.select_rank.select_schedule.select_wage_scale.');

commit;
end;
/
