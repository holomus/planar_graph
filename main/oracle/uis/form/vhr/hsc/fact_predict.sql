set define off
prompt PATH /vhr/hsc/fact_predict
begin
uis.route('/vhr/hsc/fact_predict:areas','Ui_Vhr551.Query_Areas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact_predict:drivers','Ui_Vhr551.Query_Drivers',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact_predict:model','Ui_Vhr551.Model','M','M','A','Y',null,null,null);
uis.route('/vhr/hsc/fact_predict:objects','Ui_Vhr551.Query_Objects',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/fact_predict:predict','Ui_Vhr551.Predict_Facts','M','R','A',null,null,null,null);

uis.path('/vhr/hsc/fact_predict','vhr551');
uis.form('/vhr/hsc/fact_predict','/vhr/hsc/fact_predict','F','A','F','H','M','N',null,'N');



uis.action('/vhr/hsc/fact_predict','select_area','F','/vhr/hsc/area_list','D','O');
uis.action('/vhr/hsc/fact_predict','select_driver','F','/vhr/hsc/driver_list','D','O');
uis.action('/vhr/hsc/fact_predict','select_object','F','/vhr/hsc/object_list','D','O');
uis.action('/vhr/hsc/fact_predict','server_settings','F','/vhr/hsc/server_settings','S','O');


uis.ready('/vhr/hsc/fact_predict','.model.select_area.select_driver.select_object.server_settings.');

commit;
end;
/
