set define off
prompt PATH /vhr/rep/hpd/hiring_multiple
begin
uis.route('/vhr/rep/hpd/hiring_multiple:definitions','Ui_Vhr108.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpd/hiring_multiple:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hpd/hiring_multiple:run','Ui_Vhr108.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/hiring_multiple','vhr108');
uis.form('/vhr/rep/hpd/hiring_multiple','/vhr/rep/hpd/hiring_multiple','A','A','D','Z','M','N',null,'Y');






uis.ready('/vhr/rep/hpd/hiring_multiple','.model.');

commit;
end;
/
