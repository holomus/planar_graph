set define off
prompt PATH /vhr/hes/hikvision
begin
uis.route('/vhr/hes/hikvision:load_data','Ui_Vhr159.Load_Data',null,'L','S',null,null,null,null);
uis.route('/vhr/hes/hikvision:save_employee','Ui_Vhr159.Save_Employee','M',null,'S',null,null,null,null);
uis.route('/vhr/hes/hikvision:save_tracks','Ui_Vhr159.Save_Tracks','M','M','S',null,null,null,null);

uis.path('/vhr/hes/hikvision','vhr159');
uis.form('/vhr/hes/hikvision','/vhr/hes/hikvision','F','S','E','Z','M','N',null,'N');





uis.ready('/vhr/hes/hikvision','.model.');

commit;
end;
/
