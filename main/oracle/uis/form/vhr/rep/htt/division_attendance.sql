set define off
prompt PATH /vhr/rep/htt/division_attendance
begin
uis.route('/vhr/rep/htt/division_attendance:division_groups','Ui_Vhr304.Query_Division_Groups',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/division_attendance:divisions','Ui_Vhr304.Query_Divisions',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/htt/division_attendance:model','Ui_Vhr304.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/htt/division_attendance:run','Ui_Vhr304.Run','M',null,'A',null,null,null,null);
uis.route('/vhr/rep/htt/division_attendance:save_preferences','Ui_Vhr304.Save_Preferences','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/htt/division_attendance','vhr304');
uis.form('/vhr/rep/htt/division_attendance','/vhr/rep/htt/division_attendance','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/htt/division_attendance','.model.');

commit;
end;
/
