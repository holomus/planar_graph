set define off
prompt PATH /vhr/rep/hpd/dismissal
begin
uis.route('/vhr/rep/hpd/dismissal:definitions','Ui_Vhr109.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpd/dismissal:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hpd/dismissal:run','Ui_Vhr109.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/dismissal','vhr109');
uis.form('/vhr/rep/hpd/dismissal','/vhr/rep/hpd/dismissal','A','A','D','Z','M','N',null,'Y');






uis.ready('/vhr/rep/hpd/dismissal','.model.');

commit;
end;
/
