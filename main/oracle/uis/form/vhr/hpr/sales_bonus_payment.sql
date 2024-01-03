set define off
prompt PATH /vhr/hpr/sales_bonus_payment
begin
uis.route('/vhr/hpr/sales_bonus_payment+add:bank_accounts','Ui_Vhr484.Query_Bank_Accounts',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+add:cashboxes','Ui_Vhr484.Query_Cashboxes',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+add:jobs','Ui_Vhr484.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+add:load_operations','Ui_Vhr484.Load_Operations','M','JA','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+add:model','Ui_Vhr484.Add_Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+add:save','Ui_Vhr484.Add','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+add:staffs','Ui_Vhr484.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+edit:bank_accounts','Ui_Vhr484.Query_Bank_Accounts',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+edit:cashboxes','Ui_Vhr484.Query_Cashboxes',null,'Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+edit:jobs','Ui_Vhr484.Query_Jobs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+edit:load_operations','Ui_Vhr484.Load_Operations','M','JA','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+edit:model','Ui_Vhr484.Edit_Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+edit:save','Ui_Vhr484.Edit','M',null,'A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+edit:staffs','Ui_Vhr484.Query_Staffs','M','Q','A',null,null,null,null);
uis.route('/vhr/hpr/sales_bonus_payment+edit:unpost','Ui_Vhr484.Unpost','M',null,'A',null,null,null,null);

uis.path('/vhr/hpr/sales_bonus_payment','vhr484');
uis.form('/vhr/hpr/sales_bonus_payment+add','/vhr/hpr/sales_bonus_payment','F','A','F','H','M','N',null,null);
uis.form('/vhr/hpr/sales_bonus_payment+edit','/vhr/hpr/sales_bonus_payment','F','A','F','H','M','N',null,null);



uis.action('/vhr/hpr/sales_bonus_payment+add','add_bank_account','F','/anor/mr/person/legal_person+edit','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+add','add_cashbox','F','/anor/mkcs/cashbox+add','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+add','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+add','select_cashbox','F','/anor/mkcs/cashbox_list','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+add','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+add','select_staff','F','/vhr/href/staff/staff_list','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+edit','add_bank_account','F','/anor/mr/person/legal_person+edit','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+edit','add_cashbox','F','/anor/mkcs/cashbox+add','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+edit','add_job','F','/anor/mhr/job+add','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+edit','select_cashbox','F','/anor/mkcs/cashbox_list','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+edit','select_job','F','/anor/mhr/job_list','D','O');
uis.action('/vhr/hpr/sales_bonus_payment+edit','select_staff','F','/vhr/href/staff/staff_list','D','O');


uis.ready('/vhr/hpr/sales_bonus_payment+add','.add_bank_account.add_cashbox.add_job.model.select_cashbox.select_job.select_staff.');
uis.ready('/vhr/hpr/sales_bonus_payment+edit','.add_bank_account.add_cashbox.add_job.model.select_cashbox.select_job.select_staff.');

commit;
end;
/
