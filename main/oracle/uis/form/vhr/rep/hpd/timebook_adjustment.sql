set define off
prompt PATH /vhr/rep/hpd/timebook_adjustment
begin
uis.route('/vhr/rep/hpd/timebook_adjustment:model','Ui_Vhr565.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpd/timebook_adjustment:run','Ui_Vhr565.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/timebook_adjustment','vhr565');
uis.form('/vhr/rep/hpd/timebook_adjustment','/vhr/rep/hpd/timebook_adjustment','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hpd/timebook_adjustment','.model.');

commit;
end;
/
