set define off
prompt PATH /vhr/rep/hpd/labor_contract
begin
uis.route('/vhr/rep/hpd/labor_contract:definitions','Ui_Vhr146.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpd/labor_contract:run','Ui_Vhr146.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/labor_contract','vhr146');
uis.form('/vhr/rep/hpd/labor_contract','/vhr/rep/hpd/labor_contract','A','A','D','Z','M','N',null,'Y');






uis.ready('/vhr/rep/hpd/labor_contract','.model.');

commit;
end;
/
