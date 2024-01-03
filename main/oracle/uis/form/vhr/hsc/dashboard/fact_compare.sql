set define off
prompt PATH /vhr/hsc/dashboard/fact_compare
begin
uis.route('/vhr/hsc/dashboard/fact_compare:areas','Ui_Vhr616.Query_Areas',null,'Q','A',null,null,null,null);
uis.route('/vhr/hsc/dashboard/fact_compare:drivers','Ui_Vhr616.Query_Drivers','M','Q','A',null,null,null,null);
uis.route('/vhr/hsc/dashboard/fact_compare:filter','Ui_Vhr616.Load_Facts','M','JA','A',null,null,null,null);
uis.route('/vhr/hsc/dashboard/fact_compare:model','Ui_Vhr616.Model',null,'M','A','Y',null,null,null);
uis.route('/vhr/hsc/dashboard/fact_compare:objects','Ui_Vhr616.Query_Objects',null,'Q','A',null,null,null,null);

uis.path('/vhr/hsc/dashboard/fact_compare','vhr616');
uis.form('/vhr/hsc/dashboard/fact_compare','/vhr/hsc/dashboard/fact_compare','F','A','F','H','M','N',null,'N');





uis.ready('/vhr/hsc/dashboard/fact_compare','.model.');

commit;
end;
/
