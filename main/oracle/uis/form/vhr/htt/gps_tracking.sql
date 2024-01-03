set define off
prompt PATH /vhr/htt/gps_tracking
begin
uis.route('/vhr/htt/gps_tracking:jobs','Ui_Vhr635.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/gps_tracking:load_employees','Ui_Vhr635.Load_Employees','M','M','A',null,null,null,null);
uis.route('/vhr/htt/gps_tracking:load_tracks','Ui_Vhr635.Load_Tracks','M','JO','A',null,null,null,null);
uis.route('/vhr/htt/gps_tracking:location_types','Ui_Vhr635.Query_Location_Types',null,'Q','A',null,null,null,null);
uis.route('/vhr/htt/gps_tracking:model','Ui_Vhr635.Model',null,'M','A','Y',null,null,null);

uis.path('/vhr/htt/gps_tracking','vhr635');
uis.form('/vhr/htt/gps_tracking','/vhr/htt/gps_tracking','F','A','F','HM','M','N',null,'N');





uis.ready('/vhr/htt/gps_tracking','.model.');

commit;
end;
/
