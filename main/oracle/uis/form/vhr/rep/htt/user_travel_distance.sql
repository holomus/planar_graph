set define off
prompt PATH /vhr/rep/htt/user_travel_distance
begin
uis.route('/vhr/rep/htt/user_travel_distance:employees','Ui_Vhr672.Query_Employees','M','Q','A',null,null,null,null,'S');
uis.route('/vhr/rep/htt/user_travel_distance:jobs','Ui_Vhr672.Query_Jobs',null,'Q','A',null,null,null,null,'S');
uis.route('/vhr/rep/htt/user_travel_distance:model','Ui_Vhr672.Model',null,'M','A','Y',null,null,null,'S');
uis.route('/vhr/rep/htt/user_travel_distance:run','Ui_Vhr672.Run','M',null,'A',null,null,null,null,'S');
uis.route('/vhr/rep/htt/user_travel_distance:save_preferences','Ui_Vhr672.Save_Preferences','M',null,'A',null,null,null,null,'S');

uis.path('/vhr/rep/htt/user_travel_distance','vhr672');
uis.form('/vhr/rep/htt/user_travel_distance','/vhr/rep/htt/user_travel_distance','F','A','F','H','M','N',null,'N','S');





uis.ready('/vhr/rep/htt/user_travel_distance','.model.');

commit;
end;
/
