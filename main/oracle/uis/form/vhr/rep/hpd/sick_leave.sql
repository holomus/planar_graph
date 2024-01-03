set define off
prompt PATH /vhr/rep/hpd/sick_leave
begin
uis.route('/vhr/rep/hpd/sick_leave:definitions','Ui_Vhr668.Definitions',null,'L','A',null,null,null,null,'S');
uis.route('/vhr/rep/hpd/sick_leave:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/rep/hpd/sick_leave:run','Ui_Vhr668.Run','M',null,'A',null,null,null,null,'S');

uis.path('/vhr/rep/hpd/sick_leave','vhr668');
uis.form('/vhr/rep/hpd/sick_leave','/vhr/rep/hpd/sick_leave','A','A','D','H','M','N',null,'Y','S');





uis.ready('/vhr/rep/hpd/sick_leave','.model.');

commit;
end;
/
