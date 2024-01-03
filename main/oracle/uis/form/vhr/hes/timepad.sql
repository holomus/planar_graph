set define off
prompt PATH /vhr/hes/timepad
begin
uis.route('/vhr/hes/timepad:bind_device','Ui_Vhr91.Bind_Device','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/timepad:device_update','Ui_Vhr91.Device_Update','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/timepad:check_admin','Ui_Vhr91.Check_Admin','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/timepad:filials','Ui_Vhr91.Query_Filials',null,'Q','S',null,null,null,null);
uis.route('/vhr/hes/timepad:load_settings','Ui_Vhr91.Load_Settings','M','M','S',null,null,null,null);
uis.route('/vhr/hes/timepad:load_holidays','Ui_Vhr91.Load_Holidays','M','L','S',null,null,null,null);
uis.route('/vhr/hes/timepad:locations','Ui_Vhr91.Query_Locations',null,'Q','S',null,null,null,null);
uis.route('/vhr/hes/timepad:save_settings','Ui_Vhr91.Save_Settings','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/timepad:save_tracks','Ui_Vhr91.Save_Tracks','M','M','S',null,null,null,null);

uis.path('/vhr/hes/timepad','vhr91');
uis.form('/vhr/hes/timepad','/vhr/hes/timepad','A','S','E','Z','M','N',null);






uis.ready('/vhr/hes/timepad','.model.');

commit;
end;
/
