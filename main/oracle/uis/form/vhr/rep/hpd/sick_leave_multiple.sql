set define off
prompt PATH /vhr/rep/hpd/sick_leave_multiple
begin
uis.route('/vhr/rep/hpd/sick_leave_multiple:definitions','Ui_Vhr669.Definitions',null,'L','A',null,null,null,null,'S');
uis.route('/vhr/rep/hpd/sick_leave_multiple:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/rep/hpd/sick_leave_multiple:run','Ui_Vhr669.Run','M',null,'A',null,null,null,null,'S');

uis.path('/vhr/rep/hpd/sick_leave_multiple','vhr669');
uis.form('/vhr/rep/hpd/sick_leave_multiple','/vhr/rep/hpd/sick_leave_multiple','A','A','D','H','M','N',null,'Y','S');





uis.ready('/vhr/rep/hpd/sick_leave_multiple','.model.');

commit;
end;
/
