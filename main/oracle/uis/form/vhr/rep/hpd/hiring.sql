set define off
prompt PATH /vhr/rep/hpd/hiring
begin
uis.route('/vhr/rep/hpd/hiring:definitions','Ui_Vhr106.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpd/hiring:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hpd/hiring:run','Ui_Vhr106.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/hiring','vhr106');
uis.form('/vhr/rep/hpd/hiring','/vhr/rep/hpd/hiring','A','A','D','Z','M','N',null,'Y');






uis.ready('/vhr/rep/hpd/hiring','.model.');

commit;
end;
/
