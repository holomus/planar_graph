set define off
prompt PATH /vhr/hpr/payment
begin
uis.route('/vhr/hpr/payment+add$book','Ui_Vhr591.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add$complete','Ui_Vhr591.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add$draft','Ui_Vhr591.Add','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add:bank_accounts','Ui_Vhr591.Query_Bank_Accounts',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add:cashboxes','Ui_Vhr591.Query_Cashboxes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add:currencies','Ui_Vhr591.Query_Currencies','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add:employees','Ui_Vhr591.Query_Employees',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add:fill_data','Ui_Vhr591.Fill_Data','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add:get_employee','Ui_Vhr591.Get_Employee','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+add:model','Ui_Vhr591.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hpr/payment+edit$book','Ui_Vhr591.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit$complete','Ui_Vhr591.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit$draft','Ui_Vhr591.Edit','M',null,'A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit:bank_accounts','Ui_Vhr591.Query_Bank_Accounts',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit:cashboxes','Ui_Vhr591.Query_Cashboxes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit:currencies','Ui_Vhr591.Query_Currencies','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit:employees','Ui_Vhr591.Query_Employees',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit:fill_data','Ui_Vhr591.Fill_Data','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit:get_employee','Ui_Vhr591.Get_Employee','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/payment+edit:model','Ui_Vhr591.Edit_Model','M','M','A','Y',null,null,null,null);

uis.path('/vhr/hpr/payment','vhr591');
uis.form('/vhr/hpr/payment+add','/vhr/hpr/payment','F','A','F','H','M','N',null,'N',null);
uis.form('/vhr/hpr/payment+edit','/vhr/hpr/payment','F','A','F','H','M','N',null,'N',null);

uis.override_form('/anor/mpr/payment+add','vhr','/vhr/hpr/payment+add');
uis.override_form('/anor/mpr/payment+edit','vhr','/vhr/hpr/payment+edit');


uis.action('/vhr/hpr/payment+add','add_bank_account','F','/anor/mr/person/legal_person+edit','D','O');
uis.action('/vhr/hpr/payment+add','add_cashbox','F','/anor/mkcs/cashbox+add','D','O');
uis.action('/vhr/hpr/payment+add','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/payment+add','add_employee','F','/anor/mhr/employee+add','D','O');
uis.action('/vhr/hpr/payment+add','add_employee_bank_account','F','/anor/mr/person/natural_person+edit','D','O');
uis.action('/vhr/hpr/payment+add','book','F',null,null,'A');
uis.action('/vhr/hpr/payment+add','complete','F',null,null,'A');
uis.action('/vhr/hpr/payment+add','draft','F',null,null,'A');
uis.action('/vhr/hpr/payment+add','select_cashbox','F','/anor/mkcs/cashbox_list','D','O');
uis.action('/vhr/hpr/payment+add','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/payment+add','select_employee','F','/anor/mhr/employee_list','D','O');
uis.action('/vhr/hpr/payment+edit','add_bank_account','F','/anor/mr/person/legal_person+edit','D','O');
uis.action('/vhr/hpr/payment+edit','add_cashbox','F','/anor/mkcs/cashbox+add','D','O');
uis.action('/vhr/hpr/payment+edit','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/payment+edit','add_employee','F','/anor/mhr/employee+add','D','O');
uis.action('/vhr/hpr/payment+edit','add_employee_bank_account','F','/anor/mr/person/natural_person+edit','D','O');
uis.action('/vhr/hpr/payment+edit','book','F',null,null,'A');
uis.action('/vhr/hpr/payment+edit','complete','F',null,null,'A');
uis.action('/vhr/hpr/payment+edit','draft','F',null,null,'A');
uis.action('/vhr/hpr/payment+edit','select_cashbox','F','/anor/mkcs/cashbox_list','D','O');
uis.action('/vhr/hpr/payment+edit','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/payment+edit','select_employee','F','/anor/mhr/employee_list','D','O');


uis.ready('/vhr/hpr/payment+add','.add_bank_account.add_cashbox.add_currency.add_employee.add_employee_bank_account.book.complete.draft.model.select_cashbox.select_currency.select_employee.');
uis.ready('/vhr/hpr/payment+edit','.add_bank_account.add_cashbox.add_currency.add_employee.add_employee_bank_account.book.complete.draft.model.select_cashbox.select_currency.select_employee.');

commit;
end;
/
