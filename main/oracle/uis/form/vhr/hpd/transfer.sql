set define off
prompt PATH /vhr/hpd/transfer
begin
uis.route('/vhr/hpd/transfer+add:divisions','Ui_Vhr51.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:fixed_term_bases','Ui_Vhr51.Query_Fixed_Term_Bases',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:ftes','Ui_Vhr51.Query_Ftes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:get_closest_info','Ui_Vhr51.Get_Closest_Info','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:get_indicators','Ui_Vhr51.Get_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:get_robot','Ui_Vhr51.Get_Robot','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:get_template','Ui_Vhr51.Get_Template','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:get_wage_scale','Ui_Vhr51.Get_Wage_Scale','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:jobs','Ui_Vhr51.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:load_rank_wage_scale_ids','Ui_Vhr51.Load_Rank_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:model','Ui_Vhr51.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/transfer+add:oper_types','Ui_Vhr51.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:process_cos_response','Ui_Vhr51.Process_Cos_Response','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:ranks','Ui_Vhr51.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:robots','Ui_Vhr51.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:save','Ui_Vhr51.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:schedules','Ui_Vhr51.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:staffs','Ui_Vhr51.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+add:wage_scales','Ui_Vhr51.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:divisions','Ui_Vhr51.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:fixed_term_bases','Ui_Vhr51.Query_Fixed_Term_Bases',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:ftes','Ui_Vhr51.Query_Ftes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:get_closest_info','Ui_Vhr51.Get_Closest_Info','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:get_indicators','Ui_Vhr51.Get_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:get_robot','Ui_Vhr51.Get_Robot','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:get_template','Ui_Vhr51.Get_Template','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:get_wage_scale','Ui_Vhr51.Get_Wage_Scale','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:jobs','Ui_Vhr51.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:load_rank_wage_scale_ids','Ui_Vhr51.Load_Rank_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:load_wage_sale_indicator_ids','Ui_Vhr51.Load_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:model','Ui_Vhr51.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:oper_types','Ui_Vhr51.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:process_cos_response','Ui_Vhr51.Process_Cos_Response','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:ranks','Ui_Vhr51.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:robots','Ui_Vhr51.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:save','Ui_Vhr51.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:schedules','Ui_Vhr51.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:staffs','Ui_Vhr51.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+edit:wage_scales','Ui_Vhr51.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:divisions','Ui_Vhr51.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:fixed_term_bases','Ui_Vhr51.Query_Fixed_Term_Bases',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:ftes','Ui_Vhr51.Query_Ftes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:get_closest_info','Ui_Vhr51.Get_Closest_Info','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:get_indicators','Ui_Vhr51.Get_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:get_robot','Ui_Vhr51.Get_Robot','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:get_template','Ui_Vhr51.Get_Template','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:get_wage_scale','Ui_Vhr51.Get_Wage_Scale','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:jobs','Ui_Vhr51.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:load_rank_wage_scale_ids','Ui_Vhr51.Load_Rank_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:model','Ui_Vhr51.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:oper_types','Ui_Vhr51.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:process_cos_response','Ui_Vhr51.Process_Cos_Response','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:ranks','Ui_Vhr51.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:robots','Ui_Vhr51.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:save','Ui_Vhr51.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:schedules','Ui_Vhr51.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:staffs','Ui_Vhr51.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_add:wage_scales','Ui_Vhr51.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:divisions','Ui_Vhr51.Query_Divisions',null,null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:fixed_term_bases','Ui_Vhr51.Query_Fixed_Term_Bases',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:ftes','Ui_Vhr51.Query_Ftes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:get_closest_info','Ui_Vhr51.Get_Closest_Info','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:get_indicators','Ui_Vhr51.Get_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:get_robot','Ui_Vhr51.Get_Robot','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:get_template','Ui_Vhr51.Get_Template','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:get_wage_scale','Ui_Vhr51.Get_Wage_Scale','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:jobs','Ui_Vhr51.Query_Jobs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:load_rank_wage_scale_ids','Ui_Vhr51.Load_Rank_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,'S');
uis.route('/vhr/hpd/transfer+multiple_edit:load_wage_sale_indicator_ids','Ui_Vhr51.Load_Wage_Scale_Indicator_Ids','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:model','Ui_Vhr51.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:oper_types','Ui_Vhr51.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:process_cos_response','Ui_Vhr51.Process_Cos_Response','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:ranks','Ui_Vhr51.Query_Ranks',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:robots','Ui_Vhr51.Query_Robots','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:save','Ui_Vhr51.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:schedules','Ui_Vhr51.Query_Schedules',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:staffs','Ui_Vhr51.Query_Staffs',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpd/transfer+multiple_edit:wage_scales','Ui_Vhr51.Query_Wage_Scales',null,'Q','A',null,null,null,null,null);

uis.path('/vhr/hpd/transfer','vhr51');
uis.form('/vhr/hpd/transfer+add','/vhr/hpd/transfer','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpd/transfer+edit','/vhr/hpd/transfer','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpd/transfer+multiple_add','/vhr/hpd/transfer','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpd/transfer+multiple_edit','/vhr/hpd/transfer','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpd/transfer+add','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/transfer+add','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/transfer+add','add_fixed_term_base','F','/vhr/href/fixed_term_base+add','D','O');
uis.action('/vhr/hpd/transfer+add','add_fte','F','/vhr/href/fte+add','D','O');
uis.action('/vhr/hpd/transfer+add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/transfer+add','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hpd/transfer+add','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hpd/transfer+add','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/transfer+add','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/transfer+add','select_fixed_term_base','F','/vhr/href/fixed_term_base_list','D','O');
uis.action('/vhr/hpd/transfer+add','select_fte','F','/vhr/href/fte_list','D','O');
uis.action('/vhr/hpd/transfer+add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/transfer+add','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/transfer+add','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hpd/transfer+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/transfer+add','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');
uis.action('/vhr/hpd/transfer+edit','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/transfer+edit','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/transfer+edit','add_fixed_term_base','F','/vhr/href/fixed_term_base+add','D','O');
uis.action('/vhr/hpd/transfer+edit','add_fte','F','/vhr/href/fte+add','D','O');
uis.action('/vhr/hpd/transfer+edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/transfer+edit','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hpd/transfer+edit','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hpd/transfer+edit','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/transfer+edit','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/transfer+edit','select_fixed_term_base','F','/vhr/href/fixed_term_base_list','D','O');
uis.action('/vhr/hpd/transfer+edit','select_fte','F','/vhr/href/fte_list','D','O');
uis.action('/vhr/hpd/transfer+edit','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/transfer+edit','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/transfer+edit','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hpd/transfer+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/transfer+edit','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','add_fixed_term_base','F','/vhr/href/fixed_term_base+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','add_fte','F','/vhr/href/fte+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_fixed_term_base','F','/vhr/href/fixed_term_base_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_fte','F','/vhr/href/fte_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_add','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','add_fixed_term_base','F','/vhr/href/fixed_term_base+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','add_fte','F','/vhr/href/fte+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','add_oper_type','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','add_rank','F','/anor/mhr/rank+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','add_schedule','F','/vhr/htt/schedule+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','add_wage_scale','F','/vhr/hrm/wage_scale+add','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','S','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','S','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_fixed_term_base','F','/vhr/href/fixed_term_base_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_fte','F','/vhr/href/fte_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_rank','F','/anor/mhr/rank_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_robot','F','/vhr/hrm/robot_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_schedule','F','/vhr/htt/schedule_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/transfer+multiple_edit','select_wage_scale','F','/vhr/hrm/wage_scale_list','D','O');


uis.ready('/vhr/hpd/transfer+add','.add_accrual.add_deduction.add_fixed_term_base.add_fte.add_rank.add_schedule.add_wage_scale.model.select_accrual.select_deduction.select_fixed_term_base.select_fte.select_rank.select_robot.select_schedule.select_staff.select_wage_scale.');
uis.ready('/vhr/hpd/transfer+edit','.add_accrual.add_deduction.add_fixed_term_base.add_fte.add_rank.add_schedule.add_wage_scale.model.select_accrual.select_deduction.select_fixed_term_base.select_fte.select_rank.select_robot.select_schedule.select_staff.select_wage_scale.');
uis.ready('/vhr/hpd/transfer+multiple_add','.add_accrual.add_deduction.add_fixed_term_base.add_fte.add_rank.add_schedule.add_wage_scale.model.select_accrual.select_deduction.select_fixed_term_base.select_fte.select_rank.select_robot.select_schedule.select_staff.select_wage_scale.');
uis.ready('/vhr/hpd/transfer+multiple_edit','.add_fixed_term_base.add_fte.add_oper_type.add_rank.add_schedule.add_wage_scale.model.select_accrual.select_deduction.select_fixed_term_base.select_fte.select_rank.select_robot.select_schedule.select_staff.select_wage_scale.');

commit;
end;
/
