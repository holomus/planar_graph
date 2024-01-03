set define off
prompt PATH /vhr/hpr/charge_document
begin
uis.route('/vhr/hpr/charge_document+add:currencies','Ui_Vhr612.Query_Currencies',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+add:get_employee_wage','Ui_Vhr612.Get_Employee_Wage','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+add:load_blocked_staffs','Ui_Vhr612.Load_Blocked_Staffs','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+add:load_staffs','Ui_Vhr612.Load_Staffs','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+add:model','Ui_Vhr612.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpr/charge_document+add:oper_type','Ui_Vhr612.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+add:save','Ui_Vhr612.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+add:staffs','Ui_Vhr612.Query_Staffs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+edit$load_staffs','Ui_Vhr612.Load_Staffs','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+edit:currencies','Ui_Vhr612.Query_Currencies',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+edit:load_blocked_staffs','Ui_Vhr612.Load_Blocked_Staffs','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+edit:model','Ui_Vhr612.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpr/charge_document+edit:oper_type','Ui_Vhr612.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+edit:save','Ui_Vhr612.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/charge_document+edit:staffs','Ui_Vhr612.Query_Staffs','M','Q','A',null,null,null,null,null);

uis.path('/vhr/hpr/charge_document','vhr612');
uis.form('/vhr/hpr/charge_document','/vhr/hpr/charge_document','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpr/charge_document+add','/vhr/hpr/charge_document','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hpr/charge_document+edit','/vhr/hpr/charge_document','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hpr/charge_document+add','add_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpr/charge_document+add','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/charge_document+add','add_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpr/charge_document+add','select_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpr/charge_document+add','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/charge_document+add','select_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpr/charge_document+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpr/charge_document+edit','add_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpr/charge_document+edit','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/charge_document+edit','add_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpr/charge_document+edit','select_accrual_oper_type','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpr/charge_document+edit','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/charge_document+edit','select_deduction_oper_type','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpr/charge_document+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpr/charge_document+add','.add_accrual_oper_type.add_currency.add_deduction_oper_type.model.select_accrual_oper_type.select_currency.select_deduction_oper_type.select_staff.');
uis.ready('/vhr/hpr/charge_document+edit','.add_accrual_oper_type.add_currency.add_deduction_oper_type.model.select_accrual_oper_type.select_currency.select_deduction_oper_type.select_staff.');
uis.ready('/vhr/hpr/charge_document','.model.');

commit;
end;
/
