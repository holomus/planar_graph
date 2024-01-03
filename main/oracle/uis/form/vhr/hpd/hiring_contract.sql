set define off
prompt PATH /vhr/hpd/hiring_contract
begin
uis.route('/vhr/hpd/hiring_contract+add:employees','Ui_Vhr637.Query_Employees','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:employment_sources','Ui_Vhr637.Query_Employment_Sources',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:ftes','Ui_Vhr637.Query_Ftes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:get_indicators','Ui_Vhr637.Get_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:get_robot','Ui_Vhr637.Get_Robot','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:get_template','Ui_Vhr637.Get_Template','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:get_wage_scale','Ui_Vhr637.Get_Wage_Scale','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:jobs','Ui_Vhr637.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:load_rank_wage_scale_ids','Ui_Vhr637.Load_Rank_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:model','Ui_Vhr637.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:oper_types','Ui_Vhr637.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:ranks','Ui_Vhr637.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:robots','Ui_Vhr637.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:save','Ui_Vhr637.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:schedules','Ui_Vhr637.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:services','Ui_Vhr637.Query_Service_Names',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+add:wage_scales','Ui_Vhr637.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:employees','Ui_Vhr637.Query_Employees','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:employment_sources','Ui_Vhr637.Query_Employment_Sources',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:ftes','Ui_Vhr637.Query_Ftes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:get_indicators','Ui_Vhr637.Get_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:get_robot','Ui_Vhr637.Get_Robot','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:get_template','Ui_Vhr637.Get_Template','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:get_wage_scale','Ui_Vhr637.Get_Wage_Scale','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:jobs','Ui_Vhr637.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:load_rank_wage_scale_ids','Ui_Vhr637.Load_Rank_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:load_wage_sale_indicator_ids','Ui_Vhr637.Load_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:model','Ui_Vhr637.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:oper_types','Ui_Vhr637.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:ranks','Ui_Vhr637.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:robots','Ui_Vhr637.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:save','Ui_Vhr637.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:schedules','Ui_Vhr637.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:services','Ui_Vhr637.Query_Service_Names',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/hiring_contract+edit:wage_scales','Ui_Vhr637.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/hiring_contract','vhr637');
uis.form('/vhr/hpd/hiring_contract+add','/vhr/hpd/hiring_contract','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpd/hiring_contract+edit','/vhr/hpd/hiring_contract','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/hiring_contract+add','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/hiring_contract+add','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/hiring_contract+add','add_employee','F','/vhr/href/employee/employee_add','D','O');
uis.action('/vhr/hpd/hiring_contract+add','add_employment_source','F','/vhr/href/employment_source+add','D','O');
uis.action('/vhr/hpd/hiring_contract+add','add_fte','F','/vhr/href/fte+add','D','O');
uis.action('/vhr/hpd/hiring_contract+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hpd/hiring_contract+add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/hiring_contract+add','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hpd/hiring_contract+add','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_employee','F','/vhr/href/employee/employee_list','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_employment_source','F','/vhr/href/employment_source_list','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_fte','F','/vhr/href/fte_list','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hpd/hiring_contract+add','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_employee','F','/vhr/href/employee/employee_add','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_employment_source','F','/vhr/href/employment_source+add','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_fte','F','/vhr/href/fte+add','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_employee','F','/vhr/href/employee/employee_list','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_employment_source','F','/vhr/href/employment_source_list','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_fte','F','/vhr/href/fte_list','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hpd/hiring_contract+edit','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');


uis.ready('/vhr/hpd/hiring_contract+add','.add_accrual.add_deduction.add_employee.add_employment_source.add_fte.add_job.add_rank.add_schedule.add_wage_scale.model.select_accrual.select_deduction.select_employee.select_employment_source.select_fte.select_job.select_rank.select_robot.select_schedule.select_wage_scale.');
uis.ready('/vhr/hpd/hiring_contract+edit','.add_accrual.add_deduction.add_employee.add_employment_source.add_fte.add_job.add_rank.add_schedule.add_wage_scale.model.select_accrual.select_deduction.select_employee.select_employment_source.select_fte.select_job.select_rank.select_robot.select_schedule.select_wage_scale.');

commit;
end;
/
