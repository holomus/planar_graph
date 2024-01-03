set define off
prompt PATH /vhr/rep/hpr/start/wage_report
begin
uis.route('/vhr/rep/hpr/start/wage_report:model','Ui_Vhr322.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpr/start/wage_report:run','Ui_Vhr322.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/hpr/start/wage_report:save_preferences','Ui_Vhr322.Save_Preferences','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/hpr/start/wage_report:staffs','Ui_Vhr322.Query_Staffs','M','Q','A',null,null,null,null);

uis.path('/vhr/rep/hpr/start/wage_report','vhr322');
uis.form('/vhr/rep/hpr/start/wage_report','/vhr/rep/hpr/start/wage_report','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hpr/start/wage_report','.model.');

commit;
end;
/
