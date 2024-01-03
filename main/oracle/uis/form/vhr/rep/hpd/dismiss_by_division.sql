set define off
prompt PATH /vhr/rep/hpd/dismiss_by_division
begin
uis.route('/vhr/rep/hpd/dismiss_by_division:model','Ui_Vhr303.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpd/dismiss_by_division:run','Ui_Vhr303.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/dismiss_by_division','vhr303');
uis.form('/vhr/rep/hpd/dismiss_by_division','/vhr/rep/hpd/dismiss_by_division','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hpd/dismiss_by_division','.model.');

commit;
end;
/
