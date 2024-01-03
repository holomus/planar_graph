set define off
prompt PATH /vhr/intro/division_dashboard
begin
uis.route('/vhr/intro/division_dashboard:division_groups','Ui_Vhr458.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/division_dashboard:load_hybrid_chart_stats','Ui_Vhr458.Load_Hybrid_Chart_Stats','M','M','A',null,null,null,null);
uis.route('/vhr/intro/division_dashboard:load_xy_chart_stats','Ui_Vhr458.Load_Xy_Chart_Stats','M','M','A',null,null,null,null);
uis.route('/vhr/intro/division_dashboard:model','Ui_Vhr458.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/intro/division_dashboard:run','Ui_Vhr458.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/intro/division_dashboard:schedules','Ui_Vhr458.Query_Schedules',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/division_dashboard:table','Ui_Vhr458.Query_Divisions','M','Q','A',null,null,null,null);

uis.path('/vhr/intro/division_dashboard','vhr458');
uis.form('/vhr/intro/division_dashboard','/vhr/intro/division_dashboard','F','A','F','HM','M','N',null,'N');





uis.ready('/vhr/intro/division_dashboard','.model.');

commit;
end;
/
