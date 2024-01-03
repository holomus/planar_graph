set define off
prompt PATH /vhr/hper/staff_performance
begin
uis.route('/vhr/hper/staff_performance:load_xy_chart_stats','Ui_Vhr609.Load_Xy_Chart_Stats','M','M','A',null,null,null,null);
uis.route('/vhr/hper/staff_performance:model','Ui_Vhr609.Model','M','M','A','Y',null,null,null);

uis.path('/vhr/hper/staff_performance','vhr609');
uis.form('/vhr/hper/staff_performance','/vhr/hper/staff_performance','A','A','F','H','M','N',null,null);





uis.ready('/vhr/hper/staff_performance','.model.');

commit;
end;
/
