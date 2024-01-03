set define off
prompt PATH /vhr/hpr/credit
begin
uis.route('/vhr/hpr/credit+add$book','Ui_Vhr679.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+add$complete','Ui_Vhr679.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+add$draft','Ui_Vhr679.Add','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+add:bank_accounts','Ui_Vhr679.Query_Bank_Accounts',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+add:cashboxes','Ui_Vhr679.Query_Cashboxes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+add:currencies','Ui_Vhr679.Query_Currencies','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+add:employee','Ui_Vhr679.Query_Employees',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+add:get_closest_wage','Ui_Vhr679.Get_Closest_Wage','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+add:model','Ui_Vhr679.Add_Model',null,'M','A','Y',null,null,null,null);
uis.route('/vhr/hpr/credit+edit$book','Ui_Vhr679.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+edit$complete','Ui_Vhr679.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+edit$draft','Ui_Vhr679.Edit','M','M','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+edit:bank_accounts','Ui_Vhr679.Query_Bank_Accounts',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+edit:cashboxes','Ui_Vhr679.Query_Cashboxes',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+edit:currencies','Ui_Vhr679.Query_Currencies','M','Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+edit:employee','Ui_Vhr679.Query_Employees',null,'Q','A',null,null,null,null,null);
uis.route('/vhr/hpr/credit+edit:model','Ui_Vhr679.Edit_Model','M','M','A','Y',null,null,null,null);

uis.path('/vhr/hpr/credit','vhr679');
uis.form('/vhr/hpr/credit+add','/vhr/hpr/credit','F','A','F','H','M','N',null,null,null);
uis.form('/vhr/hpr/credit+edit','/vhr/hpr/credit','F','A','F','H','M','N',null,null,null);



uis.action('/vhr/hpr/credit+add','add_bank_account','F','/anor/mr/person/legal_person+edit','D','O');
uis.action('/vhr/hpr/credit+add','add_cashbox','F','/anor/mkcs/cashbox+add','D','O');
uis.action('/vhr/hpr/credit+add','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/credit+add','book','F',null,null,'A');
uis.action('/vhr/hpr/credit+add','complete','F',null,null,'A');
uis.action('/vhr/hpr/credit+add','draft','F',null,null,'A');
uis.action('/vhr/hpr/credit+add','select_cashbox','F','/anor/mkcs/cashbox_list','D','O');
uis.action('/vhr/hpr/credit+add','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/credit+add','select_employee','F','/vhr/href/employee/employee_list','D','O');
uis.action('/vhr/hpr/credit+edit','add_bank_account','F','/anor/mr/person/legal_person+edit','D','O');
uis.action('/vhr/hpr/credit+edit','add_cashbox','F','/anor/mkcs/cashbox+add','D','O');
uis.action('/vhr/hpr/credit+edit','add_currency','F','/anor/mk/currency+add','D','O');
uis.action('/vhr/hpr/credit+edit','book','F',null,null,'A');
uis.action('/vhr/hpr/credit+edit','complete','F',null,null,'A');
uis.action('/vhr/hpr/credit+edit','draft','F',null,null,'A');
uis.action('/vhr/hpr/credit+edit','select_cashbox','F','/anor/mkcs/cashbox_list','D','O');
uis.action('/vhr/hpr/credit+edit','select_currency','F','/anor/mk/currency_list','D','O');
uis.action('/vhr/hpr/credit+edit','select_employee','F','/vhr/href/employee/employee_list','S','O');


uis.ready('/vhr/hpr/credit+add','.add_bank_account.add_cashbox.add_currency.book.complete.draft.model.select_cashbox.select_currency.select_employee.');
uis.ready('/vhr/hpr/credit+edit','.add_bank_account.add_cashbox.add_currency.book.complete.draft.model.select_cashbox.select_currency.select_employee.');

commit;
end;
/
