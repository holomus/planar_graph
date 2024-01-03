set define off
prompt PATH /vhr/rep/hpr/payroll
begin
uis.route('/vhr/rep/hpr/payroll:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hpr/payroll:query_months','Ui_Vhr221.Query_Months',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hpr/payroll:run','Ui_Vhr221.Run','M','A','A',null,null,null,null);
uis.route('/vhr/rep/hpr/payroll:telegram_model','Ui_Vhr221.Telegram_Model',null,'M','A',null,null,null,null);

uis.path('/vhr/rep/hpr/payroll','vhr221');
uis.form('/vhr/rep/hpr/payroll','/vhr/rep/hpr/payroll','F','A','R','T','M','N',null,'N');






uis.ready('/vhr/rep/hpr/payroll','.model.');

commit;
end;
/
