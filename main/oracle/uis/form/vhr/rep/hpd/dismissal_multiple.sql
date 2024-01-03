set define off
prompt PATH /vhr/rep/hpd/dismissal_multiple
begin
uis.route('/vhr/rep/hpd/dismissal_multiple:definitions','Ui_Vhr110.Definitions',null,'L','A',null,null,null,null);
uis.route('/vhr/rep/hpd/dismissal_multiple:model','Ui.No_Model',null,null,'A','Y',null,null,null);
uis.route('/vhr/rep/hpd/dismissal_multiple:run','Ui_Vhr110.Run','M',null,'A',null,null,null,null);

uis.path('/vhr/rep/hpd/dismissal_multiple','vhr110');
uis.form('/vhr/rep/hpd/dismissal_multiple','/vhr/rep/hpd/dismissal_multiple','A','A','D','Z','M','N',null,'Y');






uis.ready('/vhr/rep/hpd/dismissal_multiple','.model.');

commit;
end;
/
