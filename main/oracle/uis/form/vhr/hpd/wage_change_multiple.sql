set define off
prompt PATH /vhr/hpd/wage_change_multiple
begin
uis.route('/vhr/hpd/wage_change_multiple+add:get_indicators','Ui_Vhr439.Get_Indicators','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+add:get_staff_info','Ui_Vhr439.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+add:model','Ui_Vhr439.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+add:oper_types','Ui_Vhr439.Query_Oper_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+add:save','Ui_Vhr439.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+add:staffs','Ui_Vhr439.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+edit:get_indicators','Ui_Vhr439.Get_Indicators','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+edit:get_staff_info','Ui_Vhr439.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+edit:model','Ui_Vhr439.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+edit:oper_types','Ui_Vhr439.Query_Oper_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+edit:save','Ui_Vhr439.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change_multiple+edit:staffs','Ui_Vhr439.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/wage_change_multiple','vhr439');
uis.form('/vhr/hpd/wage_change_multiple+add','/vhr/hpd/wage_change_multiple','F','A','F','H','M','N',null,'N');
uis.form('/vhr/hpd/wage_change_multiple+edit','/vhr/hpd/wage_change_multiple','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hpd/wage_change_multiple+add','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/wage_change_multiple+add','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/wage_change_multiple+add','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/wage_change_multiple+add','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/wage_change_multiple+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/wage_change_multiple+edit','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/wage_change_multiple+edit','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/wage_change_multiple+edit','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/wage_change_multiple+edit','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/wage_change_multiple+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/wage_change_multiple+add','.add_accrual.add_deduction.model.select_accrual.select_deduction.select_staff.');
uis.ready('/vhr/hpd/wage_change_multiple+edit','.add_accrual.add_deduction.model.select_accrual.select_deduction.select_staff.');

commit;
end;
/
