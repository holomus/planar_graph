set define off
prompt PATH /vhr/intro/dashboard
begin
uis.route('/vhr/intro/dashboard:jobs','Ui_Vhr100.Query_Jobs',null,'Q','S',null,null,null,null);
uis.route('/vhr/intro/dashboard:load_birthdays','Ui_Vhr100.Load_Birthdays',null,'L','S',null,null,null,null);
uis.route('/vhr/intro/dashboard:load_day_stats_piechart','Ui_Vhr100.Load_Day_Stats_Piechart','M','M','S',null,null,null,null);
uis.route('/vhr/intro/dashboard:load_day_stats_xychart','Ui_Vhr100.Load_Day_Stats_Xychart','M','L','S',null,null,null,null);
uis.route('/vhr/intro/dashboard:locations','Ui_Vhr100.Query_Locations',null,'Q','S',null,null,null,null);
uis.route('/vhr/intro/dashboard:ftes','Ui_Vhr100.Query_Ftes',null,'Q','S',null,null,null,null);
uis.route('/vhr/intro/dashboard:model','Ui_Vhr100.Model',null,'M','S','Y',null,null,null);
uis.route('/vhr/intro/dashboard:ranks','Ui_Vhr100.Query_Ranks',null,'Q','S',null,null,null,null);
uis.route('/vhr/intro/dashboard:schedules','Ui_Vhr100.Query_Schedules',null,'Q','S',null,null,null,null);
uis.route('/vhr/intro/dashboard:table','Ui_Vhr100.Query_Employees','M','Q','S',null,null,null,null);

uis.path('/vhr/intro/dashboard','vhr100');
uis.form('/vhr/intro/dashboard','/vhr/intro/dashboard','A','S','F','HM','M','N',null,'N');



uis.action('/vhr/intro/dashboard','head_dashboard','A','/vhr/intro/head_dashboard','R','O');
uis.action('/vhr/intro/dashboard','view_employee','F','/vhr/href/employee/employee_edit','D','O');


uis.ready('/vhr/intro/dashboard','.head_dashboard.model.view_employee.');

commit;
end;
/
