set define off
prompt PATH /vhr/href/person/person_bank_account
begin
uis.route('/vhr/href/person/person_bank_account$del_bank_account','Ui_Vhr102.Del_Bank_Account','M',null,'A',null,null,null,null);
uis.route('/vhr/href/person/person_bank_account$save_bank_account','Ui_Vhr102.Save_Bank_Account','M','M','A',null,null,null,null);
uis.route('/vhr/href/person/person_bank_account:banks','Ui_Vhr102.Query_Banks','M','Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_bank_account:currencies','Ui_Vhr102.Query_Currencies',null,'Q','A',null,null,null,null);
uis.route('/vhr/href/person/person_bank_account:model','Ui_Vhr102.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/href/person/person_bank_account','vhr102');
uis.form('/vhr/href/person/person_bank_account','/vhr/href/person/person_bank_account','A','A','F','H','M','N',null,'N');



uis.action('/vhr/href/person/person_bank_account','add_bank','A','/anor/mkcs/bank+add','D','O');
uis.action('/vhr/href/person/person_bank_account','add_currency','A','/anor/mk/currency+add','D','O');
uis.action('/vhr/href/person/person_bank_account','del_bank_account','A',null,null,'A');
uis.action('/vhr/href/person/person_bank_account','save_bank_account','A',null,null,'A');
uis.action('/vhr/href/person/person_bank_account','select_bank','A','/anor/mkcs/bank_list','D','O');
uis.action('/vhr/href/person/person_bank_account','select_currency','A','/anor/mk/currency_list','D','O');


uis.ready('/vhr/href/person/person_bank_account','.add_bank.add_currency.del_bank_account.model.save_bank_account.select_bank.select_currency.');

commit;
end;
/
