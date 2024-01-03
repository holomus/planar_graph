set define off
prompt PATH /vhr/intro/dismissal_reasons
begin
uis.route('/vhr/intro/dismissal_reasons:filter','Ui_Vhr139.Reload','M','M','A',null,null,null,null);
uis.route('/vhr/intro/dismissal_reasons:jobs','Ui_Vhr139.Query_Jobs',null,'Q','A',null,null,null,null);
uis.route('/vhr/intro/dismissal_reasons:model','Ui_Vhr139.Model',null,'M','A','Y',null,null,null);

uis.path('/vhr/intro/dismissal_reasons','vhr139');
uis.form('/vhr/intro/dismissal_reasons','/vhr/intro/dismissal_reasons','F','A','F','HM','M','N',null,'N');






uis.ready('/vhr/intro/dismissal_reasons','.model.');

commit;
end;
/
