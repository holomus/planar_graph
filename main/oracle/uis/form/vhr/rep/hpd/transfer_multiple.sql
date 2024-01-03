set define off
prompt PATH /vhr/rep/hpd/transfer_multiple
begin
uis.route('/vhr/rep/hpd/transfer_multiple:definitions','Ui_Vhr111.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpd/transfer_multiple:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hpd/transfer_multiple:run','Ui_Vhr111.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/transfer_multiple','vhr111');
uis.form('/vhr/rep/hpd/transfer_multiple','/vhr/rep/hpd/transfer_multiple','A','A','D','Z','M','N',null,'Y');






uis.ready('/vhr/rep/hpd/transfer_multiple','.model.');

commit;
end;
/
