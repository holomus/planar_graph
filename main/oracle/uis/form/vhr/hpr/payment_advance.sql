set define off
prompt PATH /vhr/hpr/payment_advance
begin
uis.route('/vhr/hpr/payment_advance+add$complete','Ui_Vhr231.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+add$draft','Ui_Vhr231.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+add:bank_accounts','Ui_Vhr231.Query_Bank_Accounts',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+add:cashboxes','Ui_Vhr231.Query_Cashboxes',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+add:currencies','Ui_Vhr231.Query_Currencies','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+add:load_employee','Ui_Vhr231.Load_Employee','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+add:load_employees','Ui_Vhr231.Load_Employees','M','L','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+add:model','Ui_Vhr231.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/payment_advance+add:staffs','Ui_Vhr231.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+edit$complete','Ui_Vhr231.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+edit$draft','Ui_Vhr231.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+edit:bank_accounts','Ui_Vhr231.Query_Bank_Accounts',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+edit:cashboxes','Ui_Vhr231.Query_Cashboxes',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+edit:currencies','Ui_Vhr231.Query_Currencies','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+edit:load_employee','Ui_Vhr231.Load_Employee','M','M','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+edit:load_employees','Ui_Vhr231.Load_Employees','M','L','A',null,null,null,null);
uis.route('/vhr/hpr/payment_advance+edit:model','Ui_Vhr231.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/payment_advance+edit:staffs','Ui_Vhr231.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/hpr/payment_advance','vhr231');
uis.form('/vhr/hpr/payment_advance+add','/vhr/hpr/payment_advance','F','A','E','H','M','N',null,'N');
uis.form('/vhr/hpr/payment_advance+edit','/vhr/hpr/payment_advance','F','A','E','H','M','N',null,'N');

uis.override_form('/anor/mpr/payment_advance+add','vhr','/vhr/hpr/payment_advance+add');
uis.override_form('/anor/mpr/payment_advance+edit','vhr','/vhr/hpr/payment_advance+edit');


uis.action('/vhr/hpr/payment_advance+add','add_bank_account','F','/anor/mr/person/legal_person+edit','D','O');
uis.action('/vhr/hpr/payment_advance+add','add_cashbox','F','/anor/mkcs/cashbox+add','D','O');
uis.action('/vhr/hpr/payment_advance+add','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/payment_advance+add','add_employee_bank_account','F','/vhr/href/employee/employee_edit','D','O');
uis.action('/vhr/hpr/payment_advance+add','complete','F',null,null,'A');
uis.action('/vhr/hpr/payment_advance+add','draft','F',null,null,'A');
uis.action('/vhr/hpr/payment_advance+add','select_cashbox','F','/anor/mkcs/cashbox_list','D','O');
uis.action('/vhr/hpr/payment_advance+add','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/payment_advance+add','select_staffs','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpr/payment_advance+edit','add_bank_account','F','/anor/mr/person/legal_person+edit','D','O');
uis.action('/vhr/hpr/payment_advance+edit','add_cashbox','F','/anor/mkcs/cashbox+add','D','O');
uis.action('/vhr/hpr/payment_advance+edit','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/payment_advance+edit','add_employee_bank_account','F','/vhr/href/employee/employee_edit','D','O');
uis.action('/vhr/hpr/payment_advance+edit','complete','F',null,null,'A');
uis.action('/vhr/hpr/payment_advance+edit','draft','F',null,null,'A');
uis.action('/vhr/hpr/payment_advance+edit','select_cashbox','F','/anor/mkcs/cashbox_list','D','O');
uis.action('/vhr/hpr/payment_advance+edit','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/payment_advance+edit','select_staffs','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpr/payment_advance+add','.add_bank_account.add_cashbox.add_currency.add_employee_bank_account.complete.draft.model.select_cashbox.select_currency.select_staffs.');
uis.ready('/vhr/hpr/payment_advance+edit','.add_bank_account.add_cashbox.add_currency.add_employee_bank_account.complete.draft.model.select_cashbox.select_currency.select_staffs.');

commit;
end;
/
