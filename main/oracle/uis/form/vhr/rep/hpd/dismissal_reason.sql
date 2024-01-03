set define off
prompt PATH /vhr/rep/hpd/dismissal_reason
begin
uis.route('/vhr/rep/hpd/dismissal_reason:jobs','Ui_Vhr500.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/rep/hpd/dismissal_reason:model','Ui_Vhr500.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/rep/hpd/dismissal_reason:run','Ui_Vhr500.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/dismissal_reason','vhr500');
uis.form('/vhr/rep/hpd/dismissal_reason','/vhr/rep/hpd/dismissal_reason','F','A','R','H','M','N',null,'N');





uis.ready('/vhr/rep/hpd/dismissal_reason','.model.');

commit;
end;
/
