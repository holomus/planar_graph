set define off
prompt PATH /vx/es/timepad
begin
uis.route('/vx/es/timepad:load_settings','Ui_Vx114.Load_Settings',null,'M','S',null,null,null,null);
uis.route('/vx/es/timepad:load_holidays','Ui_Vx114.Load_Holidays',null,'JA','S',null,null,null,null);
uis.route('/vx/es/timepad:save_tracks','Ui_Vx114.Save_Tracks','M','M','S',null,null,null,null);

uis.path('/vx/es/timepad','vx114');
uis.form('/vx/es/timepad','/vx/es/timepad','A','S','E','Z','M','N',null);






uis.ready('/vx/es/timepad','.model.');

commit;
end;
/
