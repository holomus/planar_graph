set define off
prompt PATH /vhr/intro/license_balance
begin
uis.route('/vhr/intro/license_balance:jobs','Ui_Vhr274.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/license_balance:load_day_stats_piechart','Ui_Vhr274.Load_Day_Stats_Piechart','M','M','A',null,null,null,null);
uis.route('/vhr/intro/license_balance:load_day_stats_xychart','Ui_Vhr274.Load_Day_Stats_Xychart','M','L','A',null,null,null,null);
uis.route('/vhr/intro/license_balance:model','Ui_Vhr274.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/intro/license_balance:ranks','Ui_Vhr274.Query_Ranks',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/license_balance:table','Ui_Vhr274.Query_Holders','M','Q','A',null,null,null,null);

uis.path('/vhr/intro/license_balance','vhr274');
uis.form('/vhr/intro/license_balance','/vhr/intro/license_balance','A','A','F','HM','M','N',null,'N');



uis.action('/vhr/intro/license_balance','view_holder','F','/vhr/href/employee/employee_edit','S','O');


uis.ready('/vhr/intro/license_balance','.model.view_holder.');

commit;
end;
/
