set define off
prompt PATH /vhr/rep/hes/absences
begin
uis.route('/vhr/rep/hes/absences:absences_today','Ui_Vhr147.Absences_Today',null,'A','A',null,null,null,null);
uis.route('/vhr/rep/hes/absences:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hes/absences:telegram_model','Ui_Vhr147.Telegram_Model',null,'M','A',null,null,null,null);

uis.path('/vhr/rep/hes/absences','vhr147');
uis.form('/vhr/rep/hes/absences','/vhr/rep/hes/absences','F','A','R','T','M','N',null,'N');






uis.ready('/vhr/rep/hes/absences','.model.');

commit;
end;
/
