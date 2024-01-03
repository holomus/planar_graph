set define off
prompt PATH /vhr/intro/head_dashboard
begin
uis.route('/vhr/intro/head_dashboard:filials','Ui_Vhr297.Query_Filials',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/head_dashboard:ftes','Ui_Vhr297.Query_Ftes',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/head_dashboard:load_birthdays','Ui_Vhr297.Load_Birthdays',null,'L','A',null,null,null,null);
uis.route('/vhr/intro/head_dashboard:load_day_stats_piechart','Ui_Vhr297.Load_Day_Stats_Piechart','M','M','A',null,null,null,null);
uis.route('/vhr/intro/head_dashboard:load_day_stats_xychart','Ui_Vhr297.Load_Day_Stats_Xychart','M','L','A',null,null,null,null);
uis.route('/vhr/intro/head_dashboard:model','Ui_Vhr297.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/intro/head_dashboard:table','Ui_Vhr297.Query_Employees','M','Q','A',null,null,null,null);

uis.path('/vhr/intro/head_dashboard','vhr297');
uis.form('/vhr/intro/head_dashboard','/vhr/intro/head_dashboard','H','A','F','H','M','N',null,'N');



uis.action('/vhr/intro/head_dashboard','view_staff','H','/vhr/href/staff/staff_view','S','O');


uis.ready('/vhr/intro/head_dashboard','.model.view_staff.');

commit;
end;
/
