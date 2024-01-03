set define off
prompt PATH /vhr/hpd/wage_change
begin
uis.route('/vhr/hpd/wage_change+add:get_indicators','Ui_Vhr128.Get_Indicators','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+add:get_staff_info','Ui_Vhr128.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+add:model','Ui_Vhr128.Add_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/wage_change+add:oper_types','Ui_Vhr128.Query_Oper_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+add:save','Ui_Vhr128.Add','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+add:staffs','Ui_Vhr128.Query_Staffs',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+edit:get_indicators','Ui_Vhr128.Get_Indicators','M','L','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+edit:get_staff_info','Ui_Vhr128.Get_Staff_Info','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+edit:model','Ui_Vhr128.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpd/wage_change+edit:oper_types','Ui_Vhr128.Query_Oper_Types','M','Q','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+edit:save','Ui_Vhr128.Edit','M','M','A',null,null,null,null);
uis.route('/vhr/hpd/wage_change+edit:staffs','Ui_Vhr128.Query_Staffs',null,'Q','A',null,null,null,null);

uis.path('/vhr/hpd/wage_change','vhr128');
uis.form('/vhr/hpd/wage_change+add','/vhr/hpd/wage_change','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpd/wage_change+edit','/vhr/hpd/wage_change','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpd/wage_change+add','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/wage_change+add','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/wage_change+add','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/wage_change+add','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/wage_change+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpd/wage_change+edit','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpd/wage_change+edit','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpd/wage_change+edit','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpd/wage_change+edit','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpd/wage_change+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpd/wage_change+add','.add_accrual.add_deduction.model.select_accrual.select_deduction.select_staff.');
uis.ready('/vhr/hpd/wage_change+edit','.add_accrual.add_deduction.model.select_accrual.select_deduction.select_staff.');

commit;
end;
/
