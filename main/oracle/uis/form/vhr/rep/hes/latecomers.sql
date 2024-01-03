set define off
prompt PATH /vhr/rep/hes/latecomers
begin
uis.route('/vhr/rep/hes/latecomers:latecomers_today','Ui_Vhr148.Latecomers_Today',null,'A','A',null,null,null,null);
uis.route('/vhr/rep/hes/latecomers:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hes/latecomers:telegram_model','Ui_Vhr148.Telegram_Model',null,'M','A',null,null,null,null);

uis.path('/vhr/rep/hes/latecomers','vhr148');
uis.form('/vhr/rep/hes/latecomers','/vhr/rep/hes/latecomers','F','A','R','T','M','N',null,'N');






uis.ready('/vhr/rep/hes/latecomers','.model.');

commit;
end;
/
