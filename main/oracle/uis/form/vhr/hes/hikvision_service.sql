set define off
prompt PATH /vhr/hes/hikvision_service
begin
uis.route('/vhr/hes/hikvision_service:eval_commands','Ui_Vhr470.Eval_Commands','JO',null,'A',null,null,null,null);
uis.route('/vhr/hes/hikvision_service:load_commands','Ui_Vhr470.Load_Commands','JO','JA','A',null,null,null,null);
uis.route('/vhr/hes/hikvision_service:load_data','Ui_Vhr470.Load_Data','M','L','A',null,null,null,null);
uis.route('/vhr/hes/hikvision_service:save_offline_tracks','Ui_Vhr470.Save_Offline_Tracks','A',null,'A',null,null,null,null);
uis.route('/vhr/hes/hikvision_service:save_tracks','Ui_Vhr470.Save_Tracks','M','M','A',null,null,null,null);
uis.route('/vhr/hes/hikvision_service:update_ip_address','Ui_Vhr470.Update_Ip_Address','M',null,'A',null,null,null,null);

uis.path('/vhr/hes/hikvision_service','vhr470');
uis.form('/vhr/hes/hikvision_service','/vhr/hes/hikvision_service','A','A','E','Z','M','Y',null,'N');





uis.ready('/vhr/hes/hikvision_service','.model.');

commit;
end;
/
