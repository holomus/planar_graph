set define off
prompt PATH /vhr/rep/hpd/transfer
begin
uis.route('/vhr/rep/hpd/transfer:definitions','Ui_Vhr107.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpd/transfer:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hpd/transfer:run','Ui_Vhr107.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/transfer','vhr107');
uis.form('/vhr/rep/hpd/transfer','/vhr/rep/hpd/transfer','A','A','D','Z','M','N',null,'Y');






uis.ready('/vhr/rep/hpd/transfer','.model.');

commit;
end;
/
