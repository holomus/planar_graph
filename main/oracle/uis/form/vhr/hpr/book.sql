set define off
prompt PATH /vhr/hpr/book
begin
uis.route('/vhr/hpr/book+add:calc_amount','Ui_Vhr64.Calc_Amount','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:currencies','Ui_Vhr64.Query_Currencies',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:load_daily_details','Ui_Vhr64.Load_Daily_Details','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:load_indicators','Ui_Vhr64.Load_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:load_operations','Ui_Vhr64.Load_Operations','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:load_staff_info','Ui_Vhr64.Load_Staff_Info','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:load_subfilials','Ui_Vhr64.Load_Subfilials','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:model','Ui_Vhr64.Add_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpr/book+add:oper_types','Ui_Vhr64.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:save','Ui_Vhr64.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:staffs','Ui_Vhr64.Query_Staffs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:subfilials','Ui_Vhr64.Query_Subfilials',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+add:unpost','Ui_Vhr64.Unpost','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:calc_amount','Ui_Vhr64.Calc_Amount','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:currencies','Ui_Vhr64.Query_Currencies',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:load_daily_details','Ui_Vhr64.Load_Daily_Details','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:load_indicators','Ui_Vhr64.Load_Indicators','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:load_operations','Ui_Vhr64.Load_Operations','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:load_staff_info','Ui_Vhr64.Load_Staff_Info','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:load_subfilials','Ui_Vhr64.Load_Subfilials','M','L','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:model','Ui_Vhr64.Edit_Model','M','M','A','Y',null,null,null,null);
uis.route('/vhr/hpr/book+edit:oper_types','Ui_Vhr64.Query_Oper_Types','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:save','Ui_Vhr64.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:staffs','Ui_Vhr64.Query_Staffs','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:subfilials','Ui_Vhr64.Query_Subfilials',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/book+edit:unpost','Ui_Vhr64.Unpost','M',null,'A',null,null,null,null,null);

uis.path('/vhr/hpr/book','vhr64');
uis.form('/vhr/hpr/book+add','/vhr/hpr/book','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpr/book+edit','/vhr/hpr/book','F','A','F','H','M','N',null,'N',null);



uis.action('/vhr/hpr/book+add','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpr/book+add','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/book+add','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpr/book+add','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpr/book+add','select_charge','F','/vhr/hpr/charge_list','D','O');
uis.action('/vhr/hpr/book+add','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/book+add','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');
uis.action('/vhr/hpr/book+edit','add_accrual','F','/vhr/hpr/oper_type/oper_type+add_accrual','D','O');
uis.action('/vhr/hpr/book+edit','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/book+edit','add_deduction','F','/vhr/hpr/oper_type/oper_type+add_deduction','D','O');
uis.action('/vhr/hpr/book+edit','select_accrual','F','/vhr/hpr/oper_type/oper_type_list+accrual','D','O');
uis.action('/vhr/hpr/book+edit','select_charge','F','/vhr/hpr/charge_list','D','O');
uis.action('/vhr/hpr/book+edit','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/book+edit','select_deduction','F','/vhr/hpr/oper_type/oper_type_list+deduction','D','O');


uis.ready('/vhr/hpr/book+add','.add_accrual.add_currency.add_deduction.model.select_accrual.select_charge.select_currency.select_deduction.');
uis.ready('/vhr/hpr/book+edit','.add_accrual.add_currency.add_deduction.model.select_accrual.select_charge.select_currency.select_deduction.');

commit;
end;
/
