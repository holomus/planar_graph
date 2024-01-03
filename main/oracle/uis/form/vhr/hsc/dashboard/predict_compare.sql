set define off
prompt PATH /vhr/hsc/dashboard/predict_compare
begin
uis.route('/vhr/hsc/dashboard/predict_compare:areas','Ui_Vhr556.Query_Areas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/dashboard/predict_compare:drivers','Ui_Vhr556.Query_Drivers','M','Q','A',null,null,null,null);
uis.route('/vhr/hsc/dashboard/predict_compare:filter','Ui_Vhr556.Load_Facts','M','JA','A',null,null,null,null);
uis.route('/vhr/hsc/dashboard/predict_compare:model','Ui_Vhr556.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/dashboard/predict_compare:objects','Ui_Vhr556.Query_Objects',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/dashboard/predict_compare:run','Ui_Vhr556.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/hsc/dashboard/predict_compare','vhr556');
uis.form('/vhr/hsc/dashboard/predict_compare','/vhr/hsc/dashboard/predict_compare','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hsc/dashboard/predict_compare','.model.');

commit;
end;
/
