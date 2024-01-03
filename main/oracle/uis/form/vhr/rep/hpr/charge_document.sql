set define off
prompt PATH /vhr/rep/hpr/charge_document
begin
uis.route('/vhr/rep/hpr/charge_document:definitions','Ui_Vhr681.Definitions',null,'L','A',null,null,null,null,'S');
uis.route('/vhr/rep/hpr/charge_document:model','Ui.No_Model',null,null,'A','Y',null,null,null,'S');
uis.route('/vhr/rep/hpr/charge_document:run','Ui_Vhr681.Run','M',null,'A',null,null,null,null,'S');

uis.path('/vhr/rep/hpr/charge_document','vhr681');
uis.form('/vhr/rep/hpr/charge_document','/vhr/rep/hpr/charge_document','A','A','R','H','M','N',null,'N','S');





uis.ready('/vhr/rep/hpr/charge_document','.model.');

commit;
end;
/
